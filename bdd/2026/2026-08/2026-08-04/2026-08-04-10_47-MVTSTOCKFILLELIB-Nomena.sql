create or replace view MVTSTOCKFILLELIB as
SELECT base."ID",base."IDMVTSTOCK",base."IDPRODUIT",base."IDPRODUITLIB",base."ENTREE",base."SORTIE",base."IDVENTEDETAIL",base."IDVENTEDETAILLIB",base."IDTRANSFERTDETAIL",base."IDTRANSFERTDETAILLIB",base."DATY",base."IDMAGASIN",base."IDMAGASINLIB",base."PU",base."MONTANT",base."LIBELLE",base."MVTSRC",base."LIBELLEEXACTE",base."DATESQL",base."IDOBJET",base."IDTYPEMVSTOCK",base."ETAT",base."ETATLIB",
       base.couleurLib,base."TAILLE",
       (
           NVL(CAST(base.ID AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDMVTSTOCK AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUIT AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDPRODUITLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.ENTREE), '') || ' | ' ||
           NVL(TO_CHAR(base.SORTIE), '') || ' | ' ||
           NVL(CAST(base.IDVENTEDETAIL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDVENTEDETAILLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTRANSFERTDETAIL AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTRANSFERTDETAILLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.DATY, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(CAST(base.IDMAGASIN AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDMAGASINLIB AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.PU), '') || ' | ' ||
           NVL(TO_CHAR(base.MONTANT), '') || ' | ' ||
           NVL(CAST(base.LIBELLE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.MVTSRC AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.LIBELLEEXACTE AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.DATESQL, 'YYYY-MM-DD HH24:MI:SS'), '') || ' | ' ||
           NVL(CAST(base.IDOBJET AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(CAST(base.IDTYPEMVSTOCK AS VARCHAR2(4000)), '') || ' | ' ||
           NVL(TO_CHAR(base.ETAT), '') || ' | ' ||
           NVL(CAST(base.ETATLIB AS VARCHAR2(4000)), '')
           ) AS MOTSCLESSS
FROM (
         SELECT m.ID,
                m.IDMVTSTOCK,
                m.IDPRODUIT,
                p.LIBELLE AS IDPRODUITLIB,
                m.ENTREE,
                m.SORTIE,
                m.IDVENTEDETAIL,
                CAST(NULL AS VARCHAR2(255)) AS IDVENTEDETAILLIB,
                m.IDTRANSFERTDETAIL,
                CAST(NULL AS VARCHAR2(255)) AS IDTRANSFERTDETAILLIB,
                m2.DATY,
                m2.IDMAGASIN,
                m3.VAL AS IDMAGASINLIB,
                m.PU,
                CAST(
                        NVL(m.PU, 0) * NVL(m.ENTREE, 0) +
                        NVL(m.PU, 0) * NVL(m.SORTIE, 0)
                    AS NUMBER(20, 5)
                ) AS MONTANT,
                p.LIBELLE,
                m.MVTSRC,
                p.LIBELLE AS LIBELLEEXACTE,
                m2.DATY AS DATESQL,
                m2.IDOBJET,
                m2.IDTYPEMVSTOCK,
                m2.ETAT,
                CASE
                    WHEN m2.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                    WHEN m2.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN m2.ETAT = 0  THEN 'ANNUL&Eacute;E'
                    ELSE NULL
                    END AS ETATLIB,
                coul.VAL as couleurLib,
                p.TAILLE
         FROM MVTSTOCKFILLE m
                  LEFT JOIN AS_INGREDIENTS p
                            ON p.ID = m.IDPRODUIT
                  LEFT JOIN COULEUR coul
                            ON p.COULEUR = coul.id
                  LEFT JOIN MVTSTOCK m2
                            ON m2.ID = m.IDMVTSTOCK
                  LEFT JOIN MAGASIN2 m3
                            ON m3.ID = m2.IDMAGASIN
     ) base;