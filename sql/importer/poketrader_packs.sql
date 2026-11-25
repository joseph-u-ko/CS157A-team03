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
INSERT INTO `packs` VALUES ('30C','30th Celebration',1,1),('30CC','30th Classic Collection',1,1),('A1-CHARIZARD','Genetic Apex — Charizard',1,12),('A1-MEWTWO','Genetic Apex — Mewtwo',1,12),('A1-PIKACHU','Genetic Apex — Pikachu',1,12),('A1A-MEW','Mythical Island — Mew',1,13),('A2-DIALGA','Space-Time Smackdown — Dialga',1,14),('A2-PALKIA','Space-Time Smackdown — Palkia',1,14),('A2A-ARCEUS','Triumphant Light — Arceus',1,15),('A2B-SHINING','Shining Revelry — Shining',1,16),('A3-LUNALA','Celestial Guardians — Lunala',1,17),('A3-SOLGALEO','Celestial Guardians — Solgaleo',1,17),('A3A-EXTRADIMENSIONAL','Extradimensional Crisis — Extradimensional',1,18),('A3B-EEVEE','Eevee Grove — Eevee',1,19),('A4-HO-OH','Wisdom of Sea and Sky — Ho-Oh',1,20),('A4-LUGIA','Wisdom of Sea and Sky — Lugia',1,20),('A4A-SECLUDED','Secluded Springs — Secluded',1,21),('AOR','Ancient Origins',1,6),('ARC','Arceus',1,2),('ASC','Ascended Heroes',1,1),('ASR','Astral Radiance',1,4),('ASR-TG','Astral Radiance Trainer Gallery',1,4),('B1-MEGA-ALTARIA','Mega Rising — Mega Altaria',1,22),('B1-MEGA-BLAZIKEN','Mega Rising — Mega Blaziken',1,22),('B1-MEGA-GYARADOS','Mega Rising — Mega Gyarados',1,22),('B1A-CRIMSON-BLAZE','Crimson Blaze — Crimson Blaze',1,23),('B2','Base Set 2',1,11),('B2-GARDEVOIR','Fantastical Parade — Gardevoir',1,24),('B2A-PALDEAN','Paldean Wonders — Paldean',1,25),('B2B-MEGA-SHINE','Mega Shine — Mega Shine',1,26),('B3-PULSING-AURA','Pulsing Aura — Pulsing Aura',1,27),('B3A-PARADOX-DRIVE','Paradox Drive — Paradox Drive',1,28),('B3B-EVERYDAY-WONDERS','Everyday Wonders — Everyday Wonders',1,29),('B4-RULER-OF-THE-SKIES','Ruler of the Skies — Ruler of the Skies',1,30),('B4A-TEAM-ROCKET','Team Rocket’s Ambition — Team Rocket',1,31),('BCR','Boundaries Crossed',1,7),('BKP','BREAKpoint',1,6),('BKT','BREAKthrough',1,6),('BLK','Black Bolt',1,3),('BLW','Black & White',1,7),('BRS','Brilliant Stars',1,4),('BRS-TG','Brilliant Stars Trainer Gallery',1,4),('BS','Base',1,11),('BST','Battle Styles',1,4),('BUS','Burning Shadows',1,5),('CEC','Cosmic Eclipse',1,5),('CEL','Celebrations',1,4),('CEL-CC','Celebrations: Classic Collection',1,4),('CES','Celestial Storm',1,5),('CG','Crystal Guardians',1,10),('CIN','Crimson Invasion',1,5),('CL','Call of Legends',1,8),('CPA','Champion\'s Path',1,4),('CRE','Chilling Reign',1,4),('CRI','Chaos Rising',1,1),('CRZ','Crown Zenith',1,4),('CRZ-GG','Crown Zenith Galarian Gallery',1,4),('DAA','Darkness Ablaze',1,4),('DCR','Double Crisis',1,6),('DET','Detective Pikachu',1,5),('DEX','Dark Explorers',1,7),('DF','Dragon Frontiers',1,10),('DP','Diamond & Pearl',1,9),('DR','Dragon',1,10),('DRI','Destined Rivals',1,3),('DRM','Dragon Majesty',1,5),('DRV','Dragon Vault',1,7),('DRX','Dragons Exalted',1,7),('DS','Delta Species',1,10),('DX','Deoxys',1,10),('EM','Emerald',1,10),('EPO','Emerging Powers',1,7),('EVO','Evolutions',1,6),('EVS','Evolving Skies',1,4),('FCO','Fates Collide',1,6),('FFI','Furious Fists',1,6),('FLF','Flashfire',1,6),('FLI','Forbidden Light',1,5),('FO','Fossil',1,11),('FST','Fusion Strike',1,4),('GE','Great Encounters',1,9),('GEN','Generations',1,6),('GRI','Guardians Rising',1,5),('HIF','Hidden Fates',1,5),('HIF-SV','Hidden Fates Shiny Vault',1,5),('HL','Hidden Legends',1,10),('HP','Holon Phantoms',1,10),('HS','HeartGold & SoulSilver',1,8),('JTG','Journey Together',1,3),('JU','Jungle',1,11),('LA','Legends Awakened',1,9),('LM','Legend Maker',1,10),('LOR','Lost Origin',1,4),('LOR-TG','Lost Origin Trainer Gallery',1,4),('LOT','Lost Thunder',1,5),('LTR','Legendary Treasures',1,7),('MA','Team Magma vs Team Aqua',1,10),('MD','Majestic Dawn',1,9),('MEG','Mega Evolution',1,1),('MEW','151',1,3),('MT','Mysterious Treasures',1,9),('NVI','Noble Victories',1,7),('NXD','Next Destinies',1,7),('OBF','Obsidian Flames',1,3),('PAF','Paldean Fates',1,3),('PAL','Paldea Evolved',1,3),('PAR','Paradox Rift',1,3),('PBL','Pitch Black',1,1),('PFL','Phantasmal Flames',1,1),('PGO','Pokémon GO',1,4),('PHF','Phantom Forces',1,6),('PK','Power Keepers',1,10),('PLB','Plasma Blast',1,7),('PLF','Plasma Freeze',1,7),('PLS','Plasma Storm',1,7),('PLT','Platinum',1,2),('POR','Perfect Order',1,1),('PRC','Primal Clash',1,6),('PRE','Prismatic Evolutions',1,3),('RCL','Rebel Clash',1,4),('RG','FireRed & LeafGreen',1,10),('ROS','Roaring Skies',1,6),('RRL','Rising Rivals',1,2),('RS','Ruby & Sapphire',1,10),('SCR','Stellar Crown',1,3),('SF','Stormfront',1,9),('SFA','Shrouded Fable',1,3),('SHF','Shining Fates',1,4),('SHF-SV','Shining Fates Shiny Vault',1,4),('SIT','Silver Tempest',1,4),('SIT-TG','Silver Tempest Trainer Gallery',1,4),('SLG','Shining Legends',1,5),('SS','Sandstorm',1,10),('SSH','Sword & Shield',1,4),('SSP','Surging Sparks',1,3),('STS','Steam Siege',1,6),('SUM','Sun & Moon',1,5),('SUV','Supreme Victors',1,2),('SVI','Scarlet & Violet',1,3),('SW','Secret Wonders',1,9),('TEF','Temporal Forces',1,3),('TEU','Team Up',1,5),('TM','HS—Triumphant',1,8),('TR','Team Rocket',1,11),('TRR','Team Rocket Returns',1,10),('TWM','Twilight Masquerade',1,3),('UD','HS—Undaunted',1,8),('UF','Unseen Forces',1,10),('UL','HS—Unleashed',1,8),('UNB','Unbroken Bonds',1,5),('UNM','Unified Minds',1,5),('UPR','Ultra Prism',1,5),('VIV','Vivid Voltage',1,4),('WHT','White Flare',1,3),('XY','XY',1,6);
/*!40000 ALTER TABLE `packs` ENABLE KEYS */;
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

-- Dump completed on 2026-11-24 22:57:16
