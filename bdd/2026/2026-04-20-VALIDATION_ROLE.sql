create table VALIDATION_ROLE(
    id varchar(255) primary key not null,
    refobject varchar(255),
    mapping varchar(255),
    niveau int,
    role varchar(255) references ROLES (IDROLE),
    personne varchar(255),
    valeuretat int
);

-- sequence
CREATE SEQUENCE seq_validation_role
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETSEQVALIDATIONROLE
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT seq_validation_role.nextval INTO retour FROM dual;
    return retour;
END;

-- view
create or replace view VALIDATION_ROLE_LIB_CPL as
select
    vr.*,
    u.NOMUSER,
    r.DESCROLE
from
    VALIDATION_ROLE vr
        left join UTILISATEUR u on u.REFUSER = vr.personne
        left join ROLES r on r.IDROLE = vr.role;