ALTER TABLE travaux
    ADD dureeestimatif NUMBER(10,0);

CREATE OR REPLACE VIEW "SERVICEMAINTENANCE" ("ID", "VAL", "DESCE") AS
SELECT
    LOG_SERVICE.id,
    LOG_SERVICE.libelle AS val,
    LOG_SERVICE.libelle AS desce
FROM LOG_SERVICE
WHERE
    id LIKE 'SERVM%';

ALTER TABLE LOG_PERSONNEL
    ADD telephone NUMBER(10,0);

CREATE TABLE ATTRIBUTIONELEMENT
(	"ID" VARCHAR2(255),
     "IDINGREDIENTMAINTENANCE" VARCHAR2(255),
     "IDPERSONNEL" VARCHAR2(255),
     "DATY" DATE NOT NULL ENABLE,
     "ETATELEMENT" VARCHAR2(255),
     "TYPEATTRIBUTION" NUMBER DEFAULT 0,
     "QTE" NUMBER DEFAULT 0,
     "ETAT" NUMBER DEFAULT 0,
     CONSTRAINT "PK_ATTRIBUTIONELEMENT" PRIMARY KEY ("ID")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
         STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
         PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
         TABLESPACE "USERS"  ENABLE,
     CONSTRAINT "FK_ATTRELEMENT_ING" FOREIGN KEY ("IDINGREDIENTMAINTENANCE")
         REFERENCES AS_INGREDIENT_MAINTENANCE ("ID") ENABLE,
     CONSTRAINT "FK_ATTRELEMENT_PERS" FOREIGN KEY ("IDPERSONNEL")
         REFERENCES LOG_PERSONNEL ("ID") ENABLE,
     CONSTRAINT "FK_ATTRIBUTIONELEMENT_ETAT" FOREIGN KEY ("ETATELEMENT")
         REFERENCES QUALITESOBJETMAINTENANCE ("ID") ENABLE
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE(INITIAL 327680 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "USERS" ;

ALTER TABLE ATTRIBUTIONELEMENT
DROP CONSTRAINT "FK_ATTRELEMENT_PERS";

ALTER TABLE ATTRIBUTIONELEMENT
    ADD CONSTRAINT "FK_ATTRELEMENT_PERS"
        FOREIGN KEY ("IDPERSONNEL")
            REFERENCES LOG_PERSONNEL ("ID")
    ENABLE;

ALTER Table DEMANDETRAVAUX
    ADD "IDDEPARTEMENTMAINTENANCE" VARCHAR2(100);

ALTER TABLE DEMANDETRAVAUX
    ADD "IDDEPARTEMENT" VARCHAR2(255);

ALTER TABLE DEMANDETRAVAUX
    ADD "IDPLANNING" VARCHAR2(40);

ALTER TABLE AS_INGREDIENT_MAINTENANCE
    ADD "LIBELLE" VARCHAR2(255);

ALTER TABLE AS_INGREDIENT_MAINTENANCE
    ADD pu number(30,2);

ALTER TABLE AS_INGREDIENT_MAINTENANCE
    ADD "DATEAQUISITION" DATE;

ALTER TABLE AS_INGREDIENT_MAINTENANCE
    ADD "IDLIGNE" VARCHAR2(40);

CREATE OR REPLACE VIEW DEMANDETRAVAUX_CPL AS
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.id AS IDDEPARTEMENTMAINTENANCE,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.val AS IDDEPARTEMENTLIB,
    otf.ID AS idOtFille,
    pl.idtypemaintenance AS idtypemaintenance,
    tm.val AS idtypemaintenancelib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN DEPARTEMENT departement ON departement.id=dmd.iddepartement
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN PLANNING pl ON pl.id=dmd.idplanning
         LEFT JOIN TYPEMAINTENANCE tm ON tm.id=pl.idtypemaintenance;


CREATE OR REPLACE VIEW "DEMANDETRAVAUX_CPL_NOMBRE" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "IDENTITELIB", "IDSITUATIONLIB", "IDMACHINELIB", "ESTEXISTANTLIB", "ETATLIB", "IDDEPARTEMENTMAINTENANCE", "IDDEPARTEMENTMAINTENANCELIB", "PRIORITELIB", "IDDEPARTEMENTLIB", "IDOTFILLE", "QTE") AS
SELECT
    ID,
    IDENTITE,
    IDSITUATION,
    IDMACHINE,
    DATY,
    DATEBESOIN,
    PRIORITE,
    ESTEXISTANT,
    DESCRIPTION,
    ETAT,
    IDDEPARTEMENT,
    IDENTITELIB,
    IDSITUATIONLIB,
    IDMACHINELIB,
    ESTEXISTANTLIB,
    ETATLIB,
    IDDEPARTEMENTMAINTENANCE,
    IDDEPARTEMENTMAINTENANCELIB,
    PRIORITELIB,
    IDDEPARTEMENTLIB,
    IDOTFILLE,
    COUNT(*) AS qte
FROM DEMANDETRAVAUX_CPL
GROUP BY
    ID,
    IDENTITE,
    IDSITUATION,
    IDMACHINE,
    DATY,
    DATEBESOIN,
    PRIORITE,
    ESTEXISTANT,
    DESCRIPTION,
    ETAT,
    IDDEPARTEMENT,
    IDENTITELIB,
    IDSITUATIONLIB,
    IDMACHINELIB,
    ESTEXISTANTLIB,
    ETATLIB,
    IDDEPARTEMENTMAINTENANCE,
    IDDEPARTEMENTMAINTENANCELIB,
    PRIORITELIB,
    IDDEPARTEMENTLIB,
    IDOTFILLE
ORDER BY qte DESC ;








CREATE OR REPLACE VIEW "PLANNING_CPL" ("ID", "REFOBJET", "ESTPERIODIQUE", "IDTYPEMAINTENANCE", "IDMACHINE", "UNITE", "FREQUENCE", "DATEDEBUT", "DATEFIN", "DUREE", "ETAT", "HEURE", "IDSOURCE", "IDMACHINELIB", "IDTYPEMAINTENANCELIB", "ESTPERIODIQUELIB", "ETATLIB", "UNITELIB", "PRIORITE", "PRIORITELIB", "IDDEMANDETRAVAUX", "IDORDRETRAVAUX", "IDORDRETRAVAUXFILLE", "IDTRAVAUX", "IDENTITE", "IDENTITELIB", "ETATDEMANDETRAVAUX", "ETATORDRETRAVAUX", "ETATTRAVAUX", "ETATDEMANDETRAVAUXLIB", "ETATORDRETRAVAUXLIB", "ETATTRAVAUXLIB", "COUT") AS
SELECT
    p.ID,
    p.REFOBJET,
    p.ESTPERIODIQUE,
    p.IDTYPEMAINTENANCE,
    p.IDMACHINE,
    p.UNITE,
    p.FREQUENCE,
    p.DATEDEBUT,
    p.DATEFIN,
    p.DUREE,
    p.ETAT,
    p.HEURE,
    p.IDSOURCE,
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    d.etat AS etatdemandetravaux,
    o.etat AS etatordretravaux,
    tr.etat AS etattravaux,
    CASE d.etat
        WHEN 1  THEN 'Creee'
        WHEN 11 THEN 'Visee'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Creee'
        WHEN 11 THEN 'Visee'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Creee'
        WHEN 11 THEN 'Visee'
        WHEN 21 THEN 'Entamee'
        WHEN 41 THEN 'Terminee'
        ELSE 'Aucun'
        END AS etatTravauxLib,
    coalesce(SUM(fff.pu * fff.qte), 0) AS cout
FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE = otf.id
         LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE = tr.ID
         LEFT JOIN ENTITE e ON e.id = aim.IDENTITE
         LEFT JOIN FACTUREFOURNISSEUR f ON f.IDREF = tr.id
         LEFT JOIN FACTUREFOURNISSEURFILLE fff ON fff.IDFACTUREFOURNISSEUR = f.ID

GROUP BY
    p.ID, p.REFOBJET, p.ESTPERIODIQUE, p.IDTYPEMAINTENANCE, p.IDMACHINE, p.UNITE,
    p.FREQUENCE, p.DATEDEBUT, p.DATEFIN, p.DUREE, p.ETAT, p.HEURE, p.IDSOURCE,
    ai.LIBELLE, t.VAL, u.VAL,
    d.priorite, d.prioritelib, d.id, d.etat,
    o.id, o.etat,
    otf.id,
    tr.id, tr.etat,
    e.id, e.val ;



CREATE OR REPLACE VIEW "FACTUREFOURNISSEURAVECMACHINE" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "IDPREVISION", "ESTPREVULIB", "IDOBJET", "IDREF", "IDOBJETLIB", "IDENTITE") AS
SELECT f.ID,
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
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       machine.LIBELLE AS idObjetLib,
       machine.IDENTITE
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         JOIN AS_INGREDIENT_MAINTENANCE machine ON machine.ID = f.IDOBJET ;


