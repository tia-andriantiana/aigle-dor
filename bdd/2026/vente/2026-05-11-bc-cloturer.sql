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