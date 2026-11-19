create or replace view RELEVECLIENT as
SELECT SQ."ID",SQ."JOURNAL",SQ."REFERENCE",SQ."DATY",SQ."LIBELLE",SQ."LETTRE",SQ."DEBIT",SQ."CREDIT",SQ."IDCLIENT",SQ."CLIENTLIB",SQ."COMPTE",SQ."UPDATED_AT",SQ."SOLDE",SQ."ANNEE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(JOURNAL),'') || ' | ' || NVL(TO_CHAR(REFERENCE),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(LIBELLE),'') || ' | ' || NVL(TO_CHAR(LETTRE),'') || ' | ' || NVL(TO_CHAR(DEBIT),'') || ' | ' || NVL(TO_CHAR(CREDIT),'') || ' | ' || NVL(TO_CHAR(IDCLIENT),'') || ' | ' || NVL(TO_CHAR(CLIENTLIB),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(UPDATED_AT),'') || ' | ' || NVL(TO_CHAR(SOLDE),'') || ' | ' || NVL(TO_CHAR(ANNEE),'')) AS MOTSCLESSS
FROM (
         select relever.ID,
                relever.JOURNAL,
                relever.REFERENCE,
                relever.DATY,
                relever.LIBELLE,
                relever.LETTRE,
                relever.DEBIT,
                relever.CREDIT,
                relever.IDCLIENT,
                t.NOM as clientlib,
                t.COMPTE,
                relever.updated_at,relever.solde,
                EXTRACT(YEAR FROM relever.DATY) AS annee,
                ROW_NUMBER() OVER (PARTITION BY relever.ID, relever.JOURNAL, relever.REFERENCE, relever.DATY
                                   ORDER BY CASE WHEN relever.LETTRE IS NOT NULL AND relever.LETTRE != ' ' THEN 0 ELSE 1 END) as rn
         from (select AVOIRFCLIB_CPL_VISEE.id,
                      ' '                      as journal,
                      AVOIRFCLIB_CPL_VISEE.id                       as reference,
                      AVOIRFCLIB_CPL_VISEE.daty,
                      'NOTE DE CREDIT :' || AVOIRFCLIB_CPL_VISEE.id as libelle,
                      ' '                      as lettre,
                      0                        as debit	,
                      MONTANTTTCAR             as credit,
                      IDCLIENT,
                      AVOIRFCLIB_CPL_VISEE.DATY as updated_at,
                      MONTANTTTCAR*-1 as solde
               from AVOIRFCLIB_CPL_VISEE
                        JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = AVOIRFCLIB_CPL_VISEE.ID
                        join COMPTA_SOUS_ECRITURE sous on sous.IDMERE = ecr.ID
                        left join compta_lettrage cl on cl.id = sous.LETTRAGE
                        left join compta_journal cj on cj.id = sous.JOURNAL
               UNION ALL
               select MOUVEMENTCAISSE_DETAIL_UNIQUE.id,
                      cj.DESCE           as journal,
                      NUMEROFACTURE as reference,
                      MOUVEMENTCAISSE_DETAIL_UNIQUE.daty,
                      case when REFERENCES_PAIEMENT is null then ' ' else REFERENCES_PAIEMENT end,
                      cl.LETTRE           as lettre,
                      MONTANTTTCAR  as debit,
                      0             as credit,
                      IDCLIENT,
                      UPDATED_AT as updated_at,
                      MONTANTTTCAR as solde
               from MOUVEMENTCAISSE_DETAIL_UNIQUE
                        JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = MOUVEMENTCAISSE_DETAIL_UNIQUE.ID
                        join COMPTA_SOUS_ECRITURE sous on sous.IDMERE = ecr.ID
                        left join compta_lettrage cl on cl.id = sous.LETTRAGE
                        left join compta_journal cj on cj.id = sous.JOURNAL
               where MOUVEMENTCAISSE_DETAIL_UNIQUE.ETAT >= 7
               UNION ALL
               select mc.id,
                      cj.desce        as journal,
                      mc.id      as reference,
                      mc.datycomptabilisation,
                      mc.DESIGNATION,
                      cl.lettre        as lettre,
                      0          as debit,
                      mc.CREDIT,
                      mc.IDTIERS as idclient,
                      mc.UPDATED_AT,
                      mc.CREDIT*-1 as solde
               from MOUVEMENTCAISSECPL mc
                        JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = mc.ID
                        join COMPTA_SOUS_ECRITURE sous on sous.IDMERE = ecr.ID
                        left join compta_lettrage cl on cl.id = sous.LETTRAGE
                        left join compta_journal cj on cj.id = sous.JOURNAL
               where mc.ETAT > 8
              ) relever
                  left join tiers t on t.id = relever.IDCLIENT
         order by IDCLIENT, DATY, updated_at
     ) SQ
WHERE rn = 1;