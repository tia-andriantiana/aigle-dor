create view V_ETAT_CAISSE_MAGASIN as
select v."ID",v."IDCAISSE",v."IDCAISSELIB",v."IDTYPECAISSE",v."IDTYPECAISSELIB",v."IDPOINT",v."IDPOINTLIB",v."DATEDERNIERREPORT",v."MONTANTDERNIERREPORT",v."DEBIT",v."CREDIT",v."RESTE", mag.ID as IDMAGASIN, mag.VAL as IDMAGASINLIB
from V_ETATCAISSE v left join MAGASINLIB mag
                              on mag.IDPOINT = v.IDPOINT;

create view VENTE_CA_EVOLUTION_MAGASIN as
SELECT
    v_today.IDMAGASIN,
    v_today.IDMAGASINLIB,
    v_today.DATY,
    SUM(v_today.MONTANTTOTAL)                                                    AS ca_jour,
    NVL(SUM(v_hier.MONTANTTOTAL), 0)                                             AS ca_veille,

    CASE
        WHEN NVL(SUM(v_hier.MONTANTTOTAL), 0) = 0 THEN 100
        ELSE ROUND(
                ((SUM(v_today.MONTANTTOTAL) - NVL(SUM(v_hier.MONTANTTOTAL), 0))
                    / NVL(SUM(v_hier.MONTANTTOTAL), 1)) * 100,
                2
             )
        END                                                                          AS evolution_pct,
    SUM(v_today.MONTANTTOTAL) - NVL(SUM(v_hier.MONTANTTOTAL), 0)                AS difference_montant,
    v_today.moislib,
    v_today.anneelib,
    v_today.moisanneelib,
    sum(v_today.nb) as ventes_jour,
    sum(v_hier.nb) as ventes_veille,
    CASE
        WHEN NVL(SUM(v_hier.nb), 0) = 0 THEN 100
        ELSE ROUND(
                ((SUM(v_today.nb) - NVL(SUM(v_hier.nb), 0))
                    / NVL(SUM(v_hier.nb), 1)) * 100,
                2
             )
        END                                                                          AS evolution_ventes_pct,
    SUM(v_today.nb) - NVL(SUM(v_hier.nb), 0)                                                        AS difference_ventes
FROM VENTE_CA v_today
         LEFT JOIN VENTE_CA v_hier
                   ON v_hier.DATY = v_today.DATY - 1
                       AND v_hier.IDMAGASIN = v_today.IDMAGASIN
GROUP BY
    v_today.IDMAGASIN,
    v_today.IDMAGASINLIB,
    v_today.DATY,
    v_today.moislib,
    v_today.anneelib,
    v_today.moisanneelib
ORDER BY DATY DESC;


