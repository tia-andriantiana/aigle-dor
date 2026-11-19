-- Stefan

ALTER TABLE OFAB ADD Lanceur VARCHAR2(255);

ALTER TABLE OFAB
    ADD CONSTRAINT FK_OFAB_LANCEUR
        FOREIGN KEY (Lanceur)
            REFERENCES LOG_PERSONNEL (ID);

CREATE OR REPLACE VIEW OFABLIB AS
SELECT ofl.ID,
       p1.VAL  AS LANCEPAR,
       p2.VAL  AS CIBLE,
       ofl.REMARQUE,
       ofl.LIBELLE,
       ofl.BESOIN,
       ofl.DATY,
       ofl.ETAT,
       ofl.lanceur,
      lp.prenom | | lp.nom as lanceurlib,
       CASE
           WHEN ofl.ETAT=1
               THEN 'CR&Eacute;&Eacute;E'
           WHEN ofl.ETAT=11
               THEN 'Valid&eacute;'
           WHEN ofl.ETAT=0
               THEN 'ANNULEE'
           WHEN ofl.ETAT=21
               THEN 'ENTAME'
           WHEN ofl.ETAT=31
               THEN 'BLOQUE'
           WHEN ofl.ETAT=41
               THEN 'TERMINEE'
           END AS ETATLIB
FROM OFAB ofl
         LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE
         LEFT JOIN LOG_PERSONNEL lp ON lp.id = ofl.lanceur
;