UPDATE MENUDYNAMIQUE SET LIBELLE = 'Liste TVA', ICONE = 'description', HREF = 'module.jsp?but=declaration/liste-tva-adeclarer.jsp', RANG = 2, NIVEAU = 3, ID_PERE = 'MENDYN1769515257466822' where ID='MENDYN176951533777035';

delete from MENUDYNAMIQUE where id='MENDYN1768800763152660';

UPDATE MENUDYNAMIQUE SET LIBELLE = 'État', ICONE = 'balance', HREF = 'module.jsp?but=rapprochement/etat-rapprochement.jsp', RANG = 10, NIVEAU = 3, ID_PERE = 'MENDYN1766386514657608' WHERE ID = 'MENDYN1770706593858630';

UPDATE MENUDYNAMIQUE SET LIBELLE = 'Facture Standard', ICONE = 'description', HREF = '/socobis/pages/module.jsp?but=compta/depense/facture-depense-liste.jsp', RANG = 20, NIVEAU = 2, ID_PERE = 'MNDN274' WHERE ID = 'MENDYN176951991615864';
