INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COC8279', '401001', 'Divers Fournisseur', '1', '4', null, 'COMP000035', null);

create view COMPTA_SOUSECRITURE_LETTRE2 as
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
    lib."HORSEXERCICE", lib."OD", lib."ORIGINE", lib."TIERS",
    lib."LIBELLEPIECE", lib."COMPTE_AUX", lib."RAISONSOCIAL",
    lib."FOLIO", lib."LETTRAGE", lib."ANALYTIQUE",
    0 AS MONTANTRESTE,
    ecr.IDOBJET as idVente
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
    ecr.IDOBJET as idVente
FROM COMPTA_SOUSECRITURE_LIB lib
         JOIN COMPTA_ECRITURE ecr ON lib.IDMERE = ecr.ID
         JOIN FACTUREFOURNISSEURCPL_TOUS v ON v.ID = ecr.IDOBJET
    /
