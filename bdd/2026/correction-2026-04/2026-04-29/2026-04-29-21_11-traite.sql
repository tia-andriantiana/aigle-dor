CREATE OR REPLACE VIEW DMDACHATLIB_TRAITE AS
SELECT
    d.ID,
    bc.DESIGNATION ,
    bc.id AS idbc ,
    d.DATY,
    d.FOURNISSEUR,
    d.FOURNISSEURLIB,
    d.REMARQUE,
    d.DATELIMITE,
    d.IDMAGASINLIB,
    d.IDCATEGORIELIB,
    d.ETAT,
    d.ETATLIB,
    d.IDOBJET,
    d.IDSERVICELIB,
    CASE
        WHEN bc.ID IS NOT NULL THEN 'Oui'
        ELSE 'Non'
    END AS TRAITE
FROM DMDACHATLIB d
LEFT JOIN AS_BONDECOMMANDE_MERECPL bc
    ON d.ID = REPLACE(
        bc.DESIGNATION,
        'Facture de la demande d''achat ',
        ''
    );