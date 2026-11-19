CREATE TABLE HistoriqueInspectionMere(
     id varchar(50) PRIMARY KEY NOT NULL,
     daty DATE,
     heure varchar(50),
     idinspecteur varchar(50),
     idElement varchar(50),
     remarque varchar(255),
     etat integer,
     FOREIGN key(idinspecteur) REFERENCES personnel(id),
     FOREIGN KEY (idElement) REFERENCES AS_INGREDIENT_MAINTENANCE(id)
);

CREATE SEQUENCE SEQ_HISTORIQUE_INSPECTION_MERE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE function getSeqHistoriqueInspectionMere return NUMBER is retour NUMBER;
    begin
        select
            SEQ_HISTORIQUE_INSPECTION_MERE.nextval
        into
            retour
        from
            dual;
        return retour;
    end;
