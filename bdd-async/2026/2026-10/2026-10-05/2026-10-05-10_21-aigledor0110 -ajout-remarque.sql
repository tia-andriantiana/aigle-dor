CREATE OR REPLACE VIEW INVENTAIRELIB AS 
  SELECT i.ID,
       i.DATY,
       i.DESIGNATION,
       i.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       i.ETAT,
       i.HEURE,
       CASE
           WHEN i.ETAT = 0  THEN 'ANNUL&Eacute;E'
           WHEN i.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
           WHEN i.ETAT = 11 THEN 'VALID&Eacute;E'
           ELSE NULL
           END AS ETATLIB,
       i.IDCATEGORIE,
       c.VAL AS IDCATEGORIELIB,
       (
           NVL(CAST(i.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(i.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(CAST(i.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(i.IDMAGASIN AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(i.ETAT), '') || ' | ' ||
           NVL(CAST(i.HEURE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN i.ETAT = 0  THEN 'ANNUL&Eacute;E'
                       WHEN i.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                       WHEN i.ETAT = 11 THEN 'VALID&Eacute;E'
                       ELSE NULL
                       END,
                   ''
           ) || ' | ' ||
           NVL(CAST(i.IDCATEGORIE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(c.VAL AS VARCHAR2(4000)), '')
           ) AS MOTSCLESSS,
           invfgm.montantquantite,
           i.REMARQUE
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = i.IDMAGASIN
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = i.IDCATEGORIE
		 LEFT JOIN INVENTAIREFILLEGROUPEMERE invfgm ON invfgm.idinventaire = i.id;

CREATE OR REPLACE VIEW INVENTAIRELIB_ANNULEE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE, i.REMARQUE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 0;

CREATE OR REPLACE VIEW INVENTAIRELIB_CREE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE, i.REMARQUE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 1;

CREATE OR REPLACE VIEW INVENTAIRELIB_VALIDEE AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MONTANTQUANTITE, i.REMARQUE
FROM INVENTAIRELIB i 
WHERE i.ETAT = 11;
