CREATE OR REPLACE VIEW V_STATISTIQUE_CA AS
WITH CA_PAR_VENTE AS (
    SELECT
        v.ID AS IDVENTE,
        TRUNC(v.DATY) AS DATY,


        SUM(
                NVL(vd.QTE, 0) * NVL(vd.PU, 0)
        ) - NVL(v.FRAISLIVRAISON, 0) AS CA_VENTE

    FROM VENTE v

             JOIN VENTE_DETAILS vd
                  ON vd.IDVENTE = v.ID

    WHERE v.DATY IS NOT NULL
      AND v.ETAT >= 11

    GROUP BY
        v.ID,
        TRUNC(v.DATY),
        v.FRAISLIVRAISON
),

     CA_PAR_JOUR AS (
         SELECT
             DATY,
             SUM(CA_VENTE) AS CA
         FROM CA_PAR_VENTE
         GROUP BY DATY
     )

SELECT
    EXTRACT(YEAR FROM SYSDATE) AS ANNEE,
    TRUNC(SYSDATE) AS DATY,

    /* CA du jour */
    NVL(
            MAX(
                    CASE
                        WHEN DATY = TRUNC(SYSDATE)
                            THEN CA
                        END
            ),
            0
    ) AS CA_DU_JOUR,

    /* Meilleur CA journalier de la semaine */
    NVL(
            MAX(
                    CASE
                        WHEN DATY >= TRUNC(SYSDATE, 'IW')
                            AND DATY < TRUNC(SYSDATE, 'IW') + 7
                            THEN CA
                        END
            ),
            0
    ) AS MEILLEUR_CA_SEMAINE,

    /* Meilleur CA journalier du mois */
    NVL(
            MAX(
                    CASE
                        WHEN DATY >= TRUNC(SYSDATE, 'MM')
                            AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1)
                            THEN CA
                        END
            ),
            0
    ) AS MEILLEUR_CA_MOIS,

    /* CA total de l'année */
    NVL(
            SUM(
                    CASE
                        WHEN DATY >= TRUNC(SYSDATE, 'YYYY')
                            AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12)
                            THEN CA
                        ELSE 0
                        END
            ),
            0
    ) AS CA_ANNEE,

    /* CA par mois de l'année courante */
    NVL(SUM(
                CASE
                    WHEN DATY >= TRUNC(SYSDATE, 'YYYY')
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 1)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_JANVIER,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 1)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 2)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_FEVRIER,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 2)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 3)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_MARS,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 3)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 4)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_AVRIL,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 4)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 5)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_MAI,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 5)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 6)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_JUIN,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 6)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 7)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_JUILLET,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 7)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 8)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_AOUT,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 8)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 9)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_SEPTEMBRE,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 9)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 10)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_OCTOBRE,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 10)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 11)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_NOVEMBRE,

    NVL(SUM(
                CASE
                    WHEN DATY >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 11)
                        AND DATY < ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12)
                        THEN CA ELSE 0
                    END
        ), 0) AS CA_DECEMBRE

FROM CA_PAR_JOUR;