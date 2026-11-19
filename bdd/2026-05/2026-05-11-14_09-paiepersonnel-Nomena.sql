create OR REPLACE view PAIE_PERS_ELTPAIE_LIB2 as
SELECT
    ppe.id,
    pip2.matricule,
    pr.id AS id_code_rubrique,
    pr.val AS code_rubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS idpersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,
    pr.VAL as rubrique,

    TO_CHAR(
            TO_DATE(TO_CHAR(ppe.moisregularisation, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,

    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage,

    CASE
        WHEN ppe.etat = '1' THEN 'CRÉÉ'
        WHEN ppe.etat = '11' THEN 'VALIDÉ'
        WHEN ppe.etat = '0' THEN 'ANNULÉ'
        ELSE 'INCONNU'
        END AS etatlib

FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip
                   ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq
                   ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf
                   ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr
                   ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         JOIN paie_info_personnel pip2
              ON TO_CHAR(pip.id) = TO_CHAR(pip2.id) WHERE ppe.CODE_RUBRIQUE!='PR0000150HS';

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1778497950679937', 'Saisie Multiple', 'add', 'module.jsp?but=paie/fonction/paiepersonnelelementpaie-saisie.jsp', 11, 3, 'MD000000040030');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1778497976246658', 'Liste des éléments de paies', 'view_list', 'module.jsp?but=paie/fonction/paiepersonnelelementpaie-liste.jsp', 12, 3, 'MD000000040030');
