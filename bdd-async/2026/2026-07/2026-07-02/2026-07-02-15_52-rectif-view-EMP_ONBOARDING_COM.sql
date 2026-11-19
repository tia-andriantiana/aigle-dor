create view EMP_ONBOARDING_COM as
SELECT
    eos.ID,eos.DATEDEBUT,eos.DATEFIN,eos.ETAT,eos.PROGRESSION,eos.IDPERSONNEL,eos.PERSONNELLIB,eos.IDONBOARDING,eos.ONBOARDINGLIB,
    om.idFonction,
    pf.val AS idFonctionLib
FROM EMPLOYEEONBOARDINGSESSIONSCPL eos
         LEFT JOIN onboarding_mere om
                   ON om.id = eos.IDONBOARDING
         LEFT JOIN paie_fonction pf
                   ON pf.id = om.idFonction
WHERE om.idFonction IS NULL