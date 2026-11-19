INSERT INTO SERVICE
(ID, LIBELLE, CODE, COMPTE)
VALUES('SERV0001', 'Informatique', '11', '11');
INSERT INTO SERVICE
(ID, LIBELLE, CODE, COMPTE)
VALUES('SERV0002', 'Commercial', '12', '12');
INSERT INTO SERVICE
(ID, LIBELLE, CODE, COMPTE)
VALUES('SERV0003', 'Comptabilité', '13', '13');

ALTER TABLE PREVISION ADD service varchar(255);

CREATE OR REPLACE VIEW PREVISION_CPL AS
select
    p.id,
    p.designation,
    p.idcaisse,
    c.val as idcaisselib,
    p.idventedetail,
    v.IDVENTE,
    v2.designation as idventelib,
    p.idvirement,
    p.debit,
    p.credit,
    p.daty,
    p.etat,
    p.idop,
    o.DESIGNATION as idoplib ,
    p.idorigine,
    p.iddevise,
    p.designation as iddeviselib,
    p.taux,
    p.idtiers,
    p.compte,
    p.idfacture,
    v2.IDRESERVATION,
    p.dateinitial,
    p.dureeretard,
    p.mois,
    p.annee,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
        ) AS moisLib,
    s.libelle AS idServiceLib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         LEFT JOIN SERVICE s ON p.SERVICE = s.COMPTE
         left join devise d on d.id=p.IDDEVISE;

ALTER TABLE DMDACHAT ADD service varchar(255);

CREATE OR REPLACE VIEW DMDACHATLIB AS
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Responsable achat'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Directeur'
        END AS etatlib,
    da.idObjet,
    s.libelle AS idServiceLib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
         LEFT JOIN SERVICE s ON da.SERVICE = s.COMPTE
;

ALTER TABLE AS_BONDECOMMANDE ADD service varchar(255);

CREATE OR REPLACE VIEW AS_BONDECOMMANDE_MERECPL AS
SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    ab.dateLimite,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11 THEN 'VIS&Eacute;E'
        WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;E'
        END
        AS ETATLIB,
    s.libelle AS idServiceLib
from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN SERVICE s ON ab.SERVICE = s.COMPTE
;

ALTER TABLE FACTUREFOURNISSEUR ADD service varchar(255);

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL AS
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CR&Eacute;&Eacute;E'
           WHEN f.ETAT = 0
               THEN 'ANNUL&Eacute;E'
           WHEN f.ETAT = 11
               THEN 'VIS&Eacute;'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture,
       f.numero,
       f.typeachat,
       f.idfactureprincipale,
       s.libelle AS idServiceLib
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
         LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE

;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL_TOUS AS
SELECT
    fcpl.id,
    fcpl.idfournisseur,
    fcpl.idfournisseurlib,
    fcpl.idmodepaiement,
    fcpl.idmodepaiementlib,
    fcpl.daty,
    fcpl.designation,
    fcpl.dateecheancepaiement,
    fcpl.etatlib,
    fcpl.reference,
    fcpl.idbc,
    fcpl.idmagasin,
    fcpl.idmagasinlib,
    fcpl.devise,
    fcpl.iddevise,
    fcpl.etat,
    fcpl.taux,
    fcpl.montanttva,
    fcpl.montantht,
    fcpl.tauxdechange,
    fcpl.montantttc AS  MONTANTTTC,
    nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
    nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF,
    fcpl.idtypefacture,
    fcpl.idfactureprincipale,
    fcpl.idServiceLib
FROM FACTUREFOURNISSEURCPL fcpl
;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL_MGA AS
SELECT ID,IDFOURNISSEUR,IDFOURNISSEURLIB,IDMODEPAIEMENT,IDMODEPAIEMENTLIB,DATY,DESIGNATION,DATEECHEANCEPAIEMENT,ETAT,ETATLIB,REFERENCE,IDBC,IDMAGASIN,DEVISE,TAUX,IDMAGASINLIB,IDDEVISE,MONTANTTVA,MONTANTHT,MONTANTTTC,MONTANTTTCAR,MONTANTPAYE,MONTANTRESTE,TAUXDECHANGE,IDTYPEFACTURE,IDFACTUREPRINCIPALE,idServiceLib FROM FACTUREFOURNISSEURCPL
WHERE idDEVISE = 'AR'
;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL_EUR AS
SELECT ID,IDFOURNISSEUR,IDFOURNISSEURLIB,IDMODEPAIEMENT,IDMODEPAIEMENTLIB,DATY,DESIGNATION,DATEECHEANCEPAIEMENT,ETAT,ETATLIB,REFERENCE,IDBC,IDMAGASIN,DEVISE,TAUX,IDMAGASINLIB,IDDEVISE,MONTANTTVA,MONTANTHT,MONTANTTTC,MONTANTTTCAR,MONTANTPAYE,MONTANTRESTE,TAUXDECHANGE,IDTYPEFACTURE,IDFACTUREPRINCIPALE,idServiceLib FROM FACTUREFOURNISSEURCPL
WHERE idDEVISE = 'EUR'
;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL_USD AS
SELECT ID,IDFOURNISSEUR,IDFOURNISSEURLIB,IDMODEPAIEMENT,IDMODEPAIEMENTLIB,DATY,DESIGNATION,DATEECHEANCEPAIEMENT,ETAT,ETATLIB,REFERENCE,IDBC,IDMAGASIN,DEVISE,TAUX,IDMAGASINLIB,IDDEVISE,MONTANTTVA,MONTANTHT,MONTANTTTC,MONTANTTTCAR,MONTANTPAYE,MONTANTRESTE,TAUXDECHANGE,IDTYPEFACTURE,IDFACTUREPRINCIPALE,idServiceLib FROM FACTUREFOURNISSEURCPL
WHERE idDEVISE = 'USD'
;

CREATE OR REPLACE VIEW COMPTA_COMPTE_LIB AS
select ID,
       Compte,
       LIBELLE||' : '||COMPTE as libelle,
       TYPECOMPTE,
       CLASSY,
       ANALYTIQUE_OBLI,
       IDJOURNAL
from COMPTA_COMPTE
;

CREATE OR REPLACE VIEW VIREMENTINTRACAISSECPL AS
SELECT
    v.ID ,
    v.DESIGNATION ,
    v.IDCAISSEDEPART ,
    c.VAL AS IDCAISSEDEPARTLIB ,
    v.IDCAISSEARRIVE ,
    c2.VAL AS IDCAISSEARRIVELIB,
    v.MONTANT ,
    v.DATY ,
    v.ETAT ,
    CASE
        WHEN v.ETAT = 0
            THEN 'ANNUL&Eacute;'
        WHEN v.ETAT = 1
            THEN 'CR&Eacute;&Eacute;'
        WHEN v.ETAT = 11
            THEN  'VIS&Eacute;'
        END AS ETATLIB
FROM VIREMENTINTRACAISSE v
         LEFT JOIN CAISSE c ON c.ID = v.IDCAISSEDEPART
         LEFT JOIN CAISSE c2 ON c2.ID  = v.IDCAISSEARRIVE
;