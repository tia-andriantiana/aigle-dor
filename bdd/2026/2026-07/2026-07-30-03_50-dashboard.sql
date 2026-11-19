create or replace view VENTE_DETAILS_CAT as
select v."ID", v."IDVENTE", v."IDVENTELIB", v."IDPRODUIT",
       v."IDPRODUITLIB", v."IDORIGINE", v."QTE", v."PU",
       v."MONTANTREMISE", v."MONTANT", v."MONTANT" AS "MONTANTTTC",
       v."IDDEVISE", v."TAUXDECHANGE", v."TVA", v."IDCLIENT",
       v."IDCLIENTLIB", v."DESIGNATION", v."PUREVIENT",
       v."MONTANTREVIENT", v."IDUNITELIB", v."PUTOTAL",
       v."MAGASIN", v."REFERENCE", v."DATY", v."RISTOURNE",
       ing.categorieingredient, 1 AS nb, v.MAGASIN as idMagasinLib
from VENTE_DETAILS_CPL1 v
         LEFT JOIN AS_INGREDIENTS_LIB ing on ing.ID = v.IDPRODUIT;
