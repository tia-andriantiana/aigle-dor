CREATE OR REPLACE VIEW CAISSE_ESPECE as
select
    * from CAISSE where IDTYPECAISSE='TCA003' and IDCATEGORIECAISSE='CTC003';

INSERT INTO TYPECAISSE (ID, VAL, DESCE)
VALUES ('TCA005', 'FOND DE CAISSE', 'FOND DE CAISSE');


UPDATE CAISSE
SET
    VAL               = 'Fond de caisse',
    DESCE             = 'Fond de caisse',
    IDTYPECAISSE      = 'TCA005',
    IDPOINT           = 'PNTB0001',
    IDPOMPISTE        = null,
    ETAT              = 11,
    IDCATEGORIECAISSE = 'CTC003',
    COMPTE            = '530001',
    IDMAGASIN         = null,
    IDDEVISE          = 'AR',
    IDTYPEBANQUE      = null,
    ESTRIB            = 0 where  ID= 'CAIBO011';
