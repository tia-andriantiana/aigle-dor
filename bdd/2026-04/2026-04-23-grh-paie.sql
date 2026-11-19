
CREATE OR REPLACE  VIEW REMBOURSEMENTLIB (ID, IDAVANCE, MOIS, ANNEE, MONTANT, REMARQUE, DATY, ETAT, PERSONNEL, TYPEAVANCELIB, ETATLIB, MATRICULE, MOISLIB, MOTSCLESSS) AS 
  SELECT SQ.ID,SQ.IDAVANCE,SQ.MOIS,SQ.ANNEE,SQ.MONTANT,SQ.REMARQUE,SQ.DATY,SQ.ETAT,SQ.PERSONNEL,SQ.TYPEAVANCELIB,SQ.ETATLIB,SQ.MATRICULE,SQ.MOISLIB,
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDAVANCE),'') || ' | ' || NVL(TO_CHAR(MOIS),'') || ' | ' || NVL(TO_CHAR(ANNEE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(PERSONNEL),'') || ' | ' || NVL(TO_CHAR(TYPEAVANCELIB),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(MATRICULE),'') || ' | ' || NVL(TO_CHAR(MOISLIB),'')) AS MOTSCLESSS
FROM (
  SELECT pr.id,
       pr.idavance,
       pr.mois,
       pr.annee,
       pr.montant,
       pr.remarque,
       pr.daty,
       pr.etat,
       lp.nom || ' ' || lp.prenom  AS personnel,
       t.val AS typeavancelib,
       CASE
           WHEN pr.etat = 1 THEN 'CREE'
           WHEN pr.etat = 11 THEN 'VALIDE'
           ELSE NULL
           END AS etatlib,
       pip.matricule,
       TO_CHAR(
               TO_DATE(TO_CHAR(pr.mois, 'FM00'), 'MM'),
               'FMMonth',
               'NLS_DATE_LANGUAGE=FRENCH'
       ) AS moisLib
FROM remboursement pr
         LEFT JOIN avance a ON a.id = pr.idavance
         LEFT JOIN typeavance t ON t.id = a.idtypeavance
         LEFT JOIN paie_info_personnel pip ON pip.id = a.idpersonnel
         LEFT JOIN log_personnel lp ON lp.id=a.idpersonnel
 
) SQ;