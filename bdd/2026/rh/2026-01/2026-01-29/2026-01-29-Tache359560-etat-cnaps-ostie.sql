-- XC0113.CNAPS_T1 source

CREATE OR REPLACE VIEW CNAPS_T1  AS
SELECT
    pec.idpersonnel,
    pipl.matricule,
    pipl.nom AS personnel,
    pipl.prenom as prenom,
    pipl.numero_cnaps,
    pipl.direction,
    pipl.dateembauche,
    pec.annee,

    NVL(s1.brut, 0) AS mois1,
    NVL(s1.cnaps_travailleur, 0) AS cnaps_travailleur1,
    NVL(s1.cnaps_employeur, 0) AS cnaps_employeur1,

    NVL(s2.brut, 0) AS mois2,
    NVL(s2.cnaps_travailleur, 0) AS cnaps_travailleur2,
    NVL(s2.cnaps_employeur, 0) AS cnaps_employeur2,

    NVL(s3.brut, 0) AS mois3,
    NVL(s3.cnaps_travailleur, 0) AS cnaps_travailleur3,
    NVL(s3.cnaps_employeur, 0) AS cnaps_employeur3,

    (NVL(s1.cnaps_travailleur, 0) + NVL(s2.cnaps_travailleur, 0) + NVL(s3.cnaps_travailleur, 0)) AS cotisation_travailleur,
    (NVL(s1.cnaps_employeur, 0) + NVL(s2.cnaps_employeur, 0) + NVL(s3.cnaps_employeur, 0)) AS cotisation_employeur

FROM
    paie_edition_cnaps pec
        JOIN paie_info_personnel_libcomplet pipl
             ON TO_CHAR(pipl.id) = TO_CHAR(pec.idpersonnel)
                 AND pec.mois IN (1, 2, 3)

        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 1
    ) s1 ON TO_CHAR(pec.idpersonnel) = TO_CHAR(s1.idpersonnel) AND pec.annee = s1.annee

        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 2
    ) s2 ON TO_CHAR(pec.idpersonnel) = TO_CHAR(s2.idpersonnel) AND pec.annee = s2.annee

        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 3
    ) s3 ON TO_CHAR(pec.idpersonnel) = TO_CHAR(s3.idpersonnel) AND pec.annee = s3.annee

GROUP BY
    pec.idpersonnel, pipl.matricule, pipl.nom, pipl.prenom ,pipl.numero_cnaps, pipl.direction, pec.annee,
    s1.brut, s1.cnaps_travailleur, s1.cnaps_employeur, pipl.dateembauche,
    s2.brut, s2.cnaps_travailleur, s2.cnaps_employeur,
    s3.brut, s3.cnaps_travailleur, s3.cnaps_employeur;


-- XC0113.CNAPS_T2 source

CREATE OR REPLACE VIEW CNAPS_T2  AS
SELECT
    pec.idpersonnel,
    pipl.matricule,
    pipl.nom AS personnel,
    pipl.prenom as prenom,
    pipl.numero_cnaps,
    pipl.dateembauche,
    pipl.direction,
    pec.annee,

    NVL(s1.brut, 0) AS mois1,
    NVL(s1.cnaps_travailleur, 0) AS cnaps_travailleur1,
    NVL(s1.cnaps_employeur, 0) AS cnaps_employeur1,

    NVL(s2.brut, 0) AS mois2,
    NVL(s2.cnaps_travailleur, 0) AS cnaps_travailleur2,
    NVL(s2.cnaps_employeur, 0) AS cnaps_employeur2,

    NVL(s3.brut, 0) AS mois3,
    NVL(s3.cnaps_travailleur, 0) AS cnaps_travailleur3,
    NVL(s3.cnaps_employeur, 0) AS cnaps_employeur3,

    ROUND(NVL(s1.cnaps_travailleur, 0) + NVL(s2.cnaps_travailleur, 0) + NVL(s3.cnaps_travailleur, 0), 2) AS cotisation_travailleur,
    ROUND(NVL(s1.cnaps_employeur, 0) + NVL(s2.cnaps_employeur, 0) + NVL(s3.cnaps_employeur, 0), 2) AS cotisation_employeur

