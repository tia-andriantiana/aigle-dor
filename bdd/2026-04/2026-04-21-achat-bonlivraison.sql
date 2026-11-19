ALTER TABLE AS_BONDELIVRAISON_FILLE ADD tauxdechange number(30,2);
-- SOCOBISCOMPLET0420.AS_BONDELIVRAISON_FILLE_VIDE source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_FILLE_VIDE (ID, PRODUIT, PRODUITLIB, QUANTITE, UNITE, NUMBL, IDDETAILSFACTUREFOURNISSEUR, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN, UNITELIB, MAGASINLIB, PU, DESIGNATION,TAUXDECHANGE) AS 
  SELECT
    cast(' ' as varchar(100)) AS ID,
    cast(' ' as varchar(255)) AS PRODUIT,
    cast(' ' as varchar(255)) AS PRODUITLIB ,
    cast(-1 as NUMBER(10,2) ) AS QUANTITE ,
    cast(' ' as varchar(100)) AS UNITE,
    cast(' ' as varchar(100)) AS NUMBL,
    cast(' ' as varchar(100)) AS IDDETAILSFACTUREFOURNISSEUR,
    cast(' ' as varchar(100)) AS IDBC_FILLE ,
    cast(' ' as varchar(200)) AS REMARQUE ,
    cast(' ' as varchar(100)) AS IDBC ,
    cast(NULL as DATE ) AS DATY ,
    cast(-1 as int ) AS ETAT,
    cast(' ' as varchar(500)) AS MAGASIN ,
    cast(' ' as varchar(255)) AS UNITELIB ,
    cast(' ' as varchar(255)) AS MAGASINLIB,
    cast(-1 as NUMBER(10,2) ) AS pu ,
    cast(' ' as varchar(255)) AS designation,
    cast(-1 as NUMBER(10,2) ) AS tauxdechange
FROM dual
 ;
-- SOCOBISCOMPLET0420.RAPPROCHEMENT_BF_FOURNISSEUR source
-- SOCOBISCOMPLET0420.AS_BONDELIVRAISON_LIBCPL source


CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_LIBCPL (ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR, UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN, PRODUITLIB, UNITELIB, MAGASINLIB, LIBELLEEXTACTE, PU, DESIGNATION, MONTANT,PUAR,TAUXDECHANGE) AS 
  SELECT
    bl.ID,
    bl.PRODUIT,
    bl.NUMBL,
    bl.QUANTITE,
    bl.IDDETAILSFACTUREFOURNISSEUR,
    bl.UNITE,
    bl.IDBC_FILLE,
    AB.REMARQUE,
    AB.IDBC,
    AB.DATY,
    AB.ETAT,
    AB.MAGASIN,
    p.libelle AS PRODUITlib,
    u.VAL AS UNITElib,
    m.VAL AS magasinlib,
    p.LIBELLEEXTACTE,
    bl.pu,
    bl.DESIGNATION,
    cast(nvl(bl.QUANTITE*bl.PU,0) AS  NUMBER(30,2)) AS MONTANT,
    cast(nvl(bl.tauxdechange*bl.PU,0) AS  NUMBER(30,2)) AS PUAR,
    bl.tauxdechange
FROM
    As_BonDeLivraison_Fille bl
        LEFT JOIN AS_BONDELIVRAISON AB ON
        AB.ID = bl.NUMBL
        LEFT JOIN AS_INGREDIENTS p ON
        bl.PRODUIT = p.ID
        LEFT JOIN AS_UNITE  u ON
        bl.UNITE = u.ID
        LEFT JOIN MAGASIN m ON
        ab.MAGASIN = m.ID
 ;
CREATE OR REPLACE  VIEW RAPPROCHEMENT_BF_FOURNISSEUR (ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR, UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN, PRODUITLIB, UNITELIB, MAGASINLIB, LIBELLEEXACTE, QTEENTREE, RESTEASORTIR, PU,PUAR,RESTEAENTRER) AS 
  SELECT
abcc.ID,
abcc.PRODUIT,
abcc.NUMBL,
abcc.QUANTITE,
abcc.IDDETAILSFACTUREFOURNISSEUR,
abcc.UNITE,
abcc.IDBC_FILLE,
abcc.REMARQUE,
abcc.IDBC,
abcc.DATY,
abcc.ETAT,
abcc.MAGASIN,
abcc.PRODUITLIB,
abcc.UNITELIB,
abcc.MAGASINLIB,
abcc.LIBELLEEXTACTE AS LIBELLEEXACTE,
nvl(mvf.entree,0) AS qteEntree,
nvl(abcc.QUANTITE,0) - nvl(mvf.entree,0) AS resteASortir,
abcc.pu,
abcc.puar,
nvl(abcc.QUANTITE,0) - nvl(mvf.entree,0) AS resteAEntrer
FROM AS_BONDELIVRAISON_LIBCPL abcc
LEFT JOIN MVTSTOCKLIBVALIDER mv ON mv.idobjet = abcc.numbl 
LEFT JOIN mvtstockfille mvf ON mv.id=mvf.idmvtstock
 ;

 -- SOCOBISCOMPLET0420.FACTUREFOURNISSEURCPL source

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL (ID, IDFOURNISSEUR, IDFOURNISSEURLIB, IDMODEPAIEMENT, IDMODEPAIEMENTLIB, DATY, DESIGNATION, DATEECHEANCEPAIEMENT, ETAT, ETATLIB, REFERENCE, IDBC, IDMAGASIN, DEVISE, TAUX, IDMAGASINLIB, IDDEVISE, MONTANTTVA, MONTANTHT, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, TAUXDECHANGE, IDPREVISION, ESTPREVULIB, IDOBJET, IDREF, IDTYPEFACTURE, TYPEFACTURE, NUMERO, TYPEACHAT, IDFACTUREPRINCIPALE, IDSERVICELIB, SERVICE) AS 
  SELECT
    f.ID,
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
           THEN 'VIS&Eacute;E'
       END AS ETATLIB,
    reff.reference,
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
    f.typeachat,
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE
FROM FACTUREFOURNISSEUR f
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
    LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE
    LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
	LEFT JOIN referencefacture reff ON f.id=reff.idfacture;