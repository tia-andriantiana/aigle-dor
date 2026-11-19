create or replace view SOUSECRITURENR as
SELECT
    cse.ID,
    cse.LIBELLEPIECE,
    cse.DEBIT,
    cse.CREDIT,
    cse.DATY,
    cai.ID as IDCAISSE,
    cse.COMPTE
FROM COMPTA_SOUS_ECRITURE cse
         LEFT JOIN COMPTA_ECRITURE ce ON ce.ID = cse.idmere
         LEFT join CAISSE cai on cai.COMPTE=cse.COMPTE
WHERE
    cse.ID NOT IN (
        SELECT rpf.idSousEcriture
        FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
        WHERE rpf.idSousEcriture IS NOT NULL AND rp.ETAT>=11
    )
AND ce.JOURNAL in (select id from COMPTA_JOURNAL cj where cj.COMPTE like '512%') AND cse.COMPTE like '5%';

INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'BNI', 'BANQUE BNI', '512110');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'MCB', 'BANQUE MCB', '512120');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'BRED', 'BANQUE BRED', '512210');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'BOA', 'BANQUE BOA', '512410');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'BMOI', 'BANQUE BMOI', '512500');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'BBM', 'BANQUE BAOBAB ', '512600');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'CS', 'CAISSE', '530000');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'PCS', 'PETITE CAISSE', '531000');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'EFFET', 'EFFET', '403000');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'HA', 'ACHAT DE MARCHANDISES', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'IMMO', 'IMMOBILISATION', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'OD', 'OPERATIONS DIVERSES', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'RG', 'REGULARISATION', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'PA', 'PAIE TITULAIRE', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'PA TE', 'PAIE  TEMPORAIRE', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'PA VA', 'PAIE VACATAIRE', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'AV', 'AVANCE CLIENTS', '');
INSERT INTO COMPTA_JOURNAL (ID, VAL, DESCE, COMPTE) VALUES ('COMP0000'||GET_SEQ_COMPTA_JOURNAL(), 'CL', 'CLOTURE EXERCICE', '');


create or replace view COMPTASOUSECRITUREND as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  and COMPTE like '445%';

create or replace view COMPTASOUSECRITURETVA as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE,
       case
           when csed.MOISDECLARATION is null then '-'
           when csed.MOISDECLARATION =1 then 'Janvier'
           when csed.MOISDECLARATION =2 then 'Fevrier'
           when csed.MOISDECLARATION =3 then 'Mars'
           when csed.MOISDECLARATION =4 then 'Avril'
           when csed.MOISDECLARATION =5 then 'Mai'
           when csed.MOISDECLARATION =6 then 'Juin'
           when csed.MOISDECLARATION =7 then 'Juillet'
           when csed.MOISDECLARATION =8 then 'Aout'
           when csed.MOISDECLARATION =9 then 'Septembre'
           when csed.MOISDECLARATION =10 then 'Octobre'
           when csed.MOISDECLARATION =11 then 'Novembre'
           when csed.MOISDECLARATION =12 then 'Decembre'
           else '-'
           END AS declaration
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE COMPTE like '445%';

create or replace view COMPTASOUSECRITUREDND as
SELECT ' ' as ID,
       ' ' as NUMERO,
       ' ' as COMPTE,
       ' ' as JOURNAL,
       ' ' as IDJOURNAL,
       ' ' as ECRITURE,
       sysdate as DATY,
       0 as CREDIT,
       0 as DEBIT,
       sysdate as DATECOMPTABLE,
       0 as EXERCICE,
       ' ' as REMARQUE,
       11 as ETAT,
       ' ' as IDMERE,
       1 as HORSEXERCICE,
       ' ' as OD,
       ' ' as ORIGINE,
       ' ' as TIERS,
       ' ' as LIBELLEPIECE,
       ' ' as COMPTE_AUX,
       ' ' as RAISONSOCIAL,
       ' ' as FOLIO,
       ' ' as LETTRAGE,
       ' ' as ANALYTIQUE
FROM dual
Union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4456%'
    /


create or replace view COMPTASOUSECRITURECND as
select
    ' ' as ID,
    ' ' as NUMERO,
    ' ' as COMPTE,
    ' ' as JOURNAL,
    ' ' as IDJOURNAL,
    ' ' as ECRITURE,
    sysdate as DATY,
    0 as CREDIT,
    0 as DEBIT,
    sysdate as DATECOMPTABLE,
    0 as EXERCICE,
    ' ' as REMARQUE,
    11 as ETAT,
    ' ' as IDMERE,
    1 as HORSEXERCICE,
    ' ' as OD,
    ' ' as ORIGINE,
    ' ' as TIERS,
    ' ' as LIBELLEPIECE,
    ' ' as COMPTE_AUX,
    ' ' as RAISONSOCIAL,
    ' ' as FOLIO,
    ' ' as LETTRAGE,
    ' ' as ANALYTIQUE
from dual
union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4457%';