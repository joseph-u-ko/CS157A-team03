USE poketrader;
CREATE TABLE contains(
packID INT,
cardID INT,

CONSTRAINT FK_Pack_To_Card
FOREIGN KEY(packID) REFERENCES packs,
CONSTRAINT FK_Card_To_Pack
FOREIGN KEY(cardID) REFERENCES cards,
PRIMARY KEY (packID, cardID)
);

CREATE TABLE owns(
username VARCHAR(255),
cardID INT,
quantity INT,
numberOffered INT,

CONSTRAINT FK_User_To_Card
FOREIGN KEY(username) REFERENCES users,
CONSTRAINT FK_Card_To_User
FOREIGN KEY(cardID) REFERENCES cards,
PRIMARY KEY (username, cardID)
);

CREATE TABLE performs(
username VARCHAR(255),
tradeID INT,

CONSTRAINT FK_User_To_Trade
FOREIGN KEY(username) REFERENCES users,
CONSTRAINT FK_Trade_To_User
FOREIGN KEY(tradeID) REFERENCES trades,
PRIMARY KEY (username, tradeID)
);

CREATE TABLE involves(
tradeID INT,
requester VARCHAR(255),
cardID INT,
quantity INT,

CONSTRAINT FK_Trade_Involved
FOREIGN KEY(tradeID) REFERENCES trades,
CONSTRAINT FK_User_Request
FOREIGN KEY(requester) REFERENCES users,
CONSTRAINT FK_Card_Requested
FOREIGN KEY(cardID) REFERENCES cards,
PRIMARY KEY (tradeID, requester, cardID)
);