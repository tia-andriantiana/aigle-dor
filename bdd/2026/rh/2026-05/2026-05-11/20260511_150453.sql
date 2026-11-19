

UPDATE DEMANDE SET IDTYPEABSENCE='TYP000004' WHERE IDTYPEABSENCE='TYP000006';

UPDATE TYPEABSENCE SET VAL = 'Formation syndicale', DESCE = 'Formation syndicale' where id='TYPCOL0005';
UPDATE TYPEABSENCE SET VAL = 'Maternité', DESCE = 'Maternité' where id='TYP00MAT';
UPDATE TYPEABSENCE SET VAL = 'Evénement familial', DESCE = 'Evénement familial' where id='TYP000006';
UPDATE TYPEABSENCE SET VAL = 'Permission', DESCE = 'Permission' where id='TYP000003';
UPDATE TYPEABSENCE SET VAL = 'Congé', DESCE = 'Congé' where id='TYP000004';

