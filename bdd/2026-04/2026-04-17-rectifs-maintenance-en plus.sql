
CREATE OR REPLACE  VIEW ATTRIBUTIONELEMENTLIB AS
select
    attr."ID",attr."IDINGREDIENTMAINTENANCE",attr."IDPERSONNEL",attr."DATY",attr."ETATELEMENT",attr."TYPEATTRIBUTION",
    asing.LIBELLE as IDINGREDIENTMAINTENANCELIB,
    pers.NOM as idPersonnelLib,
    qom.VAL as qualiteObjetMaintenanceLib,
    case
        when attr.TYPEATTRIBUTION = 0 then 'Sortie'
        when attr.TYPEATTRIBUTION = 1 then 'Retour'
        else 'Inconnu'
        end as typeAttributionLib,
    attr.qte AS qte,
    attr.etat,
    case
        when attr.etat = 1 then 'CR&Eacute;&Eacute;E'
        when attr.etat = 11 then 'VIS&Eacute;E'
        when attr.etat = 0 then 'ANNUL&Eacute;E'
        end as etatLib,
    attr.id || asing.libelle || pers.nom || qom.val AS motsclesss
from
    ATTRIBUTIONELEMENT attr
        left join AS_INGREDIENT_MAINTENANCE ingm on attr.IDINGREDIENTMAINTENANCE = ingm.ID
        left join AS_INGREDIENTS asing on ingm.IDINGREDIENT = asing.ID
        left join PERSONNEL pers on attr.IDPERSONNEL = pers.ID
        left join QUALITESOBJETMAINTENANCE qom on attr.ETATELEMENT = qom.ID
;