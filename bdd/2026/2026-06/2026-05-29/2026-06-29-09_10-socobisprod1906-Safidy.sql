ALTER TABLE commande ADD modelivraison number(10,2);
ALTER TABLE commande ADD lieulivraison varchar(255);
ALTER TABLE commande ADD datelivraison date;

CREATE OR REPLACE  VIEW COMMANDECPL ("ID", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "IDCLIENT", "REFERENCE", "IDDEVISE", "IDMAGASIN", "DATEBESOIN", "IDPROFORMA", "MODELIVRAISON", "DATELIVRAISON", "LIEULIVRAISON", "FRAISLIVRAISON", "IDMAGASINLIB", "IDCLIENTLIB", "ETATLIB", "MODELIVRAISONLIB", "MODEPAIEMENTLIB", "MONTANTTTC") AS
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
         left join COMMANDEMONTANT cmm on cmm.id=cmd.id
;