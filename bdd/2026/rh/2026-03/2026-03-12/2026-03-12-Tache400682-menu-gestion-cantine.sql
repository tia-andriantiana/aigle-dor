INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773301147657248', 'Gestion des cantines', 'list_alt', '', 8, 2, 'ELM000010');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773301182314342', 'Saisie des pointages', 'add', 'module.jsp?but=paie/cantine/pointage-cantine-saisie.jsp', 1, 3, 'MENDYN1773301147657248');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN177330121385016', 'Liste des pointages', 'list_alt', 'module.jsp?but=paie/cantine/pointage-cantine-liste.jsp', 2, 3, 'MENDYN1773301147657248');

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9D75EDF8', 'MD000020040030', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8AC539EC', 'MD000020040030', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3B62D1C6', 'MD000020040030', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6F9A4C68', 'MD000020040030', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM82C3AB09', 'MD000020040030', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2683A69F', 'MD000020040030', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9C845CA8', 'MD000020040030', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF691337A', 'MD000020040030', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM43B64329', 'MD000020040030', NULL, 'pompiste', 1);