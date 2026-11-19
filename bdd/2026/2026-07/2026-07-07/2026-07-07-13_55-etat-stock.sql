create or replace view V_ETATSTOCK_ING_VENTE as
SELECT
    ai.id AS ID,
    ai.LIBELLEVENTE AS idproduitlib,
    m.id as IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.RESTE AS NUMBER(30,2)) AS physique,
    nvl(CAST(ste.sortie AS NUMBER(30,2)),0) AS engage,
    nvl((CAST(ve.RESTE AS NUMBER(30,2))- nvl(CAST(ste.sortie AS NUMBER(30,2)),0)),0) AS afacturer,
    CAST(nvl(ve.ENTREE*ve.pu,0) AS NUMBER(30,2)) AS MONTANTENTREE,
    CAST(nvl(ve.sortie*ve.pu,0) AS NUMBER(30,2)) AS MONTANTSORTIE,
    CAST(nvl((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu),0) AS NUMBER(30,2)) AS MONTANTRESTE,
    ai.UNITE,
    u.VAL AS idunitelib,
    case
        when ve.reste!=0 then CAST(nvl((((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu))/nvl(ve.reste,1)),0) AS NUMBER(30,2))
        else cast(ai.pu as number(30,2))
        end as pu
FROM (
         SELECT
             IDPRODUIT,
             sum(mf.ENTREE) as ENTREE,
             sum (mf.SORTIE) SORTIE,
             '' as IDVENTEDETAIL,
             '' as IDTRANSFERTDETAIL,
             avg (mf.PU) as PU,
             '' as MVTSRC,
             '' as DATY,
             (sum(mf.ENTREE)-sum (mf.SORTIE)) as RESTE,
             0 as QUANTITE,
             m.IDMAGASIN IDMAGASIN
         FROM MVTSTOCKFILLE mf
                  left join mvtStock m on m.id=mf.IDMVTSTOCK
         where m.ETAT>=11
         group by mf.IDPRODUIT,m.IDMAGASIN
     ) ve
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
         LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
         LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
         LEFT JOIN STOCK_ENGAGE_FILLE_GP_MAG ste on ste.IDPRODUIT=ve.IDPRODUIT and ste.IDMAGASIN=ve.IDMAGASIN
where CATEGORIEINGREDIENT='CAT008';