update As_INGREDIENTS set  compte_sortie_stock = '603110',  compte_stock= '311000' where 1 >0;


create or replace view COMPTASOUSECRITUREDND as
SELECT ' ' as ID,
       ' ' as NUMERO,
       ' ' as COMPTE,
       ' ' as JOURNAL,
       ' ' as IDJOURNAL,
       ' ' as ECRITURE,
       sysdate as DATY,
       0 as CREDIT,
       0 as DEBIT,
       sysdate as DATECOMPTABLE,
       0 as EXERCICE,
       ' ' as REMARQUE,
       11 as ETAT,
       ' ' as IDMERE,
       1 as HORSEXERCICE,
       ' ' as OD,
       ' ' as ORIGINE,
       ' ' as TIERS,
       ' ' as LIBELLEPIECE,
       ' ' as COMPTE_AUX,
       ' ' as RAISONSOCIAL,
       ' ' as FOLIO,
       ' ' as LETTRAGE,
       ' ' as ANALYTIQUE
FROM dual
Union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4456%';



create or replace view COMPTASOUSECRITURECND as
select
    ' ' as ID,
    ' ' as NUMERO,
    ' ' as COMPTE,
    ' ' as JOURNAL,
    ' ' as IDJOURNAL,
    ' ' as ECRITURE,
    sysdate as DATY,
    0 as CREDIT,
    0 as DEBIT,
    sysdate as DATECOMPTABLE,
    0 as EXERCICE,
    ' ' as REMARQUE,
    11 as ETAT,
    ' ' as IDMERE,
    1 as HORSEXERCICE,
    ' ' as OD,
    ' ' as ORIGINE,
    ' ' as TIERS,
    ' ' as LIBELLEPIECE,
    ' ' as COMPTE_AUX,
    ' ' as RAISONSOCIAL,
    ' ' as FOLIO,
    ' ' as LETTRAGE,
    ' ' as ANALYTIQUE
from dual
union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4457%';



INSERT INTO MOTIFAVOIRFC (ID, VAL, DESCE) VALUES ('MOTIF0002', 'Produit défectueux', 'Produit défectueux');
INSERT INTO MOTIFAVOIRFC (ID, VAL, DESCE) VALUES ('MOTIF0001', 'Retour marchandise', 'Retour marchandise');

INSERT INTO CATEGORIEAVOIRFC (ID, VAL, DESCE, TYPE) VALUES ('CAT002', 'Annulation partielle commande', 'Annulation partielle commande', null);
INSERT INTO CATEGORIEAVOIRFC (ID, VAL, DESCE, TYPE) VALUES ('CAT001', 'Categorie Avoir ', 'Categorie Avoir ', null);


INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC0003914P', '44551', '44551', '1', '4', null, 'COMP000035', null);
INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC0003914D', '4456', '4456', '1', '4', null, 'COMP000035', null);
INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC0003914CR', '44567', '44567', '1', '4', null, 'COMP000035', null);
INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC0003914C', '4457', '4457', '1', '4', null, 'COMP000035', null);

UPDATE FOURNISSEUR SET ID = 'FRNETAT', NOM = 'Administration fiscale', NIF = null, STAT = null, ADRESSE = null, CONTACT = null, CODEPOSTAL = null, COMPTE = '44551', IDTYPEFOURNISSEUR = null, COMPTEAUXILIAIRE = null, ESTACTIF = null where id='FRNETAT';


