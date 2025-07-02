import socket
import json
import threading
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import base64

# Configuración
IDENTIFICADOR_HOST = 'localhost'
IDENTIFICADOR_PORT = 5555
PROVEEDOR_HOST = '127.0.0.2'
PROVEEDOR_PORT = 6000

# Configuración AES
AES_KEY = b'1234567890123456'
AES_IV = b'initialvector123'

def cifrar_aes(texto):
    """Cifra un texto usando AES-CBC"""
    cifrador = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
    texto_bytes = texto.encode('utf-8')
    texto_padding = pad(texto_bytes, AES.block_size)
    texto_cifrado = cifrador.encrypt(texto_padding)
    return base64.b64encode(texto_cifrado).decode('utf-8')

def descifrar_aes(texto_cifrado):
    """Descifra un texto usando AES-CBC"""
    cifrador = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
    texto_cifrado_bytes = base64.b64decode(texto_cifrado.encode('utf-8'))
    texto_descifrado = unpad(cifrador.decrypt(texto_cifrado_bytes), AES.block_size)
    return texto_descifrado.decode('utf-8')

def validar_datos(datos):
    """Valida que los datos tengan los campos requeridos"""
    required_fields = ['telefono', 'identificadorTel', 'identificadorChip', 'tipo_transaccion', 'destino', 'tiempo']
    return all(field in datos for field in required_fields)

def procesar_mensaje(mensaje):
    """Procesa mensajes JSON con cifrado/descifrado"""
    try:
        datos = json.loads(mensaje)
        
        # Descifrar campos sensibles si están cifrados
        for campo in ['identificadorTel', 'identificadorChip']:
            if campo in datos and datos[campo].startswith('ENC:'):
                datos[campo] = descifrar_aes(datos[campo][4:])
        
        return datos if validar_datos(datos) else None
    except:
        return None

def comunicar_con_proveedor(datos):
    """Envía datos al proveedor y recibe respuesta"""
    try:
        # Cifrar campos sensibles
        datos_envio = datos.copy()
        for campo in ['identificadorTel', 'identificadorChip']:
            if campo in datos_envio:
                datos_envio[campo] = 'ENC:' + cifrar_aes(datos_envio[campo])
        
        # Conectar y enviar
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((PROVEEDOR_HOST, PROVEEDOR_PORT))
            s.sendall(json.dumps(datos_envio).encode())
            
            # Recibir respuesta (asumimos que el proveedor envía una respuesta completa)
            respuesta = s.recv(4096).decode()
            return json.loads(respuesta)
    except Exception as e:
        return {"status": "error", "message": str(e)}

def manejar_cliente(cliente_socket):
    """Maneja la conexión con un cliente"""
    with cliente_socket:
        try:
            datos_raw = cliente_socket.recv(4096).decode().strip()
            if not datos_raw:
                return
            
            print(f"Datos recibidos: {datos_raw}")
            
            # Procesar mensaje (texto plano o JSON)
            if datos_raw.isdigit() and len(datos_raw) == 10:  # Número de teléfono
                respuesta = {"status": "OK", "telefono": datos_raw}
            else:
                datos = procesar_mensaje(datos_raw)
                if datos:
                    respuesta = comunicar_con_proveedor(datos)
                else:
                    respuesta = {"status": "error", "message": "Datos inválidos"}
            
            cliente_socket.sendall(json.dumps(respuesta).encode())
        except Exception as e:
            print(f"Error: {e}")

def iniciar_servidor():
    """Inicia el servidor principal"""
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