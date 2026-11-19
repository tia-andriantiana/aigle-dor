
CREATE OR REPLACE VIEW PROFORMA_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, IDDEVISE, IDCLIENT, CODECLIENT, 
IDCLIENTLIB, ADRESSE, CONTACT, POIDSTOTAL, MONTANT, MONTANTREMISE, MONTANTRISTOURNE, FRAISLIVRAISON, FRAISTRANSPORT, MONTANTTOTAL,
MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, 
IDORIGINE, REMISE, NUMEROPROFORMA, IDCOMMANDE, MODELIVRAISONLIB, LIEULIVRAISON, DATELIVRAISON, REFERENCE, motsclesss) AS 
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
           WHEN v.ETAT = 12 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;</span>'
           END
                                                                                              AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.CODECLIENT,
       c.NOM                                                                                  AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE                                                                            AS CONTACT,
       cast(V2.POIDS as number(30, 2))                                                   as poidstotal,
       cast(V2.montanttotal as number(30, 2))                                                      as montant,
       cast(V2.montantremise as number(30, 2))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 2))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10, 2)) as fraislivraison,
       cast(V2.FRAIS as number(30, 2))                                               as fraistransport,
       cast(v2.MONTANTTOTAL as number(30, 2))                                                 AS MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 2))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                                                 as MONTANTTTCAR,
       cast(0 AS number(30, 2))                     AS montantpaye,
       cast(0 AS number(30, 2)) AS montantreste,
       0                                                             as avoir,
       cast(v2.tauxDeChange  as number(10, 2))                                                                        AS tauxDeChange,
       cast(v2.MONTANTREVIENT as number(20, 5))                                               AS MONTANTREVIENT,
       cast((COALESCE(V2.MONTANTTTCAR,0) - COALESCE(v2.MONTANTREVIENT,0)) as number(20, 5))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise,
       v.NUMEROPROFORMA,
       v.IDCOMMANDE,
       CASE
           WHEN v.modelivraison = 1 THEN 'LIVRAISON'
           WHEN v.modelivraison = 2 THEN 'RECUPERATION'
           END AS modelivraisonlib,
       v.lieuLivraison AS lieulivraison,
       v.datelivraison AS datelivraison,
       v.reference,
       v.ID || ' ' || v.NUMEROPROFORMA || ' ' || v.DATY || ' ' || c.NOM || ' ' || m.VAL || ' ' || v.IDMAGASIN || ' ' || v.IDCLIENT AS motsclesss
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANTLEGER v2 ON v2.ID = v.ID
;

CREATE OR REPLACE VIEW PROFORMA_CPL_CREE (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT,
ETATLIB, IDDEVISE, IDCLIENT, IDCLIENTLIB, ADRESSE, CONTACT, MONTANT, MONTANTTOTAL, MONTANTREMISE, MONTANTTVA, MONTANTTTC,
MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, IDORIGINE, REMISE,MOTSCLESSS) AS 
  SELECT
	ID,
	DESIGNATION,
	IDMAGASIN,
	IDMAGASINLIB,
	DATY,
	REMARQUE,
	ETAT,
	ETATLIB,
	IDDEVISE,
	IDCLIENT,
	IDCLIENTLIB,
	ADRESSE,
	CONTACT,
	MONTANT,
	MONTANTTOTAL,
	MONTANTREMISE,
	MONTANTTVA,
	MONTANTTTC,
	MONTANTTTCAR,
	MONTANTPAYE,
	MONTANTRESTE,
	AVOIR,
	TAUXDECHANGE,
	MONTANTREVIENT,
	MARGEBRUTE,
	IDRESERVATION,
	IDORIGINE,
	REMISE,
	MOTSCLESSS
FROM
	PROFORMA_CPL
WHERE
	etat = 1
;


