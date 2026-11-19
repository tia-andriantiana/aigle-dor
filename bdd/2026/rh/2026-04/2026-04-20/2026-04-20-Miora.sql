INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1776671202070346', 'Configurations', 'security', '', 9, 2, 'ELM000010');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1776671295351277', 'Catégorie', 'notes', 'paie/annexe/categorie-paie-liste.jsp', 1, 3, 'MENDYN1776671202070346');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM4F6AE984'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEDC4028F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2C402353'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9BC01A5B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5D63F2D2'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1861D31F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7840FD0D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0051F7AA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA28BE93CD'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5CE4B033', 'MENUDYN01908001', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAD246821', 'MENUDYN01908001', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM33B0135F', 'MENUDYN01908001', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMADF891AD', 'MENUDYN01908001', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD1E6A6A5', 'MENUDYN01908001', NULL, 'ctrmaitre', 1);