CREATE OR REPLACE VIEW V_DUREE_REELLE_TRAVAUX ("REFOBJET", "OBJET", "ACTION", "DATEHISTORIQUE", "HEURE", "DUREE_HEURES_DECIMALE", "ECART") AS
SELECT
    p.REFOBJET,
    p.OBJET,
    p.ACTION,
    p.DATEHISTORIQUE,
    p.HEURE,
    CASE
        WHEN p.HEURE IS NOT NULL THEN
            TO_NUMBER(SUBSTR(p.HEURE, 1, INSTR(p.HEURE, ':') - 1)) +
            (TO_NUMBER(SUBSTR(p.HEURE, INSTR(p.HEURE, ':') + 1)) / 60)
        ELSE NULL
        END AS DUREE_HEURES_DECIMALE,
    p.ECART
FROM PROCESS p
WHERE p.REFOBJET IS NOT NULL;

CREATE OR REPLACE VIEW V_DUREE_AGREGEE_TRAVAUX ("REFOBJET", "DUREE_REELLE_TOTAL_HEURES", "ECART_ENREGISTRE") AS
SELECT
    REFOBJET,
    SUM(DUREE_HEURES_DECIMALE) AS DUREE_REELLE_TOTAL_HEURES,
    MAX(ECART) AS ECART_ENREGISTRE
