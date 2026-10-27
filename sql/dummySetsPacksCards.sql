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

INSERT INTO cards(cardID, cardName, setCode, imageLink) VALUES
(10, 'Bulb', 1, "https://assets.pokemon.com/static-assets/content-assets/cms2/img/cards/web/PGO/PGO_EN_1.png"),
(11, 'Char', 1, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREQf-f9MgqDB04tvGiIg1iHRs25STvKa-yDqDe2TjdjQ&s=10"),
(12, 'Squi', 1, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT629cNAXmfX9HwgRz07senzvO71YE6TWmYZnW3Ye2w6w&s=10"),
(13, 'Pidg', 1, "https://assets.pokemon.com/static-assets/content-assets/cms2/img/cards/web/SV03/SV03_EN_164.png"),
(14, 'Ratt', 1, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWVLzXJcejRi1Q2GjEpsEyD2vIT_GwtWnplpm3UMBrwg&s=10"),
(15, 'Pika', 1, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_XSxLK_Tj20FD_Bd-6IItl-owPQIazupaScwMt1Dtvw&s=10"), 
(20, 'Chik', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnLKcEAV0-RMGQ01cv-ocAnrc2rD_e3xgfATtd21QdFA&s=10"),
(21, 'Cynd', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLC-yjBUTAP2BCyO-yNUuoJN41O-0DyLq0cXpSsdsG5A&s=10"),
(22, 'Toto', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFITnhLA_Uxxj2EnXm2vjOoHO_e3RAXuqJX8LnA-o6zA&s=10"),
(23, 'Sent', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrAYgOiMZvFSA2YDcNiTjURQKIZ68jDzkSezSR0azFSA&s=10"),
(24, 'Spin', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP5lneNRH-vl0EX8RJpY8snbZ1zvI4JVKJJcNZ-gxxtg&s=10"),
(25, 'Hoot', 2, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfTG18E_X5jkDH0yKS1qdgp7PuWxC32ZtI3NyPR91O5A&s=10");

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