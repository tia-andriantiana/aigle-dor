CREATE OR REPLACE VIEW AVANCE_LIB2 AS 
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
           WHEN av.etat = 1  THEN '<span style= color:blue; >créée</span>'
           WHEN av.etat = 11 THEN '<span style= color:blue; >validée et impayée</span>'
           WHEN av.etat = 21 THEN '<span style= color:blue; >validée et payée </span>'
           ELSE NULL
       END AS etatlib,
       av.idtypeavance,
       ty.val AS idtypeavancelib,
       p.matricule
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance;

CREATE OR REPLACE VIEW AVANCE_LIB_CREE AS  
select * from AVANCE_LIB2 where etat = 1 ;
CREATE OR REPLACE VIEW AVANCE_LIB_VISEE AS  
select * from AVANCE_LIB2 where etat = 11 ;
CREATE OR REPLACE VIEW AVANCE_LIB_PAYE AS  
select * from AVANCE_LIB2 where etat = 21 ;