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
       CASE
           WHEN av.etat = 1 THEN 'CREE'
           WHEN av.etat = 11 THEN 'VALIDE'
           WHEN av.etat = 21 THEN 'PAYE'
           ELSE NULL
           END AS etatlib,
       av.idtypeavance,
       ty.val AS idtypeavancelib,
       p.matricule
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance
/

select *
from MOUVEMENTCAISSE where ID = 'MTC001810092255';

select *
from BILLETAGEFILLE;

select *
from AVANCE_LIB;