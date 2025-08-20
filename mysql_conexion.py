# -------------------- Python (Servidor Intermedio) --------------------
import socket
import json
import threading
import datetime
import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from mysql.connector import connect, Error
from config_identificador import MYSQL_CONFIG, IDENTIFICADOR_HOST, IDENTIFICADOR_PORT, PROVEEDOR_HOST, PROVEEDOR_PORT

AES_KEY = b'1234567890123456'
AES_IV  = b'6543210987654321'

TRANSACCIONES_VALIDAS = {1, 2, 3, 4, 5, 6}
llamadas_activas = []

def transaccion_valida(tipo):
    try:
        return int(tipo) in TRANSACCIONES_VALIDAS
    except:
        return False

def conectar_mysql():
    try:
        return connect(**MYSQL_CONFIG)
    except Error as err:
        print(f"Error al conectar a MySQL: {err}")
        return None

def validar_telefono_existe(cursor, numero_telefono, codigo_pais=None):
    query = "SELECT 1 FROM TELEFONO WHERE NUMERO = %s AND ACTIVO = TRUE"
    params = [numero_telefono]
    if codigo_pais:
        query += " AND ID_CODIGO_PAIS = %s"
        params.append(codigo_pais)
    cursor.execute(query, tuple(params))
    return cursor.fetchone() is not None

def obtener_datos_tarjeta(cursor, identificador_tarjeta):
    query = ("SELECT ID_TARJETA, IDENTIFICADOR_TARJETA, IDENTIFICADOR_TELEFONO, "
             "ID_TELEFONO, NUMERO_TELEFONO, ACTIVO FROM TARJETA WHERE IDENTIFICADOR_TARJETA = %s")
    cursor.execute(query, (identificador_tarjeta,))
    row = cursor.fetchone()
    return {
        "id_tarjeta": row[0],
        "identificador_tarjeta": row[1],
        "identificador_telefono": row[2],
        "id_telefono": row[3],
        "numero_telefono": row[4],
        "activo": row[5]
    } if row else None

def cifrar_aes(texto):
    cifrador = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
    texto_bytes = texto.encode('utf-8')
    texto_padding = pad(texto_bytes, AES.block_size)
    texto_cifrado = cifrador.encrypt(texto_padding)
    return base64.b64encode(texto_cifrado).decode('utf-8')

def descifrar_aes(texto_cifrado):
    cifrador = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
    texto_cifrado_bytes = base64.b64decode(texto_cifrado.encode('utf-8'))
    texto_descifrado = unpad(cifrador.decrypt(texto_cifrado_bytes), AES.block_size)
    return texto_descifrado.decode('utf-8')

def coordenadas_validas(coord):
    try:
        lat, lon = map(float, coord.split(','))
        return 8.0 <= lat <= 11.5 and -86 <= lon <= -82
    except:
        return False

def escribir_bitacora(datos):
    try:
        with open("bitacora.txt", "a", encoding="utf-8") as f:
            fecha = datetime.datetime.now().strftime("%d/%m/%Y")
            json_line = json.dumps(datos, ensure_ascii=False)
            f.write(f"{fecha}: {json_line}\n")
    except Exception as e:
        print(f"Error al escribir bitácora: {e}")

def registrar_llamada_activa(telefono, tiempo_segundos, datos):
    fecha_fin = datetime.datetime.now() + datetime.timedelta(seconds=tiempo_segundos)
    llamadas_activas.append({"telefono": telefono, "fecha_fin": fecha_fin, "datos": datos})

def monitor_llamadas_activas():
    while True:
        ahora = datetime.datetime.now()
        vencidas = [ll for ll in llamadas_activas if ll["fecha_fin"] <= ahora]
        for llamada in vencidas:
            print(f"[AUTO-FINALIZADA] Llamada: {llamada['telefono']}, fin: {llamada['fecha_fin']}")
            llamadas_activas.remove(llamada)
        threading.Event().wait(5)

def comunicar_con_proveedor(datos):
    try:
        datos_envio = datos.copy()
        if "coordenadas" in datos_envio:
            del datos_envio["coordenadas"]
        for campo in ['identificadorTel', 'identificadorChip', 'identificador_tarjeta']:
            if campo in datos_envio and datos_envio[campo]:
                datos_envio[campo] = 'ENC:' + cifrar_aes(str(datos_envio[campo]))

        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(10)
            s.connect((PROVEEDOR_HOST, PROVEEDOR_PORT))
            mensaje = json.dumps(datos_envio) + '\n'
            s.sendall(mensaje.encode('utf-8'))
            respuesta = s.recv(4096).decode('utf-8').strip()
            return json.loads(respuesta) if respuesta else {"status": "error", "message": "Sin respuesta del proveedor"}

    except Exception as e:
        return {"status": "error", "message": str(e)}

