CREATE TABLE HistoriqueInspectionFille(
      id varchar(50) PRIMARY KEY NOT NULL,
      idMere varchar(50),
      idElement varchar(50),
      etatInspection varchar(50),
      remarque varchar(255),
      FOREIGN KEY (idElement) REFERENCES ELEMENTINSPECTIONMACHINE(id),
      FOREIGN key(etatInspection) REFERENCES etatinspection(id)
);

CREATE SEQUENCE SEQ_HISTORIQUE_INSPECTION_F INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE function getSeqHistoriqueInspectionF return NUMBER is retour NUMBER;
begin
select
    SEQ_HISTORIQUE_INSPECTION_F.nextval
into
    retour
from
    dual;
return retour;
end;

