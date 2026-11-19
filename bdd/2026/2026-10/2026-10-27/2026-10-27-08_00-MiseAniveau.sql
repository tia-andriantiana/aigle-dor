ALTER TABLE as_bondecommande ADD COLUMN idcategorie VARCHAR(200);
ALTER TABLE as_bondecommande ADD COLUMN conformite NUMERIC;
ALTER TABLE as_bondecommande ADD COLUMN dateecheancepaiement DATE;

ALTER TABLE as_bondecommande_fille ADD COLUMN designation VARCHAR(100);

ALTER TABLE facturefournisseur ADD COLUMN remise numeric(10, 2);

create table OBSERVATIONBC
(
    ID          VARCHAR(255) not null
        primary key,
    IDBC        VARCHAR(255) not null
        references AS_BONDECOMMANDE,
    OBSERVATION VARCHAR(1000)
);

create view AS_BONDECOMMANDE_FILLE_CPL_U
as
( select
    asbc.*,
       au.val        as "UNITELIB",
       asing.libelle AS PRODUITLIB
FROM AS_BONDECOMMANDE_FILLE asbc LEFT JOIN AS_INGREDIENTS asing ON
    asbc.PRODUIT = asing.ID  left join as_unite au on au.ID = asing.UNITE
    );

create or replace view FACTUREFOURNISSEURFILLEUNITE as
(
SELECT
    f.*,
    au.id AS idunite,
    au.VAL AS idunitelib
FROM
    FACTUREFOURNISSEURFILLE f
        LEFT JOIN AS_INGREDIENTS p
                  ON
                      p.ID = f.IDPRODUIT
        JOIN as_unite au ON
        au.ID = p.UNITE
    );



CREATE TABLE ACHATDIVERS
(
    ID          VARCHAR(255) NOT NULL PRIMARY KEY,
    DATY        DATE,
    FOURNISSEUR VARCHAR(255) REFERENCES FOURNISSEUR(ID),
    DESIGNATION VARCHAR(255),
    ETAT        NUMERIC,
    IDCAISSE    VARCHAR(255) REFERENCES CAISSE(ID)
);


CREATE SEQUENCE SEQACHATDIVERS
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    NO CYCLE
    CACHE 20;


CREATE OR REPLACE FUNCTION getseqachatdivers()
    RETURNS NUMERIC
    LANGUAGE plpgsql
AS $$
DECLARE
    retour NUMERIC;
BEGIN
    SELECT nextval('seqachatdivers') INTO retour;
    RETURN retour;
END;
$$;


CREATE TABLE ACHATDIVERSFILLE
(
    ID          VARCHAR(255) NOT NULL PRIMARY KEY,
    IDMERE      VARCHAR(255) REFERENCES ACHATDIVERS(ID),
    IDPRODUIT   VARCHAR(255),
    DESIGNATION VARCHAR(255),
    QUANTITE    NUMERIC(10, 2),
    PU          NUMERIC(10, 2)
);


CREATE SEQUENCE SEQACHATDIVERSFILLE
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    NO CYCLE
    CACHE 20;


CREATE OR REPLACE FUNCTION getseqachatdiversfille()
    RETURNS NUMERIC
    LANGUAGE plpgsql
AS $$
DECLARE
    retour NUMERIC;
BEGIN
    SELECT nextval('seqachatdiversfille') INTO retour;
    RETURN retour;
END;
$$;


