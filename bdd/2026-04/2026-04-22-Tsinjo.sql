CREATE OR REPLACE VIEW CAISSECPL AS
SELECT SQ.ID,SQ.VAL,SQ.DESCE,SQ.IDTYPECAISSE,SQ.IDTYPECAISSELIB,SQ.IDPOINT,SQ.IDPOINTLIB,SQ.IDPOMPISTE,SQ.ETAT,SQ.COMPTE,SQ.ETATLIB,SQ.IDCATEGORIECAISSE,SQ.IDCATEGORIECAISSELIB,SQ.IDMAGASIN,SQ.IDMAGASINLIB,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(VAL),'') || ' | ' || NVL(TO_CHAR(DESCE),'') || ' | ' || NVL(TO_CHAR(IDTYPECAISSE),'') || ' | ' || NVL(TO_CHAR(IDTYPECAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDPOINTLIB),'') || ' | ' || NVL(TO_CHAR(IDPOMPISTE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSE),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'')) AS MOTSCLESSS
FROM (
         SELECT c.ID,
                c.VAL,
                c.DESCE,
                c.IDTYPECAISSE,
                t.VAL   AS IDTYPECAISSELIB,
                c.IDPOINT,
                p.VAL   AS IDPOINTLIB,
                c.IDPOMPISTE,
                c.ETAT,
                cop.LIBELLE||'('||cop.COMPTE||')' as compte ,
                CASE
                    WHEN c.ETAT = 0
                        THEN 'ANNUL&Eacute;'
                    WHEN c.ETAT = 1
                        THEN 'CR&Eacute;&Eacute;'
                    WHEN c.ETAT = 11
                        THEN 'VIS&Eacute;'
                    END AS ETATLIB,
                c.idCategorieCaisse,
                c2.VAL  AS idCategorieCaisseLib,
                c.IDMAGASIN ,
                m.val AS idMagasinLib
         FROM CAISSE c
                  LEFT JOIN TYPECAISSE t ON t.ID = c.IDTYPECAISSE
                  LEFT JOIN POINT p ON p.ID = c.IDPOINT
                  LEFT JOIN CATEGORIECAISSE c2 ON c2.ID = c.idCategorieCaisse
                  LEFT JOIN COMPTA_COMPTE cop ON cop.COMPTE = c.COMPTE
                  LEFT JOIN MAGASIN2 m ON m.ID =c.IDMAGASIN


     ) SQ;

CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL_A AS
SELECT
    ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS
FROM
    MOUVEMENTCAISSECPL m
WHERE
        m.etat = 8;

CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL_VALIDER AS
SELECT SQ.ID,SQ.DESIGNATION,SQ.IDCAISSE,SQ.IDCAISSELIB,SQ.IDVENTEDETAIL,SQ.IDVIREMENT,SQ.DEBIT,SQ.CREDIT,SQ.DATY,SQ.ETAT,SQ.ETATLIB,SQ.IDVENTE,SQ.IDORIGINE,SQ.IDTIERS,SQ.TIERS,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(IDCAISSE),'') || ' | ' || NVL(TO_CHAR(IDCAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDVENTEDETAIL),'') || ' | ' || NVL(TO_CHAR(IDVIREMENT),'') || ' | ' || NVL(TO_CHAR(DEBIT),'') || ' | ' || NVL(TO_CHAR(CREDIT),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(IDTIERS),'') || ' | ' || NVL(TO_CHAR(TIERS),'')) AS MOTSCLESSS
FROM (
         SELECT
             ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS
         FROM
             MOUVEMENTCAISSECPL m
         WHERE
                 m.etat = 11

     ) SQ;