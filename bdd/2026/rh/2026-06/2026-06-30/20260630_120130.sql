create or replace view PAIEPERS_ELP_CPL as
SELECT
    ppe.id,
    pip2.matricule,
    pr.id as id_code_rubrique,
    pr.val AS nomRubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS nomPersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,
    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage,
    ppe.idpersonnel,
    CASE
        WHEN ppe.etat = 1 THEN 'CRÉÉ'
        WHEN ppe.etat = 11 THEN 'VISÉE'
        ELSE 'INCONNU'
        END AS etatLib
FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         JOIN paie_info_personnel pip2 ON TO_CHAR(pip.id) = TO_CHAR(pip2.id);


create or replace view HS_GROUPE as
SELECT "MATRICULE","DATE_DEBUT","DATE_FIN","RETENUE","REMARQUE","NOMPERSONNEL","ETAT","ID_OBJET","IDUSER","MOISREGULARISATION","ANNEEREGULARISATION","IDCATEGORIE_QUALIFICATION","IDFONCTION","POURCENTAGE","ETATLIB","HS_30_NI","HS_30_I","HS_50_NI","HS_50_I"
FROM (
         SELECT
             p.idpersonnel as id,
             p.matricule,
             p.id_code_rubrique,
--         p.nomRubrique,
             p.date_debut,
             p.date_fin,
             p.gain,
             p.retenue,
             p.remarque,
             p.nomPersonnel,
             p.etat,
             p.id_objet,
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

