create or replace view VENTE_DETAILS_POIDS_ING as
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

    CAST(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) AS NUMBER(30, 5))                AS POIDS,
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
    p.IDREMISE
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