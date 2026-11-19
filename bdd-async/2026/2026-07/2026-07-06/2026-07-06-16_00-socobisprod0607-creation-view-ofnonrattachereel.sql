-- Iratra

CREATE VIEW OFNONRATTACHEREEL (IDOFFILLE, DATY, IDPRODUIT, IDPRODUITLIB, QTE, QTEPETRI, IDLIGNE, LIGNE, LANCEPAR) AS 
  SELECT
        offille.id AS idoffille,
        o.daty AS daty,
        offille.IDINGREDIENTS AS idproduit,
        ai.LIBELLE AS idproduitLib,
        offille.qtefabrique as qte,
        (offille.qtefabrique/e.NBCARTON) AS qtepetri,
        l.id AS idligne,
        l.VAL AS ligne,
        o.lancepar
        FROM ofab o
LEFT join OfFilleLibStock offille ON o.id=offille.idmere
LEFT JOIN AS_INGREDIENTS ai ON ai.id=offille.IDINGREDIENTS
LEFT JOIN TYPE_PRODUIT tp ON tp.ID = ai.typeproduit 
LEFT JOIN LIGNE l ON l.id=tp.IDLIGNE 
LEFT JOIN EQUIVALENCECARTON e ON e.IDCARTON = offille.IDINGREDIENTS
WHERE o.etat = 11
