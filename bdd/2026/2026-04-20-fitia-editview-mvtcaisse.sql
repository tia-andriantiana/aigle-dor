create or replace view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       case when m.credit > 0 then cast(nvl(m.CREDIT, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldecredit,
       case when m.debit > 0 then cast(nvl(m.debit, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldedebit,
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
               THEN 'À COMPTABILISER'
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
       m.UPDATED_AT
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
        left join modepaiement mp on m.idmodepaiement = mp.id

/

