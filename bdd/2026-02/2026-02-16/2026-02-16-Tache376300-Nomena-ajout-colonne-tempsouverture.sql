ALTER TABLE TEMPSOUVERTURE
    ADD CAPACITE NUMBER;

ALTER TABLE TEMPSOUVERTURE
    ADD IDUNITE VARCHAR(25);

ALTER TABLE TEMPSOUVERTURE
    ADD CONSTRAINT FK_TEMPSOUVERTURE_UNITE
        FOREIGN KEY (IDUNITE)
            REFERENCES AS_UNITE(ID);

create or replace view TEMPSOUVERTURELIB as
SELECT
    t.ID,t.IDMACHINE,t.TEMPS,t.CAPACITE,t.IDUNITE,
    aim.LIBELLE AS idmachinelib,
    au.VAL as idunitelib
FROM tempsouverture t
         LEFT JOIN as_ingredient_maintenance aim
                   ON aim.id = t.idmachine
         LEFT JOIN AS_UNITE au
                   ON au.id = t.IDUNITE;