FROM V_DUREE_REELLE_TRAVAUX
GROUP BY REFOBJET;

CREATE OR REPLACE VIEW "V_DUREE_TRAVAUX_MACHINE" ("IDINGREDIENTS", "DESCRIPTIONOBJET", "DATY", "ID_TRAVAUX", "DUREE_ESTIMATIVE_HEURES", "DUREE_REELLE_HEURES", "ECART_HEURES", "ECART_POURCENTAGE", "ECART_ENREGISTRE", "IDENTITE") AS
SELECT
    CASE
        WHEN aim.id IS NULL THEN ai.id
        ELSE aim.id
        END AS idIngredients,
    CASE
        WHEN aim.libelle IS NULL THEN ai.descriptionObjet
        ELSE aim.libelle
        END AS DESCRIPTIONOBJET,
    t.DATY,
    t.ID AS ID_TRAVAUX,
    NVL(t.DUREEESTIMATIF, 0) AS DUREE_ESTIMATIVE_HEURES,
    COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) AS DUREE_REELLE_HEURES,
    COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) - COALESCE (t.DUREEESTIMATIF, 0) AS ECART_HEURES,
    CASE
        WHEN t.DUREEESTIMATIF > 0 THEN
            ROUND(((COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) - t.DUREEESTIMATIF) / t.DUREEESTIMATIF) * 100, 2)
        ELSE NULL
        END AS ECART_POURCENTAGE,
    vd.ECART_ENREGISTRE,
    ai.idEntite AS idEntite
FROM ORDRETRAVAUXFILLE o
         LEFT JOIN as_ingredient_maintenance ai
                   ON o.IDINGREDIENTS = ai.ID
         LEFT JOIN AS_INGREDIENTS aim
                   ON ai.IDINGREDIENT = aim.ID
         JOIN TRAVAUX t
              ON o.id = t.IDOFFILLE
         LEFT JOIN V_DUREE_AGREGEE_TRAVAUX vd
                   ON vd.REFOBJET = t.ID ;

