
CREATE OR REPLACE VIEW FOURNISSEURCPL AS
SELECT f.*,
       1 as nb
FROM FOURNISSEUR f;

create OR REPLACE view AS_BONDECOMMANDE_MERECPL as
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
    ab.iddmdachat AS IDDMDACHAT,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    CAST(abf.montantTVA AS NUMBER(30,5)) AS montantTVA,
    CAST(abf.montantHT AS NUMBER(30,5)) AS montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,5)) AS montantTTC,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,5)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11 THEN 'VIS&Eacute;E'
        WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;E'
        END AS ETATLIB,
    s.libelle AS idServiceLib,
    ab.refproforma,
    1 AS nb
FROM AS_BONDECOMMANDE AB
         LEFT JOIN MODEPAIEMENT mp ON AB.MODEPAIEMENT = mp.id
         LEFT JOIN FOURNISSEUR F ON AB.FOURNISSEUR = F.id
         LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
         LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
         LEFT JOIN SERVICE s ON ab.SERVICE = s.COMPTE;