CREATE OR REPLACE VIEW PROFORMA_CPL_VISEE (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, IDDEVISE, IDCLIENT, IDCLIENTLIB, ADRESSE, CONTACT, MONTANT, MONTANTTOTAL, MONTANTREMISE, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, IDORIGINE, REMISE,MOTSCLESSS) AS 
  SELECT
	ID,
	DESIGNATION,
	IDMAGASIN,
	IDMAGASINLIB,
	DATY,
	REMARQUE,
	ETAT,
	ETATLIB,
	IDDEVISE,
	IDCLIENT,
	IDCLIENTLIB,
	ADRESSE,
	CONTACT,
	MONTANT,
	MONTANTTOTAL,
	MONTANTREMISE,
	MONTANTTVA,
	MONTANTTTC,
	MONTANTTTCAR,
	MONTANTPAYE,
	MONTANTRESTE,
	AVOIR,
	TAUXDECHANGE,
	MONTANTREVIENT,
	MARGEBRUTE,
	IDRESERVATION,
	IDORIGINE,
	REMISE,
	MOTSCLESSS
FROM
	PROFORMA_CPL
WHERE
	etat = 11
;


CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_CPL_M (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, MODEPAIEMENTLIB, 
IDCLIENT, IDCLIENTLIB, REFERENCE, IDMAGASINLIB, ETATLIB, IDPROFORMA, NBFACTURE, MODELIVRAISONLIB, DATELIVRAISON, LIEULIVRAISON,
NUMEROBC, QTERESTE, FACTURELIB,MOTSCLESSS) AS 
  SELECT
    bc.ID,
    bc.DATY,
    case WHEN (sum(bcf.QTERESTE)) = 0 then 12
         else bc.ETAT
        END AS ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN (sum(bcf.QTERESTE)) = 0 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 12 THEN '<span style=color: green;>VALID&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>R&Eacute;CUP&Eacute;RATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    sum(bcf.QTERESTE) as QTERESTE,
    CASE
        WHEN nvl(vo.nombre,0) > 0 THEN '<span style=color: green;>FACTUR&Eacute;</span>'
        WHEN nvl(vo.nombre,0) = 0 THEN '<span style=color: red;>NON FACTUR&Eacute;</span>'
        END AS facturelib,
     bc.ID || '' || bc.DATY || '' || bc.IDCLIENT || '' || c.NOM || '' || bc.DESIGNATION || '' || bc.REFERENCE || '' || bc.MODEPAIEMENT || '' || bc.NUMEROBC AS motsclesss
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
         left join BC_CLIENT_FILLE_CPL_LIB bcf on bcf.IDBC = bc.ID
group by
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL,
    bc.IDCLIENT,
    c.NOM,
    bc.REFERENCE,
    m2.VAL,
    bc.IDPROFORMA,
    vo.nombre,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    bc.modelivraison
 ;


CREATE OR REPLACE VIEW VENTE_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, MONTANTTOTAL, IDDEVISE, IDCLIENT, IDCLIENTLIB, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, DATYPREVU, REFERENCEFACTURE, MONTANTREMISE, MONTANT, MOIS, ANNEE, POIDS, COLIS, MODEPAIEMENT, MODEPAIEMENTLIB, FRAISLIVRAISON, MODELIVRAISON, MODELIVRAISONLIB, RESTE, IDPROVINCE, PROVINCELIB, IDORIGINE, FRAIS, REFERENCEFACT, NUMEROFACTURE, LIEULIVRAISON, DATELIVRAISON, UPDATED_AT, ESTPREVULIB, IDECRITURE, DATEDELIVRAISON,MOTSCLESSS) AS 
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
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.MONTANTTTCAR-acg.MONTANTPAYEAR, 0) AS number(30, 5)) AS montantreste,
       cast(nvl(ACG.MONTANTTTCAR, 0) as number(30, 5))                                             as avoir,
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
       CAST(v2.poids as number(30, 5))                                                               as poids,
       CAST(v2.colis as number(30, 5))                                                               as colis,
       v.modepaiement,
       mp.VAL                                                                                        as modepaiementlib,
       nvl(v.fraislivraison, 0) * nvl(v2.poids, 0)                                                   as fraislivraison,
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
       v.ID || '' || v.DATY || '' || v.IDCLIENT || '' || c.NOM || '' || v.IDMAGASIN || '' || m.VAL || '' || v.REMARQUE AS motsclesss
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANTLEGER v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN AVOIRFCMONTANT ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         --left join( select sum(vd.POIDS) as poids,sum(vd.QTE) as colis,v.ID  from VENTE_DETAILS vd left join vente v on v.ID=vd.IDVENTE where v.ETAT>=11 group by v.ID ) vp on vp.ID=v.id
         --left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN AS_BONDELIVRAISON_CLIENT blc ON blc.IDVENTE = v.id
         LEFT JOIN compta_ecriture ce ON ce.idobjet=v.id
 ;
 

CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL (ID, DESIGNATION, IDCAISSE, IDCAISSELIB, IDVENTEDETAIL, IDVIREMENT, DEBIT, CREDIT, SOLDECREDIT, SOLDEDEBIT, DATY, ETAT, ETATLIB, IDVENTE, IDORIGINE, IDTIERS, TIERS, IDPREVISION, IDOP, TAUX, COMPTE, IDDEVISE, IDTRAITE, IDMODEPAIEMENTLIB, IDMVTCAISSEMERE, REFERENCE, DATYCOMPTABILISATION, UPDATED_AT, HEURE,MOTSCLESSS) AS 
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
	       m.IDORIGINE as idorigine,
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
	       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS
	FROM MOUVEMENTCAISSE m
	         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
	         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
	         LEFT JOIN tiers t ON t.ID = m.idtiers
	         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
	        left join modepaiement mp on m.idmodepaiement = mp.id
 ;


CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL_A (ID, DESIGNATION, IDCAISSE, IDCAISSELIB, IDVENTEDETAIL, IDVIREMENT, DEBIT, CREDIT, DATY, ETAT, ETATLIB, IDVENTE, IDORIGINE, IDTIERS, TIERS,MOTSCLESSS) AS 
  SELECT
	    ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS,MOTSCLESSS
	FROM
	    MOUVEMENTCAISSECPL m
	WHERE
	        m.etat = 8
 
 ;

 CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL_CREE (ID, DESIGNATION, IDCAISSE, IDCAISSELIB, IDVENTEDETAIL, IDVIREMENT, DEBIT, CREDIT, DATY, ETAT, ETATLIB, IDVENTE, IDORIGINE, IDTIERS, TIERS,MOTSCLESSS) AS 
  SELECT
			ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS,MOTSCLESSS
		FROM 
			MOUVEMENTCAISSECPL m 
		WHERE 
			m.etat = 1
 ;

CREATE OR REPLACE VIEW MVTSTOCKLIB (ID, DESIGNATION, IDMAGASIN, IDOBJET, IDMAGASINLIB, IDVENTE, IDVENTELIB, 
IDTRANSFERT, IDTRANSFERTLIB, IDTYPEMVSTOCK, IDTYPEMVSTOCKLIB, DATY, ETAT, HEURE, ETATLIB, IDRESERVATION, MONTANTENTREE, 
MONTANTSORTIE, IDCATEGORIESTOCK, IDCATEGORIESTOCKLIB,MOTSCLESSS) AS 
  SELECT
m.ID ,
m.DESIGNATION ,
m.IDMAGASIN ,
m.IDOBJET ,
m2.VAL  AS idMagasinlib,
m.IDVENTE ,
v.DESIGNATION  AS idVentelib,
m.IDTRANSFERT ,
CAST('' AS VARCHAR2(255)) AS idTransfertlib,
m.IDTYPEMVSTOCK ,
t.VAL AS idTypeMvStocklib ,
m.DATY ,
m.ETAT ,
m.heure,
CASE
	WHEN m.ETAT = 0
	THEN 'ANNUL&Eacute;E'
	WHEN m.ETAT = 1
	THEN 'CR&Eacute;&Eacute;E'
	WHEN m.ETAT = 11
	THEN 'VALID&Eacute;E'
