-- Nomena Ramar

CREATE OR REPLACE VIEW VENTEMONTANT AS
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
       NVL(NULLIF(avg(vd.tauxDeChange), 0), 1)                                                                                  AS tauxDeChange,
       cast(SUM((((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - (nvl(vd.fraislivraison, 0) * nvl(vd.CALORIE, 0) * vd.QTE)) * (1 + NVL(VD.TVA, 0) / 100)) * NVL(NULLIF(vd.TAUXDECHANGE, 0), 1)) as number(30, 2)) as montantTTCAR,
       cast(sum(vd.PUREVIENT * vd.QTE) as number(20, 2))                                                             as montantRevient,
       vd.IDRESERVATION
FROM VENTE_DETAILS_POIDS vd
--         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
--         left join AS_INGREDIENTS vp on vp.id = vd.IDPRODUIT
GROUP BY vd.IDVENTE, vd.IDDEVISE, vd.IDRESERVATION;

CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2_VISEE AS
SELECT VD.ID,
       VD.IDVENTE,
       VD.IDVENTELIB,
       VD.IDPRODUIT,
       VD.IDPRODUITLIB,
       VD.IDORIGINE,
       VD.QTE,
       CAST(VD.PU AS NUMBER(30,5)) AS PU,
       CAST(VD.PUTOTAL AS NUMBER(30,2)) AS PUTOTAL,
       CAST(VD.PUTOTALACHAT AS NUMBER(30,2)) AS PUTOTALACHAT,
       CAST(VD.PUREVIENT AS NUMBER(30,2)) AS PUREVIENT,
       VD.IDCATEGORIE,
       VD.IDCATEGORIELIB,
       VD.DATY,
       VD.IDMAGASIN,
       VD.IDMAGASINLIB,
       VD.IDPOINT,
       VD.IDPOINTLIB,
       VD.IDDEVISE,
       VD.IDDEVISELIB,
       VD.IDRESERVATION,
       VD.IDBCFILLE,
       SUM(VD.QTE) OVER ()                            AS SUM_QTE,
       CAST(SUM(VD.PUTOTAL) OVER () AS NUMBER(30,2))                        AS MONTANTTOTAL,
       CAST(SUM(VD.PUTOTAL) OVER () AS NUMBER(30,2))                        AS MONTANT_TOTAL,
       V.IDCLIENT,
       CAST(SUM(VD.PUTOTAL)  OVER (PARTITION BY V.IDCLIENT) AS NUMBER(30,2))  AS TOTAL_ACHAT,
       VD.TYPEPRODUIT,
       VD.TYPEPRODUITLIB,
       VD.IDPROVINCE,
       VD.IDPROVINCELIB,
       VD.IDMODELE,
       VD.IDMODELELIB,
       VD.IDCATEGORIEMODELE,
       VD.IDSOUSCATEGORIE,
       VD.IDCATEGORIEMODELLIB,
       VD.IDSOUSCATEGORIELIB,
       CAST(NVL(p.MONTANTTTC, 0) * NVL(NULLIF(p.TAUXDECHANGE, 0), 1) AS NUMBER(30,2)) AS MONTANTTTCAR
FROM VENTE_DETAILS_CPL_2 VD
         LEFT JOIN VENTE V ON V.ID = VD.IDVENTE
         LEFT JOIN VENTE_DETAILS_POIDS p ON p.ID = VD.ID
WHERE V.ETAT >= 11;

CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_CPL_M AS
SELECT
    bc.ID,
    bc.DATY,
    case WHEN (sum(bcf.QTERESTE)) = 0 then 12
         else bc.ETAT
        END AS ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN (sum(bcf.QTERESTE)) = 0 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 12 THEN '<span style=color: green;>VALID&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>R&Eacute;CUP&Eacute;RATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    sum(bcf.QTERESTE) as QTERESTE,
    CASE
        WHEN nvl(vo.nombre,0) > 0 THEN '<span style=color: green;>FACTUR&Eacute;</span>'
        WHEN nvl(vo.nombre,0) = 0 THEN '<span style=color: red;>NON FACTUR&Eacute;</span>'
        END AS facturelib,
     bc.ID || '' || bc.DATY || '' || bc.IDCLIENT || '' || c.NOM || '' || bc.DESIGNATION || '' || bc.REFERENCE || '' || bc.MODEPAIEMENT || '' || bc.NUMEROBC AS motsclesss,
       CAST(SUM(NVL(bcf.MONTANTTTC, 0)) AS NUMBER(30,2)) AS MONTANTTTC,
       CAST(SUM(NVL(bcf.MONTANTTTC, 0)) AS NUMBER(30,2)) AS MONTANTTTCAR
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
         left join BC_CLIENT_FILLE_CPL_LIB bcf on bcf.IDBC = bc.ID
group by
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL,
    bc.IDCLIENT,
    c.NOM,
    bc.REFERENCE,
    m2.VAL,
    bc.IDPROFORMA,
    vo.nombre,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    bc.modelivraison;

-- Colonnes ajoutees en fin de VENTE_CPL, sans retirer les colonnes existantes.
-- montant paye AR = paiement x taux (taux nul = 1).
-- montant restant AR = TTC AR - paye AR - avoir net AR.

CREATE OR REPLACE VIEW VENTE_CPL AS
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
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.MONTANTTTCAR-acg.MONTANTPAYEAR, 0) AS number(30, 5)) AS montantreste,
       cast(nvl(ACG.MONTANTTTCAR, 0) as number(30, 5))                                             as avoir,
       cast(v2.tauxDeChange as number(10, 2))                                                                        AS tauxDeChange,
       cast(v2.MONTANTREVIENT as number(20, 5)) AS MONTANTREVIENT  ,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 5))                                  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end                                as datyprevu,
       rf.REFERENCE                                                                                  as referencefacture,
       cast(v2.MONTANTREMISE as number(30, 5)) AS MONTANTREMISE,
       cast(nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0) as number(30, 5))                                             as montant,
       extract(month from v.DATY)                                                                    as mois,
       extract(year from v.DATY)                                                                     as annee,
       CAST(v2.poids as number(30, 5))                                                               as poids,
       CAST(v2.colis as number(30, 5))                                                               as colis,
       v.modepaiement,
       mp.VAL                                                                                        as modepaiementlib,
       nvl(v.fraislivraison, 0) * nvl(v2.poids, 0)                                                   as fraislivraison,
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
       ce.id AS idecriture,
       nvl(blc.daty,v.DATELIVRAISON) AS datedelivraison,
       v.ID || '' || v.DATY || '' || v.IDCLIENT || '' || c.NOM || '' || v.IDMAGASIN || '' || m.VAL || '' || v.REMARQUE AS motsclesss,
       v.heureSaisie,
       ADECLARER,
       v.factureEchange,
       m.id as idPoint,
       cast(nvl(mv.montant, 0) * NVL(NULLIF(v2.tauxDeChange, 0), 1) AS number(30, 5)) AS montantpayeAr,
       cast(nvl(V2.MONTANTTTCAR, 0) - nvl(mv.montant, 0) * NVL(NULLIF(v2.tauxDeChange, 0), 1) - nvl(ACG.MONTANTTTCAR - acg.MONTANTPAYEAR, 0) AS number(30, 5)) AS montantresteAr
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN POINT m ON m.ID = v.IDMAGASIN
         left join ZONE pv on pv.id = m.IDZONE
         JOIN VENTEMONTANTLEGER v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN AVOIRFCMONTANT ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
    --left join( select sum(vd.POIDS) as poids,sum(vd.QTE) as colis,v.ID  from VENTE_DETAILS vd left join vente v on v.ID=vd.IDVENTE where v.ETAT>=11 group by v.ID ) vp on vp.ID=v.id
    --left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN AS_BONDELIVRAISON_CLIENT blc ON blc.IDVENTE = v.id
         LEFT JOIN compta_ecriture ce ON ce.idobjet=v.id;
 
 
