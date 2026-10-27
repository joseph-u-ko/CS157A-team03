USE poketrader;

CREATE TABLE contains(
packID INT NOT NULL,
cardID INT NOT NULL,
setCode INT NOT NULL,


PRIMARY KEY (packID, cardID),
CONSTRAINT FK_Pack_To_Card
FOREIGN KEY(packID, setCode) REFERENCES packs(packID, setCode),
CONSTRAINT FK_Card_To_Pack
FOREIGN KEY(cardID, setCode) REFERENCES cards(cardID, setCode)
);

CREATE TABLE owns(
username VARCHAR(255) NOT NULL,
cardID INT NOT NULL,
quantity INT NOT NULL DEFAULT 0,
numberOffered INT NOT NULL DEFAULT 0,

CONSTRAINT FK_User_To_Card
FOREIGN KEY(username) REFERENCES users,
CONSTRAINT FK_Card_To_User
FOREIGN KEY(cardID) REFERENCES cards,
PRIMARY KEY (username, cardID)
);

CREATE TABLE performs(
username VARCHAR(255) NOT NULL,
tradeID INT NOT NULL,

CONSTRAINT FK_User_To_Trade
FOREIGN KEY(username) REFERENCES users,
CONSTRAINT FK_Trade_To_User
FOREIGN KEY(tradeID) REFERENCES trades,
PRIMARY KEY (username, tradeID)
);

CREATE TABLE involves(
tradeID INT NOT NULL,
username VARCHAR(255) NOT NULL,
cardID INT NOT NULL,
quantity INT NOT NULL DEFAULT 0,

CONSTRAINT FK_Trade_Involved
FOREIGN KEY(tradeID) REFERENCES trades,
CONSTRAINT FK_User_Request
FOREIGN KEY(username) REFERENCES users,
CONSTRAINT FK_Card_Requested
FOREIGN KEY(cardID) REFERENCES cards,
PRIMARY KEY (tradeID, username, cardID)
);