END AS etatlib,
v.IDRESERVATION,
CAST(COALESCE(gm.montantEntree,0) AS NUMBER(30,5)) AS  montantEntree,
CAST(COALESCE(gm.montantSortie,0) AS NUMBER(30,5)) AS  montantSortie,
m.IDCATEGORIESTOCK,
cs.val as idCategorieStockLib,
m.ID || '' || m.DESIGNATION || '' || m.IDMAGASIN || '' || m2.VAL || '' || m.IDVENTE || '' || v.DESIGNATION || '' || t.VAL || '' || cs.val || '' || m.DATY AS MOTSCLESSS
FROM MVTSTOCK m
LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
LEFT JOIN VENTE v ON v.ID = m.IDVENTE
LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID
LEFT JOIN categorieStock cs ON m.IDCATEGORIESTOCK = cs.id
 ;

 CREATE OR REPLACE VIEW MVTSTOCKLIBANNULER (ID, DESIGNATION, IDMAGASIN, IDOBJET, IDMAGASINLIB, IDVENTE, IDVENTELIB, IDTRANSFERT, IDTRANSFERTLIB, IDTYPEMVSTOCK, IDTYPEMVSTOCKLIB, DATY, ETAT, ETATLIB, IDRESERVATION,MOTSCLESSS) AS 
  SELECT
m.ID,m.DESIGNATION,m.IDMAGASIN,m.IDOBJET,m.IDMAGASINLIB,m.IDVENTE,m.IDVENTELIB,m.IDTRANSFERT,m.IDTRANSFERTLIB,m.IDTYPEMVSTOCK,m.IDTYPEMVSTOCKLIB,m.DATY,m.ETAT,m.ETATLIB,m.IDRESERVATION,m.MOTSCLESSS
FROM MVTSTOCKLIB m
WHERE m.ETAT = 0
 ;

CREATE OR REPLACE VIEW MVTSTOCKLIBCREER (ID, DESIGNATION, IDMAGASIN, IDOBJET, IDMAGASINLIB, IDVENTE, IDVENTELIB, IDTRANSFERT, IDTRANSFERTLIB, IDTYPEMVSTOCK, IDTYPEMVSTOCKLIB, DATY, ETAT, ETATLIB, IDRESERVATION,MOTSCLESSS) AS 
  SELECT
m.ID,m.DESIGNATION,m.IDMAGASIN,m.IDOBJET,m.IDMAGASINLIB,m.IDVENTE,m.IDVENTELIB,m.IDTRANSFERT,m.IDTRANSFERTLIB,m.IDTYPEMVSTOCK,m.IDTYPEMVSTOCKLIB,m.DATY,m.ETAT,m.ETATLIB,m.IDRESERVATION,m.MOTSCLESSS
FROM MVTSTOCKLIB m
WHERE m.ETAT = 1
 ;

 CREATE OR REPLACE VIEW MVTSTOCKLIBVALIDER (ID, DESIGNATION, IDMAGASIN, IDOBJET, IDMAGASINLIB, IDVENTE, IDVENTELIB, IDTRANSFERT, IDTRANSFERTLIB, IDTYPEMVSTOCK, IDTYPEMVSTOCKLIB, DATY, ETAT, ETATLIB, IDRESERVATION,MOTSCLESSS) AS 
  SELECT
m.ID,m.DESIGNATION,m.IDMAGASIN,m.IDOBJET,m.IDMAGASINLIB,m.IDVENTE,m.IDVENTELIB,m.IDTRANSFERT,m.IDTRANSFERTLIB,m.IDTYPEMVSTOCK,m.IDTYPEMVSTOCKLIB,m.DATY,m.ETAT,m.ETATLIB,m.IDRESERVATION,m.MOTSCLESSS
FROM MVTSTOCKLIB m
WHERE m.ETAT = 11
 ;