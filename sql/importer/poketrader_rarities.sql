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
