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
  AND cse.COMPTE LIKE '4456%' AND cse.COMPTE!='445600'
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
  AND cse.COMPTE LIKE '4457%' AND cse.COMPTE !='445700'
/

alter table LIAISONCODEIMPOT add formule varchar(50);
alter table LIAISONCODEIMPOT add taxable varchar(50);

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
       csed.MOISDECLARATION,
       case
           when csed.MOISDECLARATION is null then 'non'
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
           else 'oui'
           END AS declaration
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE COMPTE like '4457%' OR COMPTE like '4456%'
    /


create view COMPTASOUSECRITUREDECLARER as
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
       csed.MOISDECLARATION,
       case
           when csed.MOISDECLARATION is null then 'non'
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
           else 'oui'
           END AS declaration
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
                       /

create view COMPTASOUSECRITURESTVA as
select cse1.* from COMPTA_SOUS_ECRITURE cse1 left join COMPTA_SOUS_ECRITURE cse2 on cse1.IDMERE=cse2.IDMERE AND cse2.COMPTE like '445%' where cse2.COMPTE is null ;

UPDATE MENUDYNAMIQUE SET LIBELLE = 'Liste TVA', ICONE = 'description', HREF = 'module.jsp?but=declaration/liste-tva-adeclarer.jsp', RANG = 2, NIVEAU = 3, ID_PERE = 'MENDYN1769515257466822' where ID='MENDYN176951533777035';
