import queue
import threading
from datetime import datetime
import json


class BitacoraManager:
    """Clase para manejar el registro de bitácoras en segundo plano"""
    
    def __init__(self, archivo_bitacora="bitacora_operaciones.txt"):
        self.archivo_bitacora = archivo_bitacora
        self.cola_escritura = queue.Queue()
        self.running = True
        self.hilo_escritor = None
        self._iniciar_escritor()
    
    def _iniciar_escritor(self):
        """Inicia el hilo de escritura en segundo plano"""
        self.hilo_escritor = threading.Thread(target=self._procesar_cola_escritura, daemon=True)
        self.hilo_escritor.start()
    
    def _procesar_cola_escritura(self):
        """Procesa la cola de escritura de bitácoras en segundo plano"""
        while self.running:
            try:
                # Esperar por un registro con timeout
                registro = self.cola_escritura.get(timeout=1)
                if registro is None:  # Señal para terminar
                    break
                
                self._escribir_registro(registro)
                self.cola_escritura.task_done()
                
            except queue.Empty:
                continue
            except Exception as e:
                print(f"Error procesando bitácora: {e}")
    
    def _escribir_registro(self, datos_registro):
        
        """Escribe un registro en el archivo de bitácora"""
        try:
            
            fecha_actual = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            
            linea_bitacora = f"{fecha_actual}: {json.dumps(datos_registro, ensure_ascii=False)}\n"
            
            # Escribir en el archivo (modo append)
            with open(self.archivo_bitacora, 'a', encoding='utf-8') as archivo:
                archivo.write(linea_bitacora)
                archivo.flush()  # Asegurar que se escriba inmediatamente
                
        except Exception as e:
            print(f"Error escribiendo bitácora: {e}")
    
    def registrar_operacion(self, numero_telefono, identificador_telefono, identificador_tarjeta, 
                      ubicacion, tipo_transaccion, telefono_destino="", tiempo_maximo="00:00:00"):
        try:
            # Validar que los parámetros no sean None
            numero_telefono = numero_telefono or ""
            identificador_telefono = identificador_telefono or "NO_DISPONIBLE"
            identificador_tarjeta = identificador_tarjeta or "NO_DISPONIBLE"
            ubicacion = ubicacion or "DESCONOCIDA"
            
            registro = {
                "telefono": numero_telefono,
                "identificadorTel": identificador_telefono,
                "identificadorChip": identificador_tarjeta,
                "coordenadas": ubicacion,
                "transaccion": tipo_transaccion,
                "destino": telefono_destino if telefono_destino else "",
                "tiempo": tiempo_maximo
            }
            
            self.cola_escritura.put(registro)
            
        except Exception as e:
            print(f"Error encolando registro de bitácora: {e}")
    
    def detener(self):
        """Detiene el procesamiento de bitácoras"""
        self.running = False
        # Enviar señal de terminación
        self.cola_escritura.put(None)
        # Esperar a que termine el hilo
        if self.hilo_escritor and self.hilo_escritor.is_alive():
            self.hilo_escritor.join(timeout=5)