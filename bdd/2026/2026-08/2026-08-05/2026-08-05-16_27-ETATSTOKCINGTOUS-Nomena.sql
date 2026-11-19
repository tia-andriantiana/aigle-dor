create or replace view V_ETATSTOCK_ING_TOUS as
WITH max_inventaire AS (
    -- Etape 1 : On extrait la date maximale valide et la quantite par COUPLE produit/magasin
    SELECT
        invff.idproduit,
        imeref.idmagasin,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
             LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.idproduit, imeref.idmagasin
),
     somme_precalc AS (
         -- Etape 3 : Calcul des sommes globales agregees par COUPLE produit/magasin
         SELECT
             mff.idproduit as idproduit,
             meref.idmagasin as idmagasin,
             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,

             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,
             ai.LIBELLE AS idproduitlib,
             ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,
             ai.IDMODELE as idmodele,
             mo.LIBELLE as idmodelelib,
             mo.IDCATEGORIE as idCategorieModele,
             camo.VAL as idCategorieModeleLib,
             scm.id as idSousCategorieModele,
             scm.VAL as idSousCategorieModeleLib,
             ai.UNITE as unite,
             ai.TYPESTOCK as typestock,
             ai.marque as idPointure,
             pt.VAL as idPointureLib,
             u.VAL AS idunitelib,
             c.VAL AS idtypeproduitlib,
             vrc.REFERENCECOULEUR ,
             vrc.NOMCOULEUR,
             vrc.CODECOULEUR,
             avg(mff.PU) as pu,
             null as IDFOURNISSEUR,
             null as IDFOURNISSEURLIB,
             m.VAL AS idmagasinlib,
             max(inv.max_daty) AS invdaty,
             nvl(max(inv.qte_max_daty),0)as invquantite,
             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,
             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,
             nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv, nvl(max(ai.SEUIL),0) as seuil,nvl(max(ai.SEUILMAX),nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,nvl(max(ai.SEUILMIN),0) as seuilMin
         FROM MVTSTOCKFILLE mff
                  LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
                  LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin
                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                  LEFT join modele mo on mo.id = ai.IDMODELE
                  LEFT join categoriemodele camo on camo.ID = mo.IDCATEGORIE
                  LEFT join  souscategoriemodele scm on  scm.ID =mo.IDSOUSCATEGORIE
                  LEFT join pointure pt on pt.ID = ai.MARQUE
                  LEFT JOIN COULEUR coul ON coul.id = ai.COULEUR
                  LEFT join V_REFERENCE_COULEUR vrc on vrc.CODECOULEUR = coul.DESCE
         WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and
             meref.ETAT >= 11
           AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
        GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL, ai.IDMODELE, mo.IDCATEGORIE, camo.VAL, mo.LIBELLE, scm.ID , scm.VAL, ai.MARQUE,pt.VAL,vrc.REFERENCECOULEUR ,vrc.NOMCOULEUR,vrc.CODECOULEUR
        )
-- Selection finale
SELECT
    NULL AS id,
    NULL AS daty,

    CAST(NVL(invquantite,0) AS NUMBER(30,2)) AS invquantite,
    CAST(NVL(entree,0) AS NUMBER(30,2)) AS entree,
    CAST(NVL(sortie,0) AS NUMBER(30,2)) AS sortie,

    CAST(
            NVL(invquantite,0)
                + NVL(entree,0)
                - NVL(sortie,0)
        AS NUMBER(30,2)) AS reste,

    CAST(
            NVL(invquantite,0)
                + NVL(entree,0)
                - NVL(sortie,0)
        AS NUMBER(30,2)) AS quantite,

    CAST(
            NVL(montantInv,0)
                + NVL(montantEntree,0)
                - NVL(montantSortie,0)
        AS NUMBER(30,2)) AS montantreste,

    CASE
        WHEN NVL(invquantite,0)
                 + NVL(entree,0)
                 - NVL(sortie,0) = 0
            THEN 0
        ELSE CAST(
                (
                    NVL(montantInv,0)
                        + NVL(montantEntree,0)
                        - NVL(montantSortie,0)
                    )
                    / (
                    NVL(invquantite,0)
                        + NVL(entree,0)
                        - NVL(sortie,0)
                    )
            AS NUMBER(30,2))
        END AS pu,

    idproduitlib,

    idmodele,
    idmodelelib,
    idCategorieModele,
    idCategorieModeleLib,
    idSousCategorieModele,
    idSousCategorieModeleLib,
    idPointure,
    idPointureLib,
    categorieingredient,
    unite,
    typestock,
    idunitelib,
    idtypeproduitlib,
    idfournisseur,
    idfournisseurlib,
    idproduit,
    idmagasin,
    idmagasinlib,
    invdaty,
    REFERENCECOULEUR,
    NOMCOULEUR,
    CODECOULEUR,
    CAST(NVL(seuil,0) AS NUMBER(30,2)) AS seuil,
    CAST(NVL(seuilMin,0) AS NUMBER(30,2)) AS seuilMin,
    CAST(NVL(seuilMax,0) AS NUMBER(30,2)) AS seuilMax

FROM somme_precalc;