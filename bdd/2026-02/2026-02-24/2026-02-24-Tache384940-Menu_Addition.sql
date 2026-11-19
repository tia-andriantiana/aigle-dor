--STEFAN

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110333', 'Avance Sp&eacute;cial', 'add_card', '', 3, 3, 'MD00021110001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110031', 'Saisie', 'add_card', 'module.jsp?but=paie/avance/avance-saisie.jsp', 1, 4, 'MD00021110333');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110032', 'Liste', 'receipt_long', 'module.jsp?but=paie/avance/avance-liste.jsp', 2, 4, 'MD00021110333');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110033', 'Remboursement', 'request_page', 'module.jsp?but=paie/avance/remboursement-liste.jsp', 3, 4, 'MD00021110333');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110034', 'Paiement Avance', 'payments', '', 4, 4, 'MD00021110333');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD0002111003411', 'Liste avance impay&eacute;e', 'receipt_long', 'module.jsp?but=paie/avance/avance-liste-impayee.jsp&idType=PRU0453', 1, 5, 'MD00021110034');



INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110777', 'Avance du 15', 'add_card', '', 4, 3, 'MD00021110001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110071', 'Saisie Mutliple', 'add_card', 'module.jsp?but=paie/avance/avancesaisie-multiple.jsp', 1, 4, 'MD00021110777');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD00021110072', 'Paiement Avance', 'add_card', '', 2, 4, 'MD00021110777');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MD0002111007211', 'Liste avance impay&eacute;e', 'receipt_long', 'module.jsp?but=paie/avance/avance-liste-impayee.jsp&idType=PRU0447', 1, 5, 'MD00021110072');

UPDATE MENUDYNAMIQUE SET ID_PERE = '', RANG = 0, NIVEAU = 0 WHERE ID = 'AMS006';