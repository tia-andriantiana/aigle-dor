-- SOCOBISCOMPLET0420.AS_BONDECOMMANDE_CPL source

CREATE OR REPLACE  VIEW AS_BONDECOMMANDE_CPL  AS 
  SELECT SQ.ID,SQ.PRODUIT,SQ.IDBC,SQ.QUANTITE,SQ.MONTANT,SQ.PU,SQ.TVA,SQ.UNITE,SQ.REMISE,SQ.DATY,SQ.ETAT,SQ.REMARQUE,SQ.DESIGNATION,SQ.MODEPAIEMENT,SQ.FOURNISSEUR,SQ.REFERENCE,SQ.PRODUITLIB,SQ.UNITELIB,SQ.MODEPAIEMENTLIB,SQ.FOURNISSEURLIB,SQ.MONTANTTVA,SQ.MONTANTTTC,SQ.MONTANTHT,SQ.IDDEVISE,SQ.TAUXDECHANGE,SQ.MONTANTTTCAR,
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(PRODUIT),'') || ' | ' || NVL(TO_CHAR(IDBC),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(TVA),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(REMISE),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENT),'') || ' | ' || NVL(TO_CHAR(FOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(REFERENCE),'') || ' | ' || NVL(TO_CHAR(PRODUITLIB),'') || ' | ' || NVL(TO_CHAR(UNITELIB),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENTLIB),'') || ' | ' || NVL(TO_CHAR(FOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTHT),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'')) AS MOTSCLESSS
FROM (
  select bcf.ID,bcf.PRODUIT,bcf.IDBC,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.UNITE,bcf.REMISE,
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST (bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montanttva,
       CAST( bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100)) AS NUMBER(30,2)) AS montantttc,
       CAST (bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu  * (bcf.tva/100)) - bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montantht,
 		bcf.iddevise,
 		   CAST(bcf.TAUXDECHANGE AS NUMBER(30,2)) AS TAUXDECHANGE,
       CAST((bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100))) * bcf.TAUXDECHANGE AS NUMBER(30,2)) AS MONTANTTTCAR
from AS_BONDECOMMANDE_FILLE bcf
         left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id

 
 
) SQ;