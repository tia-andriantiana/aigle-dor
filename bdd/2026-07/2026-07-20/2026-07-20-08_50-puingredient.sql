create or replace view PROFORMADETAILS_CPL_ING_PDF as
SELECT vd.ID,
       vd.IDPROFORMA,
       vd.IDPRODUIT,
       vd.IDORIGINE,
       vd.QTE,
       vd.PU,
       vd.REMISE,
       vd.TVA,
       vd.PUACHAT,
       vd.PUVENTE,
       v.IDDEVISE,
       vd.TAUXDECHANGE,
       vd.DESIGNATION,
       vd.COMPTE,
       vd.PUREVIENT,
       vd.IDDEMANDEPRIXFILLE,
       v.DESIGNATION                                                                                       AS IDPROFORMALIB,
       p.LIBELLEVENTE                                                                                           AS IDPRODUITLIB,
       cast((vd.QTE * vd.PU) as NUMBER(30, 2))                                                             AS puTotal,
       vd.unite,
       au.val                                                                                              AS uniteLib,
       cast(((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2))                                 AS remisemontant,
       cast((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) * nvl(vd.ristourne, 0) /
             100) as number(30, 2))                                                                                               as montantristourne,
       cast(nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0) as number(30, 2))                                as fraistransport,
       cast((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
             (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) * nvl(vd.ristourne, 0) /
              100)) -
            nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0) as number(30 ,2))                                                       as montanttotal,
       cast((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)))  as number(30 ,2))                                                       as montantremise,
       cast((nvl(vd.TVA, 0) / 100) *
            ((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
              (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
               nvl(vd.ristourne, 0) /
               100)) -
             nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0)) as number(30,2))                                                     as montanttva,
       cast(((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
              (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
               nvl(vd.ristourne, 0) /
               100)) - nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0)) + (nvl(vd.TVA, 0) / 100) *
                                                                        ((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
                                                                          (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
                                                                           nvl(vd.ristourne, 0) / 100)) -
                                                                         p.CALORIE * vd.QTE *
                                                                         v.fraislivraison) as number(30, 2))                      as montantttc,
       vd.datedebut,
       cast(nvl(p.calorie, 0) as number(10,2))                                                                                   as CALORIE,
       vd.ristourne                                                                                        as ristourne,
       cast(p.CALORIE as number(30, 2))                                                                    as poidsparkilo,
       cast(v.fraislivraison as number(30, 2))                                                             as fraislivraison,
       cast(p.CALORIE * vd.QTE as number(30, 2))                                                           as poidstotal,
       cast((vd.pu/nvl(eq.QUANTITE,1)) as number(30,2)) as puingredient,
       nvl(eq.QUANTITE,1) as contenue,
       p.UNITE2
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=p.ID;

create or replace view VENTE_DETAILS_POIDS_ING as
SELECT v.ID,
       v.IDVENTE,
       v.IDPRODUIT,
       v.IDORIGINE,
       CAST(v.QTE AS NUMBER(38, 2)) AS QTE,
       v.PU,
       v.REMISE,
       v.TVA,
       v.PUACHAT,
       v.PUVENTE,
       v.IDDEVISE,
       v.TAUXDECHANGE,
       v.DESIGNATION,
       v.COMPTE,
       v.PUREVIENT,
       v.IDBCFILLE,
       v.UNITE,
       v.UNITELIB,
       v.PUNET,
       v.MONTANTHT,
       cast(v.MONTANTTTC as number(30,2)) as MONTANTTTC,
       cast(v.MONTANTTVA as number(30,2)) as montanttva,
       v.MONTANTREMISE,
       v.MONTANT,
       v.poids,
       vc.RESTE                     AS RESTE,
       v.frais                      AS FRAIS,
       v.IDPRODUITLIB,
       v.DATY,
       v.DATYPREVU                  AS DATYPREVU,
       v.IDDEVISE                   AS IDDEVISELIB,
       v.IDCATEGORIELIB,
       v.CATEGORIEPRODUITLIB,
       montantttc                   AS PUTOTAL,
       v.idclientlib,
       v.RISTOURNE                  AS RISTOURNE,
       v.idprevision,
       v.IDRESERVATION,
       v.fraislivraison,
       v.calorie,
       cast((v.pu/nvl(eq.QUANTITE,1)) as number(30,2)) as puingredient,
       nvl(eq.QUANTITE,1) as contenue,
       ing.unite2,
       MONTANT-MONTANTREMISE as montantremiser
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=v.IDPRODUIT
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = v.IDPRODUIT;

