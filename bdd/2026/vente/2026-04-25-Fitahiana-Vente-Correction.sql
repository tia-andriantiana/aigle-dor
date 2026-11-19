CREATE OR REPLACE VIEW RELEVECLIENT AS
SELECT
    SQ.ID,
    SQ.JOURNAL,
    SQ.REFERENCE,
    SQ.DATY,
    SQ.LIBELLE,
    SQ.LETTRE,
    SQ.DEBIT,
    SQ.CREDIT,
    SQ.IDCLIENT,
    SQ.CLIENTLIB,
    SQ.COMPTE,
    SQ.UPDATED_AT,
    SQ.SOLDE,
    SQ.ANNEE,

    NVL(TO_CHAR(SQ.ID), '') || ' | ' ||
    NVL(TO_CHAR(SQ.JOURNAL), '') || ' | ' ||
    NVL(TO_CHAR(SQ.REFERENCE), '') || ' | ' ||
    NVL(TO_CHAR(SQ.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
    NVL(TO_CHAR(SQ.LIBELLE), '') || ' | ' ||
    NVL(TO_CHAR(SQ.LETTRE), '') || ' | ' ||
    NVL(TO_CHAR(SQ.DEBIT), '') || ' | ' ||
    NVL(TO_CHAR(SQ.CREDIT), '') || ' | ' ||
    NVL(TO_CHAR(SQ.IDCLIENT), '') || ' | ' ||
    NVL(TO_CHAR(SQ.CLIENTLIB), '') || ' | ' ||
    NVL(TO_CHAR(SQ.COMPTE), '') || ' | ' ||
    NVL(TO_CHAR(SQ.UPDATED_AT, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
    NVL(TO_CHAR(SQ.SOLDE), '') || ' | ' ||
    NVL(TO_CHAR(SQ.ANNEE), '') AS MOTSCLESSS

FROM (
         SELECT
             relever.ID,
             relever.JOURNAL,
             relever.REFERENCE,
             relever.DATY,
             relever.LIBELLE,
             relever.LETTRE,
             relever.DEBIT,
             relever.CREDIT,
             relever.IDCLIENT,
             t.NOM AS CLIENTLIB,
             NVL(relever.COMPTE, t.COMPTE) AS COMPTE,
             relever.UPDATED_AT,
             relever.SOLDE,
             EXTRACT(YEAR FROM relever.DATY) AS ANNEE,

             ROW_NUMBER() OVER (
            PARTITION BY relever.ID, relever.JOURNAL, relever.REFERENCE, relever.DATY
            ORDER BY
                CASE
                    WHEN relever.LETTRE IS NOT NULL AND TRIM(relever.LETTRE) IS NOT NULL THEN 0
                    ELSE 1
                END
        ) AS RN

         FROM (

                  /* NOTE DE CREDIT / AVOIR CLIENT */
                  SELECT
                      av.id AS ID,
                      NVL(cj.DESCE, ' ') AS JOURNAL,
                      av.id AS REFERENCE,
                      av.daty AS DATY,
                      'NOTE DE CREDIT : ' || av.id AS LIBELLE,
                      NVL(cl.LETTRE, ' ') AS LETTRE,
                      0 AS DEBIT,
                      av.MONTANTTTCAR AS CREDIT,
                      av.IDCLIENT AS IDCLIENT,
                      sous.COMPTE AS COMPTE,
                      av.DATY AS UPDATED_AT,
                      av.MONTANTTTCAR * -1 AS SOLDE
                  FROM AVOIRFCLIB_CPL_VISEE av
                           JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = av.ID
                           JOIN COMPTA_SOUS_ECRITURE sous ON sous.IDMERE = ecr.ID
                           LEFT JOIN COMPTA_LETTRAGE cl ON cl.ID = sous.LETTRAGE
                           LEFT JOIN COMPTA_JOURNAL cj ON cj.ID = sous.JOURNAL
                  WHERE sous.COMPTE LIKE '411%'

                  UNION ALL

                  /* FACTURE / VENTE CLIENT */
                  SELECT
                      mcd.id AS ID,
                      NVL(cj.DESCE, ' ') AS JOURNAL,
                      mcd.NUMEROFACTURE AS REFERENCE,
                      mcd.daty AS DATY,
                      NVL(mcd.REFERENCES_PAIEMENT, ' ') AS LIBELLE,
                      NVL(cl.LETTRE, ' ') AS LETTRE,
                      mcd.MONTANTTTCAR AS DEBIT,
                      0 AS CREDIT,
                      mcd.IDCLIENT AS IDCLIENT,
                      sous.COMPTE AS COMPTE,
                      mcd.UPDATED_AT AS UPDATED_AT,
                      mcd.MONTANTTTCAR AS SOLDE
                  FROM MOUVEMENTCAISSE_DETAIL_UNIQUE mcd
                           JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = mcd.ID
                           JOIN COMPTA_SOUS_ECRITURE sous ON sous.IDMERE = ecr.ID
                           LEFT JOIN COMPTA_LETTRAGE cl ON cl.ID = sous.LETTRAGE
                           LEFT JOIN COMPTA_JOURNAL cj ON cj.ID = sous.JOURNAL
                  WHERE mcd.ETAT >= 7
                    AND sous.COMPTE LIKE '411%'

                  UNION ALL

                  /* REGLEMENT CLIENT */
                  SELECT
                      mc.ID AS ID,
                      NVL(cj.DESCE, ' ') AS JOURNAL,
                      mc.ID AS REFERENCE,
                      mc.DATYCOMPTABILISATION AS DATY,
                      mc.DESIGNATION AS LIBELLE,
                      NVL(cl.LETTRE, ' ') AS LETTRE,
                      0 AS DEBIT,
                      mc.CREDIT AS CREDIT,
                      mc.IDTIERS AS IDCLIENT,
                      sous.COMPTE AS COMPTE,
                      mc.UPDATED_AT AS UPDATED_AT,
                      mc.CREDIT * -1 AS SOLDE
                  FROM MOUVEMENTCAISSECPL mc
                           JOIN COMPTA_ECRITURE ecr ON ecr.IDOBJET = mc.ID
                           JOIN COMPTA_SOUS_ECRITURE sous ON sous.IDMERE = ecr.ID
                           LEFT JOIN COMPTA_LETTRAGE cl ON cl.ID = sous.LETTRAGE
                           LEFT JOIN COMPTA_JOURNAL cj ON cj.ID = sous.JOURNAL
                  WHERE mc.ETAT > 8
                    AND sous.COMPTE LIKE '411%'

              ) relever
                  LEFT JOIN TIERS t ON t.ID = relever.IDCLIENT
     ) SQ
WHERE SQ.RN = 1;

create or replace view VENTE_CPL as
SELECT SQ.ID,SQ.DESIGNATION,SQ.IDMAGASIN,SQ.IDMAGASINLIB,SQ.DATY,SQ.REMARQUE,SQ.ETAT,SQ.ETATLIB,SQ.MONTANTTOTAL,SQ.IDDEVISE,SQ.IDCLIENT,SQ.IDCLIENTLIB,SQ.MONTANTTVA,SQ.MONTANTTTC,SQ.MONTANTTTCAR,SQ.MONTANTPAYE,SQ.MONTANTRESTE,SQ.AVOIR,SQ.TAUXDECHANGE,SQ.MONTANTREVIENT,SQ.MARGEBRUTE,SQ.IDRESERVATION,SQ.DATYPREVU,SQ.REFERENCEFACTURE,SQ.MONTANTREMISE,SQ.MONTANT,SQ.MOIS,SQ.ANNEE,SQ.POIDS,SQ.COLIS,SQ.MODEPAIEMENT,SQ.MODEPAIEMENTLIB,SQ.FRAISLIVRAISON,SQ.MODELIVRAISON,SQ.MODELIVRAISONLIB,SQ.RESTE,SQ.IDPROVINCE,SQ.PROVINCELIB,SQ.IDORIGINE,SQ.FRAIS,SQ.REFERENCEFACT,SQ.NUMEROFACTURE,SQ.LIEULIVRAISON,SQ.DATELIVRAISON,SQ.UPDATED_AT,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(MONTANTTOTAL),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(IDCLIENT),'') || ' | ' || NVL(TO_CHAR(IDCLIENTLIB),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTTTCAR),'') || ' | ' || NVL(TO_CHAR(MONTANTPAYE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'') || ' | ' || NVL(TO_CHAR(AVOIR),'') || ' | ' || NVL(TO_CHAR(TAUXDECHANGE),'') || ' | ' || NVL(TO_CHAR(MONTANTREVIENT),'') || ' | ' || NVL(TO_CHAR(MARGEBRUTE),'') || ' | ' || NVL(TO_CHAR(IDRESERVATION),'') || ' | ' || NVL(TO_CHAR(DATYPREVU,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(REFERENCEFACTURE),'') || ' | ' || NVL(TO_CHAR(MONTANTREMISE),'') || ' | ' || NVL(TO_CHAR(MONTANT),'') || ' | ' || NVL(TO_CHAR(MOIS),'') || ' | ' || NVL(TO_CHAR(ANNEE),'') || ' | ' || NVL(TO_CHAR(POIDS),'') || ' | ' || NVL(TO_CHAR(COLIS),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENT),'') || ' | ' || NVL(TO_CHAR(MODEPAIEMENTLIB),'') || ' | ' || NVL(TO_CHAR(FRAISLIVRAISON),'') || ' | ' || NVL(TO_CHAR(MODELIVRAISON),'') || ' | ' || NVL(TO_CHAR(MODELIVRAISONLIB),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(IDPROVINCE),'') || ' | ' || NVL(TO_CHAR(PROVINCELIB),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(FRAIS),'') || ' | ' || NVL(TO_CHAR(REFERENCEFACT),'') || ' | ' || NVL(TO_CHAR(NUMEROFACTURE),'') || ' | ' || NVL(TO_CHAR(LIEULIVRAISON),'') || ' | ' || NVL(TO_CHAR(DATELIVRAISON,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(UPDATED_AT),'')) AS MOTSCLESSS, estprevulib
FROM (
         SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL                                                                                         AS IDMAGASINLIB,
                v.DATY,
                v.REMARQUE,
                v.ETAT,
                CASE
                    WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
                    WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
                    END
                                                                                                              AS ETATLIB,
                v2.MONTANTTOTAL,
                v2.IDDEVISE,
                v.IDCLIENT,
                c.NOM                                                                                         AS IDCLIENTLIB,
                cast(V2.MONTANTTVA as number(30, 2))                                                          as MONTANTTVA,
                cast(V2.MONTANTTTC as number(30, 2))                                                          as montantttc,
                cast(V2.MONTANTTTCAR as number(30, 2))                                                        as MONTANTTTCAR,
                cast(nvl(mv.montant, 0) AS NUMBER(30, 2))                                                     AS montantpaye,
                cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.imputeefactar, 0) AS NUMBER(30, 2)) AS montantreste,
                cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30, 2))                                             as avoir,
                v2.tauxDeChange                                                                               AS tauxDeChange,
                v2.MONTANTREVIENT,
                cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2))                                  as margeBrute,
                v.IDRESERVATION,
                case when v.DATYPREVU is null then v.daty else V.DATYPREVU end                                as datyprevu,
                rf.REFERENCE                                                                                  as referencefacture,
                v2.MONTANTREMISE,
                nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0)                                            as montant,
                extract(month from v.DATY)                                                                    as mois,
                extract(year from v.DATY)                                                                     as annee,
                CAST(vp.poids as number(30, 5))                                                               as poids,
                CAST(vp.colis as number(30, 2))                                                               as colis,
                v.modepaiement,
                mp.VAL                                                                                        as modepaiementlib,
                nvl(v.fraislivraison, 0) * nvl(vp.poids, 0)                                                   as fraislivraison,
                v.modelivraison,
                CASE
                    WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
                    WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
                    END                                                                                       AS modelivraisonlib,
                vr.reste,
                pv.id                                                                                         as idprovince,
                pv.val                                                                                        as provincelib,
                --bl.id                                                                                         as idbl,
                v.IDORIGINE,
                v.FRAISLIVRAISON                                                                              as frais,
                v.REFERENCEFACT,
                v.NUMEROFACTURE,
                v.LIEULIVRAISON,
                v.DATELIVRAISON,
                v.UPDATED_AT,
                case
                    when v.ESTPREVU = 0 then 'Non'
                    ELSE 'Oui'
                    END estprevulib
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  left join PROVINCE pv on pv.id = c.IDPROVINCE
                  LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
                  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
                  LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
                  left join vente_poids vp on vp.idvente = v.id
                  left join MODEPAIEMENT mp on mp.id = v.modepaiement
                  left join vente_reste vr on vr.idvente = v.id

 ) SQ;
