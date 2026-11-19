create or replace view DECLARATIONTVALIB as
SELECT
    de.id,
    de.designation,
    de.datyDebut,
    de.datyFin,
    de.etat,
    CASE
        WHEN de.etat = 1 THEN 'Cree'
        WHEN de.etat = 11 THEN 'Valide'
        ELSE 'Inconnu'
        END AS etatLib,
    nvl(mv.DEBIT,0) as montantpayer,
    case
        when mv.IDORIGINE is null then 'Non payé'
        else 'Payé'
        END as payementLib
FROM DeclarationTVA de left join FACTUREDECLARATION fd on de.id=fd.IDOBJET left join mouvementcaisse mv on mv.IDORIGINE=fd.id
    /

