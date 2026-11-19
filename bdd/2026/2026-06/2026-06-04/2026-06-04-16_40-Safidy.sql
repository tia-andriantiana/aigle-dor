create table utilisateur_personnel(
  id varchar(50)primary key not null,
  idUtilisateur varchar(50),
  idPersonnel varchar(50),
  CONSTRAINT fk_up_personnel
      FOREIGN KEY (idPersonnel)
          REFERENCES log_personnel (id),
  CONSTRAINT uq_up_utilisateur
      UNIQUE (idUtilisateur),
  CONSTRAINT uq_up_personnel
      UNIQUE (idPersonnel)
);

create sequence sequtilisateur_personnel
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OF
CREATE OR REPLACE FUNCTION getsequtilisateur_personnel
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT sequtilisateur_personnel.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


CREATE OR REPLACE VIEW Log_personnel_v2_user AS
Select
    l.*,
    up.idUtilisateur as idutilisateur
from log_personnel_v2 l
         JOIN utilisateur_personnel up ON up.idpersonnel=l.id_pers;

CREATE OR REPLACE  VIEW V_UTILISATEURLIB ("REFUSER", "LOGINUSER", "PWDUSER", "NOMUSER", "ADRUSER", "TELUSER", "IDROLE", "DESCROLE","IDPERSONNEL") AS
select u."REFUSER",u."LOGINUSER",u."PWDUSER",u."NOMUSER",u."ADRUSER",u."TELUSER",u."IDROLE",r.DESCROLE,up.idpersonnel from UTILISATEUR u
                                                                                                                               left join ROLES r on r.IDROLE=u.IDROLE
                                                                                                                               LEFT JOIN utilisateur_personnel up ON up.idutilisateur=u.refuser;



CREATE OR REPLACE  VIEW EMPLOYE_COMPLET_LIBELLE2 ("ID", "NOM", "PRENOM", "ID_PERS", "INITIALE", "MATRICULE", "DATE_NAISSANCE", "LIEU_NAISSANCE_COMMUNE", "SEXE", "NUMERO_CIN", "DATE_CIN", "DATE_DUPL_CIN", "LIEU_DELIVRANCE_CIN", "ADRESSE", "FOKOTANY", "NATIONALITE", "ACTE_NAISSANCE", "SITUATION_MATRIMONIAL", "IDCONJOINT", "DIRECTION", "SERVICE", "IDFONCTION", "CTG", "IDCATEGORIE", "CLASSEE", "INDICEGRADE", "INDICE_FONCTIONNEL", "MATRICULE_PATRON", "STATUT", "MODE_PAIEMENT", "CODE_AGENCE_BANQUE", "BANQUE_COMPTE_CLE", "BANQUE_NUMERO_COMPTE", "PERMIS_CONDUIRE", "REMARQUE", "CHEMIN_PERMIS", "CTURGENCE_NOM_PRENOM", "CTURGENCE_TELEPHONE1", "CTURGENCE_TELEPHONE2", "CTURGENCE_TELEPHONE3", "DATEEMBAUCHE", "DATESAISIE", "CODE_DR", "BANQUE_CODE", "ECHELON", "VEHICULEE", "VEHICULEE_STR", "DATE_DERNIERPROMO", "HEUREJOURNALIER", "HEUREHEBDOMADAIRE", "HEUREMENSUEL", "NUMERO_CNAPS", "NUMERO_OSTIE", "TEMPORAIRE", "TEMPORAIRE_LIB", "NBENFANT", "MOTIF_DEBAUCHE", "TYPE_DEBAUCHE", "ADRESSE_LIGNE1", "ADRESSE_LIGNE2", "MAIL", "TELEPHONE", "CODE_POSTAL", "REGION", "ANNEEEXPERIENCE", "FORMATION", "DISCIPLINE", "ETAT", "CATEGORIEPAIELIB","IDDEPARTEMENT","IDDEPARTEMENTLIB") AS
SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule AS matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       s.desce AS sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       sf.val AS fokotany,
       p.val AS nationalite,
       logp.acte_naissance,
       sitmat.desce AS situation_matrimonial,
       paie.idconjoint,
       ld.val AS direction,
       serv.libelle AS service,
       pf.desce AS idfonction,
       paie.ctg,
       pc.val AS idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       pm.val AS mode_paiement,
       paie.code_agence_banque,
       paie.banque_compte_cle,
       paie.banque_numero_compte,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.dateembauche,
       paie.datesaisie,
       serv.code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.vehiculee,
       CASE paie.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       tab.date_dernierpromo,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       CASE
           WHEN paie.temporaire = '-1' THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire_lib,
       paie.nbenfant,
       lpnv.motif AS motif_debauche,
       ddt.val AS type_debauche,
       paie.adresse_ligne1,
       paie.adresse_ligne2,
       paie.mail,
       paie.telephone,
       paie.code_postal,
       reg.val AS region,
       paie.anneeexperience,
       fd.val AS formation,
       paie.discipline,
       paie.etat,
       cp.DESCE AS categoriePaieLib,
       paie.iddepartement AS iddepartement,
       dep.val AS iddepartementlib
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN sexe s ON logp.sexe = s.id
         LEFT JOIN sig_fokontany sf ON logp.fokotany = sf.id
         LEFT JOIN pays p ON logp.nationalite = p.id
         LEFT JOIN log_direction ld ON logp.direction = ld.id
         LEFT JOIN paie_fonction pf ON paie.idfonction = pf.id
         LEFT JOIN paie_categorie pc ON paie.idcategorie = pc.id
         LEFT JOIN modepaiement pm ON paie.mode_paiement = pm.id
         LEFT JOIN situation_matrimoniale sitmat ON paie.situation_matrimonial = sitmat.id
         LEFT JOIN log_personnel_non_valide lpnv ON logp.id = lpnv.idlogpers
         LEFT JOIN dec_decision_type ddt ON lpnv.idtypedebauche = ddt.id
         LEFT JOIN region reg ON reg.id = paie.region
         LEFT JOIN formation_diplome fd ON fd.id = paie.formation
         LEFT JOIN categorie_paie cp ON paie.IDCATEGORIE_PAIE = cp.id
         LEFT JOIN DEPARTEMENT dep ON dep.id=paie.iddepartement
