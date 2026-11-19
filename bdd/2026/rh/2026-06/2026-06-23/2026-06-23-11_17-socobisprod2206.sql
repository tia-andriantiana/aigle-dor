-- bdd
--
--creer view : PAIE_MODEPAIEMENT 
--
--fa ny ligne tokony ho ao 
--
--Chèque 
--
--Espèce 
--
--Virement 
--
--miainga @ MODEPAIEMENT
--
--pushena makato ny script socobis\bdd\2026\rh\2026-06\2026-06-23

CREATE VIEW PAIE_MODEPAIEMENT
AS 
SELECT 
*
FROM MODEPAIEMENT m 
WHERE m.id IN ('0001',
'0002',
'0003');