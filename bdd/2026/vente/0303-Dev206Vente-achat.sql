ALTER TABLE VENTE_DETAILS ADD IDPREVISION VARCHAR2(55);
create or replace view VENTE_DETAILS_VIDE as
select p.ID,
       p.IDVENTE,
       p.IDPRODUIT,
       p.IDORIGINE,
       p.QTE,
       p.PU,
       p.REMISE,
       p.TVA,
       p.PUACHAT,
       p.PUVENTE,
       p.IDDEVISE,
       p.TAUXDECHANGE,
       p.DESIGNATION,
       p.COMPTE,
       p.PUREVIENT,
       p.IDBCFILLE,
       p.UNITE,
       u.VAL                                                                                                   as unitelib,
       cast(p.pu - (p.pu * remise / 100) + ((p.pu * p.tva / 100)) as number(30, 2))                                                   as punet,
       cast(nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 2))                                          as frais,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                    NVL(p.QTE, 0)) as number(30,2))                                                  as montantht,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) +
            ((((p.pu * qte) - (p.pu * remise / 100) * qte) -
              nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva /
             100) as number(30, 2))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * remise / 100) * qte) - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                             NVL(p.QTE, 0)) * p.tva / 100) as number(30,2))                                            as montanttva,
       cast((p.pu * remise / 100) * qte as number(30,2))                                                                             as montantremise,
       cast((p.pu) * qte as number(30,2))                                                                                            as montant,
       p.ristourne,
       cl.nom                                                                                                  as idclientlib,
       v.DATY,
       v.DATYPREVU,
       ing.LIBELLE                                                                                             AS IDPRODUITLIB,
       c.VAL                                                                                                   AS IDCATEGORIELIB,
       c.VAL                                                                                                   AS CATEGORIEPRODUITLIB,
       cast(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30,2))                                                                     as poids,
       p.idprevision
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
         left join vente v on v.id = p.IDVENTE
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID;
                       /
                       
                       
                       
CREATE OR REPLACE
VIEW UPDATEVENTEDETAILS AS
SELECT
	vd.ID,
	vd.IDVENTE,
	vd.IDPRODUIT,
	p.LIBELLE AS idProduitLib,
	vd.IDORIGINE,
	vd.QTE,
	vd.PU,
	vd.REMISE,
	vd.TVA,
	vd.PUACHAT,
	vd.PUVENTE,
	vd.IDDEVISE,
	vd.TAUXDECHANGE,
	vd.DESIGNATION,
	vd.COMPTE,
	vd.idprevision
FROM
	VENTE_DETAILS vd
LEFT JOIN AS_INGREDIENTS p ON
	p.ID = vd.IDPRODUIT;

    UPDATE menudynamique SET rang = 1 WHERE id = 'MNDNAN001';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN000000006';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN00000000107';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN000000006';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000007';
UPDATE menudynamique SET rang = 14, id_pere = 'MNDN000000001' WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 15, id_pere = 'MNDN000000001' WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0014';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1772544841195913', 'Paiement Avance', 'fa fa-plus', 'module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree-vente.jsp', 16, 2, 'MNDN000000001');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM278E3D0F'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM999DD3B2', 'MENUDYN0077', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8147ED73', 'MENUDYN0077', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME5A2BC43', 'MENUDYN7778', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDAE0B45E', 'MENUDYN7778', NULL, 'magcentral', 1);

UPDATE menudynamique SET rang = 13, id_pere = 'MNDN000000001' WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 14 WHERE id = 'MNDN0005050001';
UPDATE menudynamique SET rang = 15 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 16 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 17 WHERE id = 'MENDYN1772544841195913';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN0014';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD6F270C2', 'MENUDYN0077RC', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7C6E207C', 'MENUDYN0077RC', NULL, 'magcentral', 1);



CREATE OR REPLACE VIEW RELEVECLIENT AS 
select relever.ID,
       relever.JOURNAL,
       relever.REFERENCE,
       relever.DATY,
       relever.LIBELLE,
       relever.LETTRE,
       relever.DEBIT,
       relever.CREDIT,
       relever.IDCLIENT,
       t.NOM as clientlib,
       t.COMPTE,
       relever.updated_at,relever.solde,
       EXTRACT(YEAR FROM relever.DATY) AS annee
