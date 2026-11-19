alter table CAISSE add estRib number(1) default 0;
 
update CAISSE set estRib = 1 , DESCE = '00009 07500 10018080006 96' where id = 'CAISB017'; -- BOA
update CAISSE set estRib = 1 , DESCE = '00008 00008 21010073423 17' where id = 'CAI000229'; --BRED
update CAISSE set estRib = 1 , DESCE = '00005 00001 01462790100 32' where id = 'CAISB003'; --BNI
update CAISSE set estRib = 1 , DESCE = '00004 00001 01520600125 32 ' where id = 'CAISB019'; -- BMOI