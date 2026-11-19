CREATE OR REPLACE FORCE VIEW "TRANSFERTSTOCKCPL" ("ID", "DESIGNATION", "IDMAGASINDEPART", "IDMAGASINDEPARTLIB", "IDMAGASINARRIVE", "IDMAGASINARRIVELIB", "DATY", "ETAT", "IDOF", "ETATLIB", "MOTSCLESSS") AS
SELECT t.ID,
       t.DESIGNATION,
       t.IDMAGASINDEPART,
       m.VAL AS IDMAGASINDEPARTLIB,
       t.IDMAGASINARRIVE,
       m2.VAL AS IDMAGASINARRIVELIB,
       t.DATY,
       t.ETAT,
       t.IDOF,
       CASE
           WHEN t.ETAT = 0  THEN 'ANNULÉE'
           WHEN t.ETAT = 1  THEN 'CRÉÉE'
           WHEN t.ETAT = 11 THEN 'VISÉE'
           ELSE NULL
           END AS ETATLIB,
       (
           NVL(CAST(t.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.DESIGNATION AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINDEPART AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(t.IDMAGASINARRIVE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(m2.VAL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(t.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(TO_CHAR(t.ETAT), '') || ' | ' ||
           NVL(CAST(t.IDOF AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(
                   CASE
                       WHEN t.ETAT = 0  THEN 'ANNULÉE'
                       WHEN t.ETAT = 1  THEN 'CRÉÉE'
                       WHEN t.ETAT = 11 THEN 'VISÉE'
                       ELSE NULL
                       END,
                   ''
           )
           ) AS MOTSCLESSS
FROM TRANSFERTSTOCK t
         LEFT JOIN MAGASINPOINT m
                   ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2
                   ON m2.ID = t.IDMAGASINARRIVE;


CREATE OR REPLACE FORCE VIEW "COMMANDECPL" ("ID", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "IDCLIENT", "REFERENCE", "IDDEVISE", "IDMAGASIN", "DATEBESOIN", "IDPROFORMA", "MODELIVRAISON", "DATELIVRAISON", "LIEULIVRAISON", "FRAISLIVRAISON", "IDMAGASINLIB", "IDCLIENTLIB", "ETATLIB", "MODELIVRAISONLIB", "MODEPAIEMENTLIB", "MONTANTTTC") AS
SELECT cmd."ID",cmd."DATY",cmd."ETAT",cmd."REMARQUE",cmd."DESIGNATION",cmd."MODEPAIEMENT",cmd."IDCLIENT",cmd."REFERENCE",cmd."IDDEVISE",cmd."IDMAGASIN",cmd."DATEBESOIN",cmd."IDPROFORMA",cmd."MODELIVRAISON",cmd."DATELIVRAISON",cmd."LIEULIVRAISON",cmd."FRAISLIVRAISON",
       p.VAL AS idMagasinLib,
       cl.NOM AS idClientLib,
       CASE
           WHEN cmd.etat = 1 THEN 'Créée'
           WHEN cmd.etat = 11 THEN 'Validée'
           WHEN cmd.etat = 0 THEN 'Annulée'
           ELSE 'Inconnu'
           END AS etatLib,
       CASE
           WHEN cmd.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN cmd.modelivraison = 2 THEN '<span style=color: green;>RÉCUPÉRATION</span>'
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

CREATE OR REPLACE FORCE VIEW "MOUVEMENTCAISSECPL" ("ID", "DESIGNATION", "IDCAISSE", "IDCAISSELIB", "IDVENTEDETAIL", "IDVIREMENT", "DEBIT", "CREDIT", "SOLDECREDIT", "SOLDEDEBIT", "DATY", "ETAT", "ETATLIB", "IDVENTE", "IDORIGINE", "IDTIERS", "TIERS", "IDPREVISION", "IDOP", "TAUX", "COMPTE", "IDDEVISE", "IDTRAITE", "IDMODEPAIEMENTLIB", "IDMVTCAISSEMERE", "REFERENCE", "DATYCOMPTABILISATION", "UPDATED_AT", "HEURE", "IDREPORT", "MOTSCLESSS") AS
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       CAST(
               CASE
                   WHEN m.credit > 0 THEN NVL(m.CREDIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldecredit,
       CAST(
               CASE
                   WHEN m.debit > 0 THEN NVL(m.DEBIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULÉE'
           WHEN m.ETAT = 1
               THEN 'CRÉÉE'
           WHEN m.ETAT = 11
               THEN 'VALIDÉE'
           WHEN m.ETAT = 8
               THEN 'A COMPTABILISER'
           END AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite,
       mp.VAL as idModePaiementLib,
       m.idmvtcaissemere,
       m.reference,
       m.datycomptabilisation,
       m.UPDATED_AT, m.heure,
       m.IDREPORT,
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id

;