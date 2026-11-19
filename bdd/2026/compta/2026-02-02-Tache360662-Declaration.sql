-- Antema
create or replace view ECRITURE_IMPOT as
select
    se.ID,
    se.COMPTE,
    se.DEBIT,
    se.CREDIT,
    se.REMARQUE,
    se.LIBELLEPIECE,
    se.IDMERE,
    se.REFERENCE_ENGAGEMENT,
    se.COMPTE_AUX,
    se.LETTRAGE,
    se.JOURNAL,
    se.EXERCICE,
    se.ETAT,
    se.DATY,
    se.FOLIO,
    se.ANALYTIQUE,
    se.SOURCE,
    ce.daty as datymere,
    cc.COMPTE as codeimpot,
    sed.MOISDECLARATION
from COMPTA_SOUS_ECRITURE se
         join COMPTA_ECRITURE ce on ce.id=se.IDMERE
         join COMPTA_COMPTE cc on cc.COMPTE=se.COMPTE
         JOIN SOUSECRITUREDECLARER sed ON sed.IDSOUSECRITURE = se.ID;