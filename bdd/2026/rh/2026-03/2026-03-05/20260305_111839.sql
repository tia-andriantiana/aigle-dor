create or replace view HS_GROUPE as
SELECT "MATRICULE","NOMPERSONNEL","DATE_DEBUT","DATE_FIN","RETENUE","REMARQUE","ETAT","ID_OBJET","IDUSER","MOISREGULARISATION","ANNEEREGULARISATION","IDCATEGORIE_QUALIFICATION","IDFONCTION","POURCENTAGE","ETATLIB","HS_30_NI","HS_30_I","HS_50_NI","HS_50_I"
FROM (
         SELECT
             p.matricule,
             p.nomPersonnel,
             p.date_debut,
             p.date_fin,
             p.retenue,
             p.remarque,
             p.etat,
             p.id_objet,
             p.iduser,
             p.moisregularisation,
             p.anneeregularisation,
             p.idcategorie_qualification,
             p.idfonction,
             p.pourcentage,
             p.etatLib,
             p.id_code_rubrique,
             p.gain
         FROM PAIEPERS_ELP_CPL p
     )
         PIVOT (
                SUM(gain)
    FOR id_code_rubrique IN (
        'PR0000130'  AS HS_30_NI,
        'PR0000130I' AS HS_30_I,
        'PR0000150'  AS HS_50_NI,
        'PR0000150I' AS HS_50_I
        )
        )
ORDER BY matricule ASC;