from (select id,
             ' '                      as journal,
             id                       as reference,
             daty,
             'NOTE DE CREDIT :' || id as libelle,
             ' '                      as lettre,
             0                        as debit	,
             MONTANTTTCAR             as credit,
             IDCLIENT,
             DATY as updated_at,
             MONTANTTTCAR*-1 as solde
      from AVOIRFCLIB_CPL_VISEE
  UNION ALL
      select id,
             ' '           as journal,
             NUMEROFACTURE as reference,
             daty,
             case when REFERENCES_PAIEMENT is null then ' ' else REFERENCES_PAIEMENT end,
             ' '           as lettre,
             MONTANTTTCAR  as debit,
             0             as credit,
             IDCLIENT,
             UPDATED_AT as updated_at,
             MONTANTTTCAR as solde
      from MOUVEMENTCAISSE_DETAIL_UNIQUE
      where ETAT >= 7
  UNION ALL
      select mc.id,
             ' '        as journal,
             mc.id      as reference,
             mc.datycomptabilisation,
             mc.DESIGNATION,
             ' '        as lettre,
             0          as debit,
             mc.CREDIT,
             mc.IDTIERS as idclient,
             mc.UPDATED_AT,
             mc.CREDIT*-1 as solde
      from MOUVEMENTCAISSECPL mc where ETAT > 8 ) relever
         left join tiers t on t.id = relever.IDCLIENT
order by IDCLIENT, DATY, updated_at
 ;


INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1772626689297708', 'Relevé Client par année', 'fa fa-file-alt', 'module.jsp?but=vente\releve-client-annee.jsp', 18, 2, 'MNDN000000001');
UPDATE menudynamique SET rang = 15 WHERE id = 'MNDN0005050001';
UPDATE menudynamique SET rang = 16 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 17 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 18 WHERE id = 'MENDYN1772544841195913';
UPDATE menudynamique SET icone = 'fa fa-book' WHERE id = 'MENDYN1772626689297708';

UPDATE SOCOBISPROD0324.MENUDYNAMIQUE
SET LIBELLE='Paiement Avance', ICONE='add', HREF='module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree-vente.jsp', RANG=17, NIVEAU=2, ID_PERE='MNDN000000001'
WHERE ID='MENDYN1771571618461753';

UPDATE menudynamique SET icone = 'account_balance' WHERE id = 'MENDYN1772626689297708';
UPDATE menudynamique SET icone = 'account_balance' WHERE id = 'MENDYN1772544841195913';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDN000000012';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN00050500002L';
UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN00050500002';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDN0001109001';
UPDATE menudynamique SET rang = 9 WHERE id = 'MDO0000056';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENDYN1758529047722337';
UPDATE menudynamique SET rang = 11 WHERE id = 'ELM01';
UPDATE menudynamique SET rang = 12 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET icone = 'account_balance', rang = 13 WHERE id = 'MENDYN1772626689297708';
UPDATE menudynamique SET rang = 14 WHERE id = 'MNDN000000010';
UPDATE menudynamique SET rang = 18 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET icone = 'account_balance', rang = 19 WHERE id = 'MENDYN1772544841195913';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM3D691778'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM15CB585B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0B31FEE4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME7B167A4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1AD41C4D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5B107730'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF213856B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA8233799'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6DA53E52'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD5417853'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1AF5B886'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB4F0DE15'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM59614918'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM329586DD'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7DBB8B00'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6A53205F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMECD0BD33'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1B21CC3D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM44B4CE7A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6471F550'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFE224DE8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME2F84976'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM08A75924'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM226C9647'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAA371AC6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM28BB2A12'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEA760317'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF1C6EE36'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM727E1C57'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1E084B61'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM128D6ED5'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBCBBBFBD'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDACAFEC7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4B0F89E0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC86A6D57'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7C549333'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF3A14573'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM999DD3B2'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8147ED73'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME5A2BC43'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDAE0B45E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD6F270C2'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7C6E207C'; -- 1 rows
