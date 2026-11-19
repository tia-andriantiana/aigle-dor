create or replace view HS_FABRICATION_SEMAINE as
SELECT
    hp.idPersonne,
    p.annee,
    p.mois,
    TO_CHAR(f.daty, 'IYYY-IW') AS semaine,
    SUM(hp.HS) AS hs_total,
    LEAST(SUM(hp.HS), 8) AS hs30,
    GREATEST(SUM(hp.HS) - 8, 0) AS hs50,
    SUM( hp.IF) AS if, sum(hp.JF) as JF, SUM(hp.MN) as MN , SUM( hp.HD) as HD
FROM HEURESUPFABRICATION_CPL hp
         LEFT JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p ON f.daty BETWEEN p.datedebut AND p.datefin
GROUP BY hp.idPersonne, p.annee, p.mois, TO_CHAR(f.daty, 'IYYY-IW');



create or replace view HS_MOIS as
SELECT
    IDPERSONNE as idPersonnel,
    annee,
    mois,
    SUM(hs30) AS hs30_mois,
    SUM(hs50) AS hs50_mois,
    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE as idCategorie
FROM HS_FABRICATION_SEMAINE hs
         LEFT JOIN PAIE_INFO_PERSONNEL pip on pip.id = hs.idPersonne
GROUP BY idPersonne, annee, mois, pip.IDDEPARTEMENT, pip.IDCATEGORIE_PAIE;



create OR REPLACE view HS_GROUPE as
SELECT "MATRICULE","DATE_DEBUT","DATE_FIN","RETENUE","REMARQUE","NOMPERSONNEL","ETAT","ID_OBJET","IDUSER","MOISREGULARISATION","ANNEEREGULARISATION","IDCATEGORIE_QUALIFICATION","IDFONCTION","POURCENTAGE","ETATLIB","HS_30_NI","HS_30_I","HS_50_NI","HS_50_I"
FROM (
         SELECT
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
