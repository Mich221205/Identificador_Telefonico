-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: docusmart
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comentarios`
--

DROP TABLE IF EXISTS `comentarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comentarios` (
  `ID_COMENTARIO` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `ID_DOCUMENTAL` int NOT NULL,
  `COMENTARIO` text NOT NULL,
  `FECHA_COMENTARIO` datetime DEFAULT CURRENT_TIMESTAMP,
  `ESTADO` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ID_COMENTARIO`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `ID_DOCUMENTAL` (`ID_DOCUMENTAL`),
  CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comentarios`
--

LOCK TABLES `comentarios` WRITE;
/*!40000 ALTER TABLE `comentarios` DISABLE KEYS */;
INSERT INTO `comentarios` VALUES (1,1,1,'Que buen documental :)','2025-08-06 16:03:50',1),(2,1,2,'Que grande Luisito','2025-08-08 20:46:06',1),(3,1,2,'si','2025-08-09 13:40:30',1),(4,5,3,'demasiado bueno el documental.','2025-08-11 12:21:26',0),(5,5,2,'holaaaaaa','2025-08-11 19:36:17',1),(6,6,1,'mal documental la verdad.','2025-08-18 15:43:05',1),(7,7,12,'muy buen documental','2025-08-18 19:44:26',1),(8,8,15,'buen documental','2025-08-19 11:44:56',1);
/*!40000 ALTER TABLE `comentarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documental`
--

DROP TABLE IF EXISTS `documental`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documental` (
  `ID_DOCUMENTAL` int NOT NULL AUTO_INCREMENT,
  `TITULO` varchar(200) NOT NULL,
  `DESCRIPCION` varchar(500) DEFAULT NULL,
  `DURACION` varchar(100) DEFAULT NULL,
  `FECHA_PUBLICACIÓN` datetime NOT NULL,
  `ID_NIVEL_EDUCATIVO` int NOT NULL,
  `ID_GENERO` int NOT NULL,
  `DIRECTOR` varchar(500) DEFAULT NULL,
  `PRODUCTORA` varchar(500) DEFAULT NULL,
  `ESTADO` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID_DOCUMENTAL`),
  KEY `ID_NIVEL_EDUCATIVO` (`ID_NIVEL_EDUCATIVO`),
  KEY `ID_GENERO` (`ID_GENERO`),
  KEY `ID_DIRECTOR` (`DIRECTOR`),
  KEY `ID_PRODUCTORA` (`PRODUCTORA`),
  CONSTRAINT `documental_ibfk_1` FOREIGN KEY (`ID_NIVEL_EDUCATIVO`) REFERENCES `niveles_educativos` (`ID_NIVEL`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `documental_ibfk_2` FOREIGN KEY (`ID_GENERO`) REFERENCES `genero` (`ID_GENERO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documental`
--

LOCK TABLES `documental` WRITE;
/*!40000 ALTER TABLE `documental` DISABLE KEYS */;
INSERT INTO `documental` VALUES (1,'Mujeres en la Ciencia','Documental de mujeres y su impacto en la ciencia','10:48','2024-05-01 00:00:00',3,1,'Carla Morales','CienciaViva',1),(2,'Explorando Chernobyl – Luisito Comunica Parte 1','Primera parte de la exploración de Chernobyl realizada por Luisito Comunica, mostrando la historia, lugares icónicos y consecuencias del accidente nuclear.','24:12','2025-08-08 00:00:00',3,1,'Luis Arturo Villar Sudek','Luisito Comunica Producciones',1),(3,'Explorando Chernobyl 2: Pripyat y base militar (Parte 2/2)','Segunda parte de la exploración de Chernobyl realizada por Luisito Comunica, visitando la ciudad fantasma de Pripyat y una base militar abandonada.','00:20:51','2025-08-08 00:00:00',3,1,'Luis Arturo Villar Sudek','Luisito Comunica Producciones',1),(4,'La VERDADERA HISTORIA DETRÁS del HUNDIMIENTO del TITANIC | Documental','Documental narrado por Farid Dieck que relata los eventos reales y menos conocidos sobre el hundimiento del Titanic, sus causas y consecuencias.','00:21:06','2025-08-08 00:00:00',2,2,'Farid Dieck','Dieck Docs',1),(5,'La Mayor Conspiración de la Historia | Documental John F. Kennedy','Documental del canal Fusgo que investiga las teorías y hechos detrás del asesinato de John F. Kennedy, explorando posibles conspiraciones y su impacto histórico.','01:01:15','2025-08-08 00:00:00',3,2,'Fusgo','Fusgo Producciones',1),(6,'Documental - La Penitenciaria Central - Historia de Costa Rica','Documental del canal Historia de Costa Rica que relata la historia, funcionamiento y hechos relevantes de la Penitenciaría Central del país.','00:21:09','2025-08-08 00:00:00',1,2,'Historia de Costa Rica','Historia de Costa Rica Producciones',1),(7,'LA EDUCACIÓN DEL FUTURO (Documental) LSChannel','Documental del canal LSChannel que explora cómo será la educación en el futuro, incluyendo innovaciones tecnológicas, métodos de enseñanza y retos para las nuevas generaciones.','00:57:33','2025-08-08 00:00:00',2,3,'LSChannel','LSChannel Producciones',1),(8,'El Discurso MÁS IMPORTANTE de STEVE JOBS | Documental','Documental narrado por Farid Dieck que analiza y contextualiza el famoso discurso de Steve Jobs en la Universidad de Stanford, destacando sus enseñanzas y mensajes clave.','00:28:52','2025-08-08 00:00:00',1,3,'Farid Dieck','Dieck Docs',1),(9,'La inteligencia artificial, ¿nuestra salvación o condena | Nosotros y ellos','La inteligencia artificial como parte de nuestro dia a dia','00:28:26','2025-08-08 00:00:00',3,3,'DW Documental','Deutsche Welle',1),(10,'LOS MAYAS | Secretos Ocultos de una Civilización Eterna - Documental','Explora la historia, cultura y misterios de la civilización maya, revelando sus avances en astronomía, arquitectura y sociedad.','00:30:26','2025-08-17 00:00:00',3,1,'National Geographic','History Channel',1),(11,'PLANETA HUMANO - Documental Cuerpo Humano HD','Explora el funcionamiento del cuerpo humano, mostrando de manera visual y educativa sus principales sistemas y capacidades.','00:52:21','2025-08-17 00:00:00',3,1,'BBC Earth','Discovery Channel',1),(12,'El futuro de la Humanidad: 5 Escenarios Probables (Documental de Ciencia Ficción)','Un recorrido especulativo y reflexivo sobre cinco escenarios posibles para el futuro de la humanidad, explorando avances tecnológicos, retos sociales y dilemas éticos.','00:24:03','2025-08-17 00:00:00',3,1,'Ridley Scott','Future Docs',1),(13,'DOCUMENTAL - Historia SECRETA de Costa Rica - Historia de Costa Rica','Documental que explora hechos poco conocidos de la historia de Costa Rica, revelando aspectos culturales, políticos y sociales que marcaron la identidad del país.','00:43:44','2025-08-17 00:00:00',3,2,'Canal UCR','Historia Tica',1),(14,'MISTERIOSAS ESFERAS DE COSTA RICA - ALIENÍGENAS ANCESTRALES','Documental que analiza el origen y los misterios de las esferas de piedra de Costa Rica, relacionándolas con teorías de arqueología y antiguos astronautas.','00:05:00','2025-08-17 00:00:00',3,2,'Giorgio A. Tsoukalos','History Channel',1),(15,'Documental: ¡Sí estuvimos! Mujeres en la historia - Historia de Costa Rica','Un recorrido por la participación y el legado de las mujeres en la historia de Costa Rica, destacando su influencia social, política y cultural.','00:52:34','2025-08-17 00:00:00',3,2,'María Pérez','Producciones Ticas',1);
/*!40000 ALTER TABLE `documental` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genero`
--

DROP TABLE IF EXISTS `genero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genero` (
  `ID_GENERO` int NOT NULL AUTO_INCREMENT,
  `DESCRIPCION` varchar(200) NOT NULL,
  `ESTADO` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID_GENERO`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genero`
--

LOCK TABLES `genero` WRITE;
/*!40000 ALTER TABLE `genero` DISABLE KEYS */;
INSERT INTO `genero` VALUES (1,'Ciencia',_binary ''),(2,'Historia',_binary ''),(3,'Tecnología',_binary '');
/*!40000 ALTER TABLE `genero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_visualizacion`
--

DROP TABLE IF EXISTS `historial_visualizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_visualizacion` (
  `ID_HISTORIAL` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `ID_DOCUMENTAL` int NOT NULL,
  `FECHA_VISUALIZACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `TIEMPO_VISUALIZADO` int DEFAULT '0',
  PRIMARY KEY (`ID_HISTORIAL`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `ID_DOCUMENTAL` (`ID_DOCUMENTAL`),
  CONSTRAINT `historial_visualizacion_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `historial_visualizacion_ibfk_2` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_visualizacion`
--

LOCK TABLES `historial_visualizacion` WRITE;
/*!40000 ALTER TABLE `historial_visualizacion` DISABLE KEYS */;
INSERT INTO `historial_visualizacion` VALUES (1,1,3,'2025-08-09 20:27:43',0),(2,1,2,'2025-08-10 22:06:24',0),(3,5,3,'2025-08-11 12:16:33',0),(4,5,2,'2025-08-11 19:36:04',0),(5,1,1,'2025-08-14 12:19:34',0),(6,1,10,'2025-08-17 23:11:38',0),(7,6,10,'2025-08-18 15:42:01',0),(8,6,2,'2025-08-18 15:44:12',0),(9,7,12,'2025-08-18 19:43:20',0),(10,7,11,'2025-08-18 19:45:23',0),(11,8,15,'2025-08-19 11:44:15',0);
/*!40000 ALTER TABLE `historial_visualizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagenes_documentales`
--

DROP TABLE IF EXISTS `imagenes_documentales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagenes_documentales` (
  `id_imagen` int NOT NULL AUTO_INCREMENT,
  `id_documental` int NOT NULL,
  `ruta_imagen` varchar(255) NOT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_imagen`),
  KEY `id_documental` (`id_documental`),
  CONSTRAINT `imagenes_documentales_ibfk_1` FOREIGN KEY (`id_documental`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagenes_documentales`
--

LOCK TABLES `imagenes_documentales` WRITE;
/*!40000 ALTER TABLE `imagenes_documentales` DISABLE KEYS */;
INSERT INTO `imagenes_documentales` VALUES (1,1,'/img/MujeresEnLaCiencia.png','2025-08-06 19:52:29'),(4,2,'/img/EXPLORANDO CHERNOBYL luisito comunica parte 1.png','2025-08-09 02:45:31'),(5,3,'/img/EXPLORANDO CHERNOBYL 2_ Pripyat y base militar (parte 2_2).png','2025-08-09 02:54:14'),(6,4,'/img/La VERDADERA HISTORIA DETRÁS del HUNDIMIENTO del TITANIC.png','2025-08-09 03:04:16'),(7,5,'/img/La Mayor Conspiración de la Historia Documental John F. Kennedy.png','2025-08-09 03:10:22'),(9,6,'/img/Documental - La Penitenciaria Central - Historia de Costa Rica.png','2025-08-09 03:19:55'),(11,7,'/img/LA EDUCACIÓN DEL FUTURO (Documental) LSChannel.png','2025-08-09 07:01:00'),(12,8,'/img/El Discurso MÁS IMPORTANTE de STEVE JOBS.png','2025-08-09 07:20:54'),(13,9,'/img/La inteligencia artificial, ¿nuestra salvación o condena - Nosotros y ellos - DW Documental.png','2025-08-09 07:24:09'),(14,10,'/img/LOS MAYAS - Secretos Ocultos de una Civilización Eterna - Documental.png','2025-08-18 05:07:35'),(16,11,'/img/PLANETA HUMANO - Documental Cuerpo Humano.png','2025-08-18 05:15:29'),(17,12,'/img/El futuro de la Humanidad= 5 Escenarios Probables (Documental de Ciencia Ficción).png','2025-08-18 05:19:21'),(18,13,'/img/DOCUMENTAL - Historia SECRETA de Costa Rica - Historia de Costa Rica.png','2025-08-18 05:35:53'),(19,14,'/img/MISTERIOSAS ESFERAS DE COSTA RICA - ALIENÍGENAS ANCESTRALES.png','2025-08-18 05:39:54'),(20,15,'/img/Documental= “¡Sí estuvimos! Mujeres en la historia” - Historia de Costa Rica.png','2025-08-18 05:44:17');
/*!40000 ALTER TABLE `imagenes_documentales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_detalle`
--

DROP TABLE IF EXISTS `lista_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista_detalle` (
  `ID_LISTA_DOC` int NOT NULL AUTO_INCREMENT,
  `ID_LISTA` int NOT NULL,
  `ID_DOCUMENTAL` int NOT NULL,
  `ORDEN_EN_LISTA` int DEFAULT '1',
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_LISTA_DOC`),
  KEY `ID_LISTA` (`ID_LISTA`),
  KEY `ID_DOCUMENTAL` (`ID_DOCUMENTAL`),
  CONSTRAINT `lista_detalle_ibfk_1` FOREIGN KEY (`ID_LISTA`) REFERENCES `lista_reproduccion` (`ID_LISTA`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lista_detalle_ibfk_2` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_detalle`
--

LOCK TABLES `lista_detalle` WRITE;
/*!40000 ALTER TABLE `lista_detalle` DISABLE KEYS */;
INSERT INTO `lista_detalle` VALUES (2,1,1,1,'2025-08-09 13:53:30'),(3,1,3,1,'2025-08-09 14:12:46'),(4,2,10,1,'2025-08-18 15:42:34'),(5,3,12,1,'2025-08-18 19:43:55'),(6,4,15,1,'2025-08-19 11:44:44');
/*!40000 ALTER TABLE `lista_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_reproduccion`
--

DROP TABLE IF EXISTS `lista_reproduccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista_reproduccion` (
  `ID_LISTA` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `NOMBRE_LISTA` varchar(200) NOT NULL,
  `DESCRIPCION` text,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `ES_PUBLICA` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID_LISTA`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  CONSTRAINT `lista_reproduccion_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_reproduccion`
--

LOCK TABLES `lista_reproduccion` WRITE;
/*!40000 ALTER TABLE `lista_reproduccion` DISABLE KEYS */;
INSERT INTO `lista_reproduccion` VALUES (1,1,'videos de luisito',NULL,'2025-08-09 13:44:36',0),(2,6,'lista nueva',NULL,'2025-08-18 15:42:30',0),(3,7,'Videos para mas tarde',NULL,'2025-08-18 19:43:50',0),(4,8,'para mas tarde',NULL,'2025-08-19 11:44:40',0);
/*!40000 ALTER TABLE `lista_reproduccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `niveles_educativos`
--

DROP TABLE IF EXISTS `niveles_educativos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `niveles_educativos` (
  `ID_NIVEL` int NOT NULL AUTO_INCREMENT,
  `DESCRIPCION` varchar(200) NOT NULL,
  `ESTADO` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID_NIVEL`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_educativos`
--

LOCK TABLES `niveles_educativos` WRITE;
/*!40000 ALTER TABLE `niveles_educativos` DISABLE KEYS */;
INSERT INTO `niveles_educativos` VALUES (1,'Primaria',_binary ''),(2,'Secundaria',_binary ''),(3,'Universitario',_binary ''),(4,'Postgrado',_binary ''),(5,'General / Público en general',_binary '');
/*!40000 ALTER TABLE `niveles_educativos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferencias`
--

DROP TABLE IF EXISTS `preferencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferencias` (
  `ID_PREFERENCIA` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `ID_GENERO` int NOT NULL,
  PRIMARY KEY (`ID_PREFERENCIA`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `ID_GENERO` (`ID_GENERO`),
  CONSTRAINT `preferencias_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `preferencias_ibfk_2` FOREIGN KEY (`ID_GENERO`) REFERENCES `genero` (`ID_GENERO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferencias`
--

LOCK TABLES `preferencias` WRITE;
/*!40000 ALTER TABLE `preferencias` DISABLE KEYS */;
INSERT INTO `preferencias` VALUES (6,3,1),(24,5,1),(27,1,1),(29,6,2),(31,7,2),(32,8,2);
/*!40000 ALTER TABLE `preferencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reacciones`
--

DROP TABLE IF EXISTS `reacciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reacciones` (
  `ID_REACCION` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `ID_DOCUMENTAL` int NOT NULL,
  `TIPO_REACCION` enum('ME_GUSTA','NO_ME_GUSTA','NO_ME_INTERESA') NOT NULL,
  `FECHA_REACCION` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_REACCION`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `ID_DOCUMENTAL` (`ID_DOCUMENTAL`),
  CONSTRAINT `reacciones_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reacciones_ibfk_2` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reacciones`
--

LOCK TABLES `reacciones` WRITE;
/*!40000 ALTER TABLE `reacciones` DISABLE KEYS */;
INSERT INTO `reacciones` VALUES (12,1,2,'NO_ME_GUSTA','2025-08-14 12:21:09'),(17,1,1,'ME_GUSTA','2025-08-14 12:47:34'),(18,6,10,'ME_GUSTA','2025-08-18 15:42:22'),(19,6,1,'NO_ME_GUSTA','2025-08-18 15:43:12'),(20,6,1,'NO_ME_INTERESA','2025-08-18 15:43:27'),(21,7,12,'ME_GUSTA','2025-08-18 19:43:37'),(22,7,1,'NO_ME_INTERESA','2025-08-18 19:45:04'),(23,7,11,'ME_GUSTA','2025-08-18 19:45:14'),(24,8,15,'ME_GUSTA','2025-08-19 11:44:27');
/*!40000 ALTER TABLE `reacciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recomendaciones`
--

DROP TABLE IF EXISTS `recomendaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recomendaciones` (
  `ID_RECOMENDACIÓN` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `ID_DOCUMENTAL` int NOT NULL,
  PRIMARY KEY (`ID_RECOMENDACIÓN`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `ID_DOCUMENTAL` (`ID_DOCUMENTAL`),
  CONSTRAINT `recomendaciones_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `recomendaciones_ibfk_2` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recomendaciones`
--

LOCK TABLES `recomendaciones` WRITE;
/*!40000 ALTER TABLE `recomendaciones` DISABLE KEYS */;
INSERT INTO `recomendaciones` VALUES (7,1,2),(8,1,1),(9,1,3),(10,1,5),(11,1,4),(12,1,6),(13,1,5),(14,1,6),(15,1,4),(16,1,5),(17,1,6),(18,1,4),(19,1,5),(20,1,4),(21,1,6),(22,1,5),(23,1,4),(24,1,6),(25,1,6),(26,1,4),(27,1,5),(28,1,4),(29,1,6),(30,1,5),(31,1,2),(32,1,1),(33,1,3),(34,1,1),(35,1,3),(36,1,2),(37,1,1),(38,1,2),(39,1,3),(40,1,2),(41,1,3),(42,1,1),(43,1,1),(44,1,3),(45,1,2),(46,1,2),(47,1,1),(48,1,3),(49,1,3),(50,1,1),(51,1,2),(52,1,2),(53,1,1),(54,1,3),(55,1,3),(56,1,1),(57,1,2),(58,1,1),(59,1,2),(60,1,3),(61,1,2),(62,1,1),(63,1,3),(64,1,1),(65,1,3),(66,1,2),(67,1,3),(68,1,2),(69,1,1),(70,1,2),(71,1,3),(72,1,1),(73,1,2),(74,1,3),(75,1,1),(76,1,1),(77,1,3),(78,1,2),(79,1,3),(80,1,2),(81,1,1),(82,1,1),(83,1,3),(84,1,2),(85,1,1),(86,1,2),(87,1,3),(88,1,2),(89,1,1),(90,1,3),(91,1,2),(92,1,3),(93,1,1),(94,1,1),(95,1,3),(96,1,2),(97,1,1),(98,1,3),(99,1,2),(100,1,1),(101,1,3),(102,1,2),(103,1,3),(104,1,1),(105,1,2),(106,1,1),(107,1,3),(108,1,2),(109,1,1),(110,1,3),(111,1,2),(112,1,3),(113,1,1),(114,1,2),(115,1,3),(116,1,2),(117,1,1),(118,1,3),(119,1,1),(120,1,2),(121,1,2),(122,1,3),(123,1,1),(124,1,2),(125,1,3),(126,1,1),(127,1,1),(128,1,3),(129,1,2),(130,1,3),(131,1,1),(132,1,2),(133,1,1),(134,1,2),(135,1,2),(136,1,1),(137,1,2),(138,1,1),(139,1,2),(140,1,1),(141,1,1),(142,1,2),(143,1,1),(144,1,2),(145,1,2),(146,1,1),(147,1,1),(148,1,2),(149,1,1),(150,1,2),(151,1,1),(152,1,2),(153,1,1),(154,1,2),(155,1,1),(156,1,2),(157,1,1),(158,1,2),(159,1,1),(160,1,1),(161,1,1),(162,1,7),(163,1,8),(164,1,9),(165,1,8),(166,1,9),(167,1,7),(168,1,7),(169,1,8),(170,1,9),(171,1,4),(172,1,6),(173,1,5),(174,1,7),(175,1,9),(176,1,8),(177,1,1),(178,1,1),(179,1,1),(180,1,1),(181,1,4),(182,1,5),(183,1,6),(184,1,8),(185,1,7),(186,1,5),(187,1,6),(188,1,4),(189,1,6),(190,1,4),(191,1,5),(192,1,4),(193,1,6),(194,1,5),(195,1,5),(196,1,6),(197,1,4),(198,1,4),(199,1,6),(200,1,5),(201,1,6),(202,1,5),(203,1,4),(204,1,6),(205,1,5),(206,1,4),(207,1,6),(208,1,5),(209,1,4),(210,1,5),(211,1,6),(212,1,4),(213,1,4),(214,1,6),(215,1,5),(216,1,5),(217,1,4),(218,1,6),(219,1,6),(220,1,4),(221,1,5),(222,1,5),(223,1,4),(224,1,6),(225,1,5),(226,1,6),(227,1,4),(228,1,4),(229,1,5),(230,1,6),(231,1,5),(232,1,4),(233,1,6),(234,1,5),(235,1,6),(236,1,4),(237,1,6),(238,1,4),(239,1,5),(240,1,6),(241,1,4),(242,1,5),(243,1,6),(244,1,4),(245,1,5),(246,1,6),(247,1,5),(248,1,4),(249,1,5),(250,1,4),(251,1,6),(252,1,6),(253,1,4),(254,1,5),(255,1,6),(256,1,5),(257,1,4),(258,1,5),(259,1,6),(260,1,4),(261,1,6),(262,1,5),(263,1,4),(264,1,4),(265,1,5),(266,1,6),(267,1,4),(268,1,5),(269,1,6),(270,1,4),(271,1,5),(272,1,6),(273,1,5),(274,1,6),(275,1,4),(276,1,6),(277,1,4),(278,1,5),(279,1,5),(280,1,6),(281,1,4),(282,1,6),(283,1,5),(284,1,4),(285,1,6),(286,1,5),(287,1,4),(288,1,6),(289,1,5),(290,1,4),(291,1,4),(292,1,6),(293,1,5),(294,1,5),(295,1,6),(296,1,4),(297,1,6),(298,1,5),(299,1,4),(300,1,5),(301,1,6),(302,1,4),(303,1,6),(304,1,5),(305,1,4),(306,1,5),(307,1,6),(308,1,4),(309,1,5),(310,1,4),(311,1,6),(312,1,6),(313,1,5),(314,1,4),(315,1,6),(316,1,4),(317,1,5),(318,1,5),(319,1,4),(320,1,6),(321,1,5),(322,1,6),(323,1,4),(324,1,6),(325,1,5),(326,1,4),(327,1,5),(328,1,6),(329,1,4),(330,1,5),(331,1,6),(332,1,4),(333,1,4),(334,1,6),(335,1,5),(336,1,1),(337,1,1),(338,1,1),(339,1,1),(340,5,3),(341,5,2),(342,5,1),(343,5,1),(344,5,2),(345,5,2),(346,5,1),(347,5,2),(348,5,1),(349,5,1),(350,5,2);
/*!40000 ALTER TABLE `recomendaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `ID_USUARIO` int NOT NULL AUTO_INCREMENT,
  `NOMBRE` varchar(200) NOT NULL,
  `CORREO` varchar(200) DEFAULT NULL,
  `CONTRASENNA` varchar(200) NOT NULL,
  `ROL` enum('admin','usuario') NOT NULL DEFAULT 'usuario',
  `FECHA_REGISTRO` datetime DEFAULT CURRENT_TIMESTAMP,
  `ESTADO` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = Activo, 0 = Inactivo',
  PRIMARY KEY (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Michel Xavier Quiros Chaves','michelxquiros@gmail.com','$2b$10$Z8qL4SfcYb2FT7uLFjXBZ.8Tk1gYQXerXqguamvtqF.GOXosAwtRu','usuario','2025-07-18 12:47:51',1),(2,'Saul Hidalgo Vargas','saul@gmail.com','$2b$10$mm9of72..yzoZ/nTmyv5T.tNMq/n1XqUA0mPZ.y.3t8QimS975HhC','usuario','2025-08-05 18:37:08',1),(3,'Daniel Granados Calvo','daniel123@gmail.com','$2b$10$IjfNaLCuY/QDzoe46nVaI.kzcoC1F9he0M99bYHiz49ehaSEeGE2y','usuario','2025-08-06 16:04:58',1),(4,'administrador','administrador@gmail.com','$2b$10$OwMwiTyaGptWseVbK0Tlz.YUm5D92olNy/p2GVCGs4m6N/0TM/r2O','admin','2025-08-08 12:38:21',1),(5,'Walter Quirós Chacón','wquiros@gmail.com','$2b$10$9keSXrlWrXhdOFrnOb/z8OEU1f7N/70qFjnDKlerVRipLN3yJaCKa','usuario','2025-08-11 12:04:41',1),(6,'José Fernández Meneses','jose@gmail.com','$2b$10$eMQRDLMaMvZPWNAHzUHZmOyibOM.X8J07siOZX9hlOygQ7IV.HOS2','usuario','2025-08-18 15:12:33',0),(7,'Juan Perez','juanperez@gmail.com','$2b$10$foEjACRdzpOxjAD7nFReAOU58HB/A9T4Uiarz5eZnPJL3azysQDXK','usuario','2025-08-18 19:40:18',1),(8,'Federico lopez robles','federico@gmail.com','$2b$10$D.EZrdMiwGe20jVQd49c.OPf/RYq0btOsuUpklxqHaRJ30Mal3FLO','usuario','2025-08-19 11:43:07',1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_documentales`
--

DROP TABLE IF EXISTS `video_documentales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video_documentales` (
  `ID_DOCUMENTAL` int NOT NULL,
  `ruta_video` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_DOCUMENTAL`),
  CONSTRAINT `fk_video_documental` FOREIGN KEY (`ID_DOCUMENTAL`) REFERENCES `documental` (`ID_DOCUMENTAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_documentales`
--

LOCK TABLES `video_documentales` WRITE;
/*!40000 ALTER TABLE `video_documentales` DISABLE KEYS */;
INSERT INTO `video_documentales` VALUES (1,'/documentales/MujeresEnLaCiencia.mp4','2025-08-06 19:51:32'),(2,'/documentales/EXPLORANDO CHERNOBYL luisito comunica parte 1.mp4','2025-08-09 02:36:39'),(3,'/documentales/EXPLORANDO CHERNOBYL 2_ Pripyat y base militar (parte 2_2).mp4','2025-08-09 02:53:56'),(4,'/documentales/La VERDADERA HISTORIA DETRÁS del HUNDIMIENTO del TITANIC.mp4','2025-08-09 03:04:00'),(5,'/documentales/La Mayor Conspiración de la Historia Documental John F. Kennedy.mp4','2025-08-09 03:10:18'),(6,'/documentales/Documental - La Penitenciaria Central - Historia de Costa Rica.mp4','2025-08-09 03:18:50'),(7,'/documentales/LA EDUCACIÓN DEL FUTURO (Documental) LSChannel.mp4','2025-08-09 07:00:57'),(8,'/documentales/El Discurso MÁS IMPORTANTE de STEVE JOBS.mp4','2025-08-09 07:20:40'),(9,'/documentales/La inteligencia artificial, ¿nuestra salvación o condena - Nosotros y ellos - DW Documental.mp4','2025-08-09 07:24:01'),(10,'/documentales/LOS MAYAS - Secretos Ocultos de una Civilización Eterna - Documental.mp4','2025-08-18 05:09:39'),(11,'/documentales/PLANETA HUMANO - Documental Cuerpo Humano.mp4','2025-08-18 05:15:19'),(12,'/documentales/El futuro de la Humanidad= 5 Escenarios Probables (Documental de Ciencia Ficción).mp4','2025-08-18 05:19:25'),(13,'/documentales/DOCUMENTAL - Historia SECRETA de Costa Rica - Historia de Costa Rica.mp4','2025-08-18 05:36:08'),(14,'/documentales/MISTERIOSAS ESFERAS DE COSTA RICA - ALIENÍGENAS ANCESTRALES.mp4','2025-08-18 05:39:58'),(15,'/documentales/Documental= “¡Sí estuvimos! Mujeres en la historia” - Historia de Costa Rica.mp4','2025-08-18 05:44:30');
/*!40000 ALTER TABLE `video_documentales` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-20 22:28:03
