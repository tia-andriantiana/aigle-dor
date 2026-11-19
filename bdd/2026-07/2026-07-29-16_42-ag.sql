CREATE OR REPLACE VIEW V_POINTAGE_KPI_PRESENCE AS
WITH totals AS (
    SELECT COUNT(*) AS magasiniers_attendus
    FROM log_personnel_v2
),
presence AS (
    SELECT
        pm.daty,
        COUNT(DISTINCT CASE WHEN pm.idTypePointage = 'TP000001' THEN pm.idPersonnel END) AS presents
    FROM POINTAGE_MAGASINIER pm
    GROUP BY pm.daty
)
SELECT
    p.daty,
    p.presents,
    t.magasiniers_attendus,
    (t.magasiniers_attendus - p.presents) AS absents,
    ROUND(p.presents * 100.0 / NULLIF(t.magasiniers_attendus, 0), 2) AS taux_presence
FROM presence p
         CROSS JOIN totals t;

---

CREATE OR REPLACE VIEW V_POINTAGE_KPI_RETARD AS
WITH premier_pointage AS (
    SELECT
        pm.daty,
        pm.idPersonnel,
        MIN(pm.heure) AS heure
    FROM POINTAGE_MAGASINIER pm
    WHERE pm.idTypePointage = 'TP000001'
    GROUP BY pm.daty, pm.idPersonnel
),
horaire AS (
    SELECT heureArriveeNormal
    FROM CONF_HORAIRE
    WHERE ROWNUM = 1
)
SELECT
    p.daty,
    COUNT(*) AS nb_retards,
    ROUND(
            AVG(
                    (TO_DATE(p.heure, 'HH24:MI:SS') - TO_DATE(h.heureArriveeNormal, 'HH24:MI:SS')) * 24 * 60
            ),
            0
    ) AS retard_moyen_minutes
FROM premier_pointage p
         CROSS JOIN horaire h
WHERE TO_DATE(p.heure, 'HH24:MI:SS') > TO_DATE(h.heureArriveeNormal, 'HH24:MI:SS')
GROUP BY p.daty;
---


CREATE OR REPLACE VIEW V_POINTAGE_JOUR AS
SELECT
    pm.daty,
    pm.heure,
    p.nom || ' ' || p.prenom AS employe,
    pdv.val AS point_de_vente,
    tp.val AS action
FROM POINTAGE_MAGASINIER pm
    JOIN log_personnel_v2 p
ON p.id=pm.idPersonnel
    JOIN POINT pdv
    ON pdv.id=pm.idPoint
    JOIN typePointage tp
    ON tp.id=pm.idTypePointage;


---
CREATE OR REPLACE VIEW V_POINTAGE_RETARDS AS
WITH premier_pointage AS (
    SELECT
        pm.daty,
        pm.idPersonnel,
        pm.idPoint,
        MIN(pm.heure) AS heure
    FROM POINTAGE_MAGASINIER pm
    WHERE pm.idTypePointage = 'TP000001'
    GROUP BY pm.daty, pm.idPersonnel, pm.idPoint
),
horaire AS (
    SELECT heureArriveeNormal
    FROM CONF_HORAIRE
    WHERE ROWNUM = 1
)
SELECT
    t.daty,
    p.nom || ' ' || p.prenom AS personnel,
    pdv.val AS point_de_vente,
    t.heure AS heure_arrivee,
    ROUND(
            (TO_DATE(t.heure, 'HH24:MI:SS') - TO_DATE(h.heureArriveeNormal, 'HH24:MI:SS')) * 24 * 60
    ) AS retard_minutes
FROM premier_pointage t
         INNER JOIN log_personnel_v2 p ON p.id = t.idPersonnel
         INNER JOIN POINT pdv          ON pdv.id = t.idPoint
         CROSS JOIN horaire h
WHERE TO_DATE(t.heure, 'HH24:MI:SS') > TO_DATE(h.heureArriveeNormal, 'HH24:MI:SS');
---

CREATE OR REPLACE VIEW V_POINTAGE_RETARD_POINT AS
SELECT
    daty,
    point_de_vente,
    COUNT(*) AS nb_retards,
    ROUND(AVG(retard_minutes), 0) AS retard_moyen_minutes
