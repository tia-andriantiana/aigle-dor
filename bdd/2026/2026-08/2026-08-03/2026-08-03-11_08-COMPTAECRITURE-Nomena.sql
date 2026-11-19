create or replace view COMPTA_ECRITURE_LIB_VENTE as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Cree'
        WHEN ce.ETAT = 11 THEN 'Valide'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
where IDOBJET like '%VNT%'
order by ce.DATY desc;

create or replace view COMPTA_ECRITURE_LIB_STOCK as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Cree'
        WHEN ce.ETAT = 11 THEN 'Valide'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
where IDOBJET like '%MVTST%' or
    IDOBJET like '%MTC%'
order by ce.DATY desc;

create or replace view COMPTA_ECRITURE_LIB_AVOIRFC as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Cree'
        WHEN ce.ETAT = 11 THEN 'Valide'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
where IDOBJET like '%AVRFC%'
order by ce.DATY desc;

create or replace view COMPTA_ECRITURE_LIB_ACHAT as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Cree'
        WHEN ce.ETAT = 11 THEN 'Valide'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
where IDOBJET like '%FCF%'
order by ce.DATY desc;

create or replace view COMPTA_ECRITURE_LIB_MANUELLE as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB, cj.val as JOURNALCODE,
    CASE
        WHEN ce.ETAT = 1  THEN 'Cree'
        WHEN ce.ETAT = 11 THEN 'Valide'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
where IDOBJET is null
order by ce.DATY desc;
