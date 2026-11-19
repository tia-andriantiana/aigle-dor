alter table RistourneDetails add QTE NUMBER;
alter table RistourneDetails add     PU      NUMBER(30, 5);

create or replace view RISTOURNEDETAILS_LIB as
SELECT
    r.Id,
    r.idristourne,
    r.idproduit,
    r.taux1,
    r.taux2,
    r.idorigine,
    ai.libelle AS idproduitlib,
    r.QTE,
    r.PU
FROM RISTOURNEDETAILS r
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=r.idproduit;