FROM V_POINTAGE_RETARDS
GROUP BY
    daty,
    point_de_vente;

---

UPDATE menudynamique SET rang = 5 WHERE id = 'MENDYN1785353714232846';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENDYN1765357174546422';
UPDATE menudynamique SET rang = 7 WHERE id = 'MD00021110001';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENDYN1765437395219335';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENDYN1773301147657248';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENDYN1776671202070346';
UPDATE menudynamique SET rang = 11 WHERE id = 'MENDYN177460016447254';
UPDATE menudynamique SET rang = 12 WHERE id = 'MENDYN1774426742347394';
UPDATE menudynamique SET libelle = 'Gestion des pointages', href = '', rang = 5 WHERE id = 'MENDYN1785353714232846';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1785356964603319', 'Liste des retards', 'view_list', 'module.jsp?but=rh/pointage/retard.jsp', 3, 3, 'MENDYN1785353714232846');

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1785353714232846', 'Gestion de pointage', 'schedule', '', 12, 2, 'ELM000010');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1785353826079264', 'Liste des pointages', 'view_list', 'rh/pointage/pointagemagasinier-liste.jsp', 1, 3, 'MENDYN1785353714232846');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1785354117943917', 'Saisie de pointage', 'add', 'rh/pointage/pointagemagasinier-saisie.jsp', 2, 3, 'MENDYN1785353714232846');


