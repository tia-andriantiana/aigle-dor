ALTER TABLE MASOCIETE
    ADD (
    disponnibilite VARCHAR(250)
);

alter table REPORTCAISSE ADD TYPEREPORT VARCHAR2(255);
ALTER TABLE REPORTCAISSE ADD idUser varchar2(255);


create or replace view MONTANTCAISSE as
SELECT
    etatcaisse.idcaisseLib AS caisselib,
    etatcaisse.idcaisse,
    CAST(ROUND(etatcaisse.reste, 0) AS NUMBER(30,0)) AS montantTheorique,
    0 AS montant,
    etatcaisse.dateDernierReport AS dateDernierReport,
    '' AS explication,
    '' AS idcloture
FROM V_ETATCAISSE_CLOTURE etatcaisse
WHERE TRUNC(etatcaisse.dateDernierReport) <= TRUNC(SYSDATE);


create or replace view REPORTCAISSE_CPL as
SELECT
    r.ID ,
    r.IDCAISSE ,
    c.VAL AS CAISSELIB,
    CAST(r.MONTANT AS NUMBER(30,5)) AS MONTANT ,
    CAST(r.MONTANTTHEORIQUE AS NUMBER(30,5)) AS MONTANTTHEORIQUE ,
    r.DATY ,
    r.ETAT ,r.heure,
    CASE
        WHEN r.ETAT = 0
            THEN 'ANNULEE'
        WHEN r.ETAT = 1
            THEN 'CREE'
        WHEN r.ETAT = 11
            THEN 'VALIDEE'
        END AS ETATLIB,
    r.idUser
FROM REPORTCAISSE r
         LEFT JOIN CAISSE c ON c.ID  = r.IDCAISSE;


