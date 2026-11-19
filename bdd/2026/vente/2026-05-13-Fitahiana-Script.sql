create view COMMANDEFILLE_V as
select p.ID,
       p.PRODUIT,
       p.IDC,
       p.QUANTITE,
       p.PU,
       p.MONTANT,
       p.TVA,
       p.REMISE,
       p.IDDEVISE,
       p.UNITE,
       p.DESIGNATION,
       uni.val as unitelib,
       0  as punet,
       0  as montantht,
       0  as montantttc,
       p.RISTOURNE,
       ing.calorie
from COMMANDEFILLE p
         LEFT JOIN as_unite uni ON p.unite = uni.id
         LEFT JOIN  AS_INGREDIENTS ing ON p.PRODUIT = ing.ID;

create or replace view COMMANDECPL as
SELECT cmd."ID",cmd."DATY",cmd."ETAT",cmd."REMARQUE",cmd."DESIGNATION",cmd."MODEPAIEMENT",cmd."IDCLIENT",cmd."REFERENCE",cmd."IDDEVISE",cmd."IDMAGASIN",cmd."DATEBESOIN",cmd."IDPROFORMA",cmd."MODELIVRAISON",cmd."DATELIVRAISON",cmd."LIEULIVRAISON",cmd."FRAISLIVRAISON",
       p.VAL AS idMagasinLib,
       cl.NOM AS idClientLib,
       CASE
           WHEN cmd.etat = 1 THEN 'Créé'
           WHEN cmd.etat = 11 THEN 'Validé'
           WHEN cmd.etat = 0 THEN 'Annulé'
           ELSE 'Inconnu'
           END AS etatLib,
       CASE
           WHEN cmd.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN cmd.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib,
       mp.VAL as modePaiementLib
FROM COMMANDE cmd
         LEFT JOIN MAGASIN2 p
                   ON p.id = cmd.IDMAGASIN
         LEFT JOIN CLIENT cl
                   ON cl.id = cmd.IDCLIENT
         left join modepaiement mp
                   on mp.id = cmd.MODEPAIEMENT;

alter table AVOIRFCFILLE add taux number(32,2);

create or replace view AVOIRFCFILLELIB_PDF as
SELECT
    AF.ID,
    AF.IDAVOIRFC,
    AF.IDPRODUIT,
    AF.IDORIGINE,
    AF.QTE,
    AF.PU,
    AF.REMISE,
    AF.TVA,
    AF.PUACHAT,
    AF.PUVENTE,
    AF.IDDEVISE,
    AF.TAUXDECHANGE,
    AF.DESIGNATION,
    AF.IDVENTEDETAILS,
    P.libelle AS IDPRODUITLIB,
    P.CALORIE,
    P.CALORIE * AF.QTE AS POIDS,
    AF.PU * AF.QTE AS PTHT,
    (NVL(AF.pu,0) * NVL(AF.QTE,0)) * NVL(AF.TVA,0) / 100 AS montantTVA,
    AF.TAUX
FROM
    AVOIRFCFILLE AF
        LEFT JOIN as_ingredients P ON
        P.id = AF.IDPRODUIT
;

alter table AVOIRFC add numavoir varchar2(50);
alter table AVOIRFC add idristourne varchar2(50);

create view V_NUMEROAVOIR_EN_COURS as
SELECT
    EXTRACT(YEAR FROM SYSDATE) AS ANNEE_EN_COURS,
    NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) AS DERNIER_NUM,
    NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) + 1 AS PROCHAIN_NUM,
    LPAD(NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) + 1, 4, '0')
        || '/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) AS PROCHAIN_NUM_FORMAT
FROM AVOIRFC
WHERE SUBSTR(numavoir, INSTR(numavoir, '/') + 1) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE));


create or replace view AVOIRFCLIB as
SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION,
       ta.val        as Typeavoir,
       t.NOM         as clientlib,
       a.numavoir,
       a.idristourne
FROM AVOIRFC a
         LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;

create or replace view BONDECOMMANDE_CLIENT_CPL_M as
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
        WHEN (sum(bcf.QTERESTE)) = 0 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;E</span>'
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 12 THEN '<span style=color: green;>CL&Ocirc;TUR&Eacute;E</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    bc.NUMEROBC,
    sum(bcf.QTERESTE) as QTERESTE
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
    bc.modelivraison;