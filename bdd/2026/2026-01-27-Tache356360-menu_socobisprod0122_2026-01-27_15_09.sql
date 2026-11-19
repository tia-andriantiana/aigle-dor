INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1769515692345990', 'État inspection', 'view_list', '', 5, 2, 'MNDNMT01');
UPDATE menudynamique SET href = '' WHERE id = 'MNDNMT012';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1769515739156933', 'Saisie', 'add', 'module.jsp?but=etatInspection/etatInspection-saisie.jsp', 1, 3, 'MENDYN1769515692345990');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1769515764762417', 'Liste', 'view_list', 'module.jsp?but=etatInspection/etatInspection-liste.jsp', 2, 3, 'MENDYN1769515692345990');
