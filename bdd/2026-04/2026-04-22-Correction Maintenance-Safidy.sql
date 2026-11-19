CREATE OR REPLACE  VIEW ATTRIBUTIONELEMENTLIB AS
   select
    attr."ID",attr."IDINGREDIENTMAINTENANCE",attr."IDPERSONNEL",attr."DATY",attr."ETATELEMENT",attr."TYPEATTRIBUTION",
    asing.LIBELLE as IDINGREDIENTMAINTENANCELIB,
    pers.NOM as idPersonnelLib,
    qom.VAL as qualiteObjetMaintenanceLib,
    case
        when attr.TYPEATTRIBUTION = 0 then 'Sortie'
        when attr.TYPEATTRIBUTION = 1 then 'Retour'
        else 'Inconnu'
        end as typeAttributionLib,
    attr.qte AS qte,
    attr.etat,
    case
        when attr.etat = 1 then 'Créée'
        when attr.etat = 11 then 'Visée'
        when attr.etat = 0 then 'Annulée'
        end as etatLib,
    attr.id || asing.libelle || pers.nom || qom.val AS motsclesss
from
    ATTRIBUTIONELEMENT attr
        left join AS_INGREDIENT_MAINTENANCE ingm on attr.IDINGREDIENTMAINTENANCE = ingm.ID
        left join AS_INGREDIENTS asing on ingm.IDINGREDIENT = asing.ID
        left join PERSONNEL pers on attr.IDPERSONNEL = pers.ID
        left join QUALITESOBJETMAINTENANCE qom on attr.ETATELEMENT = qom.ID;

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB_PIECE as
SELECT SQ."ID",SQ."LIBELLE",SQ."PARFUMS",SQ."SEUIL",SQ."UNITE",SQ."QUANTITEPARPACK",SQ."PU",SQ."ACTIF",SQ."PHOTO",SQ."CALORIE",SQ."DURRE",SQ."COMPOSE",SQ."COMPOSELIB",SQ."IDCATEGORIEINGREDIENT",SQ."CATEGORIEINGREDIENT",SQ."IDCATEGORIE",SQ."IDFOURNISSEUR",SQ."DATY",SQ."BIENOUSERV",SQ."ETATLIB",SQ."COMPTE_VENTE",SQ."COMPTE_ACHAT",SQ."PV",SQ."TVA",SQ."TYPESTOCK",SQ."IDUNITE",SQ."REFPOST",SQ."REFQUALIFICATION",SQ."REFPOSTLIB",SQ."REFQUALIFICATIONLIB",SQ."IDFAMILLELIB",SQ."TYPEPRODUIT",SQ."IDLIGNE",SQ."COMPTE_STOCK",SQ."COMPTE_SORTIE_STOCK",SQ."IDFOURNISSEURLIB",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(LIBELLE),'') || ' | ' || NVL(TO_CHAR(PARFUMS),'') || ' | ' || NVL(TO_CHAR(SEUIL),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(QUANTITEPARPACK),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(ACTIF),'') || ' | ' || NVL(TO_CHAR(PHOTO),'') || ' | ' || NVL(TO_CHAR(CALORIE),'') || ' | ' || NVL(TO_CHAR(DURRE),'') || ' | ' || NVL(TO_CHAR(COMPOSE),'') || ' | ' || NVL(TO_CHAR(COMPOSELIB),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(CATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIE),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(BIENOUSERV),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(COMPTE_VENTE),'') || ' | ' || NVL(TO_CHAR(COMPTE_ACHAT),'') || ' | ' || NVL(TO_CHAR(PV),'') || ' | ' || NVL(TO_CHAR(TVA),'') || ' | ' || NVL(TO_CHAR(TYPESTOCK),'') || ' | ' || NVL(TO_CHAR(IDUNITE),'') || ' | ' || NVL(TO_CHAR(REFPOST),'') || ' | ' || NVL(TO_CHAR(REFQUALIFICATION),'') || ' | ' || NVL(TO_CHAR(REFPOSTLIB),'') || ' | ' || NVL(TO_CHAR(REFQUALIFICATIONLIB),'') || ' | ' || NVL(TO_CHAR(IDFAMILLELIB),'') || ' | ' || NVL(TO_CHAR(TYPEPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDLIGNE),'') || ' | ' || NVL(TO_CHAR(COMPTE_STOCK),'') || ' | ' || NVL(TO_CHAR(COMPTE_SORTIE_STOCK),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'')) AS MOTSCLESSS
FROM (
         SELECT ing.id,
                ing.LIBELLE,
                ing.PARFUMS,
                ing.SEUIL,
                au.VAL AS unite,
                ing.QUANTITEPARPACK,
                ing.pu,
                ing.ACTIF,
                ing.PHOTO,
                ing.CALORIE,
                ing.DURRE,
                ing.COMPOSE,
                CAST(
                        CASE
                            WHEN ing.COMPOSE = 1 THEN 'OUI'
                            WHEN ing.COMPOSE = 0 THEN 'NON'
                            END AS VARCHAR2(100)
                ) AS COMPOSELIB,
                cating.id AS IDCATEGORIEINGREDIENT ,
                catIng.VAL AS CATEGORIEINGREDIENT,
                ing.CATEGORIEINGREDIENT AS idcategorie,
                ing.idfournisseur,
                ing.daty,
                catIng.desce as bienOuServ,
                CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                         THEN 'INDISPONIBLE'
                     WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                         THEN 'DISPONIBLE'
                    END AS etatlib,
                ing.COMPTE_VENTE,
                ing.COMPTE_ACHAT,
                ing.pv,
                ing.tva,
                ing.TYPESTOCK,
                ing.UNITE as idunite,
                ing.REFPOST,
                ing.REFQUALIFICATION ,
                p.VAL AS REFPOSTLIB,
                qp.VAL AS REFQUALIFICATIONLIB,
                fp.val AS idfamilleLib,
                ing.typeProduit,
                tp.idligne,
                ing.compte_stock,
                ing.compte_sortie_stock,
                f.nom as idFournisseurLib
         FROM as_ingredients ing
                  LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
                  LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                            ON catIng.id = ing.CATEGORIEINGREDIENT
                  LEFT JOIN POSTE p ON p.id = ing.REFPOST
                  LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
                  LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
                  LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
                  LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id
                  LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.IDINGREDIENT=ing.id
         WHERE aim.IDINGREDIENT IS NOT NULL AND aim.identite='ENT000004'
     ) SQ;