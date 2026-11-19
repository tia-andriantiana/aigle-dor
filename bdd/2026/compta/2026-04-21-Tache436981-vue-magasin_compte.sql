create or replace  view  MAGASIN_COMPTE_CPL as
select m.*, c.LIBELLE as nomCompte
from MAGASIN_COMPTE m
         left join COMPTA_COMPTE c on m.DESCE = c.COMPTE;