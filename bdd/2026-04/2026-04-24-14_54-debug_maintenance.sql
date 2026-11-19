alter table as_bondecommande add iddmdachat VARCHAR(255);

create or replace view AS_BONDECOMMANDE_MERECPL as
SELECT SQ."ID",SQ."DATY",SQ."ETAT",SQ."REMARQUE",SQ."IDDMDACHAT",SQ."DESIGNATION",SQ."MODEPAIEMENT",SQ."FOURNISSEUR",SQ."REFERENCE",SQ."DATELIMITE",SQ."MODEPAIEMENTLIB",SQ."FOURNISSEURLIB",SQ."MONTANTTVA",SQ."MONTANTHT",SQ."MONTANTTTC",SQ."MONTANTTTCARIARY",SQ."IDDEVISELIB",SQ."IDDEVISE",SQ."ETATLIB",SQ."IDSERVICELIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENT),'') || ' | ' || NVL(TO_CHAR(FOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(REFERENCE),'') || ' | ' || NVL(TO_CHAR(DATELIMITE,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENTLIB),'') || ' | ' || NVL(TO_CHAR(FOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTHT),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTTTCARIARY),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDSERVICELIB),'') || ' | ' || NVL(TO_CHAR(IDDMDACHAT),'')) AS MOTSCLESSS
FROM (
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
             ab.iddmdachat AS IDDMDACHAT,
             mp.VAL AS MODEPAIEMENTLIB,
             F.NOM AS FOURNISSEURLIB,
             abf.montantTVA,
             abf.montantHT,
             CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC,
             CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
             d.val AS idDeviselib,
             d.id AS IDDEVISE,
             CASE
                 WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
                 WHEN ab.ETAT = 11 THEN 'VIS&Eacute;E'
                 WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;E'
                 END AS ETATLIB,
             s.libelle AS idServiceLib
         FROM AS_BONDECOMMANDE AB
                  LEFT JOIN MODEPAIEMENT mp ON AB.MODEPAIEMENT = mp.id
                  LEFT JOIN FOURNISSEUR F ON AB.FOURNISSEUR = F.id
                  LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
                  LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
                  LEFT JOIN SERVICE s ON ab.SERVICE = s.COMPTE
     ) SQ;