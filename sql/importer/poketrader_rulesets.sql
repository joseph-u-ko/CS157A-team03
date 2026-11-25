CREATE DATABASE  IF NOT EXISTS `poketrader` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `poketrader`;
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
886cc565-a65f-11f1-921a-00155d460e24:1-2479';

--
-- Table structure for table `rulesets`
--

DROP TABLE IF EXISTS `rulesets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rulesets` (
  `ruleSetID` int NOT NULL AUTO_INCREMENT,
  `ruleName` varchar(255) NOT NULL,
  PRIMARY KEY (`ruleSetID`),
  UNIQUE KEY `ruleSetID` (`ruleSetID`),
  UNIQUE KEY `ruleName` (`ruleName`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rulesets`
--

LOCK TABLES `rulesets` WRITE;
/*!40000 ALTER TABLE `rulesets` DISABLE KEYS */;
INSERT INTO `rulesets` VALUES (3,'30th Celebration'),(24,'Base / Jungle / Fossil / Base Set 2 Standard'),(19,'Black & White Standard'),(14,'Black Bolt / White Flare'),(21,'Call of Legends'),(7,'Celebrations Classic Collection'),(4,'Classic Collection'),(9,'Crown Zenith'),(22,'Diamond & Pearl Standard'),(17,'Double Crisis'),(23,'EX Ruby & Sapphire Standard'),(18,'Generations'),(20,'HeartGold & SoulSilver Standard'),(1,'Modern Mega Evolution'),(11,'Paldean Fates'),(2,'Platinum Era'),(8,'Pokémon GO'),(13,'Prismatic Evolutions'),(10,'Scarlet & Violet Standard'),(6,'Shining Fates'),(12,'Shrouded Fable'),(15,'Sun & Moon Standard'),(5,'SWSH Standard'),(27,'TCG Pocket A Series Shiny'),(26,'TCG Pocket A Series Standard'),(28,'TCG Pocket B Series Shiny'),(25,'Team Rocket Standard'),(16,'XY Standard');
/*!40000 ALTER TABLE `rulesets` ENABLE KEYS */;
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

-- Dump completed on 2026-11-24 23:15:40
