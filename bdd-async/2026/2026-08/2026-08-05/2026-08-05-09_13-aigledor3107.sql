---Sarobidy

DELETE FROM usermenu WHERE id = 'UM5F4D8192'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM247089CE'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM16A6A887'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9229DA11'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA95B3E12'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1E5B9CC1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBFC569F1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM12522208'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM712445C7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM568374A0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM091947DA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC25A7749'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM64AFF8B5'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME6B312F7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7DD32482'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAB79A8EB'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMCB199A00'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME7F05E48'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4953859F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4C46C77B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM28AFE5C5'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB41B2D0C'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBEF14B09'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM05A15B50'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF1BB53BC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM41897B0E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3945F993'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM19F92B20'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8FCD8E6E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMED3D7243'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME4B9486F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM818EE347'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEFC93CEB'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM138496FA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME41E4821'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAA1C5677'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM994E790F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDF3BF081'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5184FD36'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4FA95564'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9C9C4486'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5A7FFB44'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM03051A25'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM244AB9AA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9B30A88D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD448FBF2'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBE8C04E9', 'MENDYN1785335030202805', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2A802F61', 'MENDYN1785335030202805', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM140A5D05', 'MENDYN1785335045614843', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM21D33482', 'MENDYN1785335045614843', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF26A133D', 'MENDYN1785335074064336', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA041A900', 'MENDYN1785335074064336', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF81B48F4', 'MENDYN1765272431570133', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6278F10E', 'MENDYN1765272431570133', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7D047E61', 'MNDNMT012', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAA4D7498', 'MNDNMT012', NULL, 'dg', 1);
 
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDD2BA4BA', 'MDT0210300229', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4852C4E0', 'MDT0210300229', NULL, 'dg', 1);


-- 2026-08-04-17_10-aigledor3107

CREATE OR REPLACE VIEW VENTE_DETAILS_TICKET AS
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       vd.IDPRODUIT,
       p.LIBELLE AS IDPRODUITLIB,
       v.IDORIGINE,
       vd.QTE,
       VD.pu
                     AS PU,
       CAST((nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montantRemise,
       CAST((1-nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montant,
       vd.iddevise AS iddevise,
       vd.tauxDeChange AS tauxDeChange,
       vd.tva AS tva,
       v.idclient,
       v.idclientlib,
       vd.designation,
       vd.PUREVIENT,
       cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
       p.UNITE,
       unit.val as idUniteLib,
       CAST(vd.pu * (1 + vd.TVA / 100) AS NUMBER(30,2)) AS PVTVA
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN UNITE unit ON unit.id = p.UNITE

;