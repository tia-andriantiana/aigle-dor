ALTER TABLE proforma ADD modelivraison number;
ALTER TABLE proforma ADD lieulivraison varchar(255);
ALTER TABLE proforma ADD datelivraison date;


CREATE OR REPLACE  VIEW PROFORMA_CPL ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "IDDEVISE", "IDCLIENT", "CODECLIENT", "IDCLIENTLIB", "ADRESSE", "CONTACT", "POIDSTOTAL", "MONTANT", "MONTANTREMISE", "MONTANTRISTOURNE", "FRAISLIVRAISON", "FRAISTRANSPORT", "MONTANTTOTAL", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "IDORIGINE", "REMISE", "NUMEROPROFORMA", "IDCOMMANDE","MODELIVRAISONLIB","LIEULIVRAISON","DATELIVRAISON") AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
                                                                                              AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.CODECLIENT,
       c.NOM                                                                                  AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE                                                                            AS CONTACT,
       cast(V2.POIDSTOTAL as number(30, 5))                                                   as poidstotal,
       cast(V2.montant as number(30, 5))                                                      as montant,
       cast(V2.montantremise as number(30, 5))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 5))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10, 5)) as fraislivraison,
       cast(V2.FRAISTRANSPORT as number(30, 5))                                               as fraistransport,
       cast(v2.MONTANTTOTAL as number(30, 5))                                                 AS MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 5))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 5))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 5))                                                 as MONTANTTTCAR,
       cast(nvl(mv.credit, 0) - nvl(ACG.MONTANTPAYE, 0) AS number(30, 5))                     AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.credit, 0) - nvl(ACG.resteapayer_avr, 0) AS number(30, 5)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)                                                             as avoir,
       cast(v2.tauxDeChange  as number(10, 2))                                                                        AS tauxDeChange,
       cast(v2.MONTANTREVIENT as number(20, 5))                                               AS MONTANTREVIENT,
       cast((COALESCE(V2.MONTANTTTCAR,0) - COALESCE(v2.MONTANTREVIENT,0)) as number(20, 5))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise,
       v.NUMEROPROFORMA,
       v.IDCOMMANDE,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib,
       v.lieuLivraison AS lieulivraison,
       v.datelivraison AS datelivraison
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;