CREATE OR REPLACE VIEW "DUREETRAVAUXMACHINE" ("IDMACHINE", "NOMMACHINE", "DATY", "IDTRAVAUX", "DUREEESTIMATIF", "DUREE", "ECART", "IDENTITE") AS
SELECT
    IDINGREDIENTS AS idMachine,
    DESCRIPTIONOBJET AS nomMachine,
    DATY,
    ID_TRAVAUX AS idTravaux,
    DUREE_ESTIMATIVE_HEURES AS DureeEstimatif ,
    DUREE_REELLE_HEURES as Duree ,
    ECART_HEURES AS ecart,
    IDENTITE AS IDENTITE
FROM V_DUREE_TRAVAUX_MACHINE
ORDER BY DATY DESC ;

CREATE OR REPLACE VIEW "MOYENNETRAVAUXMACHINE" ("IDMACHINE", "NOMMACHINE", "MOYENNEDUREEESTIMATIF", "MOYENNEDUREE", "MOYENNEECART", "IDENTITE") AS
SELECT
    d.IDMACHINE,
    d.NOMMACHINE ,
    CAST (AVG(d.DUREEESTIMATIF) AS NUMBER(10, 2)) AS moyenneDureeEstimatif,
    CAST (AVG(d.DUREE) AS NUMBER(10, 2)) AS moyenneDuree,
    CAST (AVG(d.ECART) AS NUMBER(10, 2)) as moyenneEcart,
    d.identite
FROM DUREETRAVAUXMACHINE d
GROUP BY d.IDMACHINE, d.NOMMACHINE,d.IDENTITE  ;

CREATE OR REPLACE VIEW "TEMPSMOYENPANNES" ("IDMACHINE", "NOMMACHINE", "IDTRAVAUX", "DATY", "ECART_JOURS", "IDENTITE") AS
WITH ECARTS AS (
    SELECT
        CASE
            WHEN ai.id IS NULL THEN aim.id
            ELSE ai.id
            END AS idMachine,
        CASE
            WHEN ai.libelle IS NULL THEN aim.descriptionObjet
            ELSE ai.libelle
            END AS nomMachine,
        t.ID AS IDTRAVAUX,
        t.DATY,
        NVL(
                t.DATY - LAG(t.DATY) OVER (PARTITION BY o.IDINGREDIENTS ORDER BY t.DATY),
                0
        ) AS ECART_JOURS,
        aim.idEntite AS identite
    FROM TRAVAUX t
             LEFT JOIN ORDRETRAVAUXFILLE o
                       ON t.IDOFFILLE = o.ID
             LEFT JOIN AS_INGREDIENT_MAINTENANCE aim
                       ON o.IDINGREDIENTS = aim.id
             LEFT JOIN as_ingredients ai
                       ON aim.IDINGREDIENT = ai.id

)
SELECT "IDMACHINE","NOMMACHINE","IDTRAVAUX","DATY","ECART_JOURS","IDENTITE"
FROM ECARTS
;

CREATE OR REPLACE VIEW "MOYENNEPANNESTRAVAUX" ("IDMACHINE", "NOMMACHINE", "ECARTJOURS", "IDENTITE") AS
SELECT
    idMachine,
    nomMachine,
    cast (ROUND(AVG(ECART_JOURS), 2) as number(10,2)) AS ECARTJOURS,
    identite
FROM TempsMoyenPannes
WHERE ECART_JOURS IS NOT NULL
GROUP BY idMachine, nomMachine,identite ;


ALTER TABLE FACTUREFOURNISSEUR ADD CONSTRAINT fk_iddmdachat_ff FOREIGN KEY (idDmdAchat) REFERENCES DMDACHAT (id);

CREATE OR REPLACE VIEW DMDACHATLIB AS
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;(E)'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;(E)'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Responsable achat'
        END AS etatlib,
    da.idObjet
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id;

create or replace view FACTUREFOURNISSEURCPL_TRAVAUX AS
SELECT f.ID,
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
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
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
       t.id AS idTravaux
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
         LEFT JOIN dmdAchat d ON f.idDmdAchat = d.id
         LEFT JOIN TRAVAUX t ON d.idObjet = t.id;


CREATE TABLE MOTRAVAUX(
                          ID VARCHAR2(50) NOT NULL PRIMARY KEY,
                          IDPERSONNEL VARCHAR2(255),
                          IDTRAVAUX VARCHAR2(255),
                          DUREEESTIMATIF VARCHAR2(50),
                          TAUXHORAIRE NUMBER
);



