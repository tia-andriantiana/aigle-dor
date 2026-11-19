-- CREATE SEQUENCE seqcategorieavoirfc
--     MINVALUE 1
--     MAXVALUE 999999999999999999999999999
--     START WITH 1
--     INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETseqcategorieavoirfc
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seqcategorieavoirfc.nextval INTO retour FROM dual;
return retour;
END;

-- CREATE SEQUENCE seqmotifavoirfc
--     MINVALUE 1
--     MAXVALUE 999999999999999999999999999
--     START WITH 1
--     INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETseqmotifavoirfc
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seqmotifavoirfc.nextval INTO retour FROM dual;
return retour;
END;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1777019490100738', 'Avoir', 'credit_card', '', 8, 2, 'MNDN00000002111');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN177701954231275', 'Catégorie', 'description', 'module.jsp?but=avoir/categorie/categorie-avoir-liste.jsp', 1, 3, 'MENDYN1777019490100738');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1777019615736733', 'Motif', 'article', 'module.jsp?but=avoir/motif/motif-avoir-liste.jsp', 2, 3, 'MENDYN1777019490100738');
