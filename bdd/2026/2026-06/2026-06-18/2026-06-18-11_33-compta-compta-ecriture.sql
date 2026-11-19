create or replace view COMPTA_ECRITURE_LIB as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Créé'
        WHEN ce.ETAT = 11 THEN 'Validé'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
order by ce.DATY desc;

