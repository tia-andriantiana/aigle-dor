create view PROFORMACOMMADER as
select PRODUIT, sum(QUANTITE) as quantite, bc.IDPROFORMA from BONDECOMMANDE_CLIENT_FILLE bcf join BONDECOMMANDE_CLIENT bc on bc.id=bcf.IDBC where bc.ETAT>=11 group by PRODUIT, bc.IDPROFORMA;

create or replace view BONDECOMMANDEFACTURER as
select PRODUIT,sum(bcf.QUANTITE) - sum(vdf.QTE) as quantite, bc.IDPROFORMA from bondecommande_client_fille bcf join VENTE_DETAILS vdf ON bcf.id = vdf.idbcfille join vente v on v.id=vdf.IDVENTE join BONDECOMMANDE_CLIENT bc on bc.ID=bcf.IDBC where v.ETAT>=11 group by PRODUIT, bc.IDPROFORMA;


create or replace view PROFORMADETAILS_CPL as
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
       ((vd.qte - pfc.QUANTITE ) +  bcr.QUANTITE )as restebc
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite
         LEFT JOIN PROFORMACOMMADER pfc on pfc.IDPROFORMA=v.ID and vd.IDPRODUIT=pfc.PRODUIT
         LEFT JOIN BONDECOMMANDEFACTURER bcr on v.id=bcr.IDPROFORMA and bcr.PRODUIT=vd.IDPRODUIT
order by p.LIBELLEVENTE asc
;

create or replace view BONDECOMMANDE_CLIENT_CPL_M as
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
        END AS facturelib
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

create or replace view PROFORMA_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           WHEN v.ETAT = 12 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;</span>'
           END
                                                                                              AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.CODECLIENT,
       c.NOM                                                                                  AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE                                                                            AS CONTACT,
       cast(V2.POIDSTOTAL as number(30, 5))                                                   as poidstotal,
       cast(V2.montant as number(30, 5))                                                      as montant,
       cast(V2.montantremise as number(30, 5))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 5))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10, 5)) as fraislivraison,
       cast(V2.FRAISTRANSPORT as number(30, 5))                                               as fraistransport,
       cast(v2.MONTANTTOTAL as number(30, 5))                                                 AS MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 5))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 5))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 5))                                                 as MONTANTTTCAR,
       cast(nvl(mv.credit, 0) - nvl(ACG.MONTANTPAYE, 0) AS number(30, 5))                     AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.credit, 0) - nvl(ACG.resteapayer_avr, 0) AS number(30, 5)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)                                                             as avoir,
       cast(v2.tauxDeChange  as number(10, 2))                                                                        AS tauxDeChange,
       cast(v2.MONTANTREVIENT as number(20, 5))                                               AS MONTANTREVIENT,
       cast((COALESCE(V2.MONTANTTTCAR,0) - COALESCE(v2.MONTANTREVIENT,0)) as number(20, 5))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise,
       v.NUMEROPROFORMA,
       v.IDCOMMANDE,
       CASE
           WHEN v.modelivraison = 1 THEN 'LIVRAISON'
           WHEN v.modelivraison = 2 THEN 'RECUPERATION'
           END AS modelivraisonlib,
       v.lieuLivraison AS lieulivraison,
       v.datelivraison AS datelivraison,
       v.reference
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;
