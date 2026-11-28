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
INSERT INTO `rulecardsbyrarity` VALUES (1,'Chase Rare',0,0.0200),(1,'Common',5,0.1500),(1,'Holo/Rare',1,0.0800),(1,'Premium Rare',0,0.0400),(1,'Ultra-Chase Rare',0,0.0000),(1,'Uncommon',4,0.2000),(2,'Common',6,0.1000),(2,'Holo/Rare',1,0.0500),(2,'Premium Rare',0,0.0000),(2,'Uncommon',3,0.1500),(3,'Chase Rare',0,0.0000),(3,'Common',4,0.2500),(3,'Holo/Rare',0,0.2000),(3,'Premium Rare',1,0.1000),(3,'Uncommon',0,1.0000),(4,'Chase Rare',0,0.0000),(4,'Common',3,0.9000),(4,'Holo/Rare',0,0.3529),(4,'Premium Rare',0,0.2222),(4,'Uncommon',0,0.9444),(5,'Common',5,0.1800),(5,'Holo/Rare',1,0.0800),(5,'Premium Rare',0,0.0000),(5,'Uncommon',4,0.2200),(6,'Common',5,0.2500),(6,'Holo/Rare',1,0.1200),(6,'Premium Rare',0,0.0000),(6,'Uncommon',4,0.2500),(7,'Common',0,1.0000),(7,'Holo/Rare',0,1.0000),(7,'Premium Rare',1,0.0000),(7,'Uncommon',0,1.0000),(8,'Common',5,0.2000),(8,'Holo/Rare',1,0.1000),(8,'Premium Rare',0,0.0000),(8,'Uncommon',4,0.2200),(9,'Common',5,0.2200),(9,'Holo/Rare',1,0.1200),(9,'Premium Rare',0,0.0000),(9,'Uncommon',4,0.2400),(10,'Chase Rare',0,0.0300),(10,'Common',5,0.1800),(10,'Holo/Rare',1,0.1000),(10,'Premium Rare',0,0.0700),(10,'Ultra-Chase Rare',0,0.0000),(10,'Uncommon',4,0.2200),(11,'Chase Rare',0,0.0700),(11,'Common',4,0.2500),(11,'Holo/Rare',1,0.1400),(11,'Premium Rare',0,0.1800),(11,'Ultra-Chase Rare',0,0.0000),(11,'Uncommon',3,0.2500),(12,'Chase Rare',0,0.0400),(12,'Common',4,0.2000),(12,'Holo/Rare',2,0.1200),(12,'Premium Rare',0,0.1000),(12,'Ultra-Chase Rare',0,0.0000),(12,'Uncommon',3,0.2400),(13,'Chase Rare',0,0.0600),(13,'Common',4,0.2200),(13,'Holo/Rare',2,0.1200),(13,'Premium Rare',0,0.1500),(13,'Ultra-Chase Rare',0,0.0000),(13,'Uncommon',3,0.2400),(14,'Chase Rare',0,0.0000),(14,'Common',4,0.1800),(14,'Holo/Rare',3,0.1000),(14,'Premium Rare',0,0.0700),(14,'Uncommon',3,0.2200),(15,'Common',5,0.1800),(15,'Holo/Rare',1,0.0800),(15,'Premium Rare',0,0.0000),(15,'Uncommon',4,0.2200),(16,'Common',5,0.1800),(16,'Holo/Rare',1,0.0800),(16,'Premium Rare',0,0.0000),(16,'Uncommon',4,0.2200),(17,'Common',3,0.1800),(17,'Holo/Rare',1,0.0800),(17,'Premium Rare',0,0.0000),(17,'Uncommon',3,0.2200),(18,'Common',4,0.2200),(18,'Holo/Rare',2,0.1200),(18,'Premium Rare',0,0.0000),(18,'Uncommon',4,0.2500),(19,'Common',5,0.1800),(19,'Holo/Rare',2,0.1000),(19,'Premium Rare',0,0.0000),(19,'Uncommon',3,0.2200),(20,'Chase Rare',0,0.0000),(20,'Common',5,0.1800),(20,'Holo/Rare',2,0.1000),(20,'Premium Rare',0,0.0800),(20,'Uncommon',3,0.2200),(21,'Common',5,0.1800),(21,'Holo/Rare',2,0.0000),(21,'Uncommon',3,0.2200),(22,'Common',5,0.1800),(22,'Holo/Rare',1,0.1000),(22,'Premium Rare',0,0.0000),(22,'Uncommon',4,0.2200),(23,'Common',5,0.1800),(23,'Holo/Rare',1,0.1000),(23,'Premium Rare',0,0.0000),(23,'Uncommon',4,0.2200),(24,'Common',5,0.1800),(24,'Holo/Rare',1,0.0000),(24,'Uncommon',4,0.2200),(25,'Common',5,0.1800),(25,'Holo/Rare',1,0.1000),(25,'Premium Rare',0,0.0000),(25,'Uncommon',4,0.2200),(26,'Chase Rare',0,0.2000),(26,'Common',3,0.0000),(26,'Holo/Rare',0,0.6000),(26,'Premium Rare',0,0.3500),(26,'Ultra-Chase Rare',0,0.0000),(26,'Uncommon',2,0.2500),(27,'Chase Rare',0,0.0700),(27,'Common',3,0.0000),(27,'Holo/Rare',0,0.4000),(27,'Premium Rare',0,0.1300),(27,'Ultra-Chase Rare',0,0.0000),(27,'Uncommon',2,0.2750),(28,'Chase Rare',0,0.0700),(28,'Common',3,0.0000),(28,'Holo/Rare',0,0.4000),(28,'Premium Rare',0,0.1300),(28,'Ultra-Chase Rare',0,0.0000),(28,'Uncommon',2,0.2750);
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

-- Dump completed on 2026-11-27 17:27:01
