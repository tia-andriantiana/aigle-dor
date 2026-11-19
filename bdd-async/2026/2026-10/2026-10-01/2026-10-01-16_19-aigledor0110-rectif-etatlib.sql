CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL AS 
  SELECT t.ID,
       t.DESIGNATION,
       t.IDMAGASINDEPART,
       m.VAL AS IDMAGASINDEPARTLIB,
       t.IDMAGASINARRIVE,
       m2.VAL AS IDMAGASINARRIVELIB,
       t.DATY,
       t.ETAT,
       t.IDOF,
       CASE
           WHEN t.ETAT = 0  THEN 'ANNUL&Eacute;'
           WHEN t.ETAT = 1  THEN 'CR&Eacute&Eacute;'
           WHEN t.ETAT = 11 THEN 'VIS&Eacute;'
           ELSE NULL
           END AS ETATLIB,
       (
           NVL(CAST(t.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINDEPART AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINARRIVE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m2.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(t.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(t.ETAT), '') || ' | ' ||
           NVL(CAST(t.IDOF AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN t.ETAT = 0  THEN 'ANNUL&Eacute;'
                       WHEN t.ETAT = 1  THEN 'CR&Eacute&Eacute;'
                       WHEN t.ETAT = 11 THEN 'VIS&Eacute;'
                       ELSE NULL
                       END,
                   ''
           )
           ) AS MOTSCLESSS
FROM TRANSFERTSTOCK t
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2
                   ON m2.ID = t.IDMAGASINARRIVE;