CREATE SEQUENCE seq_motravaux
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqmotravaux
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seq_motravaux.NEXTVAL into retour from dual;
RETURN retour;
END;


CREATE OR REPLACE VIEW PERSONNELDEMAINTENANCE AS
SELECT
    lp.id,
    nom,
    prenom,
    service,
    ls.libelle AS serviceLib
FROM log_personnel lp
         LEFT JOIN LOG_SERVICE ls ON lp.service = ls.id
WHERE
    service LIKE 'SERVM%';

CREATE OR REPLACE VIEW MoTravauxLib AS
SELECT
    mo.*,
    LPAD(FLOOR(TO_NUMBER(mo.DUREEESTIMATIF) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 60), 2, '0')
                                               AS dureeEstimatifLib,
    ((mo.DUREEESTIMATIF/60)/60)*mo.TAUXHORAIRE AS montant,
    p.NOM AS idPersonnelLib
FROM MOTRAVAUX mo
         LEFT JOIN PERSONNELDEMAINTENANCE p ON p.ID = mo.IDPERSONNEL;

-- ALTER TABLE TRAVAUX ADD dureeEstimatif VARCHAR2(50);

CREATE TABLE ProcessMaintenance (
                                    ID VARCHAR2(50) NOT NULL PRIMARY KEY,
                                    IDPERSONNEL VARCHAR2(255),
                                    IDTRAVAUX VARCHAR2(255),
                                    DATEDEBUT DATE,
                                    DATEFIN DATE,
                                    HEUREDEBUT VARCHAR2(50),
                                    HEUREFIN VARCHAR2(50)
);

CREATE SEQUENCE seq_processmaintenance
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqprocessmaintenance
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seq_processmaintenance.NEXTVAL into retour from dual;
RETURN retour;
END;

-- ALTER TABLE ProcessMaintenance ADD DATEFIN DATE;

-- alter table MOTRAVAUX rename column LOGPERSONNEL to IDPERSONNEL;


CREATE OR REPLACE VIEW ProcessMaintenanceLib AS
SELECT
    prc.*,
    /* Écart en secondes */
    ROUND((prc.datetime_fin - prc.datetime_debut) * 86400) AS ecart_seconde,
    /* Écart format HH:MM:SS */
    LPAD(FLOOR(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400) / 3600), 2, '0')
        || ':' ||
    LPAD(FLOOR(MOD(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400), 3600) / 60), 2, '0')
        || ':' ||
    LPAD(MOD(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400), 60), 2, '0')
                                                           AS ecart_hms,
    p.NOM AS idPersonnelLib
FROM (
         SELECT
             prc.*,

             /* Date + Heure début */
             prc.DATEDEBUT
                 + (TO_DATE(prc.HEUREDEBUT, 'HH24:MI:SS')
                 - TRUNC(TO_DATE(prc.HEUREDEBUT, 'HH24:MI:SS')))
                 AS datetime_debut,

             /* Date + Heure fin */
             prc.DATEFIN
                 + (TO_DATE(prc.HEUREFIN, 'HH24:MI:SS')
                 - TRUNC(TO_DATE(prc.HEUREFIN, 'HH24:MI:SS')))
                 AS datetime_fin

         FROM ProcessMaintenance prc
     ) prc
         LEFT JOIN PERSONNELDEMAINTENANCE p ON p.ID = prc.IDPERSONNEL;

