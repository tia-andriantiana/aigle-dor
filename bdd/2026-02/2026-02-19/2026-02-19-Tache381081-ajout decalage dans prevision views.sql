create or replace view PREVISION_CPL as
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
    p.dureeretard
from PREVISION p
left join caisse c on p.idcaisse = c.id
left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
left join vente v2 on v2.id=v.IDVENTE
left join ORDONNERPAIEMENT o on o.id=p.IDOP
left join devise d on d.id=p.IDDEVISE;

create or replace view PREVISION_COMPLET_CPL as
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
    p.COMPTE,
    NVL(pe.effectifDeb,0) AS effectifDebit,
    NVL(pe.effectifCred,0) AS effectifCredit,
    p.debit - NVL(pe.effectifDeb,0) AS depenseEcart,
    p.credit - NVL(pe.effectifCred,0) AS recetteEcart,
    p.idfacture,
    COALESCE(v.IDVENTE, f.IDFACTUREFOURNISSEUR) AS idfacturemere,
    p.DATEINITIAL,
    p.DUREERETARD
FROM PREVISION_CPL p
         LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
         LEFT JOIN VENTE_DETAILS v ON v.id = p.idfacture
         LEFT JOIN FACTUREFOURNISSEURFILLE f ON f.id = p.idfacture;
