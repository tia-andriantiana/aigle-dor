CREATE OR REPLACE VIEW MVTCAISSECPLORIGINE AS
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
       lp.ID2 as idorigine,
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
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS,
       cr.id as idecriture
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id
         LEFT JOIN COMPTA_ECRITURE cr on cr.IDOBJET=m.id
         JOIN LIAISONPAIEMENT lp ON lp.ID1 = m.ID
;

create or replace view MVTCAISSECPLORIGINE_CREER AS
       select m.* from MVTCAISSECPLORIGINE m where m.etat = 1;

create or replace view MVTCAISSECPLORIGINE_A AS
select m.* from MVTCAISSECPLORIGINE m where m.etat = 8;

create or replace view MVTCAISSECPLORIGINE_VALIDER AS
select m.* from MVTCAISSECPLORIGINE m where m.etat = 11;

create or replace view MVTCAISSECPLORIGINE_ANNULE AS
select m.* from MVTCAISSECPLORIGINE m where m.etat = 0;

INSERT INTO MENUDYNAMIQUE (ID,LIBELLE,ICONE,HREF,RANG,NIVEAU,ID_PERE)
VALUES ('MENUDYNXX00172','Liste des mouvement de caisse origine','list_alt','module.jsp?but=caisse/mvt/mvtCaisse-origine-liste.jsp',4,3,'MENUDYN0017');
