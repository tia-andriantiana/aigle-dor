INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN003', 'Budget', 'account_balance_wallet', null, 13, 1, null);
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN004', 'Saisie', 'add', 'module.jsp?but=budget/budget-saisie.jsp', 1, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN005', 'Liste', 'view_list', 'module.jsp?but=budget/budget-liste.jsp', 2, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN006', 'Dupliquer', 'add', 'module.jsp?but=budget/budget-liste-choix.jsp', 3, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN007', 'Situation depense', 'view_list', 'module.jsp?but=budget/budget-depenses-liste.jsp', 4, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYN1607007', 'Situation depense annuelle', 'view_list', 'module.jsp?but=budget/budget-depenses-annuel.jsp', 5, 2, 'MENUDYN003');
