UPDATE menudynamique SET libelle = 'Bon de Commande' WHERE id = 'MNDN00000000107';
UPDATE menudynamique SET libelle = 'Factures' WHERE id = 'MNDN000000007';

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1778052650179283', 'Commande', 'receipt_long', 'module.jsp?but=commande/commande-liste.jsp', 19, 2, 'MNDN000000001');
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDNAN001';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN00000000107';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000006';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDN000000007';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN000000012';
UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN00050500002L';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDN00050500002';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN0001109001';
UPDATE menudynamique SET rang = 10 WHERE id = 'MDO0000056';
UPDATE menudynamique SET rang = 11 WHERE id = 'MENDYN1758529047722337';
UPDATE menudynamique SET rang = 12 WHERE id = 'ELM01';
UPDATE menudynamique SET rang = 13 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 14 WHERE id = 'MENDYN1772626689297708';
UPDATE menudynamique SET rang = 15 WHERE id = 'MNDN000000010';
UPDATE menudynamique SET rang = 16 WHERE id = 'MNDN0005050001';
UPDATE menudynamique SET rang = 17 WHERE id = 'MENUDYN0077';


INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCEFAC1BB', 'MNDN000000006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3045A69A', 'MNDN000000006', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM012A908A', 'MNDN000000006', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA6AF871A', 'MNDN000000006', NULL, 'magcentral', 1);


UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN00050500002';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDN00050500002L';
