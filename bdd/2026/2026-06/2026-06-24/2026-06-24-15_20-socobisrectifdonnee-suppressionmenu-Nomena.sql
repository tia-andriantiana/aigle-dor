-- Suppression du menu "Transferts multiple" (Stock -> Transfert -> Transfert multiple)
DELETE FROM USERMENU WHERE IDMENU = 'MNDN00000002112001';
DELETE FROM MENUDYNAMIQUE WHERE ID = 'MNDN00000002112001';

-- Suppression du menu "Détails par entrée" (Stock -> État de stock -> Détails par entrée)
DELETE FROM USERMENU WHERE IDMENU = 'MNDN0002706171';
DELETE FROM MENUDYNAMIQUE WHERE ID = 'MNDN0002706171';

COMMIT;

-- ==========================================
-- BACKUP / RESTAURATION (Commenté)
-- ==========================================
-- INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) 
-- VALUES ('MNDN00000002112001', 'Transferts multiple', 'list_alt', 'module.jsp?but=stock/etatstock/etatstock-liste-transfert.jsp', 5, 3, 'MNDN0000000211');
--
-- INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) 
-- VALUES ('MNDN0002706171', 'Détails par entrée', 'list_alt', 'module.jsp?but=stock/etatstock/etatstock-liste-pu.jsp', 2, 3, 'MNDN000000017');
--
-- COMMIT;

-- Nomena
