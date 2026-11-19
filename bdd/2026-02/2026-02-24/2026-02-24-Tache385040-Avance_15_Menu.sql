-- STEFAN
UPDATE MENUDYNAMIQUE SET rang = 0, niveau = 0, id_pere = '' WHERE ID = 'MD00021110002';
UPDATE MENUDYNAMIQUE SET rang = 3 WHERE ID = 'MD00021110071';
UPDATE MENUDYNAMIQUE SET rang = 4 WHERE ID = 'MD00021110072';
UPDATE MENUDYNAMIQUE SET href = 'module.jsp?but=paie/avance/avance-quinzaine-saisie.jsp', id_pere = 'MD00021110777', rang = 1 WHERE ID = 'MD00021110003';
UPDATE MENUDYNAMIQUE SET href = 'module.jsp?but=paie/avance/avance-liste.jsp&idType=PRU0447', id_pere = 'MD00021110777', rang = 2 WHERE ID = 'MD00021110004';


