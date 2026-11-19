-- ito izy avant

-- UPDATE MENUDYNAMIQUE
--SET LIBELLE='Relevé electricité', ICONE='find_replace', HREF='module.jsp?but=compteur/releve-electricite-liste.jsp', RANG=4, NIVEAU=3, ID_PERE='MNDCMPT012505'
--WHERE ID='MENDYN1781507344256825';

UPDATE MENUDYNAMIQUE SET href = 'module.jsp?but=compteur/releve-electricite-multiple-liste.jsp' WHERE id = 'MENDYN1781507344256825';