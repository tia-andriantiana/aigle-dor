-- Stefan


CREATE OR REPLACE VIEW "LOG_PERSONNEL_V2" AS
SELECT lpv.id,
       lpv.permis_conduire,
       lpv.chemin_permis,
       lpv.remarque,
       lpv.id_pers,
       lpv.nom,
       lpv.prenom,
       lpv.date_naissance,
       lpv.sexe,
       lpv.numero_cin,
       lpv.date_cin,
       lpv.date_dupl_cin,
       lpv.nationalite,
       lpv.adresse,
       lpv.fokotany,
       lpv.acte_naissance,
       lpv.direction,
       lpv.service,
       lpv.code_dr,
       lpv.matricule,
       lpv.idcategorie,
       lpv.ctg,
       lpv.indicegrade,
       lpv.indice_fonctionnel,
       lpv.statut,
       lpv.categorieval,
       lpv.ctgval,
       lpv.numero_cnaps,
       lpv.numero_ostie,
       lpv.temporaire,
       lpv.resteconge,
       cpl.val AS categorie,
       qp.val AS qualification,
       lpv.idDIRECTION,
       pinfo.iddepartement,
       pinfo.idcategorie_paie
FROM log_personnel_v lpv
         LEFT JOIN paie_info_personnel pinfo ON pinfo.id = lpv.id
         LEFT JOIN categorie_paie_lib cpl ON cpl.id = pinfo.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = pinfo.idqualification
;

CREATE OR REPLACE VIEW "AVANCE_LIB2" AS
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
       p.matricule
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance
;

ALTER TABLE REMBOURSEMENT ADD datyRemboursement DATE;