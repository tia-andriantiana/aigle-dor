create or replace view FACTUREFOURNISSEURCPL as
SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM  AS IDFOURNISSEURLIB,
    f.IDMODEPAIEMENT,
    m.VAL   AS IDMODEPAIEMENTLIB,
    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,
    f.ETAT,
    CASE
        WHEN f.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN f.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT = 11
            THEN 'VIS&Eacute;E'
        END AS ETATLIB,
    reff.reference,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    case
        when f.TAUX=0 then 1
        else f.TAUX
        end as taux,
    p.VAL   AS idMagasinLib,
    f3.IDDEVISE,
    cast(f3.MONTANTTVA as number(30,5)) as MONTANTTVA,
    CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,5)) AS MONTANTHT,
    cast(f3.MONTANTTTC as number(30,5)) as montantttc,
    cast(f3.MONTANTTTC*f3.tauxdechange as number(30,5)) as MONTANTTTCAR,
    cast(nvl(mv.debit,0) AS number(30,5)) AS montantpaye,
    cast(f3.MONTANTTTC-nvl(mv.debit,0) AS number(30,5)) AS montantreste,
    cast(nvl(f3.tauxdechange,0) AS  number(30,5)) AS tauxdechange,
    prev.id as idPrevision,
    CASE
        WHEN f.estprevu=0 THEN 'NON'
        ELSE 'OUI'
        END
        AS estprevulib,
    f.IDOBJET,
    f.IDREF,
    f.IDTYPEFACTURE,
    tf.VAL as typefacture,
    f.numero,
    f.typeachat,
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE,
    f.TYPEFACTUREFOURNISSEUR,
    tff.DESCE AS TYPEFACTUREFOURNISSEURLIB
FROM FACTUREFOURNISSEUR f
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
    LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE
    LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
    LEFT JOIN referencefacture reff ON f.id=reff.idfacture
    LEFT JOIN typefacturefournisseur tff ON tff.id = f.TYPEFACTUREFOURNISSEUR;