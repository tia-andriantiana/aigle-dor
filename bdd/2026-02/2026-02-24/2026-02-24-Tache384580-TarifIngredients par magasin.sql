ALTER TABLE TARIF_INGREDIENTS ADD IDMAGASIN VARCHAR2(100) NULL;
INSERT INTO TARIF_INGREDIENTS (ID, IDTYPECLIENT, IDINGREDIENT, DATY, PRIXUNITAIRE, UNITE, IDMAGASIN) VALUES ('TIM000022', 'TYPE002', 'ING000T0125', DATE '2025-11-07', 250.00, 'UNT00010', 'MAGAPPRO1');
INSERT INTO TARIF_INGREDIENTS (ID, IDTYPECLIENT, IDINGREDIENT, DATY, PRIXUNITAIRE, UNITE, IDMAGASIN) VALUES ('TIM000021', 'TYPE001', 'ING000T0125', DATE '2025-11-07', 500.00, 'UNT00010', 'MAGAPPRO1');

create or replace view TARIF_INGREDIENTS_MAX as
select IDINGREDIENT, UNITE, IDTYPECLIENT, PRIXUNITAIRE, max(DATY) as daty, IDMAGASIN
from TARIF_INGREDIENTS
group by IDINGREDIENT, UNITE, IDTYPECLIENT, PRIXUNITAIRE, IDMAGASIN;

create or replace view AS_INGREDIENT_VENTE_LIB as
select ing."ID",
       concat(concat(ing.LIBELLE, ' '), ing.PARFUMS) as LIBELLE,
       ing."SEUIL",
       ing."UNITE",
       ing."QUANTITEPARPACK",
       ing."PU",
       ing."ACTIF",
       ing."PHOTO",
       ing."CALORIE",
       ing."DURRE",
       ing."COMPOSE",
       ing."CATEGORIEINGREDIENT",
       ing."IDFOURNISSEUR",
       ing."DATY",
       ing."QTELIMITE",
       ing."PV",
       ing."LIBELLEVENTE",
       ing."SEUILMIN",
       ing."SEUILMAX",
       ing."PUACHATUSD",
       ing."PUACHATEURO",
       ing."PUACHATAUTREDEVISE",
       ing."PUVENTEUSD",
       ing."PUVENTEEURO",
       ing."PUVENTEAUTREDEVISE",
       ing."ISVENTE",
       ing."ISACHAT",
       ing."COMPTE_VENTE",
       ing."COMPTE_ACHAT",
       ing."LIBELLEEXTACTE",
       ing."TVA",
       ing."FILEPATH",
       ing."RESTE",
       ing."TYPESTOCK",
       ing."REFPOST",
       ing."REFQUALIFICATION",
       ing."IDCHAMBRE",
       ing."ISPERISHABLE",
       ing."PV2",
       ing."IDMAGASIN",
       nvl(ting.PRIXUNITAIRE,ing.PV) AS PRIXUNITAIRE,
       tc.ID as IDTYPECLIENT,
       tc.VAL as idtypeclientlib,
       nvl(un.id,un2.id) as idunite,
       nvl(un.VAL,un2.val) as idunitelib,
       eq.POIDS,
       eq.QTE,
       ting.IDMAGASIN as TARIFMAGASIN
from AS_INGREDIENTS ing
         cross join TYPECLIENT tc
         left join TARIF_INGREDIENTS_MAX ting on ing.ID = TING.IDINGREDIENT AND ting.IDTYPECLIENT=tc.id
         left join AS_UNITE un on un.ID = TING.UNITE
         left join AS_UNITE un2 on un2.ID = ing.UNITE
         left join EQUIVALENCE eq on eq.IDPRODUIT = ting.IDINGREDIENT and eq.IDUNITE = ting.UNITE
WHERE ing.CATEGORIEINGREDIENT = 'CAT008';
