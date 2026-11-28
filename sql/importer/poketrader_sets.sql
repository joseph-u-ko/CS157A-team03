-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: poketrader
-- ------------------------------------------------------
-- Server version	26.7.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '72d3b320-a296-11f1-8118-14ac60eadace:1-246,
886cc565-a65f-11f1-921a-00155d460e24:1-2863';

--
-- Table structure for table `sets`
--

DROP TABLE IF EXISTS `sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets` (
  `setCode` int NOT NULL AUTO_INCREMENT,
  `setName` varchar(255) NOT NULL DEFAULT 'UNDEFINED',
  `description` varchar(1024) DEFAULT NULL,
  `available` tinyint(1) NOT NULL DEFAULT '0',
  `imageLink` tinytext,
  PRIMARY KEY (`setCode`),
  UNIQUE KEY `setCode` (`setCode`),
  UNIQUE KEY `setName` (`setName`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sets`
--

LOCK TABLES `sets` WRITE;
/*!40000 ALTER TABLE `sets` DISABLE KEYS */;
INSERT INTO `sets` VALUES (1,'Mega Evolution','',1,'https://images.pokemontcg.io/me1/logo.png'),(2,'Platinum','',1,'https://images.pokemontcg.io/pl1/logo.png'),(3,'Scarlet & Violet','',1,'https://images.pokemontcg.io/sv1/logo.png'),(4,'Sword & Shield','',1,'https://images.pokemontcg.io/swsh1/logo.png'),(5,'Sun & Moon','',1,'https://images.pokemontcg.io/sm1/logo.png'),(6,'XY','',1,'https://images.pokemontcg.io/xy1/logo.png'),(7,'Black & White','',1,'https://images.pokemontcg.io/bw1/logo.png'),(8,'HeartGold & SoulSilver','',1,'https://images.pokemontcg.io/hgss1/logo.png'),(9,'Diamond & Pearl','',1,'https://images.pokemontcg.io/dp1/logo.png'),(10,'EX Ruby & Sapphire','',1,'https://images.pokemontcg.io/ex1/logo.png'),(11,'Base','',1,'https://images.pokemontcg.io/base1/logo.png'),(12,'Genetic Apex','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A1/A1_001_EN.webp'),(13,'Mythical Island','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A1a/A1a_001_EN.webp'),(14,'Space-Time Smackdown','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A2/A2_001_EN.webp'),(15,'Triumphant Light','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A2a/A2a_001_EN.webp'),(16,'Shining Revelry','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A2b/A2b_001_EN.webp'),(17,'Celestial Guardians','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A3/A3_001_EN.webp'),(18,'Extradimensional Crisis','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A3a/A3a_001_EN.webp'),(19,'Eevee Grove','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A3b/A3b_001_EN.webp'),(20,'Wisdom of Sea and Sky','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A4/A4_001_EN.webp'),(21,'Secluded Springs','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/A4a/A4a_001_EN.webp'),(22,'Mega Rising','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B1/B1_001_EN.webp'),(23,'Crimson Blaze','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B1a/B1a_001_EN.webp'),(24,'Fantastical Parade','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B2/B2_001_EN.webp'),(25,'Paldean Wonders','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B2a/B2a_001_EN.webp'),(26,'Mega Shine','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B2b/B2b_001_EN.webp'),(27,'Pulsing Aura','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B3/B3_001_EN.webp'),(28,'Paradox Drive','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B3a/B3a_001_EN.webp'),(29,'Everyday Wonders','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B3b/B3b_001_EN.webp'),(30,'Ruler of the Skies','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B4/B4_001_EN.webp'),(31,'Team Rocket’s Ambition','',1,'https://limitlesstcg.nyc3.cdn.digitaloceanspaces.com/pocket/B4a/B4a_001_EN.webp');
/*!40000 ALTER TABLE `sets` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-27 17:27:00
