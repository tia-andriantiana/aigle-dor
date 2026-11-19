
CREATE VIEW COMPTASOUSECRITUREDND as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4456%'
    /