CREATE OR REPLACE VIEW ACHATDIVERSLIB AS
SELECT
    d.ID,
    d.DATY,
    d.FOURNISSEUR,
    d.DESIGNATION,
    d.ETAT,
    d.IDCAISSE,
    c.VAL AS IDCAISSELIB,
    f.NOM AS FOURNISSEURLIB,
    CASE
        WHEN d.ETAT = 0 THEN 'ANNULÉE'
        WHEN d.ETAT = 1 THEN 'CRÉÉE'
        WHEN d.ETAT = 11 THEN 'VISÉE'
        ELSE 'EN COURS'
        END AS ETATLIB,
    (
        SELECT COALESCE(SUM(COALESCE(df.QUANTITE, 0) * COALESCE(df.PU, 0)), 0)
        FROM ACHATDIVERSFILLE df
        WHERE df.IDMERE = d.ID
    ) AS MONTANTTOTAL,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM MOUVEMENTCAISSE mc
            WHERE mc.IDORIGINE = d.ID
               OR mc.IDORIGINE IN (
                SELECT ff.ID
                FROM FACTUREFOURNISSEUR ff
                WHERE ff.IDOBJET = d.ID
                   OR ff.DESIGNATION LIKE '%' || d.ID || '%'
            )
        )
            THEN (
                     SELECT COALESCE(SUM(COALESCE(mc.DEBIT, 0)), 0)
                     FROM MOUVEMENTCAISSE mc
                     WHERE mc.IDORIGINE = d.ID
                        OR mc.IDORIGINE IN (
                         SELECT ff.ID
                         FROM FACTUREFOURNISSEUR ff
                         WHERE ff.IDOBJET = d.ID
                            OR ff.DESIGNATION LIKE '%' || d.ID || '%'
                     )
                 ) - (
                     SELECT COALESCE(SUM(COALESCE(df.QUANTITE, 0) * COALESCE(df.PU, 0)), 0)
                     FROM ACHATDIVERSFILLE df
                     WHERE df.IDMERE = d.ID
                 )
        ELSE 0
        END AS SURPLUSTOTAL,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM MOUVEMENTCAISSE mc
            WHERE mc.IDORIGINE = d.ID
               OR mc.IDORIGINE IN (
                SELECT ff.ID
                FROM FACTUREFOURNISSEUR ff
                WHERE ff.IDOBJET = d.ID
                   OR ff.DESIGNATION LIKE '%' || d.ID || '%'
            )
        )
            THEN (
            SELECT COALESCE(SUM(COALESCE(mc.CREDIT, 0)), 0)
            FROM MOUVEMENTCAISSE mc
            WHERE mc.IDORIGINE = d.ID
               OR mc.IDORIGINE IN (
                SELECT ff.ID
                FROM FACTUREFOURNISSEUR ff
                WHERE ff.IDOBJET = d.ID
                   OR ff.DESIGNATION LIKE '%' || d.ID || '%'
            )
        )
        ELSE 0
        END AS RENDUTOTAL
FROM ACHATDIVERS d
         LEFT JOIN FOURNISSEUR f
                   ON d.FOURNISSEUR = f.ID
         LEFT JOIN CAISSE c
                   ON c.ID = d.IDCAISSE;


CREATE OR REPLACE VIEW ACHATDIVERSFILLELIB AS
SELECT
    d.ID,
    d.IDMERE,
    d.IDPRODUIT,
    d.DESIGNATION,
    d.QUANTITE,
    d.PU,
    ail.LIBELLE AS IDPRODUITLIB,
    COALESCE(d.QUANTITE, 0) * COALESCE(d.PU, 0) AS MONTANT
FROM ACHATDIVERSFILLE d
         LEFT JOIN AS_INGREDIENTS_LIB ail
                   ON d.IDPRODUIT = ail.ID;




-------------------------



delete
from menudynamique
where id_pere = 'MENUDYN0017';
delete
from menudynamique
where id_pere = 'MENUDYN001';

update menudynamique
set libelle = 'Trésorerie'
where id = 'MENUDYN001';

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0017', 'Mouvement de trésorerie', 'list_alt', null, 4, 2, 'MENUDYN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0012', 'Trésorerie', 'point_of_sale', null, 2, 2, 'MENUDYN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0011', 'État de trésorerie', 'list_alt', 'module.jsp?but=caisse/etatcaisse/etatcaisse-liste.jsp', 1, 2,
        'MENUDYN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0015', 'Report de trésorerie', 'account_balance', 'module.jsp?but=caisse/report/reportCaisse-liste.jsp',
        6, 2, 'MENUDYN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0016', 'Virement Intra Trésorerie', 'compare_arrows',
        'module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp', 5, 2, 'MENUDYN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1781523791892897', 'Clôture de trésorerie', 'attach_money', null, 7, 2, 'MENUDYN001');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0014', 'Liste des Trésoreries', 'view_list', 'module.jsp?but=caisse/caisse-liste.jsp', 2, 3,
        'MENUDYN0012');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0012F0001', 'Saisie', 'add', 'module.jsp?but=caisse/caisse-saisie.jsp', 1, 3, 'MENUDYN0012');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN00171', 'Nouvelle Entrée', 'add', 'module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree.jsp', 1, 3,
        'MENUDYN0017');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN00172', 'Liste des mouvements de trésorerie', 'list_alt',
        'module.jsp?but=caisse/mvt/mvtCaisse-liste.jsp', 3, 3, 'MENUDYN0017');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN00173', 'Nouvelle Sortie', 'add', 'module.jsp?but=caisse/mvt/mvtCaisse-saisie-sortie.jsp', 2, 3,
        'MENUDYN0017');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN005161', 'Saisie', 'add', 'module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie.jsp', 1,
        3, 'MENUDYN0016');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0XX0162', 'Liste', 'list_alt',
        'module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp', 2, 3, 'MENUDYN0016');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN005151', 'Saisie', 'add', 'module.jsp?but=caisse/report/reportCaisse-saisie.jsp', 1, 3, 'MENUDYN0015');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENUDYN0690152', 'Liste', 'view_list', 'module.jsp?but=caisse/report/reportCaisse-liste.jsp', 2, 3,
        'MENUDYN0015');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN178152XX3807055733', 'Saisie', 'add', 'module.jsp?but=cloturecaisse/cloturecaisse-saisie.jsp', 1, 3,
        'MENDYN1781523791892897');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1781XX523828159993', 'Liste', 'view_list', 'module.jsp?but=cloturecaisse/cloturecaisse-liste.jsp', 2, 3,
        'MENDYN1781523791892897');


