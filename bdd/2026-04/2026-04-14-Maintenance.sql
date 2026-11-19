INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMA28BE93CD', '*', 'MENUDYN01908001', NULL, NULL, NULL, 1);
ALTER TABLE COMPTEURMAINTENANCE DROP COLUMN idtranche;

CREATE OR REPLACE FORCE VIEW "COMPTEURCPL" ("ID", "DATY", "IDLIGNE", "VALEUR", "ECART", "IDCATEGORIE", "IDLIGNELIB", "IDCATEGORIELIB", "ETAT", "IDMAGASIN", "IDMAGASINLIB") AS 
  SELECT
    c.id,
    c.daty,
    c.idligne,
    c.valeur,
    c.ecart,
    c.idcategorie,
    l.val        AS idlignelib,
    cc.libelle       AS idcategorielib,
    c.etat,
    c.IDMAGASIN,
    m.VAL AS idMagasinLib
FROM compteurmaintenance c
         LEFT JOIN ligne l
                   ON l.id = c.idligne
         LEFT JOIN AS_INGREDIENTS_CONSOMMABLE cc
                   ON cc.id = c.idcategorie
         LEFT JOIN MAGASIN2 m ON m.ID = c.IDMAGASIN;

ALTER TABLE COMPTEURMAINTENANCE DROP CONSTRAINT SYS_C0030920;

CREATE OR REPLACE VIEW AS_INGREDIENTS_CONSOMMABLE AS 
SELECT * FROM AS_INGREDIENTS ai WHERE ai.CATEGORIEINGREDIENT = 'CAT0011' ;

ALTER TABLE compteurmaintenance
ADD CONSTRAINT fk_compteur_ingredients
FOREIGN KEY (idCategorie)
REFERENCES as_ingredients(id);

delete from historique_produit;
delete from produit;
delete from categorie;
delete from type_produit;

CREATE OR REPLACE force VIEW ofnonrattache as
SELECT
        offille.id AS idoffille,
        o.daty AS daty,
        offille.IDINGREDIENTS AS idproduit,
        ai.LIBELLE AS idproduitLib,
        offille.qte AS qte,
       (offille.qte/e.NBCARTON) AS qtepetri,
        l.id AS idligne,
        l.VAL AS ligne
        FROM ofab o
LEFT join offille offille ON o.id=offille.idmere
LEFT JOIN AS_INGREDIENTS ai ON ai.id=offille.IDINGREDIENTS
LEFT JOIN TYPE_PRODUIT tp ON tp.ID = ai.TYPECONSO 
LEFT JOIN LIGNE l ON l.id=tp.IDLIGNE 
LEFT JOIN EQUIVALENCECARTON e ON e.IDCARTON = offille.IDINGREDIENTS 
WHERE o.etat = 11
 ;

ALTER TABLE RELEVEFAB DROP CONSTRAINT SYS_C0030922;
ALTER TABLE RELEVEFAB
ADD CONSTRAINT fk_releve_off
FOREIGN KEY (idFab)
REFERENCES offille(id);

CREATE OR REPLACE VIEW OFRATTACHE AS 
SELECT ofn.*,r.IDRELEVE  FROM ofnonrattache ofn
	JOIN RELEVEFAB r ON r.IDFAB = ofn.idoffille;