create or replace view inventaireFilleVide as
    select 'invvidef'||mfv.ID as id,'invVide' as idinventaire,mfv.IDPRODUIT,'inv Auto Vide' as explication,null as idjauge,cast( 0 as number(30,10)) as QUANTITETHEORIQUE,cast(0 as number(30,10)) as quantite,mfv.ID as mvtsource
         ,cast(1 as number(30,5)) as pu,null as idfournisseur, null as daty from mvtStockFilleSansInventaire mfv;