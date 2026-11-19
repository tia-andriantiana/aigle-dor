CREATE OR REPLACE VIEW MOUVEMENTCAISSEAVECHEURE AS
SELECT
    m.ID,
    m.DESIGNATION,
    m.IDCAISSE,
    m.IDVENTEDETAIL,
    m.IDVIREMENT,
    CASE
        WHEN m.HEURE IS NOT NULL AND m.HEURE != '00:00:00'
        THEN m.DATY + (TO_NUMBER(SUBSTR(m.HEURE, 1, 2)) / 24)
                   + (TO_NUMBER(SUBSTR(m.HEURE, 4, 2)) / 1440)
                   + (TO_NUMBER(SUBSTR(m.HEURE, 7, 2)) / 86400)
        ELSE m.DATY
    END AS DATY,
    m.ETAT,
    m.IDOP,
    m.IDORIGINE,
    m.IDDEVISE,
    m.IDTIERS,
    m.COMPTE,
    m.IDPREVISION,
    m.IDTRAITE,
    m.ETATVERSEMENT,
    m.IDMODEPAIEMENT,
    m.IDMVTCAISSEMERE,
    m.REFERENCE,
    m.UPDATED_AT,
    m.DATYCOMPTABILISATION,
    m.ACQUEREUR,
    m.IDTYPEPAIEMENT,
    m.DEBIT,
    m.CREDIT,
    m.TAUX,
    m.HEURE,
    m.idReport
FROM MOUVEMENTCAISSE m;

create or replace view V_ETATCAISSE as
WITH max_inventaire AS (
    -- Etape 1 : On extrait la date maximale valide et la quantite par COUPLE produit/magasin
    SELECT rep.IDCAISSE,
           MAX(rep.DATY)                                             AS max_daty,
           MAX(rep.MONTANT) KEEP (DENSE_RANK LAST ORDER BY rep.DATY) AS montant_max_daty
    FROM REPORTCAISSEAVECHEURE rep
    WHERE rep.ETAT >= 11 --and rep.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
    GROUP BY rep.IDCAISSE),
    tauxChangeMax AS (
         SELECT
             max(tau.TAUX) KEEP (DENSE_RANK LAST ORDER BY tau.DATY) as taux,
             tau.IDDEVISE as tauxIdDevise,
             max(tau.DATY) as tauxDaty
         FROM TAUXDECHANGE tau group by IDDEVISE
     ),
     somme_precalc AS (
         SELECT c.ID as idcaisse, c.VAL as idCaisselib,
                NVL(SUM(CASE
                            WHEN mff.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.CREDIT
                            ELSE 0 END), 0)       AS credit,

                NVL(SUM(CASE
                            WHEN mff.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.DEBIT
                            ELSE 0 END), 0)       AS debit,
                max(inv.max_daty)                 AS dateDernierReport,
                nvl(max(inv.montant_max_daty), 0) as montantDernierReport,
                c.IDPOINT,p.VAL as idPointlib,c.IDTYPECAISSE,typ.VAL as idTypeCaisselib,c.IDDEVISE,
                max(tau.taux) as taux
         FROM Caisse c
         left join    MOUVEMENTCAISSEAVECHEURE mff on mff.IDCAISSE=c.ID and mff.ETAT>=11 and mff.idreport is not null-- and mff.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
         JOIN max_inventaire inv ON inv.IDCAISSE=c.ID
         left JOIN tauxChangeMax TAU ON TAU.tauxIdDevise=C.IDDEVISE
         left join point p on p.ID=c.IDPOINT
         left join TYPECAISSE typ on typ.ID=c.IDTYPECAISSE
         GROUP BY c.id,c.IDPOINT,p.VAL,c.IDTYPECAISSE,typ.VAL,c.VAL,c.IDDEVISE)
-- Selection finale
SELECT idcaisse,idCaisselib||' ('||nvl(IDDEVISE,'AR')||')' as idCaisselib, cast(credit as number(30,2)) as credit, cast(debit as number(30,2)) as debit,
       cast(montantDernierReport+credit-debit as number(30,2)) as reste, cast(nvl(taux,1) as number(30,2)) as taux,
       cast((montantDernierReport+credit-debit)*nvl(taux,1) as number(30,2)) as resteAr, DATE'2025-01-01' as daty,idcaisse as id,
       datedernierreport, cast(montantdernierreport as number(30,2)) as montantdernierreport, idpoint, idpointlib, idtypecaisse, idtypecaisselib
FROM somme_precalc
;


insert into COMPTA_COMPTE values('COMCSOCPERTECAISSE01','671800','perte sur report de caisse',1,6,null,'COMP000067',null);
insert into COMPTA_COMPTE values('COMCSOCGAINCAISSE02','771800','gain sur report de caisse',1,6,null,'COMP000039',null);
insert into PARAMCOMPTA values('PARAMPERTE1','Perte sur report de caisse','671800');
insert into PARAMCOMPTA values('PARAMGAIN2','Gain sur report de caisse','771800'); 