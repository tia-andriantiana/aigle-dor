create or replace view MOUVEMENTCAISSEGROUPEFACTURE1 as
select idorigine, sum(credit) as credit, sum(debit) as debit, sum(MONTANTRETOURNER) as montantretourner, C.IDDEVISE
from mouvementcaisse m
         LEFT JOIN caisse c on c.id = idcaisse
where m.etat >= 11
  and idorigine is not null
group by idorigine, c.iddevise;


create view VENTE_CPL1 as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.DATYPREVU,
       v.REMARQUE,
       v.ETAT,
       ADECLARER,
       CASE
           WHEN v.ETAT = 0 THEN 'ANNULÉE'
           WHEN v.ETAT = 1 THEN 'CRÉÉE'
           WHEN v.ETAT = 11 THEN 'VALIDÉE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       CASE
           WHEN cm.id IS NOT NULL
               THEN 'Oui'
           WHEN cm.id IS NULL
               THEN 'Non'
           END AS avecCommission,
       v.idmodepaiement,
       rf.REFERENCE as referencefacture,
       mp.val AS idmodepaiementlib,
       v.MONTANTDONNE as MONTANTDONNE,
       nvl(mv.MONTANTRETOURNER, 0) as montantretourner,
       v.heureSaisie,
       pers.nom AS idResponsablelib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture1 mv ON v.id in mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN COMMISSION cm ON cm.IDFACTURE = v.id
         LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         LEFT JOIN PERSONNEl pers ON pers.id = v.idResponsable;

create or replace view VENTE_CA as
SELECT
    v."ID",v."DESIGNATION",v."IDMAGASIN",v."IDMAGASINLIB",v."DATY",v."DATYPREVU",v."REMARQUE",v."ETAT",v."ADECLARER",v."ETATLIB",v."MONTANTTOTAL",v."IDDEVISE",v."IDCLIENT",v."IDCLIENTLIB",v."MONTANTTVA",v."MONTANTTTC",v."MONTANTTTCAR",v."MONTANTPAYE",v."MONTANTRESTE",v."AVOIR",v."TAUXDECHANGE",v."MONTANTREVIENT",v."MARGEBRUTE",v."IDRESERVATION",v."AVECCOMMISSION",v."IDMODEPAIEMENT",v."REFERENCEFACTURE",v."IDMODEPAIEMENTLIB",v."MONTANTDONNE",v."MONTANTRETOURNER",v."HEURESAISIE",v."IDRESPONSABLELIB",
    TO_CHAR(v.DATY, 'MM/YYYY')                                           AS moisanneelib,
    TO_CHAR(v.DATY, 'MM')                                                AS moislib,
    TO_CHAR(v.DATY, 'YYYY')                                              AS anneelib,
    1                                                                     AS nb,
    SUBSTR(v.HEURESAISIE, 1, 2) || 'h'  AS heurevente
FROM VENTE_CPL1 v;

create or replace view VENTE_DETAILS_CPL1 as
SELECT
    x.ID,
    x.IDVENTE,
    x.IDVENTELIB,
    x.IDPRODUIT,
    x.IDPRODUITLIB,
    x.IDORIGINE,
    x.QTE,
    x.PU,
    x.MONTANTREMISE,
    x.MONTANT,
    x.IDDEVISE,
    x.TAUXDECHANGE,
    x.TVA,
    x.IDCLIENT,
    x.IDCLIENTLIB,
    x.DESIGNATION,
    x.PUREVIENT,
    x.MONTANTREVIENT,
    x.IDUNITELIB,
    CAST(x.QTE * x.PU AS NUMBER(30,2)) AS PUTOTAL,
    x.magasin,
    x.reference,
    x.daty,
    x.RISTOURNE
