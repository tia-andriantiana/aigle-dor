-- SOCOBISCOMPLET0420.CHARGE_LIB source

CREATE OR REPLACE  VIEW CHARGE_LIB (ID, DATY, LIBELLE, PU, TYPE, IDFABRICATION, ETAT, IDINGREDIENTS, QTE, IDOFFILLE, IDOF, MOTSCLESSS,typechargelib,idingredientslib,montant) AS 
  SELECT SQ.ID,SQ.DATY,SQ.LIBELLE,SQ.PU,SQ.TYPE,SQ.IDFABRICATION,SQ.ETAT,SQ.IDINGREDIENTS,SQ.QTE,SQ.IDOFFILLE,SQ.IDOF,
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(LIBELLE),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(TYPE),'') || ' | ' || NVL(TO_CHAR(IDFABRICATION),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(IDINGREDIENTS),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(IDOFFILLE),'') || ' | ' || NVL(TO_CHAR(IDOF),'')) AS MOTSCLESSS,typechargelib,idingredientslib,montant
FROM (
  SELECT 
c.id ,
c.daty ,
c.libelle,
c.pu ,
c.type ,
c.idfabrication,
c.etat , 
c.idingredients,
c.qte ,
f.IDOFFILLE,
f.IDOF,
tc.val AS typechargelib,
ing.libelle AS idingredientslib,
CAST(NVL(c.pu * c.qte, 0) AS NUMBER(30,2)) AS montant
FROM CHARGE c 
LEFT JOIN FABRICATION f ON f.id = c.idfabrication  
LEFT JOIN typecharge tc ON c.TYPE=tc.id
LEFT JOIN as_ingredients ing ON c.idingredients=ing.id 
) SQ;

CREATE OR REPLACE  VIEW OFFILLELIBSTOCK (ID, IDINGREDIENTS, LIBELLE, REMARQUE, IDMERE, DATYBESOIN, QTE, IDUNITE, QTEFABRIQUE, QTERESTE, LIBELLEEXACTE, PV, MONTANTENTREE, MONTANTSORTIE, POURC, MOTSCLESSS,DATY) AS 
  SELECT SQ.ID,SQ.IDINGREDIENTS,SQ.LIBELLE,SQ.REMARQUE,SQ.IDMERE,SQ.DATYBESOIN,SQ.QTE,SQ.IDUNITE,SQ.QTEFABRIQUE,SQ.QTERESTE,SQ.LIBELLEEXACTE,SQ.PV,SQ.MONTANTENTREE,SQ.MONTANTSORTIE,SQ.POURC,
  (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDINGREDIENTS),'') || ' | ' || NVL(TO_CHAR(LIBELLE),'') || ' | ' || NVL(TO_CHAR(REMARQUE),'') || ' | ' || NVL(TO_CHAR(IDMERE),'') || ' | ' || NVL(TO_CHAR(DATYBESOIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(QTE),'') || ' | ' || NVL(TO_CHAR(IDUNITE),'') || ' | ' || NVL(TO_CHAR(QTEFABRIQUE),'') || ' | ' || NVL(TO_CHAR(QTERESTE),'') || ' | ' || NVL(TO_CHAR(LIBELLEEXACTE),'') || ' | ' || NVL(TO_CHAR(PV),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(POURC),'')) AS MOTSCLESSS,daty
FROM (
  SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ob.daty AS  DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    cast(nvl(mv.entree,0) as number(30,5)) as qteFabrique,
    cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,5)) as qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
    ai.pv,
    cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
    cast(nvl(mvt.montantSortie,0) as number(30,5)) as montantSortie,
    CASE
        WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
        ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
        END AS pourc,
    ob.daty
FROM
    OFFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
        left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
        LEFT JOIN OFAB ob ON ob.id =  ofll.idmere

) SQ;

-- SOCOBISCOMPLET0420.COUT_FAB_PAR_OF source

CREATE OR REPLACE  VIEW COUT_FAB_PAR_OF_TEMP (IDMERE, DATYBESOIN, INGREDIENTS, COUTDEPRODUCTION, MOTSCLESSS) AS 
  SELECT SQ.IDMERE,SQ.DATYBESOIN,SQ.INGREDIENTS,SQ.COUTDEPRODUCTION,
  (NVL(TO_CHAR(IDMERE),'') || ' | ' || NVL(TO_CHAR(DATYBESOIN,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(INGREDIENTS),'') || ' | ' || NVL(TO_CHAR(COUTDEPRODUCTION),'')) AS MOTSCLESSS
FROM (
  SELECT 
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS AS INGREDIENTS,
    ROUND(
        SUM(montantsortie) , 2
    )  AS COUTDEPRODUCTION
FROM 
    OFFILLELIBSTOCK base
    JOIN OFAB fb ON fb.id = base.idmere AND fb.etat >= 11
GROUP BY 
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS
ORDER BY 
    base.IDMERE
 
) SQ;