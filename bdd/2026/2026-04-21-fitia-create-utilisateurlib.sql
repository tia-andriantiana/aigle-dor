
create or replace view v_utilisateurlib as
select u.*,r.DESCROLE from UTILISATEUR u
left join ROLES r on r.IDROLE=u.IDROLE;