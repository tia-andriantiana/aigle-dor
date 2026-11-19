ALTER TABLE COMPTEURMAINTENANCE
    ADD idMagasin VARCHAR2(250);

ALTER TABLE COMPTEURMAINTENANCE
    ADD CONSTRAINT fk_compteur_magasin
        FOREIGN KEY (idMagasin)
            REFERENCES MAGASIN2(id);

CREATE OR REPLACE VIEW COMPTEURCPL AS
SELECT
    c.id,
    c.daty,
    c.idligne,
    c.valeur,
    c.ecart,
    c.idcategorie,
    c.idtranche,
    l.val        AS idlignelib,
    cc.val       AS idcategorielib,
    t.val        AS idtranchelib,
    c.etat,
    m.VAL AS idMagasinLib
FROM compteurmaintenance c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN categorieconsommable cc
                   ON cc.id = c.idcategorie
         LEFT JOIN tranche t
                   ON t.id = c.idtranche
         LEFT JOIN MAGASIN2 m ON m.ID = c.IDMAGASIN;

UPDATE AS_INGREDIENTS
SET TYPESTOCK = 'CUMP'
WHERE TYPECONSO IS NOT NULL;
