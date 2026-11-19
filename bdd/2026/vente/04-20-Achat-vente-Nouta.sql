CREATE OR REPLACE VIEW DMDACHATFILLE_LIB AS 
SELECT 
    d.*,
    au.val AS unite
FROM DMDACHATFILLE d
LEFT JOIN AS_INGREDIENTS ai 
    ON ai.id = d.idproduit
LEFT JOIN AS_UNITE au 
    ON au.id = ai.UNITE;
    
-- SOCOBISCOMPLET0420.AS_BONDECOMMANDE_MERECPL source

CREATE OR REPLACE  VIEW "AS_BONDECOMMANDE_MERECPL" ("ID", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "FOURNISSEUR", "REFERENCE", "DATELIMITE", "MODEPAIEMENTLIB", "FOURNISSEURLIB", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCARIARY", "IDDEVISELIB", "IDDEVISE", "ETATLIB") AS 
  SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    ab.dateLimite,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11 THEN 'VIS&Eacute;E'
        WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;E'
        END
        AS ETATLIB
from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
 ;


-- SOCOBISCOMPLET0420.AS_BONDELIVRAISON_LIB source

CREATE OR REPLACE  VIEW "AS_BONDELIVRAISON_LIB" ("ID", "REMARQUE", "IDBC", "DATY", "ETAT", "MAGASIN", "MAGASINLIB", "ETATLIB", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDFACTUREFOURNISSEUR") AS 
  select bl.ID,
       bl.REMARQUE,
       bl.IDBC,
       bl.DATY,
       bl.ETAT,
       bl.MAGASIN,
       m.VAL as MAGASINlib,
       case
           when bl.etat = 1 then 'CR&Eacute;&Eacute;(E)'
           when bl.etat = 11 then 'VIS&Eacute;(E)'
           end as etatlib,
       bl.idfournisseur,
       f.nom AS idfournisseurlib,
       bl.IDFACTUREFOURNISSEUR
from AS_BONDELIVRAISON bl
         left join MAGASIN2 m on bl.MAGASIN = m.ID
         LEFT JOIN fournisseur f ON f.id=bl.idfournisseur
 ;

-- SOCOBISCOMPLET0420.FACTUREFOURNISSEURCPL_TOUS source

CREATE OR REPLACE FORCE VIEW "SOCOBISCOMPLET0420"."FACTUREFOURNISSEURCPL_TOUS" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "IDMAGASINLIB", "DEVISE", "IDDEVISE", "ETAT", "TAUX", "MONTANTTVA", "MONTANTHT", "TAUXDECHANGE", "MONTANTTTC", "MONTANTPAYE", "MONTANTRESTE", "IDOBJET", "IDREF") AS 
  SELECT
    fcpl.id,
    fcpl.idfournisseur,
    fcpl.idfournisseurlib,
    fcpl.idmodepaiement,
    fcpl.idmodepaiementlib,
    fcpl.daty,
    fcpl.designation,
    fcpl.dateecheancepaiement,
    fcpl.etatlib,
    fcpl.reference,
    fcpl.idbc,
    fcpl.idmagasin,
    fcpl.idmagasinlib,
    fcpl.devise,
    fcpl.iddevise,
    fcpl.etat,
    fcpl.taux,
    fcpl.montanttva,
    fcpl.montantht,
    fcpl.tauxdechange,
    fcpl.montantttc AS  MONTANTTTC,
    nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
    nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF
FROM FACTUREFOURNISSEURCPL fcpl
 ;

-- SOCOBISCOMPLET0420.FACTUREFOURNISSEURCPL source

CREATE OR REPLACE  VIEW "FACTUREFOURNISSEURCPL" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "IDPREVISION", "ESTPREVULIB", "IDOBJET", "IDREF", "IDTYPEFACTURE", "TYPEFACTURE", "NUMERO", "TYPEACHAT") AS 
  SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CR&Eacute;&Eacute;E'
           WHEN f.ETAT = 0
               THEN 'ANNUL&Eacute;E'
           WHEN f.ETAT = 11
               THEN 'VIS&Eacute;'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture,
       f.numero,
       f.typeachat
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
left join type_facture tf on tf.id = f.IDTYPEFACTURE
 ;


