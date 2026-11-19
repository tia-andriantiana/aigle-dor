CREATE OR REPLACE FORCE VIEW "STOCKETDEPENSEFABTHE" ("IDOBJET", "IDPRODUIT", "DESIGNATION", "ENTREE", "SORTIE", "PU", "MONTANTENTREE", "MONTANTSORTIE", "IDMERE", "ID", "QTETH", "PUTH", "MONTTH", "CATEGORIEINGREDIENT") AS 
  SELECT
    sed.IDOBJET,
    sed.IDPRODUIT,
    ai.libelle AS designation,
    cast(sed.ENTREE as number(30,5)) as entree ,
    cast(sed.SORTIE as number(30,5)) as sortie,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu
                ELSE nvl(sed."PU",0)
                END
        as number(30,2)) AS PU,
    cast(sed.MONTANTENTREE as number(30,5)) as MONTANTENTREE,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu * sed.SORTIE
                ELSE nvl(sed."PU",0) * sed.SORTIE
                END
        as number(30,2)) as MONTANTSORTIE ,
    sed.IDMERE,
    sed.ID,
    CAST(nvl(recFab.QUANTITE, 0) AS NUMBER(30,
                                           10)) AS qteTh,
    CAST(nvl(recFab.QTEAV, sed.pu) AS NUMBER(30,
                                             5)) AS puth,
    CAST(nvl(recFab.QUANTITE, 0)* nvl(recFab.QTEAV, 0) AS NUMBER(30,
                                                                 5)) AS montTh,
    recFab.CATEGORIEINGREDIENT
FROM
    stockEtDepenseFab sed
        FULL OUTER JOIN as_recFabLibGroupe recFab
                        ON
                            sed.IDOBJET = recFab.IDPRODUITS
                                AND sed.IDPRODUIT = recFab.IDINGREDIENTS 
        LEFT JOIN as_ingredients ai ON ai.id = sed.idproduit
 ;