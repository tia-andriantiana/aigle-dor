
create or replace view COMMANDEFILLE_CPL_LIB as
SELECT bcf.ID,
       bcf.PRODUIT,
       bcf.IDC,
       bcf.QUANTITE,
       bcf.PU,
       bcf.MONTANT,
       bcf.TVA,
       bcf.REMISE,
       bcf.IDDEVISE,
       bcf.UNITE,
       i.LIBELLEVENTE                                                                                                                                      AS PRODUITlib,
       i.compte_vente                                                                                                                                 AS compte,
       NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0)                                                                                                        AS qtereste,
       au.val                                                                                                                                         AS UNITELIB,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2))                                                                                   AS MONTANTTOTAL,
       cast(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) as number(30, 2))                                                          as montantdelaremise,
       cast((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
            (bcf.ristourne / 100) as number(30, 2))                                                                                                   as montantristourne,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) -
            ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
             (bcf.ristourne / 100)) -
            nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0) as number(30, 2))                                                                    as montantremise,
       CAST(
               (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) -
                 (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) +
                  ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) -
                    ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.ristourne / 100))) -
                 nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) *
                (nvl(bcf.TVA, 0) / 100))
           AS NUMBER(30, 2)
       )                                                                                                                                              AS MONTANTTVA,
       cast((cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) -
             (cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) *
              nvl(bcf.ristourne, 0) /
              100) - nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) + (nvl(bcf.TVA, 0) / 100) *
                                                                             (cast((bcf.quantite * bcf.PU) -
                                                                                   ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                   100 as NUMBER(30, 2)) -
                                                                              (cast((bcf.quantite * bcf.PU) -
                                                                                    ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                    100 as NUMBER(30, 2)) *
                                                                               nvl(bcf.ristourne, 0) / 100) -
                                                                              nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) as number(30, 2)) AS MONTANTTTC,
       bcf.ristourne,
       nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)                                                                                           as fraistransport,
       CAST(NVL(i.CALORIE * bcf.QUANTITE,0) AS NUMBER(30,2)) AS poidstotal,
       i.CALORIE
FROM COMMANDEFILLE bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite
         LEFT JOIN COMMANDE bc on bc.id = bcf.IDC;



update AS_INGREDIENTS set tva=20 where CATEGORIEINGREDIENT = 'CAT008';

alter table PROFORMA add reference varchar2(50);

create or replace view AS_INGREDIENTS_LIB as
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
       eq.QUANTITE as nbpiece
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
;

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

create or replace view VENTE_CPL as
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
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.imputeefactar, 0) AS number(30, 5)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30, 5))                                             as avoir,
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
       ce.id AS idecriture,
       nvl(blc.daty,v.DATELIVRAISON) AS datedelivraison
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN AS_BONDELIVRAISON_CLIENT blc ON blc.IDVENTE = v.id
         LEFT JOIN compta_ecriture ce ON ce.idobjet=v.id;


create or replace view V_ETATSTOCK_ING_ENG as
SELECT
    p.ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    CAST(ms.quantite AS NUMBER(30,5) ) AS QUANTITE,
    CAST(NVL( ms.entree, 0) AS NUMBER(30, 5))  AS ENTREE,
    CAST(NVL( ms.sortie, 0) AS NUMBER(30, 5))  AS SORTIE,
    CAST(NVL( ms.quantite, 0) AS NUMBER(30, 5))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    CAST(ms.montantEntree AS NUMBER(30,5)) AS montantEntree,
    CAST(ms.montantSortie AS NUMBER(30,5)) AS montantSortie,
    CAST(p.pu AS NUMBER(30,5)) AS pu,
    CAST(ms.montant AS NUMBER(30,5)) AS montantReste,
    p.LIBELLEVENTE
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK_eng ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0) > 0 OR NVL(ms.SORTIE, 0) > 0;

create or replace view PROFORMADETAILS_CPL_ING as
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
       p.pu as puingredient,
       nvl(eq.QUANTITE,1) as contenue
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=p.ID
;


ALTER TABLE EQUIVALENCEVENTE
    ADD CONSTRAINT UK_EQUIVALENCEVENTE_IDPRODUIT
        UNIQUE (IDPRODUIT1);

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
       ing.pu as puingredient,
       nvl(eq.QUANTITE,1) as contenue
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=v.IDPRODUIT
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = v.IDPRODUIT;

select LIBELLEVENTE from V_ETATSTOCK_ING_Eng;


create or replace view V_ETATSTOCK_ING_ENG_SOMME as
SELECT
    p.ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    sum(CAST(ms.quantite AS NUMBER(30,5) )) AS QUANTITE,
    sum(CAST(NVL( ms.entree, 0) AS NUMBER(30, 5)))  AS ENTREE,
    sum(CAST(NVL( ms.sortie, 0) AS NUMBER(30, 5)) ) AS SORTIE,
    sum(CAST(NVL( ms.quantite, 0) AS NUMBER(30, 5)))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    CAST(p.pu AS NUMBER(30,5)) AS pu,
    p.LIBELLEVENTE
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK_eng ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0) > 0 OR NVL(ms.SORTIE, 0) > 0
group by p.ID, p.LIBELLE, p.CATEGORIEINGREDIENT, tp.DESCE, ms.IDMAGASIN, mag.VAL, p.UNITE, u.DESCE, mag.IDPOINT, mag.IDTYPEMAGASIN, p.SEUILMIN, p.SEUILMAX, p.pu, p.LIBELLEVENTE;

select * from MENUDYNAMIQUE where id='MENDYN177883819268969';

UPDATE MENUDYNAMIQUE SET LIBELLE = 'Liste des factures &agrave; encaisser' where id='MENDYN177883819268969';

create or replace view V_ETATSTOCK_ING as
SELECT
    '-' as id,ai.typeStock,
    ai.id AS IDPRODUIT,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT,
    c.VAL AS idtypeproduitlib,
    m.id as IDMAGASIN,
    m.VAL AS idmagasinlib,
    ve.QUANTITE,
    CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,
    CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,
    CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,
    CAST(nvl(ve.ENTREE*ve.pu,0) AS NUMBER(30,2)) AS MONTANTENTREE,
    CAST(nvl(ve.sortie*ve.pu,0) AS NUMBER(30,2)) AS MONTANTSORTIE,
    CAST(nvl((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu),0) AS NUMBER(30,2)) AS MONTANTRESTE,
    ai.UNITE,
    u.VAL AS idunitelib,
    case
        when ve.reste!=0 then CAST(nvl((((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu))/nvl(ve.reste,1)),0) AS NUMBER(30,2))
        else cast(ai.pu as number(30,2))
        end as pu,
    ve.DATY
FROM (
         SELECT
             IDPRODUIT,
             sum(mf.ENTREE) as ENTREE,
             sum (mf.SORTIE) SORTIE,
             '' as IDVENTEDETAIL,
             '' as IDTRANSFERTDETAIL,
             avg (mf.PU) as PU,
             '' as MVTSRC,
             '' as DATY,
             (sum(mf.ENTREE)-sum (mf.SORTIE)) as RESTE,
             0 as QUANTITE,
             m.IDMAGASIN IDMAGASIN
         FROM MVTSTOCKFILLE mf
                  left join mvtStock m on m.id=mf.IDMVTSTOCK
         where m.ETAT>=11
         group by mf.IDPRODUIT,m.IDMAGASIN
     ) ve
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
         LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
         LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE  ve.PU >= 0 and ve.reste>0;


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
        WHEN (sum(bcf.QTERESTE)) = 0 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;E</span>'
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 12 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;E</span>'
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










