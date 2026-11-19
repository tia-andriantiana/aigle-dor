-- ============================================================================
-- Auteur : Nomena. Migration Oracle AIGLEDOR0110 -> PostgreSQL 9.5.23 / public.
-- 3 VUES AVEC CORRECTIONS DE SYNTAXE EVIDENTES
-- Date : 2026-10-20
--
-- Contexte :
-- Ces 3 vues comportaient des erreurs de syntaxe simples dans la source Oracle :
-- 1. AS_INGREDIENTXMAGASIN2 : ORA-00918 (ambiguite de colonne non prefixee entre
--    as_ingredients et magasin2). Corrige par prefixage explicite ai.*.
-- 2. V_ETATSTOCK_ENTREE_DMDACHAT : debloquee par la creation de as_ingredientxmagasin2.
-- 3. BC_CLIENT_FILLE_CPL_LIB_VISEE : qualification explicite de la clause mere.etat >= 11.
--
-- Note de conformite :
-- Conformement a la regle stricte, aucune vue avec table ou colonne manquante
-- n'a ete modifiee ou forcee.
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
    IF current_setting('server_version_num')::integer NOT BETWEEN 90500 AND 90599 THEN
        RAISE EXCEPTION 'Script prepare pour PostgreSQL 9.5 : version %', version();
    END IF;
    SELECT string_agg(c.relname, ', ' ORDER BY c.relname) INTO problemes
    FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relname=ANY(ARRAY[
        'as_ingredientxmagasin2',
        'v_etatstock_entree_dmdachat',
        'bc_client_fille_cpl_lib_visee'
    ]::text[]);
    IF problemes IS NOT NULL THEN
        RAISE EXCEPTION 'Objets deja presents, aucune vue ne sera remplacee : %', problemes;
    END IF;
    SELECT string_agg(r.nom, ', ' ORDER BY r.nom) INTO problemes
    FROM unnest(ARRAY[
        'public.as_ingredients',
        'public.magasin2',
        'public.mvtstockentreeavecreste',
        'public.categorieingredient',
        'public.unite',
        'public.bondecommande_client_fille_cpl',
        'public.bondecommande_client'
    ]::text[]) AS r(nom)
    WHERE pg_catalog.to_regclass(r.nom::cstring) IS NULL;
    IF problemes IS NOT NULL THEN
        RAISE EXCEPTION 'Prerequis absents : %', problemes;
    END IF;
END;
$migration_guard$ LANGUAGE plpgsql;

