/*============ !!!!!!! IMPORTANT -> MILA EXECUTENA ====================*/

SELECT 'ALTER TABLE RELEVEFAB DROP CONSTRAINT ' || c.constraint_name || ';'
FROM all_constraints c
JOIN all_constraints r
    ON c.r_constraint_name = r.constraint_name
WHERE c.constraint_type = 'R'
  AND c.table_name = 'RELEVEFAB'
  AND r.table_name = 'FABRICATION';

/*============ !!!!!! IMPORTANT -> MILA EXECUTENA ====================*/


SELECT 'ALTER TABLE COMPTEURMAINTENANCE DROP CONSTRAINT ' || c.constraint_name || ';'
FROM all_constraints c
JOIN all_constraints r
    ON c.r_constraint_name = r.constraint_name
WHERE c.constraint_type = 'R' AND
c.TABLE_NAME='COMPTEURMAINTENANCE' and r.TABLE_NAME='CATEGORIECONSOMMABLE';