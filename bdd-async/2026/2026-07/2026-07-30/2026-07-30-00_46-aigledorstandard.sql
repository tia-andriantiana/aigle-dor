-- 2026-07-30-00_46-aigledorstandard

CREATE OR REPLACE VIEW VENTE_DETAILS_LIB_ING AS
SELECT
    p.ID,
    p.IDVENTE,
    p.IDPRODUIT,
    p.IDORIGINE,
    CAST(p.QTE AS NUMBER(38, 2))                                              AS QTE,
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
    u.VAL                                                                     AS UNITELIB,

    CAST(p.pu - (p.pu * p.remise / 100) + (p.pu * p.tva / 100)
        AS NUMBER(30, 5))                                                    AS PUNET,

    CAST(((p.pu - (p.pu * p.remise / 100)) * p.qte
        - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0))
        AS NUMBER(30, 5))                                                    AS MONTANTHT,

    CAST(
            ((p.pu - (p.pu * p.remise / 100)) * p.qte
                - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0))
                + ((((p.pu * p.qte) - (p.pu * p.remise / 100) * p.qte)
                - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva / 100)
        AS NUMBER(30, 2)
    )                                                                         AS MONTANTTTC,

    CAST(
            ((((p.pu * p.qte) - (p.pu * p.remise / 100) * p.qte)
                - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva / 100)
        AS NUMBER(30, 2)
    )                                                                         AS MONTANTTVA,

    CAST((p.pu * p.remise / 100) * p.qte AS NUMBER(30, 5))                    AS MONTANTREMISE,

    CAST(p.pu * p.qte AS NUMBER(30, 5))                                       AS MONTANT,
    (NVL(p.QTE, 0) - NVL(bl.QUANTITE, 0)) - NVL(avcf.qte, 0)                  AS RESTE,

    CAST(NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)
        AS NUMBER(30, 5))                                                    AS FRAIS,

    ing.LIBELLEVENTE                                                          AS IDPRODUITLIB,
    v.DATY,
    v.DATYPREVU                                                               AS DATYPREVU,
    p.IDDEVISE                                                                AS IDDEVISELIB,
    c.VAL                                                                     AS IDCATEGORIELIB,
    c.VAL                                                                     AS CATEGORIEPRODUITLIB,
    CAST(
            ((p.pu - (p.pu * p.remise / 100)) * p.qte
                - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0))
                + ((((p.pu * p.qte) - (p.pu * p.remise / 100) * p.qte)
                - NVL(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva / 100)
        AS NUMBER(30, 2)
    )                                                                         AS PUTOTAL,

    cl.nom                                                                    AS IDCLIENTLIB,
    p.ristourne                                                               AS RISTOURNE,
    p.idprevision,
    v.IDRESERVATION,
    NVL(v.fraislivraison, 0)                                                  AS FRAISLIVRAISON,
    ing.calorie,
    CAST(p.pu / NVL(eq.QUANTITE, 1) AS NUMBER(30, 2))                        AS PUINGREDIENT,
    NVL(eq.QUANTITE, 1)                                                       AS CONTENUE,
    ing.unite2,
    (p.pu * p.qte) - ((p.pu * p.remise / 100) * p.qte)                        AS MONTANTREMISER,
    p.IDREMISE,
    ing.COULEUR,
    vrc.NOMCOULEUR AS COULEURLIB,
    ing.MARQUE,
    pointure.VAL AS MARQUELIB
FROM VENTE_DETAILS p
         LEFT JOIN VENTE v
                   ON v.id = p.IDVENTE
         LEFT JOIN AS_UNITE u
                   ON u.id = p.unite
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID
         LEFT JOIN EQUIVALENCEVENTE eq
                   ON eq.IDPRODUIT1 = p.IDPRODUIT
         LEFT JOIN BL_CLIENT_FILLE_grp_vente bl
                   ON bl.idventedetail = p.ID
         LEFT JOIN avoirfcfille_grp_viseee avcf
                   ON avcf.idventedetails = p.ID
         LEFT JOIN V_REFERENCE_COULEUR vrc
                   ON ing.COULEUR = vrc.REFERENCECOULEUR
         LEFT JOIN POINTURE pointure
                   ON ing.MARQUE = pointure.ID;


CREATE OR REPLACE VIEW AS_INGREDIENT_VENTE_LIB AS
select ing.ID,
       ing.LIBELLE as LIBELLE,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS  SEUIL,
       ing.UNITE,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK ,
       CAST(ing.PU AS NUMBER(30,5)) AS PU,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       ing.CATEGORIEINGREDIENT,
       ing.IDFOURNISSEUR,
       ing.DATY,
       CAST(ing.QTELIMITE AS NUMBER(30,5)) AS QTELIMITE,
       CAST(ing.PV AS NUMBER(30,5)) AS PV,
       ing.LIBELLEVENTE,
       CAST(COALESCE(ing.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,
       CAST(COALESCE(ing.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX,
       CAST(COALESCE(ing.PUACHATUSD,0) AS NUMBER(30,5)) AS PUACHATUSD,
       CAST(COALESCE(ing.PUACHATEURO,0) AS NUMBER(30,5)) AS PUACHATEURO,
       CAST(COALESCE(ing.PUACHATAUTREDEVISE,0) AS NUMBER(30,5)) AS PUACHATAUTREDEVISE,
       CAST(COALESCE(ing.PUVENTEUSD,0) AS NUMBER(30,5)) AS PUVENTEUSD,
       CAST(COALESCE(ing.PUVENTEEURO,0) AS NUMBER(30,5)) AS PUVENTEEURO,
       CAST(COALESCE(ing.PUVENTEAUTREDEVISE,0) AS NUMBER(30,5)) AS PUVENTEAUTREDEVISE,
       ing.ISVENTE,
       ing.ISACHAT,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.LIBELLEEXTACTE,
       CAST(ing.TVA AS NUMBER(10,5)) AS TVA,
       ing.FILEPATH,
       CAST(ing.RESTE AS NUMBER(20,5)) AS RESTE,
       ing.TYPESTOCK,
       ing.REFPOST,
       ing.REFQUALIFICATION,
       ing.IDCHAMBRE,
       ing.ISPERISHABLE,
       ing.PV2,
       ing.IDMAGASIN,
       CAST(nvl(ting.PRIXUNITAIRE,ing.PV)  AS NUMBER(30,5)) AS PRIXUNITAIRE,
       tc.ID as IDTYPECLIENT,
       tc.VAL as idtypeclientlib,
       nvl(un.id,un2.id) as idunite,
       nvl(un.VAL,un2.val) as idunitelib,
       CAST(eq.POIDS  AS NUMBER(30,5)) AS POIDS,
       CAST(eq.QUANTITE AS NUMBER(20,5)) AS QUANTITE,
       ting.IDMAGASIN as TARIFMAGASIN,
       UNITE2,
       ing.COULEUR,
       vrc.NOMCOULEUR AS COULEURLIB,
       ing.MARQUE,
       pointure.VAL AS MARQUELIB
from AS_INGREDIENTS ing
         cross join TYPECLIENT tc
         left join TARIF_INGREDIENTS_MAX ting on ing.ID = TING.IDINGREDIENT AND ting.IDTYPECLIENT=tc.id
         left join AS_UNITE un on un.ID = TING.UNITE
         left join AS_UNITE un2 on un2.ID = ing.UNITE
         left join EQUIVALENCEVENTE eq on eq.IDPRODUIT2 = ting.IDINGREDIENT
         LEFT JOIN V_REFERENCE_COULEUR vrc
                   ON ing.COULEUR = vrc.REFERENCECOULEUR
         LEFT JOIN POINTURE pointure
                   ON ing.MARQUE = pointure.ID
WHERE (ing.CATEGORIEINGREDIENT = 'CAT008' OR ing.ISVENTE = 1)



;