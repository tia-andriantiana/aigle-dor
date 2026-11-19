CREATE OR REPLACE VIEW AVANCE_LIB2 (ID, IDPERSONNEL, MONTANT, NBREMBOURSEMENT, REMARQUE, DATY, DATEAVANCE, INTERET, ETAT, DATEDEBLOCAGE, DATEDEBUTREMBOURSEMENT, ETATLIB, IDTYPEAVANCE, IDTYPEAVANCELIB, MATRICULE, MOISLIB, MOIS, DATESAISIE) AS 
  SELECT av.id,
       (log.nom || ' ') || log.prenom AS idpersonnel,
       av.montant,
       av.nbremboursement,
       av.remarque,
       av.daty,
       av.dateavance,
       av.interet,
       av.etat,
       av.DATEDEBLOCAGE,
       av.DATEDEBUTREMBOURSEMENT,
       CASE
           WHEN av.etat = 1  THEN '<span style= color:blue; >créée</span>'
           WHEN av.etat = 11 THEN '<span style= color:blue; >validée et impayée</span>'
           WHEN av.etat = 21 THEN '<span style= color:blue; >validée et payée </span>'
           ELSE NULL
           END AS etatlib,
       av.idtypeavance,
       ty.val AS idtypeavancelib,
       p.matricule,
       TO_CHAR(
               TO_DATE(TO_CHAR(av.mois, 'FM00'), 'MM'),
               'FMMonth',
               'NLS_DATE_LANGUAGE=FRENCH'
       ) AS moisLib,
       av.MOIS,
       av.dateSaisie
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance
 ORDER BY TO_NUMBER(REGEXP_REPLACE(matricule, '[^0-9]', '')) 
 ;