create view FACTUREDECLARATIONMONTANT as
SELECT SQ."ID",SQ."MONTANTTOTAL",SQ."MONTANTTVA",SQ."MONTANTTTC",SQ."IDDEVISE",SQ."TAUXDECHANGE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(MONTANTTOTAL),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(TAUXDECHANGE),'')) AS MOTSCLESSS
FROM (
         SELECT v.ID,
                cast(SUM ((1-nvl(vd.remises/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montanttotal,
                cast(SUM ((1-nvl(vd.REMISES /100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100) as number(30,2)) AS montantTva,
                cast(SUM ((1-nvl(vd.remises/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remises/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)))as number(30,2))  as montantTTC,
                NVL (vd.IDDEVISE,'AR') AS IDDEVISE,
                nvl (vd.tauxdechange,1) AS tauxdechange
         FROM FACTUREDECLARATIONFILLE vd LEFT JOIN FACTUREDECLARATION v ON v.ID = vd.idfacturefournisseur
         GROUP BY v.ID, vd.IDDEVISE,vd.tauxdechange

     ) SQ;



create or replace view FACTUREDECLARATIONCPL as
SELECT SQ."ID",SQ."IDFOURNISSEUR",SQ."IDFOURNISSEURLIB",SQ."IDMODEPAIEMENT",SQ."IDMODEPAIEMENTLIB",SQ."DATY",SQ."DESIGNATION",SQ."DATEECHEANCEPAIEMENT",SQ."ETAT",SQ."ETATLIB",SQ."REFERENCE",SQ."IDBC",SQ."IDMAGASIN",SQ."DEVISE",SQ."COMPTE",SQ."TAUX",SQ."IDMAGASINLIB",SQ."IDDEVISE",SQ."MONTANTTVA",SQ."MONTANTHT",SQ."MONTANTTTC",SQ."MONTANTTTCAR",SQ."MONTANTPAYE",SQ."MONTANTRESTE",SQ."TAUXDECHANGE",SQ."IDPREVISION",SQ."ESTPREVULIB",SQ."IDOBJET",SQ."IDREF",SQ."IDTYPEFACTURE",SQ."TYPEFACTURE",SQ."NUMERO",SQ."TYPEACHAT",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(IDMODEPAIEMENT),'') || ' | ' || NVL(TO_CHAR(IDMODEPAIEMENTLIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(DATEECHEANCEPAIEMENT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(REFERENCE),'') || ' | ' || NVL(TO_CHAR(IDBC),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(DEVISE),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(TAUX),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTHT),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTTTCAR),'') || ' | ' || NVL(TO_CHAR(MONTANTPAYE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'') || ' | ' || NVL(TO_CHAR(TAUXDECHANGE),'') || ' | ' || NVL(TO_CHAR(IDPREVISION),'') || ' | ' || NVL(TO_CHAR(ESTPREVULIB),'') || ' | ' || NVL(TO_CHAR(IDOBJET),'') || ' | ' || NVL(TO_CHAR(IDREF),'') || ' | ' || NVL(TO_CHAR(IDTYPEFACTURE),'') || ' | ' || NVL(TO_CHAR(TYPEFACTURE),'') || ' | ' || NVL(TO_CHAR(NUMERO),'') || ' | ' || NVL(TO_CHAR(TYPEACHAT),'')) AS MOTSCLESSS
FROM (
         SELECT
             f.ID,
             f.IDFOURNISSEUR,
             f2.NOM AS IDFOURNISSEURLIB,

             f.IDMODEPAIEMENT,
             m.VAL AS IDMODEPAIEMENTLIB,

             f.DATY,
             f.DESIGNATION,
             f.DATEECHEANCEPAIEMENT,

             f.ETAT,
             CASE
                 WHEN f.ETAT = 1  THEN 'CREE'
                 WHEN f.ETAT = 0  THEN 'ANNULEE'
                 WHEN f.ETAT = 11 THEN 'VISEE'
                 END AS ETATLIB,

             f.REFERENCE,
             f.IDBC,
             f.IDMAGASIN,
             f.DEVISE,
             f2.COMPTE,

             NVL(NULLIF(f.TAUX,0),1) AS TAUX,

             p.VAL AS IDMAGASINLIB,

             f.IDDEVISE,

             CAST(NVL(f3.MONTANTTVA,0) AS NUMBER(30,2)) AS MONTANTTVA,
             CAST(NVL(f3.MONTANTTTC,0) - NVL(f3.MONTANTTVA,0) AS NUMBER(30,2)) AS MONTANTHT,
             CAST(NVL(f3.MONTANTTTC,0) AS NUMBER(30,2)) AS MONTANTTTC,

             CAST(
                     NVL(f3.MONTANTTTC,0) * NVL(f3.tauxdechange,1)
                 AS NUMBER(30,2)
             ) AS MONTANTTTCAR,

             CAST(NVL(mv.debit,0) AS NUMBER(30,2)) AS MONTANTPAYE,
             CAST(NVL(f3.MONTANTTTC,0) - NVL(mv.debit,0) AS NUMBER(30,2)) AS MONTANTRESTE,

             CAST(NVL(f3.tauxdechange,1) AS NUMBER(30,2)) AS TAUXDECHANGE,

             prev.ID AS IDPREVISION,

             CASE
                 WHEN f.estprevu = 0 THEN 'NON'
                 ELSE 'OUI'
                 END AS ESTPREVULIB,

             f.IDOBJET,
             f.IDREF,
             f.IDTYPEFACTURE,
             tf.VAL AS TYPEFACTURE,
             f.NUMERO,
             f.TYPEACHAT

         FROM FACTUREDECLARATION f
                  LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
                  LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
                  LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
                  LEFT JOIN FACTUREDECLARATIONMONTANT f3 ON f.ID = f3.ID
                  LEFT JOIN MOUVEMENTCAISSEGROUPEFACTURE mv ON f.ID = mv.IDORIGINE
                  LEFT JOIN PREVISION prev ON prev.IDFACTURE = f.ID
                  LEFT JOIN TYPE_FACTURE tf ON tf.ID = f.IDTYPEFACTURE

     ) SQ;




create or replace view DECLARATIONTVALIB as
SELECT SQ."ID",SQ."DESIGNATION",SQ."DATYDEBUT",SQ."DATYFIN",SQ."ETAT",SQ."ETATLIB",SQ."MONTANTPAYER",SQ."PAYEMENTLIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(DATYDEBUT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATYFIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(MONTANTPAYER),'') || ' | ' || NVL(TO_CHAR(PAYEMENTLIB),'')) AS MOTSCLESSS
FROM (
         SELECT
             de.id,
             de.designation,
             de.datyDebut,
             de.datyFin,
             de.etat,
             CASE
                 WHEN de.etat = 1 THEN 'Cree'
                 WHEN de.etat = 11 THEN 'Valide'
                 ELSE 'Inconnu'
                 END AS etatLib,
             nvl(mv.DEBIT,nvl(fd.MONTANTTTC,0)) as montantpayer,
             case
                 when mv.IDORIGINE is null then case when fd.IDBC='CREDIT' then 'Reporté' else 'Non payé' end
                 else 'Payé'
                 END as payementLib
         FROM DeclarationTVA de left join FACTUREDECLARATIONCPL fd on de.id=fd.IDOBJET left join mouvementcaisse mv on mv.IDORIGINE=fd.id


     ) SQ ;
