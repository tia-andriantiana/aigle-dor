create or replace view COMPTA_SOUSECRITURE_LETTRE2 as
SELECT SQ."ID",SQ."NUMERO",SQ."COMPTE",SQ."JOURNAL",SQ."IDJOURNAL",SQ."ECRITURE",SQ."DATY",SQ."CREDIT",SQ."DEBIT",SQ."DATECOMPTABLE",SQ."EXERCICE",SQ."REMARQUE",SQ."ETAT",SQ."IDMERE",SQ."HORSEXERCICE",SQ."OD",SQ."ORIGINE",SQ."TIERS",SQ."LIBELLEPIECE",SQ."COMPTE_AUX",SQ."RAISONSOCIAL",SQ."FOLIO",SQ."LETTRAGE",SQ."ANALYTIQUE",SQ."MONTANTRESTE",SQ."IDVENTE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(NUMERO),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(JOURNAL),'') || ' | ' || NVL(TO_CHAR(IDJOURNAL),'') || ' | ' || NVL(TO_CHAR(ECRITURE),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(CREDIT),'') || ' | ' || NVL(TO_CHAR(DEBIT),'') || ' | ' || NVL(TO_CHAR(DATECOMPTABLE,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(EXERCICE),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(IDMERE),'') || ' | ' || NVL(TO_CHAR(HORSEXERCICE),'') || ' | ' || NVL(TO_CHAR(OD),'') || ' | ' || NVL(TO_CHAR(ORIGINE),'') || ' | ' || NVL(TO_CHAR(TIERS),'') || ' | ' || NVL(TO_CHAR(LIBELLEPIECE),'') || ' | ' || NVL(TO_CHAR(COMPTE_AUX),'') || ' | ' || NVL(TO_CHAR(RAISONSOCIAL),'') || ' | ' || NVL(TO_CHAR(FOLIO),'') || ' | ' || NVL(TO_CHAR(LETTRAGE),'') || ' | ' || NVL(TO_CHAR(ANALYTIQUE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'')) AS MOTSCLESSS
FROM (
         SELECT
             lib."ID", lib."NUMERO", lib."COMPTE", lib."JOURNAL", lib."IDJOURNAL",
             lib."ECRITURE", lib."DATY", lib."CREDIT", lib."DEBIT", lib."DATECOMPTABLE",
             lib."EXERCICE", lib."REMARQUE", lib."ETAT", lib."IDMERE",
             lib."HORSEXERCICE", lib."OD", lib."ORIGINE", lib."TIERS",
             lib."LIBELLEPIECE", lib."COMPTE_AUX", lib."RAISONSOCIAL",
             lib."FOLIO", lib."LETTRAGE", lib."ANALYTIQUE",
             v.MONTANTRESTE,
             v.id as idVente
         FROM COMPTA_SOUSECRITURE_LIB lib
                  JOIN COMPTA_ECRITURE ecr ON lib.IDMERE = ecr.ID
                  JOIN VENTE_CPL v ON v.ID = ecr.IDOBJET

         UNION

-- CAS 2 : MOUVEMENTCAISSE → VENTE
         SELECT
             lib."ID", lib."NUMERO", lib."COMPTE", lib."JOURNAL", lib."IDJOURNAL",
             lib."ECRITURE", lib."DATY", lib."CREDIT", lib."DEBIT", lib."DATECOMPTABLE",
             lib."EXERCICE", lib."REMARQUE", lib."ETAT", lib."IDMERE",
             lib."HORSEXERCICE", lib."OD", mvt."IDORIGINE", lib."TIERS",
             lib."LIBELLEPIECE", lib."COMPTE_AUX", lib."RAISONSOCIAL",
             lib."FOLIO", lib."LETTRAGE", lib."ANALYTIQUE",
             0 AS MONTANTRESTE,
             mvt."IDORIGINE" as idVente
         FROM COMPTA_SOUSECRITURE_LIB lib
                  JOIN COMPTA_ECRITURE ecr ON lib.IDMERE = ecr.ID
                  JOIN MOUVEMENTCAISSE mvt ON mvt.ID = ecr.IDOBJET
                  JOIN VENTE v ON v.ID = mvt.IDORIGINE

         UNION

-- CAS 3 : FACTURE FOURNISSEUR
         SELECT
             lib."ID", lib."NUMERO", lib."COMPTE", lib."JOURNAL", lib."IDJOURNAL",
             lib."ECRITURE", lib."DATY", lib."CREDIT", lib."DEBIT", lib."DATECOMPTABLE",
             lib."EXERCICE", lib."REMARQUE", lib."ETAT", lib."IDMERE",
             lib."HORSEXERCICE", lib."OD", lib."ORIGINE", lib."TIERS",
             lib."LIBELLEPIECE", lib."COMPTE_AUX", lib."RAISONSOCIAL",
             lib."FOLIO", lib."LETTRAGE", lib."ANALYTIQUE",
             v.MONTANTRESTE,
             v.ID as idVente
         FROM COMPTA_SOUSECRITURE_LIB lib
                  JOIN COMPTA_ECRITURE ecr ON lib.IDMERE = ecr.ID
                  JOIN FACTUREFOURNISSEURCPL_TOUS v ON v.ID = ecr.IDOBJET
     ) SQ
order by IDVENTE desc;
