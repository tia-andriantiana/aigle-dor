create or replace view PREVISION_TIERS as
select p.*, t.nom as tierslib from PREVISION_COMPLET_CPLPositif p LEFT JOIN TIERS t on t.id = p.IDTIERS;
