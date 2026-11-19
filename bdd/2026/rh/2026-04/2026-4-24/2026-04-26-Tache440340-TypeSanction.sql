create sequence seq_TYPESANCTION
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION GETseq_TYPESANCTION
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_TYPESANCTION.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MDT0210300229', 'Type Sanction', 'gavel', 'module.jsp?but=typesanction/typesanction-liste.jsp', 13, 2, 'MNDN00000002111');