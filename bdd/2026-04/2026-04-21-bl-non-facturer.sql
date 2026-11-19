CREATE OR REPLACE VIEW BL_NONFACTURE AS
SELECT
    abl."ID",abl."REMARQUE",abl."IDBC",abl."DATY",abl."ETAT",abl."MAGASIN",abl."MAGASINLIB",abl."ETATLIB",abl."IDFOURNISSEUR",abl."IDFOURNISSEURLIB"
FROM AS_BONDELIVRAISON_LIB abl
WHERE abl.IDFACTUREFOURNISSEUR IS NULL
;

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBC791C50', 'MNDN001804007', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFE460CEE', 'MNDN001804007', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD64E766E', 'MNDN001804007', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4DF9A0B7', 'MNDN001804007', NULL, 'magcentral', 1);