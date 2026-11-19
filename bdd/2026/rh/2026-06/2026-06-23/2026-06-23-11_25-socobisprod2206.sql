--creer sequence : getseq_log_direction 

CREATE OR REPLACE FUNCTION getseq_log_direction
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQ_LOG_DIRECTION.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 