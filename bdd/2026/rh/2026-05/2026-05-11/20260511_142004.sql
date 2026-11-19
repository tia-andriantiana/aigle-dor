create or replace view AVANCE_LIB2 as
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
       av.MOIS
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance;

update AVANCE set mois=5 where mois=0;
update AVANCE set mois=5 where mois='' or MOIS is null ;



UPDATE MENUDYNAMIQUE
SET ID      = 'MD00021110004',
    LIBELLE = 'Liste avance du 15',
    ICONE   = 'receipt_long',
    HREF    = 'module.jsp?but=paie/avance/avance-15-liste.jsp&idType=PRU0447',
    RANG    = 2,
    NIVEAU  = 4,
    ID_PERE = 'MD00021110777';
