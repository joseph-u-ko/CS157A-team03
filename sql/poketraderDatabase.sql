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
886cc565-a65f-11f1-921a-00155d460e24:1-77';

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `cardID` int NOT NULL,
  `cardName` varchar(255) DEFAULT NULL,
  `cardType` varchar(255) DEFAULT NULL,
  `subType` varchar(255) DEFAULT NULL,
  `rarity` varchar(255) DEFAULT NULL,
  `imageLink` tinytext,
  `setName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cardID`),
  KEY `FK_Card_From_Set` (`setName`),
  CONSTRAINT `FK_Card_From_Set` FOREIGN KEY (`setName`) REFERENCES `sets` (`setCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contains`
--

DROP TABLE IF EXISTS `contains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contains` (
  `packID` int NOT NULL,
  `cardID` int NOT NULL,
  PRIMARY KEY (`packID`,`cardID`),
  KEY `FK_Card_To_Pack` (`cardID`),
  CONSTRAINT `FK_Card_To_Pack` FOREIGN KEY (`cardID`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_Pack_To_Card` FOREIGN KEY (`packID`) REFERENCES `packs` (`packID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contains`
--

LOCK TABLES `contains` WRITE;
/*!40000 ALTER TABLE `contains` DISABLE KEYS */;
/*!40000 ALTER TABLE `contains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `involves`
--

DROP TABLE IF EXISTS `involves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `involves` (
  `tradeID` int NOT NULL,
  `requester` varchar(255) NOT NULL,
  `cardID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`tradeID`,`requester`,`cardID`),
  KEY `FK_User_Request` (`requester`),
  KEY `FK_Card_Requested` (`cardID`),
  CONSTRAINT `FK_Card_Requested` FOREIGN KEY (`cardID`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_Trade_Involved` FOREIGN KEY (`tradeID`) REFERENCES `trades` (`tradeID`),
  CONSTRAINT `FK_User_Request` FOREIGN KEY (`requester`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `involves`
--

LOCK TABLES `involves` WRITE;
/*!40000 ALTER TABLE `involves` DISABLE KEYS */;
/*!40000 ALTER TABLE `involves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owns`
--

DROP TABLE IF EXISTS `owns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owns` (
  `username` varchar(255) NOT NULL,
  `cardID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  `numberOffered` int DEFAULT NULL,
  PRIMARY KEY (`username`,`cardID`),
  KEY `FK_Card_To_User` (`cardID`),
  CONSTRAINT `FK_Card_To_User` FOREIGN KEY (`cardID`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_User_To_Card` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owns`
--

LOCK TABLES `owns` WRITE;
/*!40000 ALTER TABLE `owns` DISABLE KEYS */;
/*!40000 ALTER TABLE `owns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packs`
--

DROP TABLE IF EXISTS `packs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packs` (
  `packName` varchar(255) DEFAULT NULL,
  `packID` int NOT NULL,
  `available` tinyint(1) DEFAULT NULL,
  `setName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`packID`),
  KEY `FK_Pack_From_Set` (`setName`),
  CONSTRAINT `FK_Pack_From_Set` FOREIGN KEY (`setName`) REFERENCES `sets` (`setCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packs`
--

LOCK TABLES `packs` WRITE;
/*!40000 ALTER TABLE `packs` DISABLE KEYS */;
/*!40000 ALTER TABLE `packs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performs`
--

DROP TABLE IF EXISTS `performs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performs` (
  `username` varchar(255) NOT NULL,
  `tradeID` int NOT NULL,
  PRIMARY KEY (`username`,`tradeID`),
  KEY `FK_Trade_To_User` (`tradeID`),
  CONSTRAINT `FK_Trade_To_User` FOREIGN KEY (`tradeID`) REFERENCES `trades` (`tradeID`),
  CONSTRAINT `FK_User_To_Trade` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performs`
--

LOCK TABLES `performs` WRITE;
/*!40000 ALTER TABLE `performs` DISABLE KEYS */;
/*!40000 ALTER TABLE `performs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sets`
--

DROP TABLE IF EXISTS `sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets` (
  `setCode` varchar(45) NOT NULL,
  `setName` varchar(45) NOT NULL,
  PRIMARY KEY (`setCode`),
  UNIQUE KEY `setName_UNIQUE` (`setCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sets`
--

LOCK TABLES `sets` WRITE;
/*!40000 ALTER TABLE `sets` DISABLE KEYS */;
/*!40000 ALTER TABLE `sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trademessages`
--

DROP TABLE IF EXISTS `trademessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trademessages` (
  `messageNum` int NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  `message` text,
  `tradeID` int NOT NULL,
  `writer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tradeID`,`messageNum`),
  KEY `FK_Writer` (`writer`),
  CONSTRAINT `FK_Trade_Ref` FOREIGN KEY (`tradeID`) REFERENCES `trades` (`tradeID`),
  CONSTRAINT `FK_Writer` FOREIGN KEY (`writer`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trademessages`
--

LOCK TABLES `trademessages` WRITE;
/*!40000 ALTER TABLE `trademessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `trademessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trades`
--

DROP TABLE IF EXISTS `trades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trades` (
  `status` varchar(255) DEFAULT NULL,
  `tradeID` int NOT NULL,
  PRIMARY KEY (`tradeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trades`
--

LOCK TABLES `trades` WRITE;
/*!40000 ALTER TABLE `trades` DISABLE KEYS */;
/*!40000 ALTER TABLE `trades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(255) NOT NULL,
  `passwordHashed` varchar(255) NOT NULL,
  `loggedIn` tinyint DEFAULT NULL,
  `nextTicketTime` datetime DEFAULT NULL,
  `tickets` int DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('abcde','$2a$10$lLodaZUpgOZEwX6tevcUOuGeJiLlA11BqE0obqpwaIIwc00vjw.1a',0,NULL,1),('jennypsychic','$2a$10$Fb0IBlfAPBJL7l3fvJX60OUv.U8aZpNCI8Oa6aNfvpLUWioQp.kd6',0,NULL,0),('josephK','$2a$10$RbOp8g3abMRe5QkHkgsf8.WbWvq0gW3wSnJV6fPRH5i8cdxmnwbZu',0,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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

-- Dump completed on 2026-10-22 22:56:03