FROM paie_edition_cnaps pec
         JOIN paie_info_personnel_libcomplet pipl
              ON pipl.id = pec.idpersonnel
                  AND pec.mois IN (4, 5, 6)

         LEFT JOIN (
    SELECT idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
    FROM paie_edition_cnaps
    WHERE mois = 4
) s1 ON pec.idpersonnel = s1.idpersonnel AND pec.annee = s1.annee

         LEFT JOIN (
    SELECT idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
    FROM paie_edition_cnaps
    WHERE mois = 5
) s2 ON pec.idpersonnel = s2.idpersonnel AND pec.annee = s2.annee

         LEFT JOIN (
    SELECT idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
    FROM paie_edition_cnaps
    WHERE mois = 6
) s3 ON pec.idpersonnel = s3.idpersonnel AND pec.annee = s3.annee

GROUP BY
    pec.idpersonnel, pipl.matricule, pipl.nom, pipl.numero_cnaps, pipl.prenom,    pipl.dateembauche,
    pipl.direction, pec.annee,
    s1.brut, s1.cnaps_travailleur, s1.cnaps_employeur,
    s2.brut, s2.cnaps_travailleur, s2.cnaps_employeur,
    s3.brut, s3.cnaps_travailleur, s3.cnaps_employeur;

-- XC0113.CNAPS_T3 source

CREATE OR REPLACE VIEW CNAPS_T3 AS
SELECT
    pec.idpersonnel,
    pipl.matricule,
    pipl.nom AS personnel,
    pipl.prenom as prenom,
    pipl.numero_cnaps,
    pipl.dateembauche,
    pipl.direction,
    pec.annee,
    ROUND(NVL(s1.brut, 0), 2) AS mois1,
    ROUND(NVL(s1.cnaps_travailleur, 0), 2) AS cnaps_travailleur1,
    ROUND(NVL(s1.cnaps_employeur, 0), 2) AS cnaps_employeur1,
    ROUND(NVL(s2.brut, 0), 2) AS mois2,
    ROUND(NVL(s2.cnaps_travailleur, 0), 2) AS cnaps_travailleur2,
    ROUND(NVL(s2.cnaps_employeur, 0), 2) AS cnaps_employeur2,
    ROUND(NVL(s3.brut, 0), 2) AS mois3,
    ROUND(NVL(s3.cnaps_travailleur, 0), 2) AS cnaps_travailleur3,
    ROUND(NVL(s3.cnaps_employeur, 0), 2) AS cnaps_employeur3,
    ROUND(NVL(s1.cnaps_travailleur, 0) + NVL(s2.cnaps_travailleur, 0) + NVL(s3.cnaps_travailleur, 0), 2) AS cotisation_travailleur,
    ROUND(NVL(s1.cnaps_employeur, 0) + NVL(s2.cnaps_employeur, 0) + NVL(s3.cnaps_employeur, 0), 2) AS cotisation_employeur
FROM
    paie_edition_cnaps pec
        JOIN paie_info_personnel_libcomplet pipl ON pipl.id = pec.idpersonnel
        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 7
    ) s1 ON pec.idpersonnel = s1.idpersonnel AND pec.annee = s1.annee
        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 8
    ) s2 ON pec.idpersonnel = s2.idpersonnel AND pec.annee = s2.annee
        LEFT JOIN (
        SELECT idpersonnel, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 9
    ) s3 ON pec.idpersonnel = s3.idpersonnel AND pec.annee = s3.annee
WHERE
    pec.mois IN (7, 8, 9)
GROUP BY
    pec.idpersonnel,
    pipl.matricule,
    pipl.nom,
    pipl.prenom,
    pipl.numero_cnaps,
    pipl.dateembauche,
    pipl.direction,
    pec.annee,
    s1.brut, s1.cnaps_travailleur, s1.cnaps_employeur,
    s2.brut, s2.cnaps_travailleur, s2.cnaps_employeur,
    s3.brut, s3.cnaps_travailleur, s3.cnaps_employeur;


