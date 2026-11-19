-- SOCOBISPROD2906.FACTUREFOURNISSEURCPL_TOUS source

CREATE OR REPLACE  VIEW "FACTUREFOURNISSEURCPL_TOUS" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "IDMAGASINLIB", "DEVISE", "IDDEVISE", "ETAT", "TAUX", "MONTANTTVA", "MONTANTHT", "TAUXDECHANGE", "MONTANTTTC", "MONTANTPAYE", "MONTANTRESTE", "IDOBJET", "IDREF", "IDSERVICELIB", "IDTYPEFACTURE","IDFACTUREPRINCIPALE") AS 
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

    
 
 ;