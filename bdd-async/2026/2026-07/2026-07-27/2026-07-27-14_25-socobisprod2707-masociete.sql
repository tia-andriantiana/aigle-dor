
-- Socobis 
-- Branche masociete-Tache522980


create table MASOCIETE
(
    IDSPAT    VARCHAR2(20) not null
        constraint MASOCIETE_PK
            primary key,
    NOM       VARCHAR2(75)  default '-',
    REGIME    VARCHAR2(50)  default '-',
    ADRESSE   VARCHAR2(500) default '-',
    TELEPHONE VARCHAR2(50)  default '-',
    FAX       VARCHAR2(50)  default '-',
    EMAIL     VARCHAR2(50)  default '-',
    GERANT    CHAR(50)      default '-',
    NIF       VARCHAR2(50)  default '-',
    NUMSTAT   VARCHAR2(50)  default '-',
    RC        VARCHAR2(50)  default '-',
    CAPITAL   VARCHAR2(50)  default '-',
    BANQUE1   VARCHAR2(50)  default '-',
    BANQUE2   VARCHAR2(50)  default '-',
    LOGO      VARCHAR2(255)  default '-',
    TP        VARCHAR2(50)  default '-',
    QUITTANCE VARCHAR2(50)  default '-',
    ENTITE    VARCHAR2(20)  default 'BE011'
);
INSERT
	INTO
	MASOCIETE (IDSPAT,
	NOM,
	REGIME,
	ADRESSE,
	TELEPHONE,
	FAX,
	EMAIL,
	GERANT,
	NIF,
	NUMSTAT,
	RC,
	CAPITAL,
	BANQUE1,
	BANQUE2,
	LOGO,
	TP,
	QUITTANCE,
	ENTITE)
VALUES ('ST1',
'SOCIETE CONFISERIE ET BISCUITERIE',
'General',
'Saropody Tanjombato Antananarivo BP 535',
'+261 20 85 242 84',
'-',
'socobis@malagasy.com',
'-                                                 ',
'1000000729',
'10735 11 1964 0 1000 2',
'--',
'--',
'-',
'-',
'-',
'-',
'-',
'BE011');