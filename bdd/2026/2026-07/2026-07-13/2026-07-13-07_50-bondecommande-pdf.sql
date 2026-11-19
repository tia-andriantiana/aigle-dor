
create or replace view BONDECOMMANDE_CLIENT_CPL as
SELECT
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    FRAISLIVRAISON
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id;

create or replace view BC_CLIENT_FILLE_CPL_LIB_PDF as
SELECT bcf.ID,
       bcf.PRODUIT,
       bcf.IDBC,
       bcf.QUANTITE,
       bcf.PU,
       bcf.MONTANT,
       bcf.TVA,
       bcf.REMISE,
       bcf.IDDEVISE,
       bcf.UNITE,
       i.LIBELLEVENTE                                                                                                                                      AS PRODUITlib,
       i.compte_vente                                                                                                                                 AS compte,
       NVL(bcf.quantite, 0)    - NVL(vdbc.qte, 0)    AS qtereste,   -- nanova qte reste : atao moins qte vendu  avy aminy vente_details_qte_grp
       au.val                                                                                                                                         AS UNITELIB,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2))                                                                                   AS MONTANTTOTAL,
       cast(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) as number(30, 2))                                                          as montantdelaremise,
       cast((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
            (bcf.ristourne / 100) as number(30, 2))                                                                                                   as montantristourne,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) as number(30, 2))                                                                    as montantremise,
       CAST(
               (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) -
                 (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) +
                  ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) -
                    ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.ristourne / 100))) -
                 nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) *
                (nvl(bcf.TVA, 0) / 100))
           AS NUMBER(30, 2)
       )                                                                                                                                              AS MONTANTTVA,
       cast((cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) -
             (cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) *
              nvl(bcf.ristourne, 0) /
              100) - nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) + (nvl(bcf.TVA, 0) / 100) *
                                                                             (cast((bcf.quantite * bcf.PU) -
                                                                                   ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                   100 as NUMBER(30, 2)) -
                                                                              (cast((bcf.quantite * bcf.PU) -
                                                                                    ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                    100 as NUMBER(30, 2)) *
                                                                               nvl(bcf.ristourne, 0) / 100) -
                                                                              nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) as number(30, 2)) AS MONTANTTTC,
       bcf.ristourne,
       nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)                                                                                           as fraistransport,
       CAST(NVL(i.CALORIE * bcf.QUANTITE,0) AS NUMBER(30,2)) AS poidstotal,
       (bcf.pu/nvl(eq.QUANTITE,1)) as puingredient,
       nvl(eq.QUANTITE,1) as contenue,
       i.UNITE2
FROM bondecommande_client_fille bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite
         LEFT JOIN BONDECOMMANDE_CLIENT bc on bc.id = bcf.IDBC
         LEFT JOIN EQUIVALENCEVENTE eq on eq.IDPRODUIT1=i.ID;
