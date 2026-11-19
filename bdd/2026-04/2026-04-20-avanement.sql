CREATE OR REPLACE VIEW PAIE_AVANCEMENT_LIBELLE2 AS
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.code_service AS service,
       pf.id AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       CASE
           WHEN pip.temporaire = -1 THEN 'Temporaire'
           WHEN pip.temporaire = 0 THEN 'Permanent'
           WHEN pip.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.code_banque,
       pf.desce AS fonctionLib
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie
;

CREATE OR REPLACE VIEW PAIE_PERS_ELTPAIE_LIB_IND AS
SELECT "ID",
       "MATRICULE",
       "CODE_RUBRIQUE",
       "DATE_DEBUT",
       "DATE_FIN",
       "GAIN",
       "RETENUE",
       "REMARQUE",
       "IDPERSONNEL",
       "ETAT",
       "ID_OBJET",
       "IDUSER",
       "MOISREGULARISATION",
       "ANNEEREGULARISATION",
       "IDCATEGORIE_QUALIFICATION",
       "IDFONCTION",
       "POURCENTAGE",
       -- Libellé du mois
       TO_CHAR(TO_DATE(pp.MOISREGULARISATION, 'MM'), 'MONTH', 'NLS_DATE_LANGUAGE=FRENCH')
           AS MOISREGULARISATIONLIB
FROM PAIE_PERS_ELTPAIE_LIB2 pp
WHERE pp.id_code_rubrique = 'PR000021'
;

CREATE OR REPLACE VIEW HS_GROUPE AS
SELECT "MATRICULE","NOMRUBRIQUE","DATE_DEBUT","DATE_FIN","RETENUE","REMARQUE","NOMPERSONNEL","ETAT","ID_OBJET","IDUSER","MOISREGULARISATION","ANNEEREGULARISATION","IDCATEGORIE_QUALIFICATION","IDFONCTION","POURCENTAGE","ETATLIB","HS_30_NI","HS_30_I","HS_50_NI","HS_50_I"
FROM (
         SELECT
             p.matricule,
             p.id_code_rubrique,
             p.nomRubrique,
             p.date_debut,
             p.date_fin,
             p.gain,
             p.retenue,
             p.remarque,
             p.nomPersonnel,
             p.etat,
             p.id_objet as id,
             p.iduser,
             p.moisregularisation,
             p.anneeregularisation,
             p.idcategorie_qualification,
             p.idfonction,
             p.pourcentage,
             p.etatLib
         FROM PAIEPERS_ELP_CPL p
     )
         PIVOT (
                SUM(gain)
    FOR id_code_rubrique IN (
        'PR0000130'  AS "HS_30_NI",
        'PR0000130I' AS "HS_30_I",
        'PR0000150'  AS "HS_50_NI",
        'PR0000150I' AS "HS_50_I"
        )
        ) ORDER BY matricule ASC;

CREATE OR REPLACE VIEW RECAPITULATIF_ALL_FINAL AS
SELECT rs.mois,
       rs.annee,
       rs.salaire,
       rs.indemnite,
       rs.avantage_en_nature,
       rs.salaire_brut,
       rs.irsa,
       rs.cnaps_travailleur,
       CAST(rs.montant_net_payer AS NUMBER(30, 2)) AS MONTANT_NET_PAYER,
       rs.cnaps_employeur,
       rs.cnaps_a_payer,
       frm.total_frm,
       rs.id,
       TO_CHAR(TO_DATE(rs.mois, 'MM'), 'MONTH', 'NLS_DATE_LANGUAGE=FRENCH') AS MOISLIB
FROM recapitulatif_salaire_all rs
         LEFT JOIN frm_mois_annee frm ON rs.mois = frm.mois AND rs.annee = frm.annee
;

CREATE OR REPLACE VIEW ETAT_IRSA AS
SELECT dp.id,
       dp.mois,
       dp.annee,
       dp.matricule,
       COALESCE(dp.numero_cnaps, '') AS numero_cnaps,
       dp.nom,
       dp.poste,
       dp.salaire_de_base AS salaire_de_base,
       dp.indemnitedepresentationbrut + dp.indemnite_de_transport AS indemnite,
       dp.avantages_en_nature AS avantages_en_nature,
       dp.montant_brut AS montant_brut,
       dp.cnaps,
       dp.net_a_payer,
       dp.imposable,
       dp.irsa,
       dp.reductionpourpersonnesacharge,
       dp.irsanet,
       TO_CHAR(TO_DATE(dp.mois, 'MM'), 'MONTH', 'NLS_DATE_LANGUAGE=FRENCH') AS MOIS_LIB
FROM details_paie_edition_finalpdf dp
         LEFT JOIN moiscp mcp ON dp.mois = mcp.id
;