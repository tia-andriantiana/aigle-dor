
create view COMMANDEMONTANT as
SELECT v.ID,
       cast(SUM(poidstotal) as number(30, 2))                            AS poidstotal,
       cast(SUM(PU) as number(30, 2))                               AS montant,
       cast(SUM(MONTANTREMISE) as number(30, 2))                         as montantremise,
       cast(SUM(montantristourne) as number(30, 2))                      as montantristourne,
       cast(SUM(vd.fraistransport) as number(30, 2))                     as fraistransport,
       cast(SUM(montanttotal) as number(30, 2))                          AS montanttotal,
       cast(SUM((NVL(vd.QUANTITE, 0) * NVL(vd.PU, 0))) as number(30, 2)) AS montanttotalachat,
       cast(SUM(montanttva) as number(30, 2))                            AS montantTva,
       cast(SUM(vd.MONTANTTTC) as number(30, 2))                            as montantTTC,
       NVL(vd.IDDEVISE, 'AR')                                            AS IDDEVISE,
       NVL(avg(1), 1)                                      AS tauxDeChange,
       cast(SUM(MONTANTTTC) as number(30, 2))          as montantTTCAR
FROM COMMANDEFILLE_CPL_LIB vd
         LEFT JOIN COMMANDE v ON v.ID = vd.IDC
GROUP BY v.ID, vd.IDDEVISE;

create or replace view COMMANDECPL as
SELECT cmd."ID",cmd."DATY",cmd."ETAT",cmd."REMARQUE",cmd."DESIGNATION",cmd."MODEPAIEMENT",cmd."IDCLIENT",cmd."REFERENCE",cmd."IDDEVISE",cmd."IDMAGASIN",cmd."DATEBESOIN",cmd."IDPROFORMA",cmd."MODELIVRAISON",cmd."DATELIVRAISON",cmd."LIEULIVRAISON",cmd."FRAISLIVRAISON",
       p.VAL AS idMagasinLib,
       cl.NOM AS idClientLib,
       CASE
           WHEN cmd.etat = 1 THEN 'Créé'
           WHEN cmd.etat = 11 THEN 'Validé'
           WHEN cmd.etat = 0 THEN 'Annulé'
           ELSE 'Inconnu'
           END AS etatLib,
       CASE
           WHEN cmd.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN cmd.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib,
       mp.VAL as modePaiementLib,
       cmm.MONTANTTTC
FROM COMMANDE cmd
         LEFT JOIN MAGASIN2 p
                   ON p.id = cmd.IDMAGASIN
         LEFT JOIN CLIENT cl
                   ON cl.id = cmd.IDCLIENT
         left join modepaiement mp
                   on mp.id = cmd.MODEPAIEMENT
         left join COMMANDEMONTANT cmm on cmm.id=cmd.id;