-- XC0113.CNAPS_T4 source

CREATE OR REPLACE VIEW CNAPS_T4  AS
SELECT
    pec.idpersonnel,
    pipl.matricule,
    pipl.nom AS personnel,
    pipl.prenom,
    pipl.numero_cnaps,
    pipl.dateembauche,
    pipl.direction,
    pec.annee,

    ROUND(NVL(s1.brut, 0), 2) AS mois1,
    ROUND(NVL(s1.cnaps_travailleur, 0), 2) AS cnaps_travailleur1,
    ROUND(NVL(s1.cnaps_employeur, 0), 2) AS cnaps_employeur1,

    ROUND(NVL(s2.brut, 0), 2) AS mois2,
    ROUND(NVL(s2.cnaps_travailleur, 0), 2) AS cnaps_travailleur2,
    ROUND(NVL(s2.cnaps_employeur, 0), 2) AS cnaps_employeur2,

    ROUND(NVL(s3.brut, 0), 2) AS mois3,
    ROUND(NVL(s3.cnaps_travailleur, 0), 2) AS cnaps_travailleur3,
    ROUND(NVL(s3.cnaps_employeur, 0), 2) AS cnaps_employeur3,

    ROUND(NVL(s1.cnaps_travailleur, 0) + NVL(s2.cnaps_travailleur, 0) + NVL(s3.cnaps_travailleur, 0), 2) AS cotisation_travailleur,
    ROUND(NVL(s1.cnaps_employeur, 0) + NVL(s2.cnaps_employeur, 0) + NVL(s3.cnaps_employeur, 0), 2) AS cotisation_employeur

FROM
    paie_edition_cnaps pec
        JOIN paie_info_personnel_libcomplet pipl
             ON pipl.id = pec.idpersonnel
                 AND pec.mois IN (10, 11, 12)

        LEFT JOIN (
        SELECT
            idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 10
    ) s1 ON pec.idpersonnel = s1.idpersonnel AND pec.annee = s1.annee

        LEFT JOIN (
        SELECT
            idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 11
    ) s2 ON pec.idpersonnel = s2.idpersonnel AND pec.annee = s2.annee

        LEFT JOIN (
        SELECT
            idpersonnel, mois, annee, brut, cnaps_travailleur, cnaps_employeur
        FROM paie_edition_cnaps
        WHERE mois = 12
    ) s3 ON pec.idpersonnel = s3.idpersonnel AND pec.annee = s3.annee;



-- XC0113.V1_OSTIE_AFFICHE_T1 source

CREATE OR REPLACE VIEW V1_OSTIE_AFFICHE_T1  AS
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 1
                     or
                 extract(month from pip.date_depart) = 2
                     or
                 extract(month from pip.date_depart) = 3
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 1 or mois=2 or mois =3) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 1) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 2) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 3) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;


-- XC0113.V1_OSTIE_AFFICHE_T2 source

CREATE OR REPLACE VIEW V1_OSTIE_AFFICHE_T2 AS
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 4
                     or
                 extract(month from pip.date_depart) = 5
                     or
                 extract(month from pip.date_depart) = 6
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 4 or mois=5 or mois =6) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 4) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 5) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 6) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;


-- XC0113.V1_OSTIE_AFFICHE_T3 source

CREATE OR REPLACE VIEW V1_OSTIE_AFFICHE_T3 AS
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 7
                     or
                 extract(month from pip.date_depart) = 8
                     or
                 extract(month from pip.date_depart) = 9
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 7 or mois=8 or mois =9) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 7) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 8) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 9) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;

-- XC0113.V1_OSTIE_AFFICHE_T4 source

CREATE OR REPLACE VIEW V1_OSTIE_AFFICHE_T4 AS
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 10
                     or
                 extract(month from pip.date_depart) = 11
                     or
                 extract(month from pip.date_depart) = 12
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 10 or mois=11 or mois =12) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 10) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 11) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 12) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;