CREATE OR REPLACE  VIEW ST_INGREDIENTSAUTO AS
SELECT
    ai.ID,ai.LIBELLE,CAST(ai.SEUIL AS NUMBER(10,5)) AS SEUIL ,au.val AS UNITE,CAST(ai.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,CAST(ai.PU AS NUMBER(30,5)) AS PU,ai.ACTIF,ai.PHOTO,ai.CALORIE,ai.DURRE,ai.COMPOSE,ai.CATEGORIEINGREDIENT,ai.IDFOURNISSEUR,ai.DATY,CAST(ai.QTELIMITE AS NUMBER(30,5)) AS QTELIMITE,CAST(ai.PV AS NUMBER(30,5)) AS PV,ai.LIBELLEVENTE,CAST(COALESCE(ai.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,CAST(COALESCE(ai.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX,CAST(COALESCE(ai.PUACHATUSD,0) AS NUMBER(30,5)) AS PUACHATUSD,CAST(COALESCE(ai.PUACHATEURO,0) AS NUMBER(30,5)) AS PUACHATEURO,CAST(COALESCE(ai.PUACHATAUTREDEVISE,0) AS NUMBER(30,5)) AS PUACHATAUTREDEVISE,CAST(COALESCE(ai.PUVENTEUSD,0) AS NUMBER(30,5)) AS PUVENTEUSD,CAST(COALESCE(ai.PUVENTEEURO,0) AS NUMBER(30,5)) AS PUVENTEEURO,CAST(COALESCE(ai.PUVENTEAUTREDEVISE,0) AS NUMBER(30,5)) AS PUVENTEAUTREDEVISE,ai.ISVENTE,ai.ISACHAT,ai.COMPTE_VENTE,ai.COMPTE_ACHAT,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte,
    au.VAL AS UNITELIB
FROM AS_INGREDIENTS ai
         LEFT JOIN AS_UNITE au  ON au.id = ai.UNITE
where ai.actif = 1
;


-- AIGLEDORSTANDARD.AS_INGREDIENTS_LIB source

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB  AS
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS SEUIL ,
       au.VAL AS unite,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,
       CAST(ing.pu AS NUMBER(30,5)) AS pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       ing.MARQUE,
       ing.IDMODELE,
       mo.LIBELLE as IDMODELELIB,
       po.VAL as marquelib,
       ta.VAL as taillelib,
       ing.COULEUR,
       ing.TAILLE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       CAST(ing.pv AS NUMBER(30,5)) AS pv,
       CAST(ing.tva AS NUMBER(10,5)) AS tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       ing.typeProduit,
       tp.idligne,
       ing.compte_stock,
       ing.compte_sortie_stock,
       f.nom as idFournisseurLib,
       dep.val AS idDepartementLib,
       ing.LIBELLEVENTE,
       eq.QUANTITE as nbpiece,
       tp.val AS typeproduitLib
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
         LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id
         LEFT JOIN departement dep ON dep.id=ing.parfums
         Left join EQUIVALENCEVENTE eq on eq.IDPRODUIT1 = ing.ID
         LEFT JOIN MODELE mo on mo.ID = ing.IDMODELE
         LEFT JOIN TAILLE ta on ta.ID = ing.TAILLE
         LEFT JOIN  POINTURE po on po.ID = ing.MARQUE
where ing.actif = 1;


-- AIGLEDORSTANDARD.V_INVENTAIREFILLECPL source

CREATE OR REPLACE  VIEW V_INVENTAIREFILLECPL  AS
SELECT base."ID",base."IDINVENTAIRE",base."IDPRODUIT",base."IDPRODUITLIB",base."EXPLICATION",base."QUANTITETHEORIQUE",base."QUANTITE",base."LIBELLEEXTACTE",base."PU",base."ECART",base."DATEINV",base."MONTANTTHEORIQUE",base."MONTANTREELLE",base."ECARTMONTANT",base."CATEGORIEINGREDIENT",
       (
           NVL(CAST(base.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDINVENTAIRE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUIT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUITLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.EXPLICATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.QUANTITETHEORIQUE), '') || ' | ' ||
           NVL(TO_CHAR(base.QUANTITE), '') || ' | ' ||
           NVL(CAST(base.LIBELLEEXTACTE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.PU), '') || ' | ' ||
           NVL(TO_CHAR(base.ECART), '') || ' | ' ||
           NVL(TO_CHAR(base.DATEINV, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTTHEORIQUE), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANTREELLE), '') || ' | ' ||
           NVL(TO_CHAR(base.ECARTMONTANT), '') || ' | ' ||
           NVL(
                   CAST(base.CATEGORIEINGREDIENT AS VARCHAR2(4000)),
                   ''
           )
           ) AS MOTSCLESSS
FROM (
         SELECT i.ID,
                i.IDINVENTAIRE,
                i.IDPRODUIT,
                p.LIBELLE AS IDPRODUITLIB,
                i.EXPLICATION,
                CAST(
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS QUANTITETHEORIQUE,
                CAST(
                        NVL(i.QUANTITE, 0)
                    AS NUMBER(30, 6)
                ) AS QUANTITE,
                p.LIBELLEEXTACTE,
                CAST(
                        NVL(i.PU, 0)
                    AS NUMBER(30, 6)
                ) AS PU,
                CAST(
                        NVL(i.QUANTITE, 0) -
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS ECART,
                iv.DATY AS DATEINV,
                CAST(
                        NVL(i.PU, 0) *
                        NVL(i.QUANTITETHEORIQUE, 0)
                    AS NUMBER(30, 6)
                ) AS MONTANTTHEORIQUE,
                CAST(
                        NVL(i.PU, 0) *
                        NVL(i.QUANTITE, 0)
                    AS NUMBER(30, 6)
                ) AS MONTANTREELLE,
                CAST(
                        (
                            NVL(i.PU, 0) -
                            NVL(i.QUANTITE, 0)
                            ) -
                        (
                            NVL(i.PU, 0) -
                            NVL(i.QUANTITETHEORIQUE, 0)
                            )
                    AS NUMBER(30, 6)
                ) AS ECARTMONTANT,
                p.CATEGORIEINGREDIENT
         FROM INVENTAIREFILLE i
                  LEFT JOIN INVENTAIRE iv
                            ON iv.ID = i.IDINVENTAIRE
                  LEFT JOIN AS_INGREDIENTS p
                            ON p.ID = i.IDPRODUIT
         WHERE iv.ETAT >= 11
     ) base;


-- AIGLEDORSTANDARD2.AS_INGREDIENTS_LIB source

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB  AS
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS SEUIL ,
       au.VAL AS unite,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,
       CAST(ing.pu AS NUMBER(30,5)) AS pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       ing.MARQUE,
       ing.IDMODELE,
       mo.LIBELLE as IDMODELELIB,
       po.VAL as marquelib,
       ta.VAL as taillelib,
       ing.COULEUR,
       ing.TAILLE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       CAST(ing.pv AS NUMBER(30,5)) AS pv,
       CAST(ing.tva AS NUMBER(10,5)) AS tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       ing.typeProduit,
       tp.idligne,
       ing.compte_stock,
       ing.compte_sortie_stock,
       f.nom as idFournisseurLib,
       dep.val AS idDepartementLib,
       ing.LIBELLEVENTE,
       eq.QUANTITE as nbpiece,
       tp.val AS typeproduitLib
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
         LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id
         LEFT JOIN departement dep ON dep.id=ing.parfums
         Left join EQUIVALENCEVENTE eq on eq.IDPRODUIT1 = ing.ID
         LEFT JOIN MODELE mo on mo.ID = ing.IDMODELE
         LEFT JOIN TAILLE ta on ta.ID = ing.TAILLE
         LEFT JOIN  POINTURE po on po.ID = ing.MARQUE
where ing.actif = 1;


-- AIGLEDORSTANDARD2.ST_INGREDIENTSAUTO source

CREATE OR REPLACE VIEW ST_INGREDIENTSAUTO  AS
SELECT
    ai.ID,ai.LIBELLE,CAST(ai.SEUIL AS NUMBER(10,5)) AS SEUIL ,au.val AS UNITE,CAST(ai.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,CAST(ai.PU AS NUMBER(30,5)) AS PU,ai.ACTIF,ai.PHOTO,ai.CALORIE,ai.DURRE,ai.COMPOSE,ai.CATEGORIEINGREDIENT,ai.IDFOURNISSEUR,ai.DATY,CAST(ai.QTELIMITE AS NUMBER(30,5)) AS QTELIMITE,CAST(ai.PV AS NUMBER(30,5)) AS PV,ai.LIBELLEVENTE,CAST(COALESCE(ai.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,CAST(COALESCE(ai.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX,CAST(COALESCE(ai.PUACHATUSD,0) AS NUMBER(30,5)) AS PUACHATUSD,CAST(COALESCE(ai.PUACHATEURO,0) AS NUMBER(30,5)) AS PUACHATEURO,CAST(COALESCE(ai.PUACHATAUTREDEVISE,0) AS NUMBER(30,5)) AS PUACHATAUTREDEVISE,CAST(COALESCE(ai.PUVENTEUSD,0) AS NUMBER(30,5)) AS PUVENTEUSD,CAST(COALESCE(ai.PUVENTEEURO,0) AS NUMBER(30,5)) AS PUVENTEEURO,CAST(COALESCE(ai.PUVENTEAUTREDEVISE,0) AS NUMBER(30,5)) AS PUVENTEAUTREDEVISE,ai.ISVENTE,ai.ISACHAT,ai.COMPTE_VENTE,ai.COMPTE_ACHAT,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte,
    au.VAL AS UNITELIB,
    ai.couleur,
    ingl.marqueLib

FROM AS_INGREDIENTS ai
         LEFT JOIN AS_UNITE au  ON au.id = ai.UNITE
         left join AS_INGREDIENTS_LIB ingl ON ai.id = ingl.id
where ai.actif = 1
;


-- AIGLEDORSTANDARD2.ST_INGREDIENTSAUTOACHAT_CPL source

CREATE OR REPLACE VIEW ST_INGREDIENTSAUTOACHAT_CPL AS
select st."ID",st."LIBELLE",st."SEUIL",st."UNITE",st."QUANTITEPARPACK",st."PU",st."ACTIF",st."PHOTO",st."CALORIE",st."DURRE",st."COMPOSE",st."CATEGORIEINGREDIENT",st."IDFOURNISSEUR",st."DATY",st."QTELIMITE",st."PV",st."LIBELLEVENTE",st."SEUILMIN",st."SEUILMAX",st."PUACHATUSD",st."PUACHATEURO",st."PUACHATAUTREDEVISE",st."PUVENTEUSD",st."PUVENTEEURO",st."PUVENTEAUTREDEVISE",st."ISVENTE",st."ISACHAT",st."COMPTE_VENTE",st."COMPTE_ACHAT",st."COMPTE", 1 as taux, st.couleur, st.marqueLib from ST_INGREDIENTSAUTO st

;