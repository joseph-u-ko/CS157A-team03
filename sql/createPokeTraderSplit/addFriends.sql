USE poketrader;

CREATE TABLE friends (
	userA VARCHAR(255) NOT NULL,
	userB VARCHAR(255) NOT NULL,
	status VARCHAR(255) NULL,
  
	CONSTRAINT FK_UserA
		FOREIGN KEY (userA)
        REFERENCES users(username),
	CONSTRAINT FK_UserB
		FOREIGN KEY (userB)
        REFERENCES users(username),
	CONSTRAINT FK_Not_Self
		CHECK (userA <> userB),
	PRIMARY KEY (userA, userB)
);
