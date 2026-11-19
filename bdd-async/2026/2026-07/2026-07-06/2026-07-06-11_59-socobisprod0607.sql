--view VENTE_CPL
--
--atao jointure am AS_BONDELIVRAISON_CLIENT_CPL
--
--asina datedelivraison
--
--raha NULL ilay livraison d ilay date de livraison ao am VENTE_CPL no raisina
--
--Optimisena fa mram b ilay page misy anio view io

--- ajout  IDRESERVATION , fraislivraison , calorie
CREATE OR REPLACE  VIEW VENTE_DETAILS_VIDE (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, FRAIS, MONTANTHT, MONTANTTTC, MONTANTTVA, MONTANTREMISE, MONTANT, RISTOURNE, IDCLIENTLIB, DATY, DATYPREVU, IDPRODUITLIB, IDCATEGORIELIB, CATEGORIEPRODUITLIB, POIDS, IDPREVISION, CALORIE,IDRESERVATION,fraislivraison) AS 
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
       cast(p.pu - (p.pu * remise / 100) + ((p.pu * p.tva / 100)) as number(30, 5))                                                   as punet,
       cast(nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 5))                                          as frais,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                    NVL(p.QTE, 0)) as number(30, 5))                                                  as montantht,
       cast(((p.pu - (p.pu * remise / 100)) * qte - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) +
            ((((p.pu * qte) - (p.pu * remise / 100) * qte) -
              nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva /
             100) as number(30, 5))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * remise / 100) * qte) - nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                             NVL(p.QTE, 0)) * p.tva / 100) as number(30, 5))                                            as montanttva,
       cast((p.pu * remise / 100) * qte as number(30, 5))                                                                             as montantremise,
       cast((p.pu) * qte as number(30, 5))                                                                                            as montant,
       p.ristourne,
       cl.nom                                                                                                  as idclientlib,
       v.DATY,
       v.DATYPREVU,
       ing.LIBELLE                                                                                             AS IDPRODUITLIB,
       c.VAL                                                                                                   AS IDCATEGORIELIB,
       c.VAL                                                                                                   AS CATEGORIEPRODUITLIB,
       cast(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 5))                                                                     as poids,
       p.idprevision,
       ing.calorie,
       v.IDRESERVATION,
       nvl(v.fraislivraison, 0) AS fraislivraison
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
         left join vente v on v.id = p.IDVENTE
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID
                       
 
 ;
 
 
 CREATE OR REPLACE  VIEW VENTE_DETAILS_POIDS (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, MONTANTHT, MONTANTTTC, MONTANTTVA, MONTANTREMISE, MONTANT, POIDS, RESTE, FRAIS, IDPRODUITLIB, DATY, DATYPREVU, IDDEVISELIB, IDCATEGORIELIB, CATEGORIEPRODUITLIB, PUTOTAL, IDCLIENTLIB, RISTOURNE, IDPREVISION,IDRESERVATION,fraislivraison,CALORIE) AS 
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
       v.calorie
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN EQUIVALENCE e
                   ON e.IDPRODUIT = v.IDPRODUIT
                       AND e.IDUNITE = v.UNITE
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN Vente ve
                   ON ve.ID = v.IDVENTE
         LEFT JOIN VENTE_DETAILS vdc
                   ON vdc.ID = ve.ID
 

 ;


CREATE OR REPLACE  VIEW VENTEMONTANT (ID, MONTANTTOTAL, MONTANTREMISE, FRAIS, MONTANTTOTALACHAT, MONTANTTVA, MONTANTTTC, IDDEVISE, TAUXDECHANGE, MONTANTTTCAR, MONTANTREVIENT, IDRESERVATION) AS 
  SELECT vd.IDVENTE AS ID,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) as number(30, 2))                          AS montanttotal,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PU, 0))) -
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) as number(30, 2))                  AS montantremise,
       sum(FRAIS)                                                                                                    as frais,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PuAchat, 0))) as number(30, 2))                                             AS montanttotalachat,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) * (NVL(VD.TVA, 0)) /
                100) as number(30, 2))                                                                               AS montantTva,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                 (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) * (NVL(VD.TVA, 0)) / 100) +
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) as number(30, 2))                          as montantTTC,
       NVL(vd.IDDEVISE, 'AR')                                                                                        AS IDDEVISE,
       NVL(avg(vd.tauxDeChange), 1)                                                                                  AS tauxDeChange,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0) -
                                                 (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE) *
                                                 NVL(VD.TAUXDECHANGE, 1)) *
                (NVL(VD.TVA, 0)) / 100) +
            SUM(((1 - nvl(vd.remise / 100, 0)) *
                 (NVL(vd.QTE, 0) * NVL(vd.PU, 0) - (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) *
                 NVL(VD.TAUXDECHANGE, 1)) -
                ((nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE))) as number(30, 2))                        as montantTTCAR,
       cast(sum(vd.PUREVIENT * vd.QTE) as number(20, 2))                                                             as montantRevient,
       vd.IDRESERVATION
