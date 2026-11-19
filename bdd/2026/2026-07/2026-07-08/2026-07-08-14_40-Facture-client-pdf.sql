create or replace view VENTE_DETAILS_POIDS_ING as
SELECT v.ID,
       v.IDVENTE,
       v.IDPRODUIT,
       v.IDORIGINE,
       CAST(v.QTE AS NUMBER(38, 2)) AS QTE,
       v.PU,
       v.REMISE,
       v.TVA,
       v.PUACHAT,
       v.PUVENTE,
       v.IDDEVISE,
       v.TAUXDECHANGE,
       v.DESIGNATION,
       v.COMPTE,
       v.PUREVIENT,
       v.IDBCFILLE,
       v.UNITE,
       v.UNITELIB,
       v.PUNET,
       v.MONTANTHT,
       cast(v.MONTANTTTC as number(30,2)) as MONTANTTTC,
       cast(v.MONTANTTVA as number(30,2)) as montanttva,
       v.MONTANTREMISE,
       v.MONTANT,
       v.poids,
       vc.RESTE                     AS RESTE,
       v.frais                      AS FRAIS,
       v.IDPRODUITLIB,
       v.DATY,
       v.DATYPREVU                  AS DATYPREVU,
       v.IDDEVISE                   AS IDDEVISELIB,
       v.IDCATEGORIELIB,
       v.CATEGORIEPRODUITLIB,
       montantttc                   AS PUTOTAL,
       v.idclientlib,
       v.RISTOURNE                  AS RISTOURNE,
       v.idprevision,
       v.IDRESERVATION,
       v.fraislivraison,
       v.calorie,
       (v.pu/nvl(eq.QUANTITE,1)) as puingredient,
       nvl(eq.QUANTITE,1) as contenue,
       ing.unite2,
       MONTANT-MONTANTREMISE as montantremiser
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=v.IDPRODUIT
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = v.IDPRODUIT;





alter table AS_INGREDIENTS add unite2 varchar(50);