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
886cc565-a65f-11f1-921a-00155d460e24:1-1887';

--
-- Table structure for table `rulecardsbyrarity`
--

DROP TABLE IF EXISTS `rulecardsbyrarity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rulecardsbyrarity` (
  `ruleSetID` int NOT NULL,
  `rarityClass` varchar(255) NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `upgradeRate` decimal(5,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`ruleSetID`,`rarityClass`),
  KEY `FK_RuleCardsByRarity_Class` (`rarityClass`),
  CONSTRAINT `FK_RuleCardsByRarity_Class` FOREIGN KEY (`rarityClass`) REFERENCES `rarityclasses` (`rarityClass`),
  CONSTRAINT `FK_RuleCardsByRarity_RuleSet` FOREIGN KEY (`ruleSetID`) REFERENCES `rulesets` (`ruleSetID`),
  CONSTRAINT `CHK_RuleCardsByRarity_Quantity` CHECK ((`quantity` >= 0)),
  CONSTRAINT `CHK_RuleCardsByRarity_UpgradeRate` CHECK (((`upgradeRate` >= 0.0000) and (`upgradeRate` <= 1.0000)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rulecardsbyrarity`
--

LOCK TABLES `rulecardsbyrarity` WRITE;
/*!40000 ALTER TABLE `rulecardsbyrarity` DISABLE KEYS */;
INSERT INTO `rulecardsbyrarity` VALUES (1,'Chase Rare',0,0.0200),(1,'Common',5,0.1500),(1,'Holo/Rare',1,0.0800),(1,'Premium Rare',0,0.0400),(1,'Ultra-Chase Rare',0,0.0000),(1,'Uncommon',4,0.2000),(2,'Common',6,0.1000),(2,'Holo/Rare',1,0.0500),(2,'Premium Rare',0,0.0000),(2,'Uncommon',3,0.1500),(3,'Chase Rare',0,0.0000),(3,'Common',4,0.2500),(3,'Holo/Rare',0,0.2000),(3,'Premium Rare',1,0.1000),(3,'Uncommon',0,1.0000),(4,'Chase Rare',0,0.0000),(4,'Common',3,0.9000),(4,'Holo/Rare',0,0.3529),(4,'Premium Rare',0,0.2222),(4,'Uncommon',0,0.9444);
/*!40000 ALTER TABLE `rulecardsbyrarity` ENABLE KEYS */;
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

-- Dump completed on 2026-11-20 10:14:08
