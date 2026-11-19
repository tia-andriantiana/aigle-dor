INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1770807165914602', 'Configuration', 'settings', '', 5, 2, 'MNDNMT01');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1770807196422287', 'Tranche', 'sort', '', 1, 3, 'MENDYN1770807165914602');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1770807246712106', 'Saisie', 'add', 'module.jsp?but=maintenance/tranche/tranche-saisie.jsp', 1, 4, 'MENDYN1770807196422287');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1770807265515331', 'Liste', 'view_list', 'module.jsp?but=maintenance/tranche/tranche-liste.jsp', 2, 4, 'MENDYN1770807196422287');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRM007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM764D4E4D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC229D1EA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM90ADFDE8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMECCFC05B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM532DE836'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEBC7550F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4DB1A7B0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEEB450C6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM32B50DEC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM77B93B2A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB8B9BE63'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM33C0066D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2AEE60E8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT02356446545'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT5465121254654'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT546512125465412345'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1BD8CB2B'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCF4DFC2E', 'ELM000010', '*', NULL, 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM82A05DE5', 'MNDNMT0119', NULL, 'mag_transit_emb_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6B375439', 'MNDNMT0119', NULL, 'mag_central_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9FD50B9D', 'MNDNMT0119', NULL, 'ctr_fab_bc_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCEB9D5E1', 'MNDNMT0119', NULL, 'assist_ctrm', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM492F6772', 'MNDNMT0119', NULL, 'sec_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF48D608F', 'MNDNMT0119', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM674728B6', 'MNDNMT0119', NULL, 'ctr_cond_bc_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEC34DB8A', 'MNDNMT0119', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME437F597', 'MNDNMT0119', NULL, 'mag_transit_emb_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD26D1508', 'MNDNMT0119', NULL, 'chef_prod_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC5C60615', 'MNDNMT0119', NULL, 'ctr_cond_ab_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM25636DD7', 'MNDNMT0119', NULL, 'mag_piece', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB2E19568', 'MNDNMT0119', NULL, 'mag_gaz', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDB404804', 'MNDNMT0119', NULL, 'mag_central_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDDFB71B2', 'MNDNMT0119', NULL, 'ctr_fab_ab_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM556EB4A0', 'MNDNMT0119', NULL, 'mag_transit_mp_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM602F8043', 'MNDNMT0119', NULL, 'chef_prod_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC2A5E313', 'MNDNMT0119', NULL, 'chef_dep_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM571F692D', 'MNDNMT0119', NULL, 'mag_pf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM76D75B6F', 'MNDNMT0119', NULL, 'mag_transit_mp_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBDCE90BA', 'MNDNMT0119', NULL, 'sec_prod_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3A31DF88', 'MNDNMT0119', NULL, 'ctr_fab_ab_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCD36BC7D', 'MNDNMT0119', NULL, 'chef_dep_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM58F372CD', 'MNDNMT0119', NULL, 'ctr_fab_bc_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM77A807CF', 'MNDNMT0119', NULL, 'dir_usine', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM669D1D86', 'MNDNMT0119', NULL, 'assist_mag_pf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5C186F39', 'MNDNMT0119', NULL, 'ctr_cond_ab_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBE98C7F2', 'MNDNMT0119', NULL, 'ctr_cond_bc_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2400E7EE', 'MNDNMT0119', NULL, 'resp_rdq', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM44C72917', 'MENDYN1764919987323625', NULL, 'mag_transit_emb_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME47FE523', 'MENDYN1764919987323625', NULL, 'mag_central_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM338DAB01', 'MENDYN1764919987323625', NULL, 'ctr_fab_bc_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB2CB1643', 'MENDYN1764919987323625', NULL, 'assist_ctrm', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1AEFA6A8', 'MENDYN1764919987323625', NULL, 'sec_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM127422AC', 'MENDYN1764919987323625', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA9317F31', 'MENDYN1764919987323625', NULL, 'ctr_cond_bc_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM073E4982', 'MENDYN1764919987323625', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA0C50D5D', 'MENDYN1764919987323625', NULL, 'mag_transit_emb_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM11E99B8D', 'MENDYN1764919987323625', NULL, 'chef_prod_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC2D446D7', 'MENDYN1764919987323625', NULL, 'ctr_cond_ab_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM418E3FA7', 'MENDYN1764919987323625', NULL, 'mag_piece', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3C34D29B', 'MENDYN1764919987323625', NULL, 'mag_gaz', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM61F2A4C5', 'MENDYN1764919987323625', NULL, 'mag_central_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM31538946', 'MENDYN1764919987323625', NULL, 'ctr_fab_ab_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3029902B', 'MENDYN1764919987323625', NULL, 'mag_transit_mp_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF5DC8DED', 'MENDYN1764919987323625', NULL, 'chef_prod_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5F344DAC', 'MENDYN1764919987323625', NULL, 'chef_dep_conf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM912D3E6B', 'MENDYN1764919987323625', NULL, 'mag_pf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM96DCA46A', 'MENDYN1764919987323625', NULL, 'mag_transit_mp_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1C6CB229', 'MENDYN1764919987323625', NULL, 'sec_prod_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM06CD5300', 'MENDYN1764919987323625', NULL, 'ctr_fab_ab_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2E68DC92', 'MENDYN1764919987323625', NULL, 'chef_dep_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBB72C05D', 'MENDYN1764919987323625', NULL, 'ctr_fab_bc_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM444878A1', 'MENDYN1764919987323625', NULL, 'dir_usine', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1A8749B0', 'MENDYN1764919987323625', NULL, 'assist_mag_pf', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6EC326E3', 'MENDYN1764919987323625', NULL, 'ctr_cond_ab_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB30D7A23', 'MENDYN1764919987323625', NULL, 'ctr_cond_bc_bisc', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDE9BDEAD', 'MENDYN1764919987323625', NULL, 'resp_rdq', 1);