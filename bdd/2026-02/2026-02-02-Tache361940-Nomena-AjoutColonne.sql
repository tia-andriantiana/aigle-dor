
alter table facturefournisseurfille
    ADD idprevision varchar(50);

create or replace view FFFILLECPL_VISEE as
SELECT
    f.ID ,
    f.IDFACTUREFOURNISSEUR ,
    f.IDPRODUIT ,
    nvl(i.LIBELLE,p.LIBELLE) AS IDPRODUITLIB,
    f.QTE ,
    f.PU ,
    f.REMISES ,
    f.IDBCDETAIL ,
    f.TVA ,
    f.IDDEVISE,
    f2.DATY,
    CAST(f.QTE * f.PU AS NUMBER(30,2)) AS montantht,
    CAST(f.QTE * f.PU + (f.QTE * f.PU * f.TVA/100) AS NUMBER(30,2)) AS montantttc,
    CAST(f.QTE * f.PU * f.TVA/100 AS NUMBER(30,2)) AS montanttva,
    CAST((nvl(f.remises/100,0))*(f.QTE * f.PU) AS NUMBER(30,2)) AS montantRemise,
    CAST((1-nvl(f.remises/100,0))*(f.QTE * f.PU) AS NUMBER(30,2)) AS montant,
    f.idprevision
FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2 ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p ON p.ID = f.IDPRODUIT
         LEFT JOIN AS_INGREDIENTS i ON i.ID = f.IDPRODUIT
where f2.ETAT >= 11;

