-- SOCOBISFINAL2304.HS_GROUPE source

CREATE OR REPLACE VIEW HS_GROUPE AS
SELECT SQ."ID", SQ."MATRICULE",SQ."NOMRUBRIQUE",SQ."DATE_DEBUT",SQ."DATE_FIN",SQ."RETENUE",SQ."REMARQUE",SQ."NOMPERSONNEL",SQ."ETAT",SQ."ID_OBJET",SQ."IDUSER",SQ."MOISREGULARISATION",SQ."ANNEEREGULARISATION",SQ."IDCATEGORIE_QUALIFICATION",SQ."IDFONCTION",SQ."POURCENTAGE",SQ."ETATLIB",SQ."HS_30_NI",SQ."HS_30_I",SQ."HS_50_NI",SQ."HS_50_I",
       (NVL(TO_CHAR(MATRICULE),'') || ' | ' || NVL(TO_CHAR(NOMRUBRIQUE),'') || ' | ' || NVL(TO_CHAR(DATE_DEBUT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATE_FIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(RETENUE),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(NOMPERSONNEL),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(ID_OBJET),'') || ' | ' || NVL(TO_CHAR(IDUSER),'') || ' | ' || NVL(TO_CHAR(MOISREGULARISATION),'') || ' | ' || NVL(TO_CHAR(ANNEEREGULARISATION),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIE_QUALIFICATION),'') || ' | ' || NVL(TO_CHAR(IDFONCTION),'') || ' | ' || NVL(TO_CHAR(POURCENTAGE),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(HS_30_NI),'') || ' | ' || NVL(TO_CHAR(HS_30_I),'') || ' | ' || NVL(TO_CHAR(HS_50_NI),'') || ' | ' || NVL(TO_CHAR(HS_50_I),'')) AS MOTSCLESSS
FROM (
         SELECT ID, MATRICULE,NOMRUBRIQUE,DATE_DEBUT,DATE_FIN,RETENUE,REMARQUE,NOMPERSONNEL,ETAT,ID_OBJET,IDUSER,MOISREGULARISATION,ANNEEREGULARISATION,IDCATEGORIE_QUALIFICATION,IDFONCTION,POURCENTAGE,ETATLIB,HS_30_NI,HS_30_I,HS_50_NI,HS_50_I
         FROM (
                  SELECT
                      p.id,
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
        'PR0000130'  AS HS_30_NI,
        'PR0000130I' AS HS_30_I,
        'PR0000150'  AS HS_50_NI,
        'PR0000150I' AS HS_50_I
        )
                 ) ORDER BY matricule ASC

     ) SQ;