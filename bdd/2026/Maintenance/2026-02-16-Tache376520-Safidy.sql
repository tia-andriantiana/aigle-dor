CREATE OR REPLACE VIEW typemaintenancetravaux as(
    SELECT
        t.id,
        dc.IDTYPEMAINTENANCE AS val,
        dc.IDTYPEMAINTENANCELIB AS desce
    FROM
    TRAVAUX t
    LEFT JOIN DEMANDETRAVAUX_CPL dc ON dc.IDOTFILLE =t.IDOFFILLE
);
