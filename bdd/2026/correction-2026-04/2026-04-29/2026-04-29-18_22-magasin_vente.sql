INSERT INTO POINT (ID, VAL, DESCE) VALUES ('PNTVNT001', 'Vente', 'Vente');

update MAGASIN2 set idpoint='PNTVNT001' where id='MAGAPPRO1' OR id='PHARM005';

create or replace view MagasinVente as select * from MAGASIN2 where IDPOINT = 'PNTVNT001';