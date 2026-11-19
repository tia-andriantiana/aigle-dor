CREATE VIEW COMPTA_JOURNAL_MOTSCLESSS (ID,VAL,DESCE,COMPTE,MOTSCLESSS)
AS SELECT 
cj.ID,
cj.VAL,
cj.DESCE,
cj.COMPTE,
cj.id || '' || cj.val || '' || cj.desce || '' || cj.compte AS motsclesss
FROM COMPTA_JOURNAL cj;