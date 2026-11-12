USE poketrader;

CREATE TABLE users(
	username VARCHAR(255) NOT NULL,
	passwordHashed VARCHAR(255) UNIQUE NOT NULL,
	loggedIn TINYINT(1) NOT NULL DEFAULT 0,
	tickets INT NOT NULL DEFAULT 0,
	nextTicketTime TIME NOT NULL DEFAULT '00:00:00',

	PRIMARY KEY (username)
);

CREATE TABLE sets(
	setCode INT NOT NULL,
	setName VARCHAR(255) UNIQUE NOT NULL DEFAULT 'UNDEFINED',
	description VARCHAR(1024),
	available TINYINT(1) NOT NULL DEFAULT 0,
	imageLink TINYTEXT,

	PRIMARY KEY (setCode)
);

CREATE TABLE packs(
	packID VARCHAR(255) NOT NULL,
	packName VARCHAR(255) NOT NULL DEFAULT 'UNDEFINED',
	available TINYINT(1) NOT NULL DEFAULT 0,
	setCode INT NOT NULL,

	CONSTRAINT FK_Pack_From_Set
		FOREIGN KEY(setCode)
        REFERENCES sets(setCode),
	PRIMARY KEY (packID),
	UNIQUE(packID, setCode)
);

CREATE TABLE rarityClasses(
	rarityClass VARCHAR(255) UNIQUE NOT NULL,
    rarityRank INT UNIQUE,

	CONSTRAINT CHK_RarityRank
		CHECK (rarityRank >= 0),
	PRIMARY KEY (rarityClass)
);
INSERT INTO rarityClasses (rarityClass, rarityRank) VALUES
	('Common', 0),
    ('Uncommon', 1),
    ('Holo/Rare', 2),
    ('Premium Rare', 3),
    ('Chase Rare', 4),
    ('Ultra-Chase Rare', 5);

CREATE TABLE rarities(
	rarityName VARCHAR(255) UNIQUE NOT NULL,
	rarityClass VARCHAR(255) NOT NULL,

	CONSTRAINT FK_Rarity_Class
	FOREIGN KEY(rarityClass) REFERENCES rarityClasses(rarityClass),
	PRIMARY KEY (rarityName)
);
INSERT INTO rarities (rarityName, rarityClass) VALUES
    ('Common', 'Common'),
    ('Uncommon', 'Uncommon'),

    ('Rare', 'Holo/Rare'),
    ('Rare Holo', 'Holo/Rare'),
    ('Rare Holo EX', 'Holo/Rare'),
    ('Rare Holo GX', 'Holo/Rare'),
    ('Rare Holo LV.X', 'Holo/Rare'),
    ('Holo Rare V', 'Holo/Rare'),
    ('Holo Rare VMAX', 'Holo/Rare'),
    ('Holo Rare VSTAR', 'Holo/Rare'),
    ('Double Rare', 'Holo/Rare'),

    ('Amazing Rare', 'Premium Rare'),
    ('Futuristic Rare', 'Premium Rare'),
    ('Illustration Rare', 'Premium Rare'),
    ('MEGA_ATTACK_RARE', 'Premium Rare'),
    ('Pikachu Rare', 'Premium Rare'),
    ('Rare BREAK', 'Premium Rare'),
    ('Rare Prime', 'Premium Rare'),
    ('Rare Secret', 'Premium Rare'),
    ('Rare Ultra', 'Premium Rare'),
    ('Ultra Rare', 'Premium Rare'),

    ('LEGEND', 'Chase Rare'),
    ('Special Illustration Rare', 'Chase Rare'),

    ('Mega Hyper Rare', 'Ultra-Chase Rare');
    
CREATE TABLE ruleSets (
    ruleSetID INT NOT NULL,
    ruleName VARCHAR(255) UNIQUE NOT NULL,

    PRIMARY KEY (ruleSetID)
);

CREATE TABLE cards(
	cardID INT NOT NULL,
	cardName VARCHAR(255) NOT NULL,
	cardType VARCHAR(255) NOT NULL DEFAULT 'UNDEFINED',
	subType VARCHAR(255) NOT NULL DEFAULT 'UNDEFINED',
	rarity VARCHAR(255) NOT NULL DEFAULT 'IMPOSSIBLE',
	imageLink TINYTEXT,
	setCode INT NOT NULL,

	CONSTRAINT FK_Card_From_Set
		FOREIGN KEY(setCode)
        REFERENCES sets(setCode),
	CONSTRAINT FK_Card_Rarity
		FOREIGN KEY(rarity)
        REFERENCES rarities(rarityName),
	PRIMARY KEY (cardID),
    UNIQUE (cardID, setCode)
);

CREATE TABLE trades(
	tradeID INT NOT NULL,
	status VARCHAR(255) NOT NULL DEFAULT 'UNKNOWN',
	PRIMARY KEY (tradeID)
);

CREATE TABLE tradeMessages(
	tradeID INT NOT NULL,
	messageNum INT NOT NULL,
	timestamp DATETIME,
	message TEXT,
	sender VARCHAR(255) NOT NULL,

	CONSTRAINT FK_Trade_Ref
	FOREIGN KEY(tradeID) REFERENCES trades(tradeID),
	CONSTRAINT FK_Sender
	FOREIGN KEY(sender) REFERENCES users(username),
	PRIMARY KEY (tradeID, messageNum)
);