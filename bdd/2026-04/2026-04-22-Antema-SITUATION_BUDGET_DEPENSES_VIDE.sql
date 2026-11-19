create or replace view SITUATION_BUDGET_DEPENSES_VIDE as
select id, compte, service, annee, 6 as moisdebut,moisdebutlib, 8 as moisfin,moisfinlib, budget, montantfacture, paiement, resteapayer, ECARTFACTUREBUDGET, ECARTBUDGETPAIEMENT from
    (select ID,
            COMPTE,
            SERVICE,
            ANNEE,
            sum(nvl(BUDGET, 0)) as budget,
            sum(nvl(MONTANTFACTURE, 0)) as montantfacture,
            sum(nvl(PAIEMENT, 0)) as paiement,
            SUM(nvl(RESTEAPAYER, 0)) as resteapayer,
            SUM(nvl(ECARTFACTUREBUDGET, 0)) as ECARTFACTUREBUDGET,
            SUM(nvl(ECARTBUDGETPAIEMENT, 0)) as ECARTBUDGETPAIEMENT,
            TO_CHAR(
                    TO_DATE(TO_CHAR(6, 'FM00'), 'MM'),
                    'FMMonth',
                    'NLS_DATE_LANGUAGE=FRENCH'
            ) AS moisdebutlib,
            TO_CHAR(
                    TO_DATE(TO_CHAR(8, 'FM00'), 'MM'),
                    'FMMonth',
                    'NLS_DATE_LANGUAGE=FRENCH'
            ) AS moisfinlib
     from situation_budget_depenses where mois between 6 and 8 group by ID, COMPTE, SERVICE, ANNEE);


UPDATE MENUDYNAMIQUE SET LIBELLE = 'Situation dépense', ICONE = 'view_list', HREF = 'module.jsp?but=budget/budget-depenses-liste.jsp', RANG = 4, NIVEAU = 2, ID_PERE = 'MENUDYN003' where id = 'MENUDYN007';
UPDATE MENUDYNAMIQUE SET LIBELLE = 'Situation dépense annuelle', ICONE = 'view_list', HREF = 'module.jsp?but=budget/budget-depenses-annuel.jsp', RANG = 5, NIVEAU = 2, ID_PERE = 'MENUDYN003' where id = 'MENUDYN1607007';
