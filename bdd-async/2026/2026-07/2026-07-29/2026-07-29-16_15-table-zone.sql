create table ZONE(
    id varchar(255) constraint ZONE_pk primary key ,
    val varchar(255) ,
    desce varchar(255)
);

create sequence seqZONE
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      
CREATE OR REPLACE FUNCTION getseqZONE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqZONE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;