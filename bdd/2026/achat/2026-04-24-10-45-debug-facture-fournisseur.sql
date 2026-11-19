create or replace view FACTUREFOURNISSEURCPL_TOUS as
SELECT SQ."ID",SQ."IDFOURNISSEUR",SQ."IDFOURNISSEURLIB",SQ."IDMODEPAIEMENT",SQ."IDMODEPAIEMENTLIB",SQ."DATY",SQ."DESIGNATION",SQ."DATEECHEANCEPAIEMENT",SQ."ETATLIB",SQ."REFERENCE",SQ."IDBC",SQ."IDMAGASIN",SQ."IDMAGASINLIB",SQ."DEVISE",SQ."IDDEVISE",SQ."ETAT",SQ."TAUX",SQ."MONTANTTVA",SQ."MONTANTHT",SQ."TAUXDECHANGE",SQ."MONTANTTTC",SQ."MONTANTPAYE",SQ."MONTANTRESTE",SQ."IDOBJET",SQ."IDREF",SQ."IDSERVICELIB",SQ."IDTYPEFACTURE",
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(IDMODEPAIEMENT),'') || ' | ' || NVL(TO_CHAR(IDMODEPAIEMENTLIB),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(DATEECHEANCEPAIEMENT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(REFERENCE),'') || ' | ' || NVL(TO_CHAR(IDBC),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(DEVISE),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(TAUX),'') || ' | ' || NVL(TO_CHAR(MONTANTTVA),'') || ' | ' || NVL(TO_CHAR(MONTANTHT),'') || ' | ' || NVL(TO_CHAR(TAUXDECHANGE),'') || ' | ' || NVL(TO_CHAR(MONTANTTTC),'') || ' | ' || NVL(TO_CHAR(MONTANTPAYE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'') || ' | ' || NVL(TO_CHAR(IDOBJET),'') || ' | ' || NVL(TO_CHAR(IDREF),'') || ' | ' || NVL(TO_CHAR(IDSERVICELIB),'')) AS MOTSCLESSS
FROM (
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
             fcpl.IDSERVICELIB,
             fcpl.idtypefacture
         FROM FACTUREFOURNISSEURCPL fcpl

     ) SQ;