CREATE OR REPLACE VIEW ProcessMaintenanceGlobal AS
SELECT
    pr.IDTRAVAUX,
    pr.IDPERSONNEL,
    sum(pr.ecart_seconde) as dureeReel,
    LPAD(FLOOR(TO_NUMBER(sum(pr.ecart_seconde)) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(TO_NUMBER(sum(pr.ecart_seconde)), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD(TO_NUMBER(sum(pr.ecart_seconde)), 60), 2, '0')
                          AS dureeReelHMS
FROM PROCESSMAINTENANCELIB pr
group by pr.IDTRAVAUX, pr.IDPERSONNEL;

CREATE OR REPLACE VIEW RapprochementTravaux AS
SELECT
    '' AS ID,
    mo.IDTRAVAUX,
    mo.IDPERSONNEL,
    mo.idPersonnelLib,
    mo.dureeEstimatifLib AS dureeEstimatif_hms,
    pr.dureeReelHMS AS dureeReel_hms,
    LPAD(FLOOR(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel), 60), 2, '0')
        AS ecart_hms,
    mo.DUREEESTIMATIF AS dureeEstimatif_seconde,
    pr.dureeReel AS dureeReel_seconde,
    mo.DUREEESTIMATIF - pr.dureeReel AS ecart_seconde,
    mo.montant AS montantEstimatif,
    ((pr.dureeReel/60)/60)*mo.TAUXHORAIRE AS montantReel,
    mo.montant - (((pr.dureeReel/60)/60)*mo.TAUXHORAIRE) AS montantEcart
FROM MOTRAVAUXLIB mo
         LEFT JOIN ProcessMaintenanceGlobal pr ON pr.IDPERSONNEL = mo.IDPERSONNEL AND pr.IDTRAVAUX = mo.IDTRAVAUX;


CREATE OR REPLACE VIEW RapprochementTravaux AS
SELECT
    CAST(NULL AS VARCHAR2(50)) AS id,
    mo.IDTRAVAUX,
    mo.IDPERSONNEL,
    mo.idPersonnelLib,
    mo.dureeEstimatifLib AS dureeEstimatif_hms,
    pr.dureeReelHMS AS dureeReel_hms,
    LPAD(FLOOR((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)), 60), 2, '0')
                               AS ecart_hms,
    mo.DUREEESTIMATIF AS dureeEstimatif_seconde,
    pr.dureeReel AS dureeReel_seconde,
    mo.DUREEESTIMATIF - NVL(pr.dureeReel,0) AS ecart_seconde,
    mo.montant AS montantEstimatif,
    (NVL(pr.dureeReel,0) / 3600.0) * mo.TAUXHORAIRE AS montantReel,
    mo.montant - ((NVL(pr.dureeReel,0) / 3600.0) * mo.TAUXHORAIRE) AS montantEcart
FROM MOTRAVAUXLIB mo
         LEFT JOIN ProcessMaintenanceGlobal pr
                   ON pr.IDPERSONNEL = mo.IDPERSONNEL
                       AND pr.IDTRAVAUX = mo.IDTRAVAUX;





CREATE OR REPLACE VIEW "FACTUREFOURNISSEURCPL_TRAVAUX" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "IDPREVISION", "ESTPREVULIB", "IDOBJET", "IDREF", "IDTYPEFACTURE", "TYPEFACTURE", "NUMERO", "TYPEACHAT", "IDTRAVAUX") AS
SELECT f.ID,
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
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
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
       t.id AS idTravaux
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
         LEFT JOIN DMDACHAT d ON f.idDmdAchat = d.id
         LEFT JOIN TRAVAUX t ON d.idObjet = t.id ;

CREATE OR REPLACE VIEW "TRAVAUX_RECAP" ("ID", "MONTANTCHARGEEXTERNE", "MONTANTPIECE", "MONTANTMAINDOEUVRE", "MONTANTTOTAL") AS
WITH fac_agg AS (
    SELECT idtravaux,
           SUM(NVL(montantttc, 0)) AS montantChargeExterne
    FROM FACTUREFOURNISSEURCPL_TRAVAUX
    GROUP BY idtravaux
),
     mvt_agg AS (
         SELECT idobjet,
                SUM(NVL(montantsortie, 0)) AS montantPiece
         FROM MVTSTOCKLIB
         GROUP BY idobjet
     ),
     pm_agg AS (
         SELECT idtravaux,
                SUM(NVL(montantreel, 0)) AS montantMainDoeuvre
         FROM RAPPROCHEMENTTRAVAUX
         GROUP BY idtravaux
     )
SELECT t.id,
       NVL(fac_agg.montantChargeExterne, 0) AS montantChargeExterne,
       NVL(mvt_agg.montantPiece, 0)         AS montantPiece,
       NVL(pm_agg.montantMainDoeuvre, 0)    AS montantMainDoeuvre,
       NVL(fac_agg.montantChargeExterne, 0)
           + NVL(mvt_agg.montantPiece, 0)
           + NVL(pm_agg.montantMainDoeuvre, 0)    AS montantTotal
