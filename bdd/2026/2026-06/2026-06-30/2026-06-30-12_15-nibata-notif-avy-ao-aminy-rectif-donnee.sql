
CREATE TABLE NOTIFICATION2 
   (	ID VARCHAR2(50) NOT NULL ENABLE, 
	RECEIVER NUMBER NOT NULL ENABLE, 
	MESSAGE VARCHAR2(250), 
	DATY DATE, 
	HEURE VARCHAR2(10), 
	ETAT NUMBER, 
	REF VARCHAR2(50), 
	LIEN VARCHAR2(100), 
	 CONSTRAINT NOTIFICATION_PKEY PRIMARY KEY (ID),
	 CONSTRAINT NOTIFICATION_RECEIVER_FKEY FOREIGN KEY (RECEIVER)
	  REFERENCES UTILISATEUR (REFUSER) ENABLE
   )  ; 



CREATE OR REPLACE  VIEW NOTIFICATIONLIBCPLT (ID, RECEIVER, RECEIVERLIB, MESSAGE, DATY, HEURE, ETAT, REF, REFLIB, ETATLIB, LIEN, ECARTDATE) AS 
  SELECT n.id,
       n.receiver,
       u.nomuser AS receiverlib,
       n.message,
       n.daty,
       n.heure,
       n.etat,
       n.ref,
       '' AS reflib,
       CASE
           WHEN n.etat = 11 THEN 'LU'
           WHEN n.etat = 1 THEN 'NON LU'
           ELSE NULL
           END AS etatlib,
       n.lien,
       CASE
           WHEN ( (SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS'))) * 24 * 60 * 60 ) < 60
               THEN 'il y a moins d''une minute'
           WHEN ( (SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS'))) * 24 * 60 * 60 ) < 3600
               THEN 'il y a ' || FLOOR(((SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS'))) * 24 * 60)) || ' mn'
           WHEN ( (SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS'))) * 24 * 60 * 60 ) < 86400
               THEN 'il y a ' || FLOOR(((SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS'))) * 24)) || ' h'
           ELSE 'il y a ' || FLOOR((SYSDATE - (TO_DATE(TO_CHAR(n.daty,'YYYY-MM-DD') || ' ' || n.heure, 'YYYY-MM-DD HH24:MI:SS')))) || ' jrs'
           END AS ecartdate
FROM notification2 n
         LEFT JOIN utilisateur u ON u.refuser = n.receiver order by DATY desc;



CREATE OR REPLACE  VIEW NOTIFICATIONLIBNONLU (ID, RECEIVER, MESSAGE, DATY, HEURE, ETAT, REF, ETATLIB, RECEIVERLIB, LIEN, ECARTDATE, LIEN_HTML) AS 
  SELECT n.id,
       n.receiver,
       n.message,
       n.daty,
       n.heure,
       n.etat,
       n.ref,
       n.etatlib,
       n.receiverlib,
       n.lien,
       n.ecartdate,
       '<a href=XX?but=' || n.lien || '&id=' || n.ref || '>' || n.ref || '</a>' AS lien_html
FROM notificationlibcplt n
WHERE n.etat = 1;
