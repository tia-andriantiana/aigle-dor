
CREATE OR REPLACE  VIEW "V_ACCIDENT_LIB"  AS 
  SELECT
    A.ID,
    A.DATY,
    A.DATE_DECLARATION,
    A.ID_PERSONNEL,

    A.ID_LIEU,
    L.VAL          AS ID_LIEU_LIB,

    A.ID_TYPE_ACCIDENT,
    T.VAL          AS ID_TYPE_ACCIDENT_LIB,

    A.ID_GRAVITE,
    G.VAL          AS ID_GRAVITE_LIB,

    A.CAUSE,

    A.ID_MACHINE,
    M.VAL AS ID_MACHINE_LIB,
    A.etat,
    CASE
        WHEN A.ETAT = 1 THEN '<span style= color: green; >CR&Eacute;&Eacute;</span>' 

        WHEN A.ETAT = 11 THEN '<span style= color: blue; >VALID&Eacute;</span>' 

        WHEN A.ETAT = 12 THEN '<span style= color: red; >REJET&Eacute;</span>' 

    END AS ETAT_LIB

FROM ACCIDENT A
         LEFT JOIN LIEU_ACCIDENT_TRAVAIL L
                   ON L.ID = A.ID_LIEU
         LEFT JOIN TYPE_ACCIDENT T
                   ON T.ID = A.ID_TYPE_ACCIDENT
         LEFT JOIN GRAVITE_ACCIDENT G
                   ON G.ID = A.ID_GRAVITE
        LEFT JOIN MACHINE M on M.ID = A.ID_MACHINE;