--dans menu vente => analyse => ajouter 'par zone', lien = vente/vente-analyse-client.jsp&grouper=idprovincelib

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0002708114702', 'Analyse des ventes par zone', 'bar_chart', 'module.jsp?but=vente/vente-analyse-client.jsp&grouper=idprovincelib', 10, 3, 'MNDN000000010');