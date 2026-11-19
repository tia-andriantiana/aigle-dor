-- ==============================================================================
-- Script de mise en conformite du type de idutilisateur sur HISTOINSERT
-- Contexte : Alignement avec la table HISTORIQUE et le modele Java MapHistorique
-- Base : PostgreSQL (aigledor0110)
-- Auteur : Nomena
-- ==============================================================================

-- 1. Suppression temporaire des vues dependantes
DROP VIEW IF EXISTS v_histoinsert;
DROP VIEW IF EXISTS histoinsertvue;

-- 2. Modification du type de colonne idutilisateur vers character varying(50)
ALTER TABLE histoinsert 
  ALTER COLUMN idutilisateur TYPE character varying(50) 
  USING idutilisateur::character varying;

-- 3. Recreation explicite de la vue histoinsertvue (sans SELECT *)
CREATE VIEW histoinsertvue AS
SELECT 
    h.idhistorique,
    h.datehistorique,
    h.heure,
    h.objet,
    h.action,
    h.idutilisateur,
    h.refobjet,
    (((h.remarque)::text || ' '::text) || (h.refobjet)::text) AS remarque
FROM histoinsert h;

-- 4. Recreation explicite de la vue v_histoinsert (sans SELECT *)
CREATE VIEW v_histoinsert AS
SELECT 
    hi.idhistorique,
    hi.datehistorique,
    hi.heure,
    hi.objet,
    hi.action,
    hi.idutilisateur,
    hi.refobjet,
    NULLIF(concat(hi.remarque, ' ', hi.refobjet, ' ', hi.datehistorique), ''::text) AS remarque,
    cf.fiche
FROM histoinsert hi
LEFT JOIN v_classeetfiche cf ON (((cf.classe)::text = (hi.objet)::text));
