INSERT INTO MAGASIN2
(ID, VAL, DESCE, IDPOINT, IDPRODUIT, IDTYPEMAGASIN, ETAT, CAPACITE, COMPTEUR, IDMAGASINMERE, IDLIGNE)
VALUES('PNTB0001', 'Boutique', 'Boutique', 'PNTB0001', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
 
 
INSERT INTO REMISE (ID, DATY, NOM, DATEDEBUT, DATEFIN, ETAT) VALUES ('RMSML0002', TIMESTAMP '2026-07-27 14:59:38', 'Remise directe', TIMESTAMP '2026-07-27 14:59:47', TIMESTAMP '2026-07-31 14:59:51', 11);
 
INSERT INTO REMISEFILLE (ID, REMISE, IDCATEGORIECLIENT, IDPRODUIT, CATEGORIEPRODUIT, IDPOINT, IDREMISE) VALUES ('RMSFILLE2', 5.00, null, 'IG001236', null, null, 'RMSML0002');
 
 
INSERT INTO AS_INGREDIENTS (
    ID,
    LIBELLE,
    SEUIL,
    UNITE,
    QUANTITEPARPACK,
    PU,
    ACTIF,
    PHOTO,
    CALORIE,
    DURRE,
    COMPOSE,
    CATEGORIEINGREDIENT,
    IDFOURNISSEUR,
    DATY,
    QTELIMITE,
    PV,
    LIBELLEVENTE,
    SEUILMIN,
    SEUILMAX,
    PUACHATUSD,
    PUACHATEURO,
    PUACHATAUTREDEVISE,
    PUVENTEUSD,
    PUVENTEEURO,
    PUVENTEAUTREDEVISE,
    ISVENTE,
    ISACHAT,
    COMPTE_VENTE,
    COMPTE_ACHAT,
    LIBELLEEXTACTE,
    TVA,
    FILEPATH,
    RESTE,
    TYPESTOCK,
    MARQUE,
    ANNEESORTIE,
    SAV,
    IDMODELE,
    COULEUR,
    TAILLE,
    IDREFCOM,
    REFERENCECOMMANDE,
    CLIENT,
    STYLE,
    IDCATEGORIE,
    CODEBARRE,
    IDSERVICE,
    REFERENCE,
    SOUSCATEGORIE,
    PVGROS,
    CODEGROS,
    IDNATURE,
    REFPOST,
    REFQUALIFICATION,
    IDCHAMBRE,
    ISPERISHABLE,
    PV2,
    IDFAMILLE,
    IDMAGASIN,
    PARFUMS,
    COMPTE_STOCK,
    COMPTE_SORTIE_STOCK
)
VALUES (
           'APP',
           'APPOINT',
           0,
           'UNT00005',
           0,
           0,
           0,
           NULL,
           0,
           NULL,
           0,
           NULL,
           NULL,
           NULL,
           0,
           0,
           NULL,
           NULL,
           NULL,
           0,
           0,
           NULL,
           0,
           0,
           NULL,
           0,
           0,
           '710011',
           '607011',
           NULL,
           20,
           NULL,
           -6891,
           'FIFO',
           NULL,
           0,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           0,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
       );
 
 
(ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE, IDMAGASIN, IDDEVISE, IDTYPEBANQUE)
VALUES('CAI000240', 'Chèque', 'Chèque', 'TCA001', 'PNT000084', NULL, 11, 'CTC002', '530002', NULL, 'AR', NULL);
INSERT INTO CAISSE
(ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE, IDMAGASIN, IDDEVISE, IDTYPEBANQUE)
VALUES('CAI000318', 'TPE', 'TPE', 'TCA001', 'PNT000084', NULL, 11, 'CTC007', '530002', NULL, 'AR', NULL);
 
CREATE OR REPLACE VIEW INSERTION_VENTE_PERSONNEL AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.IDORIGINE,
       v.IDCLIENT,
       CAST(' ' AS varchar(100)) AS iddevise,
       v.ESTPREVU,
       v.DATYPREVU,
       v.IDRESERVATION,
       v.idCommercial,
       v.idmodepaiement,
       v.remise,
       v.remiseMontant,
       v.HEURESAISIE,
       v.IDRESPONSABLE,
       v.NOMCLIENTDIVERS
FROM VENTE v
 
 
;
 
CREATE OR REPLACE VIEW INSERTION_VENTE_PERSONNEL_VIDE AS
SELECT id,daty,designation,idmagasin,remarque,etat,idorigine,idclient,iddevise,estprevu,datyprevu,idreservation,idcommercial,idmodepaiement,remise,remisemontant,HEURESAISIE, IDRESPONSABLE, NOMCLIENTDIVERS FROM INSERTION_VENTE_PERSONNEL
 
 
;