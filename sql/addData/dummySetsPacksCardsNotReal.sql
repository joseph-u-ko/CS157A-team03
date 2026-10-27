USE poketrader;

INSERT INTO sets(setCode, setName) VALUES
(1, 'A'),
(2, 'B');

INSERT INTO packs(packID, packName, available, setCode) VALUES
(1, 'Aaa', 0, 1),
(2, 'Abb', 1, 1),
(3, 'Acc', 1, 1),
(4, 'Baa', 1, 2),
(5, 'Bbb', 0, 2),
(6, 'Bcc', 1, 2);

INSERT INTO cards(cardID, cardName, setCode) VALUES
(10, 'Bulb', 1),
(11, 'Char', 1),
(12, 'Squi', 1),
(13, 'Pidg', 1),
(14, 'Ratt', 1),
(15, 'Pika', 1),
(20, 'Chik', 2),
(21, 'Cynd', 2),
(22, 'Toto', 2),
(23, 'Sent', 2),
(24, 'Spin', 2),
(25, 'Hoot', 2);

INSERT INTO contains(packID, cardID, setCode) VALUES
-- Pack 1: Aaa
(1, 10, 1),
(1, 11, 1),
(1, 12, 1),
(1, 13, 1),

-- Pack 2: Abb
(2, 10, 1),
(2, 11, 1),
(2, 12, 1),
(2, 14, 1),

-- Pack 3: Acc
(3, 10, 1),
(3, 11, 1),
(3, 12, 1),
(3, 15, 1),

-- Pack 4: Baa
(4, 20, 2),
(4, 21, 2),
(4, 22, 2),
(4, 23, 2),

-- Pack 5: Bbb
(5, 20, 2),
(5, 21, 2),
(5, 22, 2),
(5, 24, 2),

-- Pack 6: Bcc
(6, 20, 2),
(6, 21, 2),
(6, 22, 2),
(6, 25, 2);