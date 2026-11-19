

create or replace view HS_PAR_OFFILLE as
SELECT
    idMere,
    'CATING000001' AS CATEGORIE,
    CAST(SUM(montant) AS NUMBER(30,2)) AS montantPersonnel
FROM (

         SELECT
             fille.id AS idMere,
             SUM(hs.MONTANT) AS montant
         FROM HS_FABRICATION_DETAIL_PAIE hs
                  LEFT JOIN FABRICATION fab ON fab.id = hs.IDFABRICATION
                  LEFT JOIN OFFILLE fille ON fille.id = fab.IDOFFILLE
         GROUP BY fille.id

         UNION ALL

         SELECT
             fille.id AS idMere,
             SUM(p.GAIN) AS montant
         FROM PAIE_PERSONNEL_ELEMENTPAIE p
                  LEFT JOIN FABRICATION fab ON fab.id = p.ID_OBJET
                  LEFT JOIN OFFILLE fille ON fille.id = fab.IDOFFILLE
         WHERE p.CODE_RUBRIQUE IN (
                                   'PR0000221', -- MN
                                   'PR0000222', -- JF
                                   'PR0000223', -- HD
                                   'PR0000228'  -- IF
             )
           AND p.ETAT = 11
         GROUP BY fille.id

     ) t
GROUP BY idMere;



create or replace view RAPPROCHEMENT_COMPLETOFFILLE as
select
    st.IDOBJET AS idmere,
    st.CATEGORIEINGREDIENT,
    st.idcategorieingredient,
    cast(sum(montantsortie) as number(30,2)) as montantSortie,
    cast(sum(montth) as number(30,2)) as montth,
    cast(sum(montth)-sum(montantsortie) as number(30,2)) as ecart
from STOCKETDEPENSEOFFILLETHECAT st
group by st.IDOBJET ,st.CATEGORIEINGREDIENT, st.idcategorieingredient

UNION ALL

SELECT
    hs.idMere,
    'Charge personnel' as CATEGORIE,
    hs.CATEGORIE as idCategorieIngredient,
    hs.montantPersonnel AS montantSortie,
    0 AS montth,
    -hs.montantPersonnel AS ecart
FROM HS_PAR_OFFILLE hs;

