CREATE TABLE `trades` (
  `userA` varchar(255) DEFAULT 'UNKNOWN',
  `userB` varchar(255) DEFAULT 'UNKNOWN',
  `requestStatus` varchar(255) NOT NULL DEFAULT 'UNKNOWN',
  `tradeStatus` varchar(255) DEFAULT 'UNKNOWN',
  `userACardName` varchar(255) DEFAULT 'No Card',
  `userBCardName` varchar(255) DEFAULT 'No Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci