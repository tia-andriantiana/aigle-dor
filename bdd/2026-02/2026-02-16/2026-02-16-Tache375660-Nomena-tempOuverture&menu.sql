CREATE TABLE TempsOuverture (
                                id VARCHAR2(50) PRIMARY KEY,
                                idMachine VARCHAR2(50),
                                temps NUMBER,
                                CONSTRAINT fk_tempsouverture_machine
                                    FOREIGN KEY (idMachine)
                                        REFERENCES As_ingredient_Maintenance(id)
);

CREATE SEQUENCE SEQ_TEMPS_OUVERTURE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE FUNCTION get_SEQ_TEMPS_OUVERTURE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT SEQ_TEMPS_OUVERTURE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

CREATE OR REPLACE VIEW tempsouverturelib AS
SELECT
    t.*,
    aim.libelle AS idmachinelib
FROM tempsouverture t
         LEFT JOIN as_ingredient_maintenance aim
                   ON aim.id = t.idmachine;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771224965983163', 'Temps d''ouverture', 'access_time', '', 6, 2, 'MNDNMT01');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771224993853515', 'Saisie', 'add', 'module.jsp?but=tempsOuverture/tempsOuverture-saisie.jsp', 1, 3, 'MENDYN1771224965983163');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771225004068406', 'Liste', 'view_list', 'module.jsp?but=tempsOuverture/tempsOuverture-liste.jsp', 2, 3, 'MENDYN1771224965983163');
