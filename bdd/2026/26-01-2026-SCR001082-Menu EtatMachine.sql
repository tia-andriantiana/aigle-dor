INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1769417776103657', 'État d''une machine', 'list_alt', '', 5, 3, 'MNDNMT0134256');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN176941779929791', 'Saisie', 'add', 'module.jsp?but=etatMachine/etatMachine-saisie.jsp', 1, 4, 'MENDYN1769417776103657');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1769417822543438', 'Liste', 'view_list', 'module.jsp?but=etatMachine/etatMachine-liste.jsp', 2, 4, 'MENDYN1769417776103657');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRM007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM764D4E4D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC229D1EA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM90ADFDE8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMECCFC05B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM532DE836'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEBC7550F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4DB1A7B0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEEB450C6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM32B50DEC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6DC9B43F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1625DB0E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM73FC13A7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6814C3B6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFEDE5BAB'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM623D6E90'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB6ADE54C'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM55950519'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD4E30755'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD8436813'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFF585EE5'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC6501082'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC46BC915'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1A173FF8'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM278E3D0F', 'ELM000010', '*', NULL, 0);
