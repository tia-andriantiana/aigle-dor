efa executer prod 
-- alter table VENTE_DETAILS
--     add idRemise VARCHAR2(50);


-- create or replace view venteDetMereCatIngrCatClient as
--     select vd.*,c.id as idClient,tc.id as catClient,ing.CATEGORIEINGREDIENT as categorieIngredients,v.IDMAGASIN as idpoint from VENTE_DETAILS vd
--     left join vente v on v.id=vd.IDVENTE
--     left join client c on v.IDCLIENT=c.ID
--     left join TYPECLIENT tc on tc.id=c.IDTYPECLIENT
--     left join as_ingredients ing on ing.id=vd.IDPRODUIT;

-- create or replace view remiseFilleMere as
--     select rf.*,r.nom,r.daty,r.dateDebut,r.dateFin,r.etat from remiseFille rf left join remise r on r.id=rf.idremise;

-- create or replace view remiseFilleMereVise as
--     select rf.*,r.nom,r.daty,r.dateDebut,r.dateFin,r.etat from remiseFille rf left join remise r on r.id=rf.idremise where r.etat>=11;

-- create view MVTSTOCKFILLEGRPVariation as
-- SELECT
--     f.IDMVTSTOCK,
--     SUM(f.ENTREE * f.PU) AS entree,
--     SUM(f.SORTIE * f.PU) AS SORTIE,
--      null as compte_stock,
--     ing.compte_sortie_stock
-- FROM MVTSTOCKFILLE f
--          LEFT JOIN AS_INGREDIENTS ing ON ing.ID = f.IDPRODUIT
-- GROUP BY f.IDMVTSTOCK, ing.compte_sortie_stock;

-- create or replace view mvtStockFilleCptStock as
--     select msf.*,ing.COMPTE_STOCK,ing.COMPTE_SORTIE_STOCK from MVTSTOCKFILLE msf left join AS_INGREDIENTS ing on ing.id=msf.IDPRODUIT;




-- create table PARAMCOMPTA
-- (
--     ID        VARCHAR2(100) not null
--         constraint PARAMCOMPTA_PK
--             primary key,
--     VAL       VARCHAR2(100),
--     DESCE     VARCHAR2(100)
-- );
-- insert into PARAMCOMPTA values('PARAM001','Perte de stock','671400');
-- insert into PARAMCOMPTA values('PARAM002','Gain de stock','771400');

-- insert into COMPTA_COMPTE values('COMCSOCSTOCK01','671400','perte sur stock',1,6,null,'COMP000067',null);
-- insert into COMPTA_COMPTE values('COMCSOCSTOCK02','771400','gain sur stock',1,6,null,'COMP000039',null);

-- update AS_INGREDIENTS set COMPTE_SORTIE_STOCK='603110' where 1<2;