ALTER TABLE historique
ALTER COLUMN idhistorique   TYPE varchar(255),
    ALTER COLUMN datehistorique TYPE date USING datehistorique::date,
    ALTER COLUMN heure          TYPE varchar(50),
    ALTER COLUMN idutilisateur  TYPE varchar(50) USING idutilisateur::varchar,
    ALTER COLUMN idutilisateur  DROP NOT NULL,
    ALTER COLUMN refobjet       TYPE varchar(255);

CREATE VIEW historiqueavecuser (idhistorique, datehistorique, heure, objet, action, idutilisateur, refobjet) AS
SELECT h.idhistorique,
       h.datehistorique,
       h.heure,
       NULLIF("substring"(h.objet::text,
                          CASE
                              WHEN "position"("substring"(h.objet::text, '-1'::integer), '.'::text) = 0 THEN 0
                              ELSE "position"("substring"(h.objet::text, '-1'::integer), '.'::text) + '-1'::integer - 1
                          END + 1), ''::text) AS objet,
       h.action,
       u.loginuser                                AS idutilisateur,
       h.refobjet
FROM historique h
         JOIN utilisateur u ON u.refuser::varchar = h.idutilisateur
ORDER BY h.datehistorique DESC, h.heure DESC;