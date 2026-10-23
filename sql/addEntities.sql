CREATE TABLE packs(
packName VARCHAR(255),
packID INT,
available TINYINT(1),
setName VARCHAR(255),

CONSTRAINT FK_From_Set
FOREIGN KEY(setName) REFERENCES sets,
PRIMARY KEY (packID)
);

CREATE TABLE cards(
cardID INT,
cardName VARCHAR(255),
cardType VARCHAR(255),
subType VARCHAR(255),
rarity VARCHAR(255),
imageLink TINYTEXT,
setName VARCHAR(255),

CONSTRAINT FK_From_Set
FOREIGN KEY(setName) REFERENCES sets,
PRIMARY KEY (cardID)
);

CREATE TABLE trades(
status VARCHAR(255),
tradeID INT,
PRIMARY KEY (tradeID)
);

CREATE TABLE tradeMessages(
messageNum INT,
timestamp DATETIME,
message TEXT,
tradeID INT,
writer VARCHAR(255),

CONSTRAINT FK_Trade
FOREIGN KEY(tradeID) REFERENCES trades,
CONSTRAINT FK_Writer
FOREIGN KEY(writer) REFERENCES users,
PRIMARY KEY (tradeID, messageNum)
);