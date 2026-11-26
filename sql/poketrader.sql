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
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `cardID` int NOT NULL,
  `cardName` varchar(255) NOT NULL,
  `cardType` varchar(255) NOT NULL DEFAULT 'UNDEFINED',
  `subType` varchar(255) NOT NULL DEFAULT 'UNDEFINED',
  `rarity` varchar(255) NOT NULL DEFAULT 'IMPOSSIBLE',
  `imageLink` tinytext,
  `setCode` int NOT NULL,
  PRIMARY KEY (`cardID`),
  UNIQUE KEY `cardID` (`cardID`,`setCode`),
  KEY `FK_Card_From_Set` (`setCode`),
  KEY `FK_Card_Rarity` (`rarity`),
  CONSTRAINT `FK_Card_From_Set` FOREIGN KEY (`setCode`) REFERENCES `sets` (`setCode`),
  CONSTRAINT `FK_Card_Rarity` FOREIGN KEY (`rarity`) REFERENCES `rarities` (`rarityName`)
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
  `packID` varchar(255) NOT NULL,
  `cardID` int NOT NULL,
  `setCode` int NOT NULL,
  PRIMARY KEY (`packID`,`cardID`),
  KEY `FK_Contains_Pack` (`packID`,`setCode`),
  KEY `FK_Contains_Card` (`cardID`,`setCode`),
  KEY `FK_Contains_Set` (`setCode`),
  CONSTRAINT `FK_Contains_Card` FOREIGN KEY (`cardID`, `setCode`) REFERENCES `cards` (`cardID`, `setCode`),
  CONSTRAINT `FK_Contains_Pack` FOREIGN KEY (`packID`, `setCode`) REFERENCES `packs` (`packID`, `setCode`),
  CONSTRAINT `FK_Contains_Set` FOREIGN KEY (`setCode`) REFERENCES `sets` (`setCode`)
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
-- Table structure for table `friendmessages`
--

