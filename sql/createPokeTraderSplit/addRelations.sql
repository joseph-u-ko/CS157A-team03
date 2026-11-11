USE poketrader;

CREATE TABLE contains(
	packID VARCHAR(255) NOT NULL,
	cardID INT NOT NULL,
	setCode INT NOT NULL,

	CONSTRAINT FK_Contains_Pack
		FOREIGN KEY(packID, setCode)
        REFERENCES packs(packID, setCode),
	CONSTRAINT FK_Contains_Card
		FOREIGN KEY(cardID, setCode)
        REFERENCES cards(cardID, setCode),
	CONSTRAINT FK_Contains_Set
		FOREIGN KEY(setCode)
        REFERENCES sets(setCode),
    PRIMARY KEY (packID, cardID)
);

CREATE TABLE owns(
	username VARCHAR(255) NOT NULL,
	cardID INT NOT NULL,
	quantity INT NOT NULL DEFAULT 0,
	numberOffered INT NOT NULL DEFAULT 0,

	CONSTRAINT FK_User_To_Card
		FOREIGN KEY(username)
        REFERENCES users(username),
	CONSTRAINT FK_Card_To_User
		FOREIGN KEY(cardID)
        REFERENCES cards(cardID),
	PRIMARY KEY (username, cardID)
);

CREATE TABLE performs(
	username VARCHAR(255) NOT NULL,
	tradeID INT NOT NULL,

	CONSTRAINT FK_User_To_Trade
		FOREIGN KEY(username)
        REFERENCES users(username),
	CONSTRAINT FK_Trade_To_User
		FOREIGN KEY(tradeID)
        REFERENCES trades(tradeID),
	PRIMARY KEY (username, tradeID)
);

CREATE TABLE involves(
	tradeID INT NOT NULL,
	requester VARCHAR(255) NOT NULL,
	cardID INT NOT NULL,
	quantity INT NOT NULL DEFAULT 0,

	CONSTRAINT FK_Trade_Involved
		FOREIGN KEY(tradeID)
        REFERENCES trades(tradeID),
	CONSTRAINT FK_User_Request
		FOREIGN KEY(requester)
        REFERENCES users(username),
	CONSTRAINT FK_Card_Requested
		FOREIGN KEY(cardID)
        REFERENCES cards(cardID),
	PRIMARY KEY (tradeID, requester, cardID)
);

CREATE TABLE useRule (
    packID VARCHAR(255) NOT NULL,
    ruleSetID INT NOT NULL,

    CONSTRAINT FK_UseRule_Pack
        FOREIGN KEY (packID)
        REFERENCES packs(packID),
    CONSTRAINT FK_UseRule_RuleSet
        FOREIGN KEY (ruleSetID)
        REFERENCES ruleSets(ruleSetID),
	PRIMARY KEY (packID)
);

CREATE TABLE ruleCardsByRarity (
    ruleSetID INT NOT NULL,
    rarityClass VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,

    CONSTRAINT FK_RuleCardsByRarity_RuleSet
        FOREIGN KEY (ruleSetID)
        REFERENCES ruleSets(ruleSetID),
    CONSTRAINT FK_RuleCardsByRarity_Class
        FOREIGN KEY (rarityClass)
        REFERENCES rarityClasses(rarityClass),
    CONSTRAINT CHK_RuleCardsByRarity_Quantity
        CHECK (quantity >= 0),
    PRIMARY KEY (ruleSetID, rarityClass)
);