create or replace view VENTE_CPL1 as
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
           WHEN v.ETAT = 0 THEN 'ANNULÉE'
           WHEN v.ETAT = 1 THEN 'CRÉÉE'
           WHEN v.ETAT = 11 THEN 'VALIDÉE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       CASE
           WHEN cm.id IS NOT NULL
               THEN 'Oui'
           WHEN cm.id IS NULL
               THEN 'Non'
           END AS avecCommission,
       v.idmodepaiement,
       rf.REFERENCE as referencefacture,
       mp.val AS idmodepaiementlib,
       v.MONTANTDONNE as MONTANTDONNE,
       nvl(mv.MONTANTRETOURNER, 0) as montantretourner,
       v.heureSaisie,
       pers.nom AS idResponsablelib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture1 mv ON v.id in mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN COMMISSION cm ON cm.IDFACTURE = v.id
         LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         LEFT JOIN PERSONNEl pers ON pers.id = v.idResponsable
/