-- 1. AS_INGREDIENTXMAGASIN2 (prefixage explicite ai.* pour lever l'ambiguite ORA-00918)
CREATE VIEW public.as_ingredientxmagasin2 (
    "id", "libelle", "seuil", "unite", "quantiteparpack", "pu", "actif", "photo",
    "calorie", "durre", "compose", "categorieingredient", "idfournisseur", "daty",
    "qtelimite", "pv", "libellevente", "seuilmin", "seuilmax", "puachatusd",
    "puachateuro", "puachatautredevise", "puventeusd", "puventeeuro", "puventeautredevise",
    "isvente", "isachat", "compte_vente", "compte_achat", "libelleextacte", "tva",
    "filepath", "reste", "typestock", "refpost", "refqualification", "idchambre",
    "isperishable", "pv2", "idfamille", "idmagasin", "parfums", "idmagasinlib"
) AS
SELECT
    ai.id,
    ai.libelle,
    ai.seuil,
    ai.unite,
    ai.quantiteparpack,
    ai.pu,
    ai.actif,
    ai.photo,
    ai.calorie,
    ai.durre,
    ai.compose,
    ai.categorieingredient,
    ai.idfournisseur,
    ai.daty,
    ai.qtelimite,
    ai.pv,
    ai.libellevente,
    ai.seuilmin,
    ai.seuilmax,
    ai.puachatusd,
    ai.puachateuro,
    ai.puachatautredevise,
    ai.puventeusd,
    ai.puventeeuro,
    ai.puventeautredevise,
    ai.isvente,
    ai.isachat,
    ai.compte_vente,
    ai.compte_achat,
    ai.libelleextacte,
    ai.tva,
    ai.filepath,
    ai.reste,
    ai.typestock,
    ai.refpost,
    ai.refqualification,
    ai.idchambre,
    ai.isperishable,
    ai.pv2,
    ai.idfamille,
    m.id AS idmagasin,
    ai.parfums,
    m.val AS idmagasinlib
FROM public.as_ingredients ai, public.magasin2 m;

-- 2. V_ETATSTOCK_ENTREE_DMDACHAT (debloquee par AS_INGREDIENTXMAGASIN2)
CREATE VIEW public.v_etatstock_entree_dmdachat (
    "id", "idproduit", "idproduitlib", "categorieingredient", "idtypeproduitlib",
    "idmagasin", "idmagasinlib", "quantite", "entree", "sortie", "reste",
    "unite", "idunitelib", "pu", "daty"
) AS
SELECT
    ai.id AS id,
    ai.id AS idproduit,
    ai.libelle AS idproduitlib,
    ai.categorieingredient,
    c.val AS idtypeproduitlib,
    ve.idmagasin,
    ai.idmagasinlib,
    CAST(SUM(COALESCE(ve.quantite, 0)) AS NUMERIC(30,5)) AS quantite,
    CAST(SUM(COALESCE(ve.entree, 0)) AS NUMERIC(30,5)) AS entree,
    CAST(SUM(COALESCE(ve.sortie, 0)) AS NUMERIC(30,5)) AS sortie,
    CAST(SUM(COALESCE(ve.reste, 0)) AS NUMERIC(30,5)) AS reste,
    ai.unite,
    u.val AS idunitelib,
    CAST(MIN(COALESCE(ve.pu, 0)) AS NUMERIC(30,5)) AS pu,
    MIN(ve.daty) AS daty
FROM
    public.as_ingredientxmagasin2 ai
    LEFT JOIN public.mvtstockentreeavecreste ve ON ai.id = ve.idproduit
    LEFT JOIN public.categorieingredient c ON ai.categorieingredient = c.id
    LEFT JOIN public.unite u ON ai.unite = u.id
GROUP BY
    ai.id,
    ai.libelle,
    ai.categorieingredient,
    c.val,
    ve.idmagasin,
    ai.unite,
    u.val,
    ai.idmagasinlib;

-- 3. BC_CLIENT_FILLE_CPL_LIB_VISEE (qualification mere.etat >= 11)
CREATE VIEW public.bc_client_fille_cpl_lib_visee (
    "id", "idbc", "iddevise", "montant", "produit", "pu", "quantite", "remise",
    "tva", "unite", "qteof", "qteofrestante", "qtefab", "qtefabrestante",
    "qtelivre", "qtenonlivre", "libelleproduit", "produitlib"
) AS
SELECT
    bc.id, bc.idbc, bc.iddevise, bc.montant, bc.produit, bc.pu, bc.quantite, bc.remise, bc.tva, bc.unite,
    bc.qteof, bc.qteofrestante, bc.qtefab, bc.qtefabrestante, bc.qtelivre, bc.qtenonlivre, bc.libelleproduit,
    i.libelle AS produitlib
FROM public.bondecommande_client_fille_cpl bc
JOIN public.as_ingredients i ON i.id = bc.produit
JOIN public.bondecommande_client mere ON mere.id = bc.idbc
WHERE mere.etat >= 11;

COMMIT;

-- Verification des 3 vues avec corrections de syntaxe
SELECT 'vues_corrections_syntaxe' AS lot, count(*) AS vues_presentes, 3 AS vues_attendues
FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
WHERE n.nspname='public' AND c.relkind='v' AND c.relname=ANY(ARRAY[
    'as_ingredientxmagasin2',
        'v_etatstock_entree_dmdachat',
        'bc_client_fille_cpl_lib_visee'
]::text[]);