def manejar_cliente(cliente_socket):
    with cliente_socket:
        try:
            datos_raw = cliente_socket.recv(4096).decode().strip()
            if not datos_raw:
                return

            print(f"Datos recibidos: {datos_raw}")
            datos = json.loads(datos_raw)

            tipo_tx = str(datos.get('tipo_transaccion', '')).strip()

            # ✅ PRIORIDAD: manejar activación/desactivación antes de validar todo
            if tipo_tx == "6":
                try:
                    for campo in ['telefono', 'identificadorTel', 'identificador_tarjeta']:
                        if datos.get(campo, '').startswith("ENC:"):
                            datos[campo] = descifrar_aes(datos[campo][4:])

                    requeridos = [
                        'telefono', 'identificadorTel', 'identificador_tarjeta',
                        'tipo', 'identificacion_cliente', 'estado'
                    ]
                    if not all(datos.get(k) for k in requeridos):
                        cliente_socket.sendall(json.dumps({
                            "status": "Activación fallida",
                            "message": "Datos incompletos"
                        }).encode())
                        return

                    estado_bool = 1 if datos['estado'].lower() == "activo" else 0
                    conexion = conectar_mysql()
                    if not conexion:
                        cliente_socket.sendall(json.dumps({
                            "status": "Activación fallida",
                            "message": "Error de conexión MySQL"
                        }).encode())
                        return

                    cursor = conexion.cursor()

                    cursor.execute("SELECT ID_TELEFONO FROM TELEFONO WHERE NUMERO = %s", (datos['telefono'],))
                    fila_tel = cursor.fetchone()
                    telefono_existe = fila_tel is not None

                    if not telefono_existe:
                        cursor.execute("""
                            INSERT INTO TELEFONO (NUMERO, ACTIVO, ID_PROVEEDOR, ID_TIPO_TELEFONO, ID_CODIGO_PAIS)
                            VALUES (%s, %s, %s, %s, %s)
                        """, (
                            datos['telefono'], estado_bool, 1, 1, 1
                        ))
                        id_telefono = cursor.lastrowid
                    else:
                        id_telefono = fila_tel[0]
                        cursor.execute("""
                            UPDATE TELEFONO SET ACTIVO = %s WHERE ID_TELEFONO = %s
                        """, (estado_bool, id_telefono))

                    # TARJETA
                    cursor.execute("""
                        SELECT ID_TARJETA FROM TARJETA
                        WHERE NUMERO_TELEFONO = %s AND IDENTIFICADOR_TARJETA = %s
                    """, (datos['telefono'], datos['identificador_tarjeta']))
                    tarjeta_existe = cursor.fetchone() is not None

                    if not tarjeta_existe:
                        cursor.execute("""
                            INSERT INTO TARJETA (IDENTIFICADOR_TARJETA, IDENTIFICADOR_TELEFONO, ID_TELEFONO, NUMERO_TELEFONO, ACTIVO)
                            VALUES (%s, %s, %s, %s, %s)
                        """, (
                            datos['identificador_tarjeta'],
                            datos['identificadorTel'],
                            id_telefono,
                            datos['telefono'],
                            estado_bool
                        ))
                    else:
                        cursor.execute("""
                            UPDATE TARJETA SET ACTIVO = %s
                            WHERE NUMERO_TELEFONO = %s AND IDENTIFICADOR_TARJETA = %s
                        """, (
                            estado_bool,
                            datos['telefono'],
                            datos['identificador_tarjeta']
                        ))

                    conexion.commit()
                    cliente_socket.sendall(json.dumps({"status": "OK"}).encode())

                except Exception as e:
                    cliente_socket.sendall(json.dumps({
                        "status": "Activación fallida",
                        "message": str(e)
                    }).encode())
                finally:
                    if 'cursor' in locals():
                        cursor.close()
                    if 'conexion' in locals():
                        conexion.close()
                return

            # Validación general para los demás tipos
            if not transaccion_valida(tipo_tx):
                cliente_socket.sendall(json.dumps({
                    "status": "error",
                    "message": "Acción inválida"
                }).encode())
                return

            # Coordenadas (si aplica)
            if tipo_tx in ["solicitud", "llamada", "finalizacion"]:
                if not coordenadas_validas(datos.get('coordenadas', '')):
                    cliente_socket.sendall(json.dumps({
                        "status": "error",
                        "message": "Coordenadas inválidas"
                    }).encode())
                    return

            # Descifrar teléfono si viene cifrado
            try:
                if datos.get('telefono', '').startswith("ENC:"):
                    datos['telefono'] = descifrar_aes(datos['telefono'][4:])
            except Exception as e:
                cliente_socket.sendall(json.dumps({
                    "status": "error",
                    "message": "Error al descifrar número de teléfono"
                }).encode())
                return

            telefono = datos.get('telefono', '').strip()
            conexion = conectar_mysql()
            if not conexion:
                cliente_socket.sendall(json.dumps({
                    "status": "error",
                    "message": "Error de conexión a MySQL"
                }).encode())
                return

            cursor = conexion.cursor(dictionary=True)
            info = obtener_datos_completos_telefono(cursor, telefono)
            if not info:
                cliente_socket.sendall(json.dumps({
                    "status": "error",
                    "message": "Datos del teléfono no encontrados o inactivos"
                }).encode())
                cursor.close()
                conexion.close()
                return

            # Cargar datos para el proveedor
            datos['identificadorTel'] = info['identificador_telefono']
            datos['identificador_tarjeta'] = info['identificador_tarjeta']

            print("✅ Datos descifrados y recuperados:")
            print(f"Telefono: {datos['telefono']}")
            print(f"Identificador Tel: {datos['identificadorTel']}")
            print(f"Identificador Tarjeta: {datos['identificador_tarjeta']}")

            cursor.close()
            conexion.close()

            # Enviar al proveedor
            respuesta = comunicar_con_proveedor(datos)
            cliente_socket.sendall(json.dumps(respuesta).encode())

            # Bitácora
            threading.Thread(target=escribir_bitacora, args=(datos,)).start()

            # Registrar llamada activa (si aplica)
            if tipo_tx == "llamada":
                tiempo = int(datos.get('tiempo', '000000'))
                h, m, s = int(tiempo[:2]), int(tiempo[2:4]), int(tiempo[4:6])
                segundos = h * 3600 + m * 60 + s
                registrar_llamada_activa(telefono, segundos, datos)

        except Exception as e:
            cliente_socket.sendall(json.dumps({
                "status": "error",
                "message": str(e)
            }).encode())


