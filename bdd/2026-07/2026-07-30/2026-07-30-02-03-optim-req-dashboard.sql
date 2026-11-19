create or replace view VENTE_CPL_SANSAVOIR as
SELECT
    v.id,
    v.designation,
    v.idmagasin,
    m.val AS idmagasinlib,
    v.daty,
    v.remarque,
    v.etat,
    CASE v.etat
        WHEN 1  THEN 'CREE'
        WHEN 11 THEN 'VISE'
        WHEN 0  THEN 'ANNULE'
        ELSE 'INCONNU'
        END AS etatlib,
    vm.montanttotal,
    vm.iddevise,
    v.idclient,
    c.nom AS idclientlib,
    CAST(vm.montanttva AS NUMBER(30, 2)) AS montanttva,
    CAST(vm.montantttc AS NUMBER(30, 2)) AS montantttc,
    CAST(vm.montantttcar AS NUMBER(30, 2)) AS montantttcar,
    CAST(NVL(lp.montant, 0) AS NUMBER(30, 2)) AS montantpaye,
    CAST(NVL(vm.montantttc, 0) - NVL(lp.montant, 0) AS NUMBER(30, 2)) AS montantreste,
    vm.tauxdechange,
    vm.montantrevient,
    CAST(NVL(vm.montantttcar, 0) - NVL(vm.montantrevient, 0) AS NUMBER(20, 2)) AS margebrute,
    v.idreservation,
    NVL(v.datyprevu, v.daty) AS datyprevu,
    rf.reference AS referencefacture,
    vm.montantremise,
    NVL(vm.montanttotal, 0) + NVL(vm.montantremise, 0) AS montant,
    EXTRACT(MONTH FROM v.daty) AS mois,
    EXTRACT(YEAR FROM v.daty) AS annee,
    vp.poids,
    v.modepaiement,
    mp.val AS modepaiementlib,
    NVL(v.fraislivraison, 0) * NVL(vp.poids, 0) AS fraislivraison,
    v.modelivraison,
    CASE v.modelivraison
        WHEN 1 THEN '<span style="color: green;">LIVRAISON</span>'
        WHEN 2 THEN '<span style="color: green;">RECUPERATION</span>'
        ELSE NULL
        END AS modelivraisonlib,
    vr.reste,
    pv.id AS idprovince,
    pv.val AS provincelib,
    v.numerofacture AS numfact
FROM vente v
         JOIN ventemontant vm ON vm.id = v.id
         LEFT JOIN client c ON c.id = v.idclient
         LEFT JOIN province pv ON pv.id = c.idprovince
         LEFT JOIN magasinpoint m ON m.id = v.idmagasin
         LEFT JOIN liaisonpaiementtotal lp ON lp.id2 = v.id
         LEFT JOIN referencefacture rf ON rf.idfacture = v.id
         LEFT JOIN vente_poids vp ON vp.idvente = v.id
         LEFT JOIN modepaiement mp ON mp.id = v.modepaiement
         LEFT JOIN vente_reste vr ON vr.idvente = v.id;

-- -------------------------------------------------------------
create or replace view AVOIRFCLIB_CPL as
SELECT AL.ID,
       AL.DESIGNATION,
       AL.IDMAGASIN,
       AL.IDMAGASINLIB,
       AL.DATY,
       AL.REMARQUE,
       AL.ETAT,
       AL.IDORIGINE,
       AL.IDCLIENT,
       AL.COMPTE,
       AL.IDVENTE,
       AL.IDVENTELIB,
       AL.IDMOTIF,
       AL.IDMOTIFLIB,
       AL.IDCATEGORIE,
       AL.IDCATEGORIELIB,
       AL.IDDEVISE,
       AL.TAUXDECHANGE,
       AL.MONTANTHT,
       AL.MONTANTTVA,
       AL.MONTANTTTC,
       AL.MONTANTHTAR,
       AL.MONTANTTVAAR,
       AL.MONTANTTTCAR,
       nvl(M.montant, 0)                                        AS MONTANTPAYE,
       NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)              AS MONTANTPAYEAR,

       NVL(vc.MONTANTRESTE, 0)                                  AS MONTANT_RESTE_FACTURE,

       NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0)         AS MONTANT_AVOIRS_ANTERIEURS,
       -- Cas 1 : facture deja soldee -> chaque avoir = credit direct (exedent)
       CASE
           WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN 0
           ELSE NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0)
           END                                                  AS RESTE_CALCULE,
       -- Excedent a rembourser ou a reporter
       CASE
           WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
           WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
               THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                        NVL(AL.MONTANTTTCAR, 0))
           ELSE 0
           END                                                  AS EXCEDENT_AR,
       (CASE
            WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
            WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
            ELSE 0
           END) - NVL(M.montant, 0)                             AS resteapayer,
       (CASE
            WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
            WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
            ELSE 0
           END) - (NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)) AS resteapayerar,
       AL.clientlib,
       AL.Typeavoir,
       vc.NUMFACT
FROM AVOIRFCLIB AL
         LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
                   ON AL.ID = M.IDORIGINE
         LEFT JOIN VENTE_CPL_SANSAVOIR vc
                   ON vc.id = AL.idvente
         LEFT JOIN (SELECT idvente,
                           id AS idcourant,
                           montant_avoirs_precedents
                    FROM (SELECT idvente,
                                 id,
                                 SUM(
                                         CASE
                                             WHEN etat <> 0 THEN montantttcar
                                             ELSE 0
                                             END
                                 ) OVER (
                                             PARTITION BY idvente
                                             ORDER BY daty, id
                                             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                                             ) AS montant_avoirs_precedents
                          FROM avoirfclib)
                    WHERE montant_avoirs_precedents IS NOT NULL) SUM_PRECEDENTS
                   ON SUM_PRECEDENTS.idvente = AL.idvente
                       AND SUM_PRECEDENTS.idcourant = AL.id;