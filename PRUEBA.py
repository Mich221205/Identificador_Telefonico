import socket
import json
import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad

# Claves de cifrado
AES_KEY = b'1234567890123456'
AES_IV = b'initialvector123'

IDENTIFICADOR_HOST = '127.0.0.1'
IDENTIFICADOR_PORT = 5000

def cifrar_aes(texto):
    cipher = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
    texto_bytes = texto.encode('utf-8')
    texto_cifrado = cipher.encrypt(pad(texto_bytes, AES.block_size))
    return base64.b64encode(texto_cifrado).decode('utf-8')

def armar_trama(telefono, id_tel, id_tarjeta, estado):
    return {
        "tipo_transaccion": 6,
        "telefono": "ENC:" + cifrar_aes(telefono),
        "identificadorTel": "ENC:" + cifrar_aes(id_tel),
        "identificador_tarjeta": "ENC:" + cifrar_aes(id_tarjeta),
        "tipo": "prepago",
        "identificacion_cliente": "305630078",
        "estado": estado
    }

def enviar_trama(datos, etiqueta=""):
    print(f"\n📤 Enviando trama ({etiqueta}):")
    print(json.dumps(datos, indent=2))
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((IDENTIFICADOR_HOST, IDENTIFICADOR_PORT))
        mensaje = json.dumps(datos) + "\n"
        s.sendall(mensaje.encode('utf-8'))
        respuesta = s.recv(4096).decode('utf-8').strip()
        print("📨 Respuesta del servidor Identificador:")
        print(respuesta)

if __name__ == "__main__":
    # Caso 1: UPDATE (línea existente)
    trama_update = armar_trama(
        telefono="88765432",
        id_tel="1234567890123456",
        id_tarjeta="1234567890123456789",
        estado="activo"
    )
    enviar_trama(trama_update, etiqueta="UPDATE existente")

    # Caso 2: INSERT (línea nueva)
    trama_insert = armar_trama(
        telefono="99998888",
        id_tel="9988776655443322",
        id_tarjeta="9999999999999999999",
        estado="activo"
    )
    enviar_trama(trama_insert, etiqueta="INSERT nueva")
