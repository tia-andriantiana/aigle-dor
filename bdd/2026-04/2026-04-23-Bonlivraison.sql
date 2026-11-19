CREATE OR REPLACE VIEW RAPPROCHEMENT_BF_FOURNISSEUR (
    ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR,
    UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN,
    PRODUITLIB, UNITELIB, MAGASINLIB, LIBELLEEXACTE,
    QTEENTREE, RESTEASORTIR, PU, PUAR, RESTEAENTRER, MOTSCLESSS
) AS 
SELECT 
    SQ.ID,
    SQ.PRODUIT,
    SQ.NUMBL,
    SQ.QUANTITE,
    SQ.IDDETAILSFACTUREFOURNISSEUR,
    SQ.UNITE,
    SQ.IDBC_FILLE,
    SQ.REMARQUE,
    SQ.IDBC,
    SQ.DATY,
    SQ.ETAT,
    SQ.MAGASIN,
    SQ.PRODUITLIB,
    SQ.UNITELIB,
    SQ.MAGASINLIB,
    SQ.LIBELLEEXACTE,
    SQ.QTEENTREE,
    SQ.RESTEASORTIR,
    SQ.PU,
    SQ.PUAR,
    SQ.RESTEAENTRER,

    (
        NVL(TO_CHAR(SQ.ID),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PRODUIT),'') || ' | ' ||
        NVL(TO_CHAR(SQ.NUMBL),'') || ' | ' ||
        NVL(TO_CHAR(SQ.QUANTITE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDDETAILSFACTUREFOURNISSEUR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.UNITE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDBC_FILLE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.REMARQUE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDBC),'') || ' | ' ||
        NVL(TO_CHAR(SQ.DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' ||
        NVL(TO_CHAR(SQ.ETAT),'') || ' | ' ||
        NVL(TO_CHAR(SQ.MAGASIN),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PRODUITLIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.UNITELIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.MAGASINLIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.LIBELLEEXACTE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.QTEENTREE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.RESTEASORTIR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PU),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PUAR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.RESTEAENTRER),'')
    ) AS MOTSCLESSS

FROM (
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

        NVL(SUM(mvf.entree),0) AS QTEENTREE,

        NVL(abcc.QUANTITE,0) - NVL(SUM(mvf.entree),0) AS RESTEASORTIR,

        abcc.pu,
        abcc.puar,

        NVL(abcc.QUANTITE,0) - NVL(SUM(mvf.entree),0) AS RESTEAENTRER

    FROM AS_BONDELIVRAISON_LIBCPL abcc
    LEFT JOIN MVTSTOCKLIBVALIDER mv 
        ON mv.idobjet = abcc.numbl 
    LEFT JOIN mvtstockfille mvf 
        ON mv.id = mvf.idmvtstock  AND mvf.idproduit = abcc.produit

    GROUP BY 
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
        abcc.LIBELLEEXTACTE,
        abcc.pu,
        abcc.puar
) SQ;

CREATE OR REPLACE VIEW RAPPROCHEMENT_BF_LIVREE (
    ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR,
    UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN,
    PRODUITLIB, UNITELIB, MAGASINLIB, LIBELLEEXACTE,
    QTEENTREE, RESTEASORTIR, PU, PUAR, RESTEAENTRER, MOTSCLESSS
) AS 
SELECT 
    SQ.ID,
    SQ.PRODUIT,
    SQ.NUMBL,
    SQ.QUANTITE,
    SQ.IDDETAILSFACTUREFOURNISSEUR,
    SQ.UNITE,
    SQ.IDBC_FILLE,
    SQ.REMARQUE,
    SQ.IDBC,
    SQ.DATY,
    SQ.ETAT,
    SQ.MAGASIN,
    SQ.PRODUITLIB,
    SQ.UNITELIB,
    SQ.MAGASINLIB,
    SQ.LIBELLEEXACTE,
    SQ.QTEENTREE,
    SQ.RESTEASORTIR,
    SQ.PU,
    SQ.PUAR,
    SQ.RESTEAENTRER,

    (
        NVL(TO_CHAR(SQ.ID),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PRODUIT),'') || ' | ' ||
        NVL(TO_CHAR(SQ.NUMBL),'') || ' | ' ||
        NVL(TO_CHAR(SQ.QUANTITE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDDETAILSFACTUREFOURNISSEUR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.UNITE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDBC_FILLE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.REMARQUE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.IDBC),'') || ' | ' ||
        NVL(TO_CHAR(SQ.DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' ||
        NVL(TO_CHAR(SQ.ETAT),'') || ' | ' ||
        NVL(TO_CHAR(SQ.MAGASIN),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PRODUITLIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.UNITELIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.MAGASINLIB),'') || ' | ' ||
        NVL(TO_CHAR(SQ.LIBELLEEXACTE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.QTEENTREE),'') || ' | ' ||
        NVL(TO_CHAR(SQ.RESTEASORTIR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PU),'') || ' | ' ||
        NVL(TO_CHAR(SQ.PUAR),'') || ' | ' ||
        NVL(TO_CHAR(SQ.RESTEAENTRER),'')
    ) AS MOTSCLESSS

FROM (
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

        NVL(SUM(mvf.entree),0) AS QTEENTREE,

        NVL(abcc.QUANTITE,0) - NVL(SUM(mvf.entree),0) AS RESTEASORTIR,

        abcc.pu,
        abcc.puar,

        NVL(abcc.QUANTITE,0) - NVL(SUM(mvf.entree),0) AS RESTEAENTRER

    FROM AS_BONDELIVRAISON_LIBCPL abcc
    LEFT JOIN MVTSTOCKLIBVALIDER mv 
        ON mv.idobjet = abcc.numbl 
    LEFT JOIN mvtstockfille mvf 
        ON mv.id = mvf.idmvtstock  
       AND mvf.idproduit = abcc.produit

    GROUP BY 
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
        abcc.LIBELLEEXTACTE,
        abcc.pu,
        abcc.puar
) SQ

WHERE SQ.RESTEAENTRER > 0;

-- SOCOBISCOMPLET0420.FACTUREFOURNISSEURCPL_TOUS source

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL_TOUS (ID, IDFOURNISSEUR, IDFOURNISSEURLIB, IDMODEPAIEMENT, IDMODEPAIEMENTLIB, DATY, DESIGNATION, DATEECHEANCEPAIEMENT, ETATLIB, REFERENCE, IDBC, IDMAGASIN, IDMAGASINLIB, DEVISE, IDDEVISE, ETAT, TAUX, MONTANTTVA, MONTANTHT, TAUXDECHANGE, MONTANTTTC, MONTANTPAYE, MONTANTRESTE, IDOBJET, IDREF,IDSERVICELIB) AS 
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
    fcpl.IDREF,
    fcpl.IDSERVICELIB
FROM FACTUREFOURNISSEURCPL fcpl
 ;