WHERE logp.id <> '1002067';



CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB ("ID", "LIBELLE", "PARFUMS", "SEUIL", "UNITE", "QUANTITEPARPACK", "PU", "ACTIF", "PHOTO", "CALORIE", "DURRE", "COMPOSE", "COMPOSELIB", "IDCATEGORIEINGREDIENT", "CATEGORIEINGREDIENT", "IDCATEGORIE", "IDFOURNISSEUR", "DATY", "BIENOUSERV", "ETATLIB", "COMPTE_VENTE", "COMPTE_ACHAT", "PV", "TVA", "TYPESTOCK", "IDUNITE", "REFPOST", "REFQUALIFICATION", "REFPOSTLIB", "REFQUALIFICATIONLIB", "IDFAMILLELIB", "TYPEPRODUIT", "IDLIGNE", "COMPTE_STOCK", "COMPTE_SORTIE_STOCK", "IDFOURNISSEURLIB","IDDEPARTEMENTLIB") AS
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       CAST(ing.SEUIL AS NUMBER(10,5)) AS SEUIL ,
       au.VAL AS unite,
       CAST(ing.QUANTITEPARPACK AS NUMBER(10,5)) AS QUANTITEPARPACK,
       CAST(ing.pu AS NUMBER(30,5)) AS pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       CAST(ing.pv AS NUMBER(30,5)) AS pv,
       CAST(ing.tva AS NUMBER(10,5)) AS tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       ing.typeProduit,
       tp.idligne,
       ing.compte_stock,
       ing.compte_sortie_stock,
       f.nom as idFournisseurLib,
       dep.val AS idDepartementLib
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
         LEFT JOIN TYPE_PRODUIT tp ON tp.ID=ing.typeProduit
         LEFT JOIN FOURNISSEUR f ON ing.idFournisseur = f.id
         LEFT JOIN departement dep ON dep.id=ing.parfums;