FROM VENTE_DETAILS_POIDS vd
--         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
--         left join AS_INGREDIENTS vp on vp.id = vd.IDPRODUIT
GROUP BY vd.IDVENTE, vd.IDDEVISE, vd.IDRESERVATION
 ;




CREATE OR REPLACE  VIEW VENTE_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, MONTANTTOTAL, IDDEVISE, IDCLIENT, IDCLIENTLIB, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, DATYPREVU, REFERENCEFACTURE, MONTANTREMISE, MONTANT, MOIS, ANNEE, POIDS, COLIS, MODEPAIEMENT, MODEPAIEMENTLIB, FRAISLIVRAISON, MODELIVRAISON, MODELIVRAISONLIB, RESTE, IDPROVINCE, PROVINCELIB, IDORIGINE, FRAIS, REFERENCEFACT, NUMEROFACTURE, LIEULIVRAISON, DATELIVRAISON, UPDATED_AT, ESTPREVULIB,datedelivraison) AS 
  SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL                                                                                         AS IDMAGASINLIB,
                v.DATY,
                v.REMARQUE,
                v.ETAT,
                CASE
                    WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
                    WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
                    END
                                                                                                              AS ETATLIB,
                cast(v2.MONTANTTOTAL as number(30, 5)) AS MONTANTTOTAL,
                v2.IDDEVISE,
                v.IDCLIENT,
                c.NOM                                                                                         AS IDCLIENTLIB,
                cast(V2.MONTANTTVA as number(30, 5))                                                          as MONTANTTVA,
                cast(V2.MONTANTTTC as number(30, 5))                                                          as montantttc,
                cast(V2.MONTANTTTCAR as number(30, 5))                                                        as MONTANTTTCAR,
                cast(nvl(mv.montant, 0) AS number(30, 5))                                                     AS montantpaye,
                cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0)- nvl(ACG.MONTANTPAYEAR, 0)  AS number(30, 5)) AS montantreste,
                cast(ACG.MONTANTTTC as number(30, 5))                                             as avoir,
                cast(v2.tauxDeChange as number(10, 2))                                                                        AS tauxDeChange,
                cast(v2.MONTANTREVIENT as number(20, 5)) AS MONTANTREVIENT  ,
                cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 5))                                  as margeBrute,
                v.IDRESERVATION,
                case when v.DATYPREVU is null then v.daty else V.DATYPREVU end                                as datyprevu,
                rf.REFERENCE                                                                                 as referencefacture,
                cast(v2.MONTANTREMISE as number(30, 5)) AS MONTANTREMISE,
                cast(nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0) as number(30, 5))                                             as montant,
                extract(month from v.DATY)                                                                    as mois,
                extract(year from v.DATY)                                                                     as annee,
                CAST(vp.poids as number(30, 5))                                                               as poids,
                CAST(vp.colis as number(30, 5))                                                               as colis,
                v.modepaiement,
                mp.VAL                                                                                        as modepaiementlib,
                nvl(v.fraislivraison, 0) * nvl(vp.poids, 0)                                                   as fraislivraison,
                v.modelivraison,
                CASE
                    WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
                    WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
                    END                                                                                       AS modelivraisonlib,
                cast(vr.reste  as number(30, 5)) AS reste,
                pv.id                                                                                         as idprovince,
                pv.val                                                                                        as provincelib,
                --bl.id                                                                                         as idbl,
                v.IDORIGINE,
                CAST(COALESCE(v.FRAISLIVRAISON,0) AS  number(30, 5))                                                                             as frais,
                v.REFERENCEFACT,
                v.NUMEROFACTURE,
                v.LIEULIVRAISON,
                v.DATELIVRAISON,
                v.UPDATED_AT,
                case
                    when v.ESTPREVU = 0 then 'Non'
                    ELSE 'Oui'
                    END estprevulib,
                nvl(blc.daty,v.DATELIVRAISON) AS datedelivraison
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  left join PROVINCE pv on pv.id = c.IDPROVINCE
                  LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
                  LEFT JOIN AVOIRFCMONTANT ACG on ACG.IDVENTE = v.ID
                  LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
                  left join vente_poids vp on vp.idvente = v.id
                  left join MODEPAIEMENT mp on mp.id = v.modepaiement
                  left join vente_reste vr on vr.idvente = v.id
                  LEFT JOIN AS_BONDELIVRAISON_CLIENT blc ON blc.IDVENTE = v.id
                  

 ;