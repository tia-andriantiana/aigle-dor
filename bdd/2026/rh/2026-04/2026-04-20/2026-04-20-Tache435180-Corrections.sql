-- Stefan

CREATE OR REPLACE VIEW "LOG_PERS_NON_VALIDE_LIB_CREE" AS
SELECT log_pers_non_valide_lib.id,
       log_pers_non_valide_lib.idlogpers,
       log_pers_non_valide_lib.sexe,
       log_pers_non_valide_lib.dateapplication,
       log_pers_non_valide_lib.idtypedebauche,
       log_pers_non_valide_lib.etat,
       log_pers_non_valide_lib.iduser,
       log_pers_non_valide_lib.matricule,
       log_pers_non_valide_lib.date_decision,
       log_pers_non_valide_lib.refdecision,
       log_pers_non_valide_lib.etatLib
FROM log_pers_non_valide_lib
WHERE log_pers_non_valide_lib.etat = 1
;

CREATE OR REPLACE VIEW "LOG_PERS_NON_VALIDE_LIB_VISE"  AS
SELECT log_pers_non_valide_lib.id,
       log_pers_non_valide_lib.idlogpers,
       log_pers_non_valide_lib.sexe,
       log_pers_non_valide_lib.dateapplication,
       log_pers_non_valide_lib.idtypedebauche,
       log_pers_non_valide_lib.etat,
       log_pers_non_valide_lib.iduser,
       log_pers_non_valide_lib.matricule,
       log_pers_non_valide_lib.date_decision,
       log_pers_non_valide_lib.refdecision,
       log_pers_non_valide_lib.etatLib
FROM log_pers_non_valide_lib
WHERE log_pers_non_valide_lib.etat = 11
;

CREATE OR REPLACE VIEW "LOG_PERS_NON_VALIDE_LIB_STC" AS
SELECT log_pers_non_valide_lib.id,
       log_pers_non_valide_lib.idlogpers,
       log_pers_non_valide_lib.sexe,
       log_pers_non_valide_lib.dateapplication,
       log_pers_non_valide_lib.idtypedebauche,
       log_pers_non_valide_lib.etat,
       log_pers_non_valide_lib.iduser,
       log_pers_non_valide_lib.matricule,
       log_pers_non_valide_lib.date_decision,
       log_pers_non_valide_lib.refdecision,
       log_pers_non_valide_lib.etatLib
FROM log_pers_non_valide_lib
WHERE log_pers_non_valide_lib.etat = 24
;

create table BILLETAGEFILLE
(
    ID           VARCHAR2(100) not null
        primary key,
    IDMERE       VARCHAR2(100) not null,
    BILLET       NUMBER        not null,
    NOMBREBILLET NUMBER        not null
);