create or replace view MVTCAISSECPLORIGINE2 as
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
         JOIN LIAISONPAIEMENT lp ON lp.ID1 = m.ID;




create or replace view VENTE_DIRECTE_CPL_PDF as
SELECT "ID","DESIGNATION","IDMAGASIN","IDMAGASINLIB","DATY","DATYPREVU","REMARQUE","ETAT","ADECLARER","ETATLIB","MONTANTTOTAL","IDDEVISE","IDCLIENT","IDCLIENTLIB","MONTANTTVA","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","AVOIR","TAUXDECHANGE","MONTANTREVIENT","MARGEBRUTE","IDRESERVATION","AVECCOMMISSION","IDMODEPAIEMENT","REFERENCEFACTURE","IDMODEPAIEMENTLIB","MONTANTDONNE","MONTANTRETOURNER","HEURESAISIE","IDECHEANCEPAIEMENT","ECHEANCEPAIEMENTLIB","IDORIGINE","DATYHEURE","NOMCLIENTDIVERS"
FROM (
         SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL AS IDMAGASINLIB,
                v.DATY,
                v.DATYPREVU,
                v.REMARQUE,
                v.ETAT,
                ADECLARER,
                CASE
                    WHEN v.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                    WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN v.ETAT = 0  THEN 'ANNUL&Eacute;E'
                    END AS ETATLIB,
                v2.MONTANTTOTAL,
                v2.IDDEVISE,
                v.IDCLIENT,
                c.NOM AS IDCLIENTLIB,
                cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
                cast(V2.MONTANTTTC as number(30,2)) as montantttc,
                cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
                cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
                cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
                nvl(ACG.MONTANTTTC_avr, 0) as avoir,
                v2.tauxDeChange AS tauxDeChange,
                v2.MONTANTREVIENT,
                cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2)) as margeBrute,
                v.IDRESERVATION,
                CASE
                    WHEN cm.id IS NOT NULL THEN 'Oui'
                    ELSE                        'Non'
                    END AS avecCommission,
                v.idmodepaiement,
                rf.REFERENCE as referencefacture,
                mp.val AS idmodepaiementlib,
                CASE
                    WHEN v.MONTANTDONNE IS NULL OR v.MONTANTDONNE = 0
                        THEN cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2))
                    ELSE cast(v.MONTANTDONNE AS NUMBER(30,2))
                    END AS MONTANTDONNE,
                nvl(mv.MONTANTRETOURNER, 0) as montantretourner,
                v.heureSaisie,
                V.IDECHEANCEPAIEMENT,
                EP.DESCE AS echeancePaiementLib,
                v.IDORIGINE,
                TO_DATE(v.daty || ' ' || v.heureSaisie, 'DD/MM/YYYY HH24:MI:SS') AS DATYHEURE,
                v.NOMCLIENTDIVERS
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN MVTCAISSEGROUPEFACTURE_PDF mv ON v.id in mv.IDORIGINE
                  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
             LEFT JOIN COMMISSION cm ON cm.IDFACTURE = v.id
             LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
             LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
             LEFT JOIN ECHEANCEPAIEMENT EP on EP.ID = V.IDECHEANCEPAIEMENT
     )
ORDER BY DATYHEURE DESC NULLS LAST;


create or replace view VENTE_DIRECTE_CPL_PDF as
SELECT "ID","DESIGNATION","IDMAGASIN","IDMAGASINLIB","DATY","DATYPREVU","REMARQUE","ETAT","ADECLARER","ETATLIB","MONTANTTOTAL","IDDEVISE","IDCLIENT","IDCLIENTLIB","MONTANTTVA","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","AVOIR","TAUXDECHANGE","MONTANTREVIENT","MARGEBRUTE","IDRESERVATION","AVECCOMMISSION","IDMODEPAIEMENT","REFERENCEFACTURE","IDMODEPAIEMENTLIB","MONTANTDONNE","MONTANTRETOURNER","HEURESAISIE","IDECHEANCEPAIEMENT","ECHEANCEPAIEMENTLIB","IDORIGINE","DATYHEURE","NOMCLIENTDIVERS","IDRESPONSABLELIB"
FROM (
         SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL AS IDMAGASINLIB,
                v.DATY,
                v.DATYPREVU,
                v.REMARQUE,
                v.ETAT,
                ADECLARER,
                CASE
                    WHEN v.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                    WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN v.ETAT = 0  THEN 'ANNUL&Eacute;E'
                    END AS ETATLIB,
                v2.MONTANTTOTAL,
                v2.IDDEVISE,
                v.IDCLIENT,
                c.NOM AS IDCLIENTLIB,
                cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
                cast(V2.MONTANTTTC as number(30,2)) as montantttc,
                cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
                cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
                cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
                nvl(ACG.MONTANTTTC_avr, 0) as avoir,
                v2.tauxDeChange AS tauxDeChange,
                v2.MONTANTREVIENT,
                cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2)) as margeBrute,
                v.IDRESERVATION,
                CASE
                    WHEN cm.id IS NOT NULL THEN 'Oui'
                    ELSE                        'Non'
                    END AS avecCommission,
                v.idmodepaiement,
                rf.REFERENCE as referencefacture,
                mp.val AS idmodepaiementlib,
                CASE
                    WHEN v.MONTANTDONNE IS NULL OR v.MONTANTDONNE = 0
                        THEN cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2))
                    ELSE cast(v.MONTANTDONNE AS NUMBER(30,2))
                    END AS MONTANTDONNE,
                nvl(mv.MONTANTRETOURNER, 0) as montantretourner,
                v.heureSaisie,
                V.IDECHEANCEPAIEMENT,
                EP.DESCE AS echeancePaiementLib,
                v.IDORIGINE,
                TO_DATE(v.daty || ' ' || v.heureSaisie, 'DD/MM/YYYY HH24:MI:SS') AS DATYHEURE,
                v.NOMCLIENTDIVERS,
                u.NOMUSER as IDRESPONSABLELIB
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN MVTCAISSEGROUPEFACTURE_PDF mv ON v.id in mv.IDORIGINE
                  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
             LEFT JOIN COMMISSION cm ON cm.IDFACTURE = v.id
             LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
             LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
             LEFT JOIN ECHEANCEPAIEMENT EP on EP.ID = V.IDECHEANCEPAIEMENT
             LEFT JOIN UTILISATEUR u
             ON u.REFUSER = TO_NUMBER(v.IDRESPONSABLE)
     )
ORDER BY DATYHEURE DESC NULLS LAST;



