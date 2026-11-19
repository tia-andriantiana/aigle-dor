create or replace view RISTOURNELIB as
SELECT SQ."ID",SQ."DESIGNATION",SQ."IDCLIENT",SQ."DATY",SQ."DATEDEBUTRISTOURNE",SQ."DATEFINRISTOURNE",SQ."IDORIGINE",SQ."ETAT",SQ."IDCLIENTLIB",SQ."ETATLIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(IDCLIENT),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATEDEBUTRISTOURNE,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DATEFINRISTOURNE,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(IDCLIENTLIB),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'')) AS MOTSCLESSS
FROM (
         SELECT
             r.ID,r.DESIGNATION,r.IDCLIENT,r.DATY,r.DATEDEBUTRISTOURNE,r.DATEFINRISTOURNE,r.IDORIGINE,r.ETAT,
             c.nom AS idclientlib,
             CASE
                 WHEN r.etat = 0
                     THEN 'ANNUL&Eacute;E'
                 WHEN r.etat = 1
                     THEN 'CR&Eacute;&Eacute;E'
                 WHEN r.etat = 11
                     THEN 'VIS&Eacute;E'
                 END AS etatlib
         FROM RISTOURNE r
                  LEFT JOIN CLIENT c ON r.idclient = c.id


     ) SQ;