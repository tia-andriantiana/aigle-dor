
INSERT INTO MOTIFAVOIRFC (ID, VAL, DESCE) VALUES ('MOTIFRST1', 'Ritsourne', 'Ritsourne');

alter table AS_INGREDIENTS add compte_ristourne varchar2(50);

update AS_INGREDIENTS set compte_ristourne='709110' where id='ING000T0132';

create or replace view AVOIRFC_GRP_TOUS as
select idavoirfc,
       compte,
       cast(sum(montantHT) as NUMBER(30, 2)) as montantHT,
       cast(sum(montantTVA) as NUMBER(30, 2)) as montantTVA,
       cast(sum(montantTTC) as NUMBER(30, 2)) as montantTTC,
       cast(sum(montantHT * TAUXDECHANGE) as NUMBER(30, 2)) as montantHTAR,
       cast(sum(montantTVA * TAUXDECHANGE) as NUMBER(30, 2)) as montantTVAAR,
       cast(sum(montantTTC * TAUXDECHANGE) as NUMBER(30, 2)) as montantTTCAR,
       ETAT,
       max(TAUXDECHANGE) AS TAUXDECHANGE,
       IDPRODUIT
from AVOIR_MF
group by idavoirfc, compte, etat, IDPRODUIT;

create or replace view AVOIRFC_GRP_VISEE as
select * from AVOIRFC_GRP_TOUS where etat >= 11;


