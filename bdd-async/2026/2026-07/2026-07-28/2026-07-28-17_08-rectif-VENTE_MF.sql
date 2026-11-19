create or replace view VENTE_MF as
select vd.ID,vd.IDVENTE,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,
       v.DESIGNATION,
       v.IDMAGASIN,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.IDCLIENT,
       vd.compte,
       cast((PU * qte* (1-(nvl(vd.REMISE,0)/100))) as NUMBER(30, 2)) as montantHT,
       cast((PU * qte* (1-(nvl(vd.REMISE,0)/100)) *(tva/100)) as NUMBER(30, 2)) as montantTVA,
       cast(PU * qte* (1-(nvl(vd.REMISE,0)/100)) + (PU * qte* (1-(nvl(vd.REMISE,0)/100)) * (tva/100))  as NUMBER(30, 2)) as montantTTC,
       vd.TAUXDECHANGE AS tauxdechange,
       v.IDRESERVATION
from VENTE_DETAILS vd
         left outer join VENTE V on V.ID = vd.IDVENTE;