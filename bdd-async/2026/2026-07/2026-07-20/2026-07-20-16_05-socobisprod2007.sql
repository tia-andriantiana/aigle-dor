--Menu fabrication ampidirina anaty production

--INSERT INTO MENUDYNAMIQUE
--(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
--VALUES('MENUDYN00304002', 'Fabrication', 'precision_manufacturing', 'module.jsp?but=fabrication/fabrication-liste.jsp', 3, 1, NULL);

UPDATE MENUDYNAMIQUE 
SET rang = 6 , niveau = 2 , id_pere='MENUDYN00304001'
WHERE id = 'MENUDYN00304002';