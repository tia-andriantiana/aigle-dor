CREATE OR REPLACE VIEW "MOUVEMENTCAISSECPL" ("ID", "DESIGNATION", "IDCAISSE", "IDCAISSELIB", "IDVENTEDETAIL", "IDVIREMENT", "DEBIT", "CREDIT", "SOLDECREDIT", "SOLDEDEBIT", "DATY", "ETAT", "ETATLIB", "IDVENTE", "IDORIGINE", "IDTIERS", "TIERS", "IDPREVISION", "IDOP", "TAUX", "COMPTE", "IDDEVISE", "IDTRAITE", "IDMODEPAIEMENTLIB", "IDMVTCAISSEMERE", "REFERENCE", "DATYCOMPTABILISATION", "UPDATED_AT", "HEURE", "IDREPORT","IDPOINT","IDPOINTLIB", "MOTSCLESSS") AS
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
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREEE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
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
       point.ID AS IDPOINT,
       point.VAL AS IDPOINTLIB,
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id
        LEFT JOIN POINT point ON point.ID = c.IDPOINT
;