 CREATE   VIEW AS_BC_RESTE_A_FACTURER AS 
  SELECT
    bc.id,
    bc.idbc,
    bc.produitlib,
    bc.unitelib,
    bc.produit,
    nvl(bc.quantite,0) AS quantite,
    nvl(bl.qte,0) AS qtelivrer,
    --nvl(ff.qte + ffm.qte,0) AS qtefacturer
    nvl(ffm.qte,0) AS qtefacturer,
    FOURNISSEUR,
    FOURNISSEURLIB,
    DATY
FROM AS_BONDECOMMANDE_CPL bc
         LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
         --LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL
        left join FF_FILLEBC_GRP_MERE ffm on ffm.IDBC = bc.IDBC and ffm.IDPRODUIT = bc.PRODUIT;