FROM TRAVAUX t
         LEFT JOIN fac_agg ON fac_agg.idtravaux = t.id
         LEFT JOIN mvt_agg ON mvt_agg.idobjet   = t.id
         LEFT JOIN pm_agg  ON pm_agg.idtravaux  = t.id;

CREATE OR REPLACE VIEW "COUTSMAINTENANCE" ("IDMACHINE", "NOMMACHINE", "IDTRAVAUX", "DATY", "COUTTOTAL", "IDENTITE") AS
SELECT
    o.IDINGREDIENTS AS idMachine,
    ai.libelle AS nomMachine,
    tr.ID AS idTravaux,
    t.DATY ,
    CAST (tr.MONTANTTOTAL AS NUMBER(10,2)) AS CoutTotal,
    aim.idEntite AS idEntite
FROM TRAVAUX_RECAP tr
         LEFT JOIN TRAVAUX t
                   ON tr.id = t.ID
         LEFT JOIN ORDRETRAVAUXFILLE o
                   ON t.IDOFFILLE = o.id
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim
                   ON o.IDINGREDIENTS = aim.ID
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=aim.IDINGREDIENT
WHERE o.IDINGREDIENTS IS NOT NULL ;

CREATE OR REPLACE VIEW "NOMBRE_PANNE_MACHINE" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "DEMANDEUR", "CAUSE", "IDDEPARTEMENT", "IDDEPARTEMENTMAINTENANCE", "IDMACHINELIB", "QTE") AS
SELECT
    d."ID",
    d."IDENTITE",
    d."IDSITUATION",
    d."IDMACHINE",
    d."DATY",
    d."DATEBESOIN",
    d."PRIORITE",
    d."ESTEXISTANT",
    d."DESCRIPTION",
    d."ETAT",
    d."DEMANDEUR",
    d."CAUSE",
    d."IDDEPARTEMENT",
    d."IDDEPARTEMENTMAINTENANCE",
    ai.LIBELLE AS idMachineLib,
    COUNT(*) OVER (PARTITION BY d.IDMACHINE, d.DATY) AS qte
FROM DEMANDETRAVAUX d
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON d.IDMACHINE = m.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON m.IDINGREDIENT = ai.ID ;



CREATE OR REPLACE VIEW AS_INGREDIENT_MAINTENANCE_LIB AS
SELECT
    am."ID",am."IDINGREDIENT",am."IDENTITE",am."REFERENCEOBJET",am."MARQUEOBJET",am."MODELEOBJET",am."NUMEROSERIEOBJET",am."DESCRIPTIONOBJET",am."QUALITEOBJET",am."ETATOBJET",am."LOCALISATIONOBJET",am."PUISSANCEOBJET",am."OBSERVATIONOBJET",am."TYPERATTACHEMENT",am."ESTENGIN",am."LIBELLE",am."DATEAQUISITION",
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,
    ai.unite,
    am.LIBELLE AS libellecomposant,
    ai.compte_achat,
    ai.pu,
    am."IDLIGNE",
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         left join LOG_DEPARTEMENT ld on am.localisationObjet=ld.id;


CREATE TABLE LOG_DEPARTEMENT
(	"ID" VARCHAR2(50) NOT NULL ENABLE,
     "VAL" VARCHAR2(255),
     "DESCE" VARCHAR2(255),
     PRIMARY KEY ("ID")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
         STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
         PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
         TABLESPACE "USERS"  ENABLE
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
    STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "USERS" ;

create or replace view FACTUREFOURNISSEURCPL_TOUS as
SELECT
    fcpl.id,
    fcpl.idfournisseur,
    fcpl.idfournisseurlib,
    fcpl.idmodepaiement,
    fcpl.idmodepaiementlib,
    fcpl.daty,
    fcpl.designation,
    fcpl.dateecheancepaiement,
    fcpl.etatlib,
    fcpl.reference,
    fcpl.idbc,
    fcpl.idmagasin,
    fcpl.idmagasinlib,
    fcpl.devise,
    fcpl.iddevise,
    fcpl.etat,
    fcpl.taux,
    fcpl.montanttva,
    fcpl.montantht,
    fcpl.tauxdechange,
    fcpl.montantttc AS  MONTANTTTC,
    nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
    nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF
FROM FACTUREFOURNISSEURCPL fcpl;












