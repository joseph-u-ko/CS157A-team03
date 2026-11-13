CREATE TABLE `poketrader`.`friends` (
  `userA` VARCHAR(255) NOT NULL,
  `userB` VARCHAR(255) NOT NULL,
  `status` VARCHAR(255) NULL,
  PRIMARY KEY (`userA`, `userB`));
