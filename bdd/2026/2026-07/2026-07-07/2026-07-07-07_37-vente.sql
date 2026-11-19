CREATE OR REPLACE VIEW MOUVEMENTCAISSEMERELIB AS
SELECT
    m."ID",m."DESIGNATION",m."IDMODEPAIEMENT",m."CREDIT",m."DEBIT",m."IDTIERS",m."IDORIGINE",m."DATY",m."ETAT",
    mp.VAL AS idmodepaiementlib,
    c.NOM AS idtierslib,
    CASE
        WHEN m.ETAT = 1 THEN 'CRÉÉE'
        WHEN m.ETAT = 11 THEN 'VISÉE'
        WHEN m.ETAT = 0 THEN 'ANNULÉE'
        END AS etatlib
FROM mouvementcaissemere m
         LEFT JOIN MODEPAIEMENT mp ON mp.id = m.idmodepaiement
         LEFT JOIN CLIENT c ON c.id = m.idtiers
;

create view VENTE_CPL_CL as
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
       cast(v2.MONTANTTOTAL as number(30, 5)) AS MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM                                                                                         AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30, 5))                                                          as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 5))                                                          as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 5))                                                        as MONTANTTTCAR,
       cast(nvl(mv.montant, 0) AS number(30, 5))                                                     AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.imputeefactar, 0) AS number(30, 5)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30, 5))                                             as avoir,
       cast(v2.tauxDeChange as number(10, 2))                                                                        AS tauxDeChange,
       cast(v2.MONTANTREVIENT as number(20, 5)) AS MONTANTREVIENT  ,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 5))                                  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end                                as datyprevu,
       rf.REFERENCE                                                                                  as referencefacture,
       cast(v2.MONTANTREMISE as number(30, 5)) AS MONTANTREMISE,
       cast(nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0) as number(30, 5))                                             as montant,
       extract(month from v.DATY)                                                                    as mois,
       extract(year from v.DATY)                                                                     as annee,
       CAST(vp.poids as number(30, 5))                                                               as poids,
       CAST(vp.colis as number(30, 5))                                                               as colis,
       v.modepaiement,
       mp.VAL                                                                                        as modepaiementlib,
       nvl(v.fraislivraison, 0) * nvl(vp.poids, 0)                                                   as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END                                                                                       AS modelivraisonlib,
       cast(vr.reste  as number(30, 5)) AS reste,
       pv.id                                                                                         as idprovince,
       pv.val                                                                                        as provincelib,
       --bl.id                                                                                         as idbl,
       v.IDORIGINE,
       CAST(COALESCE(v.FRAISLIVRAISON,0) AS  number(30, 5))                                                                             as frais,
       v.REFERENCEFACT,
       v.NUMEROFACTURE,
       v.LIEULIVRAISON,
       v.DATELIVRAISON,
       v.UPDATED_AT,
       case
           when v.ESTPREVU = 0 then 'Non'
           ELSE 'Oui'
           END estprevulib,
       ce.id AS idecriture,
       nvl(blc.daty,v.DATELIVRAISON) AS datedelivraison,
       c.ADRESSE
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
         LEFT JOIN AS_BONDELIVRAISON_CLIENT blc ON blc.IDVENTE = v.id
         LEFT JOIN compta_ecriture ce ON ce.idobjet=v.id;


update MENUDYNAMIQUE set ID_PERE='MENDYN1778838030848521', NIVEAU=3 where id='MENDYN1778838045799467';
