import mysql.connector
from config_identificador import MYSQL_CONFIG

def test_mysql_conexion():
    try:
        connection = mysql.connector.connect(**MYSQL_CONFIG)
        if connection.is_connected():
            print("✅ Conexión a MySQL exitosa!")
            cursor = connection.cursor()
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()
            print(f"Versión de MySQL: {version[0]}")
    except Exception as e:
        print(f"❌ Error de conexión a MySQL: {e}")
    finally:
        if 'connection' in locals() and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    test_mysql_conexion()
