CREATE OR REPLACE VIEW EMPLOYE_COMPLET_LIBELLE2 (ID, NOM, PRENOM, ID_PERS, INITIALE, MATRICULE, DATE_NAISSANCE, LIEU_NAISSANCE_COMMUNE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, LIEU_DELIVRANCE_CIN, ADRESSE, DIRECTION, FOKOTANY, NATIONALITE, ACTE_NAISSANCE, SITUATION_MATRIMONIAL, IDCONJOINT, SERVICE, IDFONCTION, CTG, IDCATEGORIE, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, MODE_PAIEMENT, CODE_AGENCE_BANQUE, BANQUE_COMPTE_CLE, BANQUE_NUMERO_COMPTE, PERMIS_CONDUIRE, REMARQUE, CHEMIN_PERMIS, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, DATEEMBAUCHE, DATESAISIE, CODE_DR, BANQUE_CODE, ECHELON, VEHICULEE, VEHICULEE_STR, DATE_DERNIERPROMO, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, TEMPORAIRE_LIB, IDSTATUT, IDSTATUTLIB, NBENFANT, MOTIF_DEBAUCHE, TYPE_DEBAUCHE, ADRESSE_LIGNE1, ADRESSE_LIGNE2, MAIL, TELEPHONE, CODE_POSTAL, REGION, ANNEEEXPERIENCE, FORMATION, DISCIPLINE, ETAT
, CATEGORIEPAIELIB, IDDEPARTEMENT, IDDEPARTEMENTLIB, SALAIREBASE,TAUXHORAIRE) AS 
  SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule AS matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       s.desce AS sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       ld.val AS direction,
       sf.val AS fokotany,
       p.val AS nationalite,
       logp.acte_naissance,
       sitmat.desce AS situation_matrimonial,
       paie.idconjoint,
       serv.libelle AS service,
       pf.desce AS idfonction,
       paie.ctg,
       pc.val AS idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       pm.val AS mode_paiement,
       paie.code_agence_banque,
       paie.banque_compte_cle,
       paie.banque_numero_compte,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.dateembauche,
       paie.datesaisie,
       serv.code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.vehiculee,
       CASE paie.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       tab.date_dernierpromo,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       CASE
           WHEN paie.temporaire = '-1' THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire_lib,
       paie.idStatut,
       stat.val as idStatutLib,
       paie.nbenfant,
       lpnv.motif AS motif_debauche,
       ddt.val AS type_debauche,
       paie.adresse_ligne1,
       paie.adresse_ligne2,
       paie.mail,
       paie.telephone,
       paie.code_postal,
       reg.val AS region,
       paie.anneeexperience,
       fd.val AS formation,
       paie.discipline,
       paie.etat,
       cp.DESCE AS categoriePaieLib,
       paie.iddepartement AS iddepartement,
       dep.val AS iddepartementlib,
       paie.salaireBase,
       paie.salaireBase / 173.33 AS tauxHoraire
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN sexe s ON logp.sexe = s.id
         LEFT JOIN sig_fokontany sf ON logp.fokotany = sf.id
         LEFT JOIN pays p ON logp.nationalite = p.id
         LEFT JOIN log_direction ld ON logp.direction = ld.id
         LEFT JOIN paie_fonction pf ON paie.idfonction = pf.id
         LEFT JOIN paie_categorie pc ON paie.idcategorie = pc.id
         LEFT JOIN modepaiement pm ON paie.mode_paiement = pm.id
         LEFT JOIN situation_matrimoniale sitmat ON paie.situation_matrimonial = sitmat.id
         LEFT JOIN log_personnel_non_valide lpnv ON logp.id = lpnv.idlogpers
         LEFT JOIN dec_decision_type ddt ON lpnv.idtypedebauche = ddt.id
         LEFT JOIN region reg ON reg.id = paie.region
         LEFT JOIN formation_diplome fd ON fd.id = paie.formation
         LEFT JOIN categorie_paie cp ON paie.IDCATEGORIE_PAIE = cp.id
         LEFT JOIN DEPARTEMENT dep ON dep.id=paie.iddepartement
         LEFT JOIN PAIE_STATUT stat ON stat.id = paie.IDSTATUT
WHERE logp.id <> '1002067';