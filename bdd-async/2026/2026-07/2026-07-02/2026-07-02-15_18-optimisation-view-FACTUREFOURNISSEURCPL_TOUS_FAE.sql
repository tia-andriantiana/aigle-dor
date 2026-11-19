
-- nanova "not in" ho lasa left join where is null

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL_TOUS_FAE  AS 
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
    CAST(fcpl.taux AS NUMBER(30,5)) AS taux ,
    CAST(fcpl.montanttva AS NUMBER(30,5)) AS montanttva,
    CAST(fcpl.montantht AS NUMBER(30,5)) AS montantht,
    fcpl.tauxdechange,
    CAST(fcpl.montantttc AS NUMBER(30,5))  AS  MONTANTTTC,
    CAST(nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS NUMBER(30,5)) AS MONTANTPAYE,
    CAST(nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0)  AS NUMBER(30,5))  AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF,
    fcpl.IDSERVICELIB,
    fcpl.idtypefacture,
    fcpl.IDFACTUREPRINCIPALE
FROM FACTUREFOURNISSEURCPL fcpl
LEFT JOIN FACTUREFOURNISSEURCPL f2
       ON f2.idfactureprincipale = fcpl.id
WHERE f2.id IS NULL;