CREATE OR REPLACE  VIEW PLANNING_CPL ("ID", "REFOBJET", "ESTPERIODIQUE", "IDTYPEMAINTENANCE", "IDMACHINE", "UNITE", "FREQUENCE", "DATEDEBUT", "DATEFIN", "DUREE", "ETAT", "HEURE", "IDSOURCE", "IDMACHINELIB", "IDTYPEMAINTENANCELIB", "ESTPERIODIQUELIB", "ETATLIB", "UNITELIB", "PRIORITE", "PRIORITELIB", "IDDEMANDETRAVAUX", "IDORDRETRAVAUX", "IDORDRETRAVAUXFILLE", "IDTRAVAUX", "IDENTITE", "IDENTITELIB", "ETATDEMANDETRAVAUX", "ETATORDRETRAVAUX", "ETATTRAVAUX", "ETATDEMANDETRAVAUXLIB", "ETATORDRETRAVAUXLIB", "ETATTRAVAUXLIB", "COUT","IDDEPARTEMENT") AS
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
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        WHEN 21 THEN 'Entamée'
        WHEN 41 THEN 'Terminée'
        ELSE 'Aucun'
        END AS etatTravauxLib,
    coalesce(SUM(fff.pu * fff.qte), 0) AS cout,
    ai.parfums AS iddepartement
FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITEMAINTENANCE u ON u.ID = p.UNITE
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
    e.id, e.val,ai.parfums
ORDER BY p.DATEDEBUT;

alter table AS_INGREDIENT_MAINTENANCE add idDepartement varchar(50);


CREATE OR REPLACE  VIEW AS_INGREDIENT_MAINTENANCE_LIB ("ID", "IDINGREDIENT", "IDENTITE", "REFERENCEOBJET", "MARQUEOBJET", "MODELEOBJET", "NUMEROSERIEOBJET", "DESCRIPTIONOBJET", "QUALITEOBJET", "ETATOBJET", "LOCALISATIONOBJET", "PUISSANCEOBJET", "OBSERVATIONOBJET", "TYPERATTACHEMENT", "ESTENGIN", "LIBELLE", "DATEAQUISITION", "INGREDIENTLIB", "IDENTITELIB", "QUALITEOBJETLIB", "ETATOBJETLIB", "LOCALISATIONOBJETLIB", "ESTENGINLIB", "IDLIGNE", "IDLIGNELIB", "PU", "MOTSCLESSS","IDDEPARTEMENT","IDDEPARTEMENTLIB") AS
SELECT
    am.ID,
    am.IDINGREDIENT,
    am.IDENTITE,
    am.REFERENCEOBJET,
    am.MARQUEOBJET,
    am.MODELEOBJET,
    am.NUMEROSERIEOBJET,
    am.DESCRIPTIONOBJET,
    am.QUALITEOBJET,
    am.ETATOBJET,
    am.LOCALISATIONOBJET,
    am.PUISSANCEOBJET,
    am.OBSERVATIONOBJET,
    am.TYPERATTACHEMENT,
    am.ESTENGIN,
    am.LIBELLE,
    am.DATEAQUISITION,

    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,

    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB,

    l.id AS idligne,
    l.val AS idlignelib,
    am.pu AS PU,

    (
        NVL(am.ID, '') || ' | ' ||
        NVL(ai.libelle, '') || ' | ' ||
        NVL(am.IDENTITE, '') || ' | ' ||
        NVL(qo.val, '') || ' | ' ||
        NVL(eo.val, '') || ' | ' ||
        NVL(ld.val, '') || ' | ' ||
        NVL(l.val, '') || ' | ' ||
        NVL(am.LIBELLE, '')
        ) AS MOTSCLESSS,
    ai.parfums AS iddepartement,
    de.val AS iddepartementlib

FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         LEFT JOIN LOG_DEPARTEMENT ld ON am.LOCALISATIONOBJET = ld.ID
         LEFT JOIN LIGNE l ON l.ID = am.IDLIGNE
         LEFT JOIN departement de ON de.id=ai.parfums;