def obtener_datos_completos_telefono(cursor, numero_telefono):
    """
    Consulta toda la información asociada a un número telefónico:
    - ID y estado del teléfono
    - Identificadores del chip/teléfono
    - Tipo de teléfono (prepago/postpago)
    - Código de país
    - Tarifas
    """
    numero = ''.join(c for c in numero_telefono if c.isdigit())

    if not numero:
        return None

    query = """
    SELECT 
        t.ID_TELEFONO,
        t.ID_CODIGO_PAIS,
        t.ID_TIPO_TELEFONO,
        tr.ID_TARJETA,
        tr.IDENTIFICADOR_TARJETA,
        tr.IDENTIFICADOR_TELEFONO,
        tt.ES_PREPAGO,
        tt.TARIFA_LOCAL,
        cp.TARIFA_POR_MINUTO,
        cp.GRUPO_TARIFA,
        cp.CODIGO_PAIS
    FROM TELEFONO t
    JOIN TARJETA tr ON t.ID_TELEFONO = tr.ID_TELEFONO
    JOIN TIPO_TELEFONO tt ON t.ID_TIPO_TELEFONO = tt.ID_TIPO_TELEFONO
    JOIN CODIGO_PAIS cp ON t.ID_CODIGO_PAIS = cp.ID_CODIGO_PAIS
    WHERE t.NUMERO = %s AND t.ACTIVO = TRUE AND tr.ACTIVO = TRUE
    LIMIT 1
    """

    try:
        cursor.execute(query, (numero,))
        row = cursor.fetchone()
        if not row:
            return None  # teléfono no encontrado o inactivo

        return {
            "id_telefono": row["ID_TELEFONO"],
            "id_tarjeta": row["ID_TARJETA"],
            "identificador_tarjeta": row["IDENTIFICADOR_TARJETA"],
            "identificador_telefono": row["IDENTIFICADOR_TELEFONO"],
            "prepago": row["ES_PREPAGO"] == 1,
            "tarifa_local": float(row["TARIFA_LOCAL"]),
            "tarifa_internacional": float(row["TARIFA_POR_MINUTO"]),
            "grupo_tarifa": row["GRUPO_TARIFA"],
            "codigo_pais": row["CODIGO_PAIS"],
            "id_codigo_pais": row["ID_CODIGO_PAIS"]
        }
    except Exception as e:
        print(f"Error en la consulta de datos del teléfono: {e}")
        return None


def iniciar_servidor():
    threading.Thread(target=monitor_llamadas_activas, daemon=True).start()
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as servidor:
        servidor.bind((IDENTIFICADOR_HOST, IDENTIFICADOR_PORT))
        servidor.listen()
        print(f"Servidor escuchando en {IDENTIFICADOR_HOST}:{IDENTIFICADOR_PORT}...")
        while True:
            cliente_socket, addr = servidor.accept()
            print(f"Conexión aceptada de {addr}")
            threading.Thread(target=manejar_cliente, args=(cliente_socket,)).start()

if __name__ == "__main__":
    iniciar_servidor()
