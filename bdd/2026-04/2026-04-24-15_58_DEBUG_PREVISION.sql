CREATE OR REPLACE VIEW PREVISION_COMPLET_CPL AS
SELECT
    SQ."ID", SQ."DESIGNATION", SQ."IDCAISSE", SQ."IDCAISSELIB", SQ."IDVENTEDETAIL",
    SQ."IDVENTE", SQ."IDVENTELIB", SQ."IDVIREMENT", SQ."DEBIT", SQ."CREDIT",
    SQ."DATY", SQ."ETAT", SQ."IDOP", SQ."IDOPLIB", SQ."IDORIGINE",
    SQ."IDDEVISE", SQ."IDDEVISELIB", SQ."TAUX", SQ."IDTIERS", -- Ajout ici
    SQ."COMPTE", SQ."EFFECTIFDEBIT", SQ."EFFECTIFCREDIT", SQ."DEPENSEECART",
    SQ."RECETTEECART", SQ."IDFACTURE", SQ."IDFACTUREMERE",SQ."IDTIERSLIB",
    (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DESIGNATION),'') || ' | ' || NVL(TO_CHAR(IDCAISSE),'') || ' | ' || NVL(TO_CHAR(IDCAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDVENTEDETAIL),'') || ' | ' || NVL(TO_CHAR(IDVENTE),'') || ' | ' || NVL(TO_CHAR(IDVENTELIB),'') || ' | ' || NVL(TO_CHAR(IDVIREMENT),'') || ' | ' || NVL(TO_CHAR(DEBIT),'') || ' | ' || NVL(TO_CHAR(CREDIT),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(IDOP),'') || ' | ' || NVL(TO_CHAR(IDOPLIB),'') || ' | ' || NVL(TO_CHAR(IDORIGINE),'') || ' | ' || NVL(TO_CHAR(IDDEVISE),'') || ' | ' || NVL(TO_CHAR(IDDEVISELIB),'') || ' | ' || NVL(TO_CHAR(TAUX),'') || ' | ' || NVL(TO_CHAR(IDTIERS),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(EFFECTIFDEBIT),'') || ' | ' || NVL(TO_CHAR(EFFECTIFCREDIT),'') || ' | ' || NVL(TO_CHAR(DEPENSEECART),'') || ' | ' || NVL(TO_CHAR(RECETTEECART),'') || ' | ' || NVL(TO_CHAR(IDFACTURE),'') || ' | ' || NVL(TO_CHAR(IDTIERSLIB),'') || ' | ' || NVL(TO_CHAR(IDFACTUREMERE),'')) AS MOTSCLESSS
FROM (
         SELECT
             p.ID,
             p.DESIGNATION,
             p.IDCAISSE,
             p.IDCAISSELIB,
             p.IDVENTEDETAIL,
             p.IDVENTE,
             p.IDVENTELIB,
             p.IDVIREMENT,
             p.DEBIT,
             p.CREDIT,
             p.DATY,
             p.ETAT,
             p.IDOP,
             p.IDOPLIB,
             p.IDORIGINE,
             p.IDDEVISE,
             p.IDDEVISELIB,
             p.TAUX,
             p.IDTIERS,
             t.NOM as IDTIERSLIB,
             p.COMPTE,
             NVL(pe.effectifDeb,0) AS effectifDebit,
             NVL(pe.effectifCred,0) AS effectifCredit,
             p.debit - NVL(pe.effectifDeb,0) AS depenseEcart,
             p.credit - NVL(pe.effectifCred,0) AS recetteEcart,
             p.idfacture,
             COALESCE(v.IDVENTE, f.IDFACTUREFOURNISSEUR) AS idfacturemere
         FROM PREVISION_CPL p
                  LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
                  LEFT JOIN VENTE_DETAILS v ON v.id = p.idfacture
                  LEFT JOIN FACTUREFOURNISSEURFILLE f ON f.id = p.idfacture
                  LEFT JOIN TIERS t ON t.id = p.IDTIERS
     ) SQ;