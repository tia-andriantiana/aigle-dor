--dans menu transfert stock
--
--ajouter “anomalies”
--
--stock/transfertstock/anomalie-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN00000002115', 'Anomalies', 'list_alt', 'module.jsp?but=stock/transfertstock/anomalie-liste.jsp', 5, 3, 'MNDN0000000211');

--créer view mvtstockfilletransfert
--
--select 
--
--m.idtransfertdetail
--
--sum(entree) as entree
--
--sum(sortie) as sortie
--
--from
--
--mvtstockfillelib m
--
--left join
--
--mvtstock mv
--
--mv.id = m.idmvtstock
--
--group by
--
--m.idtransfertdetail
--
--where
--
--mv.etat >=11

CREATE VIEW mvtstockfilletransfert 
AS 
SELECT 
m.idtransfertdetail,
CAST(sum(nvl(m.entree ,0)) AS NUMBER(30,5))  as entree,
CAST(sum(nvl(m.sortie ,0)) AS NUMBER(30,5)) as sortie
FROM mvtstockfillelib m
left JOIN mvtstock mv ON mv.id = m.idmvtstock
WHERE mv.etat >=11 
GROUP BY m.idtransfertdetail ; 

--Créer view anomalieTransfert
--
--Select
--
--t.id as idTransfert
--
--t.magasinDepart
--
--t.magasinDepartLib
--
--t.magasinArrive
--
--t.magasinArriveLib
--
--t.daty
--
--t.designation
--
--td.idproduit
--
--td.idproduitlib
--
--td.quantite
--
--t.pu*t.quantite as montant
--
--m.sortie as envoye
--
--t.pu*m.sortie as montantEnvoye
--
--m.entree as recu 
--
--t.pu*m.entree as montantRecu
--
--m.sortie - m.entree as ecart
--
--t.pu*ecart as montantEcart
--
--t.quantite - m.sortie as reste
--
--from
--
--transfertstockdetailscpl td
--
--left join
--
--transfertstockcpl t
--
--t.id = td.idtransfertstock
--
--mvtstockfilletransfert m
--
--m.idtransfertdetail = td.id

CREATE VIEW anomalieTransfert 
AS 
SELECT 
t.id as idTransfert,
t.IDMAGASINDEPART AS magasinDepart,
t.IDMAGASINDEPARTLIB AS  magasinDepartLib,
t.IDMAGASINARRIVE AS magasinArrive,
t.IDMAGASINARRIVELIB AS magasinArriveLib,
t.daty,
t.designation,
td.idproduit,
td.idproduitlib,
CAST(nvl(td.quantite,0) AS NUMBER(30,5))  AS quantite ,
CAST(nvl(td.pu,0)*nvl(td.quantite,0) AS NUMBER(30,5))  as montant , 
CAST(nvl(m.sortie,0) AS NUMBER(30,5))  as envoye,
CAST(nvl(td.pu,0)*nvl(m.sortie,0) AS NUMBER(30,5))  as montantEnvoye, 
CAST(nvl(m.entree,0) AS NUMBER(30,5))  as recu ,
CAST(nvl(td.pu,0)*nvl(m.entree,0) AS NUMBER(30,5))  as montantRecu,
CAST(nvl(m.sortie,0) - nvl(m.entree,0) AS NUMBER(30,5))  as ecart,
CAST(nvl(td.pu,0)*CAST(nvl(m.sortie,0) - nvl(m.entree,0) AS NUMBER(30,5)) AS NUMBER(30,5))  as montantEcart ,
CAST(nvl(td.quantite,0) - nvl(m.sortie,0) AS NUMBER(30,5))  as reste
FROM transfertstockdetailscpl td
LEFT JOIN transfertstockcpl t ON t.id = td.idtransfertstock 
LEFT JOIN mvtstockfilletransfert m ON m.idtransfertdetail = td.id ;


