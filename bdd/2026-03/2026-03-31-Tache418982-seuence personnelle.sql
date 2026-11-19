CREATE OR REPLACE FUNCTION get_seq_personnelle
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT SEQ_PERSONNEL.NEXTVAL into retour from dual;
RETURN retour;
END;