DROP TABLE IF EXISTS `friendmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friendmessages` (
  `messageID` int NOT NULL AUTO_INCREMENT,
  `sentAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` text NOT NULL,
  `sender` varchar(255) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  PRIMARY KEY (`messageID`),
  KEY `FK_Sender` (`sender`),
  KEY `FK_Recipient` (`recipient`),
  CONSTRAINT `FK_Recipient` FOREIGN KEY (`recipient`) REFERENCES `users` (`username`),
  CONSTRAINT `FK_Sender` FOREIGN KEY (`sender`) REFERENCES `users` (`username`),
  CONSTRAINT `CHK_Not_Self_Messages` CHECK ((`sender` <> `recipient`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friendmessages`
--

LOCK TABLES `friendmessages` WRITE;
/*!40000 ALTER TABLE `friendmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `friendmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friends` (
  `userA` varchar(255) NOT NULL,
  `userB` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`userA`,`userB`),
  KEY `FK_UserB` (`userB`),
  CONSTRAINT `FK_UserA` FOREIGN KEY (`userA`) REFERENCES `users` (`username`),
  CONSTRAINT `FK_UserB` FOREIGN KEY (`userB`) REFERENCES `users` (`username`),
  CONSTRAINT `FK_Not_Self` CHECK ((`userA` <> `userB`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
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
  `quantity` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`,`cardID`),
  KEY `FK_Card_To_User` (`cardID`),
  CONSTRAINT `FK_Card_To_User` FOREIGN KEY (`cardID`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_User_To_Card` FOREIGN KEY (`username`) REFERENCES `users` (`username`),
  CONSTRAINT `CHK_Quantity` CHECK ((`quantity` >= 0))
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
  `packID` varchar(255) NOT NULL,
  `packName` varchar(255) NOT NULL DEFAULT 'UNDEFINED',
  `available` tinyint(1) NOT NULL DEFAULT '0',
  `setCode` int NOT NULL,
  PRIMARY KEY (`packID`),
  UNIQUE KEY `packID` (`packID`,`setCode`),
  KEY `FK_Pack_From_Set` (`setCode`),
  CONSTRAINT `FK_Pack_From_Set` FOREIGN KEY (`setCode`) REFERENCES `sets` (`setCode`)
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
-- Table structure for table `rarities`
--

DROP TABLE IF EXISTS `rarities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rarities` (
  `rarityName` varchar(255) NOT NULL,
  `rarityClass` varchar(255) NOT NULL,
  PRIMARY KEY (`rarityName`),
  UNIQUE KEY `rarityName` (`rarityName`),
  KEY `FK_Rarity_Class` (`rarityClass`),
  CONSTRAINT `FK_Rarity_Class` FOREIGN KEY (`rarityClass`) REFERENCES `rarityclasses` (`rarityClass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rarities`
--

LOCK TABLES `rarities` WRITE;
/*!40000 ALTER TABLE `rarities` DISABLE KEYS */;
INSERT INTO `rarities` VALUES ('Immersive Rare','Chase Rare'),('LEGEND','Chase Rare'),('Shiny Super Rare','Chase Rare'),('Shiny Ultra Rare','Chase Rare'),('Special Art Rare','Chase Rare'),('Special Illustration Rare','Chase Rare'),('Common','Common'),('Double Rare','Holo/Rare'),('Holo Rare V','Holo/Rare'),('Holo Rare VMAX','Holo/Rare'),('Holo Rare VSTAR','Holo/Rare'),('Rare','Holo/Rare'),('Rare Holo','Holo/Rare'),('Rare Holo EX','Holo/Rare'),('Rare Holo GX','Holo/Rare'),('Rare Holo LV.X','Holo/Rare'),('ACE SPEC Rare','Premium Rare'),('Amazing Rare','Premium Rare'),('Art Rare','Premium Rare'),('Black White Rare','Premium Rare'),('Classic Collection','Premium Rare'),('Futuristic Rare','Premium Rare'),('Illustration Rare','Premium Rare'),('MEGA_ATTACK_RARE','Premium Rare'),('Pikachu Rare','Premium Rare'),('Radiant Rare','Premium Rare'),('Rare ACE','Premium Rare'),('Rare BREAK','Premium Rare'),('Rare Holo Star','Premium Rare'),('Rare Prime','Premium Rare'),('Rare Prism Star','Premium Rare'),('Rare Rainbow','Premium Rare'),('Rare Secret','Premium Rare'),('Rare Shining','Premium Rare'),('Rare Shiny','Premium Rare'),('Rare Shiny GX','Premium Rare'),('Rare Ultra','Premium Rare'),('Shiny','Premium Rare'),('Shiny Rare','Premium Rare'),('Super Rare','Premium Rare'),('Trainer Gallery Rare Holo','Premium Rare'),('Ultra Rare','Premium Rare'),('Crown Rare','Ultra-Chase Rare'),('Hyper Rare','Ultra-Chase Rare'),('Mega Hyper Rare','Ultra-Chase Rare'),('Uncommon','Uncommon');
/*!40000 ALTER TABLE `rarities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rarityclasses`
--

DROP TABLE IF EXISTS `rarityclasses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rarityclasses` (
  `rarityClass` varchar(255) NOT NULL,
  `rarityRank` int DEFAULT NULL,
  PRIMARY KEY (`rarityClass`),
  UNIQUE KEY `rarityClass` (`rarityClass`),
  UNIQUE KEY `rarityRank` (`rarityRank`),
  CONSTRAINT `CHK_RarityRank` CHECK ((`rarityRank` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rarityclasses`
--

LOCK TABLES `rarityclasses` WRITE;
/*!40000 ALTER TABLE `rarityclasses` DISABLE KEYS */;
INSERT INTO `rarityclasses` VALUES ('Common',0),('Uncommon',1),('Holo/Rare',2),('Premium Rare',3),('Chase Rare',4),('Ultra-Chase Rare',5);
/*!40000 ALTER TABLE `rarityclasses` ENABLE KEYS */;
UNLOCK TABLES;

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
/*!40000 ALTER TABLE `rulecardsbyrarity` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rulesets`
--

LOCK TABLES `rulesets` WRITE;
/*!40000 ALTER TABLE `rulesets` DISABLE KEYS */;
/*!40000 ALTER TABLE `rulesets` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `trades`
--

DROP TABLE IF EXISTS `trades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trades` (
  `username` varchar(255) NOT NULL,
  `otherUser` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'None',
  `cardIDOffered` int DEFAULT NULL,
  `cardIDProposed` int DEFAULT NULL,
  PRIMARY KEY (`username`),
  KEY `FK_Other_User` (`otherUser`),
  KEY `FK_Card_Offered` (`cardIDOffered`),
  KEY `FK_Card_Proposed` (`cardIDProposed`),
  CONSTRAINT `FK_Card_Offered` FOREIGN KEY (`cardIDOffered`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_Card_Proposed` FOREIGN KEY (`cardIDProposed`) REFERENCES `cards` (`cardID`),
  CONSTRAINT `FK_Other_User` FOREIGN KEY (`otherUser`) REFERENCES `users` (`username`),
  CONSTRAINT `FK_Trade_User` FOREIGN KEY (`username`) REFERENCES `users` (`username`),
  CONSTRAINT `CHK_Not_Self_Trades` CHECK ((`username` <> `otherUser`))
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
  `loggedIn` tinyint(1) NOT NULL DEFAULT '0',
  `tickets` int NOT NULL DEFAULT '0',
  `nextTicketTime` time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`username`),
  UNIQUE KEY `passwordHashed` (`passwordHashed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userule`
--

DROP TABLE IF EXISTS `userule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userule` (
  `packID` varchar(255) NOT NULL,
  `ruleSetID` int NOT NULL,
  PRIMARY KEY (`packID`),
  KEY `FK_UseRule_RuleSet` (`ruleSetID`),
  CONSTRAINT `FK_UseRule_Pack` FOREIGN KEY (`packID`) REFERENCES `packs` (`packID`),
  CONSTRAINT `FK_UseRule_RuleSet` FOREIGN KEY (`ruleSetID`) REFERENCES `rulesets` (`ruleSetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userule`
--

LOCK TABLES `userule` WRITE;
/*!40000 ALTER TABLE `userule` DISABLE KEYS */;
/*!40000 ALTER TABLE `userule` ENABLE KEYS */;
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

-- Dump completed on 2026-11-25 17:12:29