drop view mouvementcaissecpl_annule;
drop view mouvementcaissecpl_cree;
drop view mouvementcaissecpl_valider;
drop view mouvementcaissecpl_nattach;
drop view mouvementcaissecpl_a_valider;
drop view mouvementcaissecpl_v_dispatch;
drop view mouvementcaissecpl_a;
drop view MOUVEMENTCAISSECPL;

CREATE OR REPLACE VIEW MOUVEMENTCAISSECPL AS
(
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL                                    AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       CAST(
               CASE
                   WHEN m.CREDIT > 0 THEN COALESCE(m.CREDIT, 0) - COALESCE(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMERIC(36, 5)
       )                                        AS soldecredit,
       CAST(
               CASE
                   WHEN m.DEBIT > 0 THEN COALESCE(m.DEBIT, 0) - COALESCE(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMERIC(36, 5)
       )                                        AS soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0 THEN 'ANNULÉ'
           WHEN m.ETAT = 1 THEN 'CRÉÉ'
           WHEN m.ETAT = 11 THEN 'VISÉ'
           WHEN m.ETAT = 8 THEN 'À COMPTABILISER'
           END                                  AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE                              AS idorigine,
       m.IDTIERS,
       t.NOM                                    AS tiers,
       m.IDPREVISION,
       m.IDOP,
       m.TAUX,
       m.COMPTE,
       m.IDDEVISE,
       m.IDTRAITE,
       mp.VAL                                   AS idModePaiementLib,
       m.IDMVTCAISSEMERE,
       m.REFERENCE,
       m.DATYCOMPTABILISATION,
       m.UPDATED_AT,
       m.HEURE,
       m.IDREPORT,
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' ||
       t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS,
       ce.ID                                    AS idecriture
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c
                   ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd
                   ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN TIERS t
                   ON t.ID = m.IDTIERS
         LEFT JOIN LIAISONPAIEMENTMVTCAISSEGRP l
                   ON l.IDMVTCAISSE = m.ID
         LEFT JOIN MODEPAIEMENT mp
                   ON m.IDMODEPAIEMENT = mp.ID
         LEFT JOIN COMPTA_ECRITURE ce
                   ON ce.IDOBJET = m.ID);



create or replace view mouvementcaissecpl_annule as
(
select *
from mouvementcaissecpl
where ETAT = 0 );

create or replace view mouvementcaissecpl_cree as
(
select *
from mouvementcaissecpl
where ETAT = 1 );

create or replace view mouvementcaissecpl_valider as
(
select *
from mouvementcaissecpl
where ETAT = 11 );

create view mouvementcaissecpl_nattach
as
(
SELECT m.id,
       m.designation,
       m.idcaisse,
       m.idcaisselib,
       m.idventedetail,
       m.idvirement,
       m.debit,
       m.credit,
       m.daty,
       m.etat,
       m.etatlib,
       m.idvente,
       m.idorigine,
       m.idtiers,
       m.tiers,
       m.idprevision,
       m.idop,
       m.taux,
       m.compte,
       m.iddevise
FROM mouvementcaissecpl m
WHERE NOT (EXISTS (SELECT mvp.id
                   FROM mvtcaisseprevision mvp
                   WHERE mvp.id1::text = m.id::text))
  AND m.etat >= 11::numeric
    );

create view mouvementcaissecpl_a_valider
as
(
SELECT m.id,
       m.designation,
       m.idcaisse,
       m.idcaisselib,
       m.idventedetail,
       m.idvirement,
       m.debit,
       m.credit,
       m.daty,
       m.etat,
       m.etatlib,
       m.idvente,
       m.idorigine,
       m.idtiers,
       m.tiers,
       m.datycomptabilisation
FROM mouvementcaissecpl m
WHERE m.datycomptabilisation IS NULL
  AND m.etat > 7::numeric
  AND m.etat < 11::numeric
    );

create view mouvementcaissecpl_v_dispatch
as
(
SELECT m.id,
       m.designation,
       m.idcaisse,
       m.idcaisselib,
       m.idventedetail,
       m.idvirement,
       m.debit,
       m.credit,
       lp.montant    AS montantimpute,
       m.daty,
       m.etat,
       m.etatlib,
       m.idvente,
       lp.id2        AS idorigine,
       m.idtiers,
       m.tiers,
       lp.id1        AS idpaiement,
       m.reference   AS referencepaiement,
       m.designation AS designationpaiement
FROM liaisonpaiement lp
         LEFT JOIN mouvementcaissecpl m ON m.id::text = lp.id1::text
WHERE m.etat > 7::numeric);


create view mouvementcaissecpl_a
as
(
SELECT m.id,
       m.designation,
       m.idcaisse,
       m.idcaisselib,
       m.idventedetail,
       m.idvirement,
       m.debit,
       m.credit,
       m.daty,
       m.etat,
       m.etatlib,
       m.idvente,
       m.idorigine,
       m.idtiers,
       m.tiers
FROM mouvementcaissecpl m
WHERE m.etat = 8::numeric
    );

alter table reportcaisse
    add column idOrigine varchar(255);

drop view reportcaisse_cpl;
drop view reportcaisselib_annule;
drop view reportcaisselib_cree;
drop view reportcaisselib_valider;
drop view ouverturecaisse_cpl;
drop view REPORTCAISSELIB;

create or replace view reportcaisse_cpl (id, idcaisse, caisselib, montant, montanttheorique, daty, etat, heure, etatlib, iduser) as
(
SELECT r.id,
       r.idcaisse,
       c.val                              AS caisselib,
       r.montant::numeric(30, 5)          AS montant,
       r.montanttheorique::numeric(30, 5) AS montanttheorique,
       r.daty,
       r.etat,
       r.heure,
       CASE
           WHEN r.etat = 0::numeric THEN 'annulee'::text
           WHEN r.etat = 1::numeric THEN 'cree'::text
           WHEN r.etat = 11::numeric THEN 'validee'::text
           ELSE NULL::text
           END                            AS etatlib,
       r.iduser
FROM reportcaisse r
         LEFT JOIN caisse c ON c.id::text = r.idcaisse::text
    );

create or replace view reportcaisselib_cree (id, idcaisse, idcaisselib, montant, montanttheorique, daty, etat, etatlib) as
(
SELECT v.id,
       v.idcaisse,
       v.idcaisselib,
       v.montant,
       v.montanttheorique,
       v.daty,
       v.etat,
       v.etatlib
FROM reportcaisselib v
WHERE v.etat = 1::numeric
    );

create or replace view reportcaisselib_annule (id, idcaisse, idcaisselib, montant, montanttheorique, daty, etat, etatlib) as
(
SELECT v.id,
       v.idcaisse,
       v.idcaisselib,
       v.montant,
       v.montanttheorique,
       v.daty,
       v.etat,
       v.etatlib
FROM reportcaisselib v
WHERE v.etat = 0::numeric
    );

create or replace view reportcaisselib_valider (id, idcaisse, idcaisselib, montant, montanttheorique, daty, etat, etatlib) as
(
SELECT v.id,
       v.idcaisse,
       v.idcaisselib,
       v.montant,
       v.montanttheorique,
       v.daty,
       v.etat,
       v.etatlib
FROM reportcaisselib v
WHERE v.etat = 11::numeric
    );

create or replace view ouverturecaisse_cpl as
(
SELECT e.id,
       e.idcaisse,
       e.idcaisselib,
       e.montant,
       e.montanttheorique,
       e.daty,
       e.etat,
       e.heure,
       e.etatlib,
       e.typereport,
       t.val AS typereportlib
FROM reportcaisselib e
         LEFT JOIN typereport t ON t.id::text = e.typereport::text
    )
;

CREATE OR REPLACE VIEW REPORTCAISSELIB AS
(
SELECT r.ID,
       r.IDCAISSE,
       c.VAL                                                  AS IDCAISSELIB,
       CAST(r.MONTANT AS NUMERIC(30, 5))                      AS MONTANT,
       CAST(r.MONTANTTHEORIQUE AS NUMERIC(30, 5))             AS MONTANTTHEORIQUE,
       CAST(r.MONTANT - r.MONTANTTHEORIQUE AS NUMERIC(30, 5)) AS ecartCalc,
       r.DATY,
       r.ETAT,
       r.HEURE,
       CASE
           WHEN r.ETAT = 0 THEN 'Annulé'
           WHEN r.ETAT = 1 THEN 'Créé'
           WHEN r.ETAT = 11 THEN 'Validé'
           END                                                AS ETATLIB,
       r.MONTANTTHEORIQUE - r.MONTANT                         AS ecart,
       r.REMARQUE,
       r.typereport
FROM REPORTCAISSE r
         LEFT JOIN CAISSE c
                   ON c.ID = r.IDCAISSE
    );

create table BILLET
(
    ID    VARCHAR(100) not null
        primary key,
    VAL   VARCHAR(255),
    DESCE VARCHAR(255)
);