FROM (
         SELECT
             vd.ID,
             vd.IDVENTE,
             v.DESIGNATION AS IDVENTELIB,
             vd.IDPRODUIT,
             p.LIBELLE AS IDPRODUITLIB,
             v.IDORIGINE,
             vd.QTE,
             vd.PU,
             CASE
                 WHEN vd.remiseMontant IS NOT NULL AND vd.remiseMontant > 0 THEN
                     NVL(vd.remiseMontant, 0)
                 ELSE
                     CAST((NVL(vd.remise / 100, 0)) * NVL((vd.QTE * vd.PU), 0) AS NUMBER(30, 2))
                 END AS MONTANTREMISE,
             CASE
                 WHEN vd.remiseMontant IS NOT NULL AND vd.remiseMontant > 0 THEN
                     (vd.QTE * vd.PU) - vd.remiseMontant
                 ELSE
                     CAST((1 - NVL(vd.remise / 100, 0)) * (vd.QTE * vd.PU) AS NUMBER(30, 2))
                 END AS MONTANT,
             vd.iddevise AS iddevise,
             vd.tauxDeChange AS tauxDeChange,
             vd.tva AS tva,
             v.idclient,
             v.idclientlib,
             p.LIBELLE AS designation,
             vd.PUREVIENT,
             CAST(vd.QTE * vd.PUREVIENT AS NUMBER(20, 2)) AS montantRevient,
             au.val AS idunitelib,
             pt.val as magasin,
             p.reference,
             v.daty,
             vd.RISTOURNE
         FROM VENTE_DETAILS vd
                  LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
                  LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
                  LEFT JOIN AS_UNITE au ON au.id = p.unite
                  LEFT JOIN POINT pt ON pt.id = v.idmagasin
     ) x;


create or replace view VENTE_DETAILS_CAT as
select v."ID",v."IDVENTE",v."IDVENTELIB",v."IDPRODUIT",
       v."IDPRODUITLIB",v."IDORIGINE",v."QTE",v."PU",
       v."MONTANTREMISE",v."MONTANT",v."IDDEVISE",
       v."TAUXDECHANGE",v."TVA",v."IDCLIENT",v."IDCLIENTLIB",
       v."DESIGNATION",v."PUREVIENT",v."MONTANTREVIENT",
       v."IDUNITELIB",v."PUTOTAL",v."MAGASIN",v."REFERENCE",v."DATY",v."RISTOURNE", ing.categorieingredient, 1 AS nb, v.MAGASIN as idMagasinLib
from VENTE_DETAILS_CPL1 v
         LEFT JOIN AS_INGREDIENTS_LIB ing on ing.ID = v.IDPRODUIT;


create view VENTE_CA_EVOLUTION as
SELECT
    v_today.DATY,
    SUM(v_today.MONTANTTOTAL)                                                    AS ca_jour,
    NVL(SUM(v_hier.MONTANTTOTAL), 0)                                             AS ca_veille,

    CASE
        WHEN NVL(SUM(v_hier.MONTANTTOTAL), 0) = 0 THEN 100
        ELSE ROUND(
                ((SUM(v_today.MONTANTTOTAL) - NVL(SUM(v_hier.MONTANTTOTAL), 0))
                    / NVL(SUM(v_hier.MONTANTTOTAL), 1)) * 100,
                2
             )
        END                                                                          AS evolution_pct,
    SUM(v_today.MONTANTTOTAL) - NVL(SUM(v_hier.MONTANTTOTAL), 0)                AS difference_montant,
    v_today.moislib,
    v_today.anneelib,
    v_today.moisanneelib,
    sum(v_today.nb) as ventes_jour,
    sum(v_hier.nb) as ventes_veille,
    CASE
        WHEN NVL(SUM(v_hier.nb), 0) = 0 THEN 100
        ELSE ROUND(
                ((SUM(v_today.nb) - NVL(SUM(v_hier.nb), 0))
                    / NVL(SUM(v_hier.nb), 1)) * 100,
                2
             )
        END                                                                          AS evolution_ventes_pct,
    SUM(v_today.nb) - NVL(SUM(v_hier.nb), 0)                                                        AS difference_ventes
FROM VENTE_CA v_today
         LEFT JOIN VENTE_CA v_hier
                   ON v_hier.DATY = v_today.DATY - 1
                       AND v_hier.IDMAGASIN = v_today.IDMAGASIN
GROUP BY
    v_today.DATY,
    v_today.moislib,
    v_today.anneelib,
    v_today.moisanneelib
ORDER BY DATY DESC;


