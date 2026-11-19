-- ============================================================================
-- Correction vue CAISSE_ESPECE : comparaison insensible a la casse
-- Date : 2026-11-12
--
-- Contexte :
-- Sur la page de login (index.jsp), la liste deroulante "Caisse" etait vide.
-- La liste est chargee depuis la vue caisse_espece
-- (Caisse.getListeCaisseEspece() -> socobis-ejb caisse.Caisse).
--
-- Cause :
-- La vue comparee les codes en minuscules ('tca003', 'ctc003'), herite de la
-- migration Oracle. Les donnees caisse sont stockees en MAJUSCULES ('TCA003',
-- 'CTC003') dans le dump PostgreSQL -> la vue retournait 0 ligne.
--
-- Correction :
-- Comparaison via upper(...) pour rester insensible a la casse, conformement
-- a l'origine Oracle (ou les identifiants etaient compares sans casse).
--
-- Verif :
--   SELECT id, val, idpoint FROM caisse_espece ORDER BY idpoint;
--   -> 7 lignes attendues, dont CAIBO002 (Caisse Espece Boutique, PNTB0001
--      = TSIROANOMANDIDY).
-- ============================================================================

BEGIN;
SET LOCAL client_encoding = 'UTF8';
SET LOCAL search_path = pg_catalog, public;
SET LOCAL lock_timeout = '5s';

DO $migration_guard$
DECLARE
    problemes text;
BEGIN
    IF current_database() <> 'aigledor0110' THEN
        RAISE EXCEPTION 'Base incorrecte : % (attendu : aigledor0110)', current_database();
    END IF;

    IF to_regclass('public.caisse') IS NULL THEN
        RAISE EXCEPTION 'Table public.caisse absente';
    END IF;

    SELECT string_agg(format('%s (%s)', n.nspname, c.relname), ', ')
      INTO problemes
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid
      JOIN pg_class c ON c.oid = r.ev_class
      JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE d.refobjid = 'public.caisse_espece'::regclass
       AND c.relname <> 'caisse_espece';
    IF problemes IS NOT NULL THEN
        RAISE EXCEPTION 'Objets dependant de caisse_espece : %', problemes;
    END IF;
END
$migration_guard$;

CREATE OR REPLACE VIEW public.caisse_espece AS
 SELECT id,
    val,
    desce,
    idtypecaisse,
    idpoint,
    idpompiste,
    etat,
    idcategoriecaisse,
    compte,
    idmagasin,
    iddevise,
    idtypebanque,
    estrib
   FROM public.caisse
  WHERE upper(idtypecaisse::text) = 'TCA003'
    AND upper(idcategoriecaisse::text) = 'CTC003';

COMMIT;