-- SOCOBISCOMPLET0420.PROFORMA_CPL source

CREATE OR REPLACE  VIEW "PROFORMA_CPL" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "IDDEVISE", "IDCLIENT", "CODECLIENT", "IDCLIENTLIB", "ADRESSE", "CONTACT", "POIDSTOTAL", "MONTANT", "MONTANTREMISE", "MONTANTRISTOURNE", "FRAISLIVRAISON", "FRAISTRANSPORT", "MONTANTTOTAL", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "IDORIGINE", "REMISE") AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;E'
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
       cast(V2.POIDSTOTAL as number(30, 2))                                                   as poidstotal,
       cast(V2.montant as number(30, 2))                                                      as montant,
       cast(V2.montantremise as number(30, 2))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 2))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10,2)) as fraislivraison,
       cast(V2.FRAISTRANSPORT as number(30, 2))                                               as fraistransport,
       v2.MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 2))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                                                 as MONTANTTTCAR,
       cast(nvl(mv.credit, 0) - nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30, 2))                     AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.credit, 0) - nvl(ACG.resteapayer_avr, 0) AS NUMBER(30, 2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)                                                             as avoir,
       v2.tauxDeChange                                                                        AS tauxDeChange,
       v2.MONTANTREVIENT,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise

FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
 ;
 
-- SOCOBISCOMPLET0420.RAPPROCHEMENT_BF_CLIENT source

CREATE OR REPLACE  VIEW "RAPPROCHEMENT_BF_CLIENT" ("ID", "PRODUIT", "NUMBL", "QUANTITE", "IDVENTEDETAIL", "UNITE", "IDBC_FILLE", "IDPRODUITLIB", "IDVENTE", "IDBC", "QTELIVREE", "QTERESTEALIVRER", "QTESORTIE", "RESTEASORTIR", "PU","UNITELIB") AS 
  SELECT abcc.ID,
       abcc.PRODUIT,
       abcc.NUMBL,
       abcc.QUANTITE,
       abcc.IDVENTEDETAIL,
       abcc.UNITE,
       abcc.IDBC_FILLE,
       abcc.IDPRODUITLIB,
       abcc.IDVENTE,
       abcc.IDBC,
       abcc.QTELIVREE,
       abcc.QTERESTEALIVRER,
       nvl(m.qteSortie, 0)                 AS qteSortie,
       least(abcc.qtevente - nvl(m.qteSortie, 0), abcc.QUANTITE) AS resteASortir,
       abcc.pu,
       au.val AS unitelib
FROM AS_BONLIVRFILLE_CLIENT_CPL abcc
         LEFT JOIN SORTIEPRODUITparventegrp m ON m.idproduit = abcc.produit and m.IDVENTE = abcc.idvente
         LEFT JOIN MVTSTOCK mv ON mv.idobjet = abcc.numbl
         LEFT JOIN as_unite au ON au.id = abcc.UNITE 
 ;



CREATE OR REPLACE  VIEW "DEMANDETRANSFERTCPL" ("ID", "DESIGNATION", "IDMAGASINDEPART", "IDMAGASINDEPARTLIB", "IDMAGASINARRIVE", "IDMAGASINARRIVELIB", "DATY", "ETAT", "IDOF", "CATEGORIEINGREDIENT", "CATEGORIEINGREDIENTLIB", "ETATLIB") AS 
  SELECT
    t.ID ,
    t.DESIGNATION ,
    t.IDMAGASINDEPART ,
    m.VAL AS IDMAGASINDEPARTLIB,
    t.IDMAGASINARRIVE ,
    m2.VAL AS IDMAGASINARRIVELIB,
    t.DATY ,
    t.ETAT ,
    t.idof,
    t.CATEGORIEINGREDIENT,
    c.VAL  AS CATEGORIEINGREDIENTLIB,
    CASE
        WHEN t.ETAT = 0
            THEN 'Annul&eacute;e'
        WHEN t.ETAT = 1
            THEN 'Cr&eacute;&eacute;e'
        WHEN t.ETAT = 11
            THEN 'Vis&eacute;e'
        END AS ETATLIB
FROM demandetransfert t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE
         LEFT JOIN CATEGORIEINGREDIENT c ON c.ID = t.CATEGORIEINGREDIENT
 ;
 

