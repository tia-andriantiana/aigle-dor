
-- Core tables
CREATE TABLE ai_session (
                            id             VARCHAR2(255) PRIMARY KEY, -- UUID
                            userId        VARCHAR2(255) NOT NULL,
                            status         VARCHAR2(16) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','CLOSED','EXPIRED')),
                            dateStartedAt     DATE,
                            timeStartedAt  varchar(255),
                            lastSeenAt    varchar(255),
                            ttl_minutes    NUMBER(6) DEFAULT 1440, -- 24h
                            metadata_json  varchar(4000)
);

CREATE SEQUENCE seq_ai_session
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_ai_session
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_ai_session.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/



CREATE TABLE ai_turn (
                         id                VARCHAR2(255) PRIMARY KEY, -- UUID
                         sessionId        VARCHAR2(255) NOT NULL REFERENCES ai_session(id),
                         role              VARCHAR2(16) CHECK (role IN ('user','bot','system')),
                         content           varchar(4000),
                         tokensPrompt     NUMBER(10),
                         tokensCompletion NUMBER(10),
                         agent             VARCHAR2(48),
                         latencyMs        NUMBER(10),
                         dateCreatedAt        DATE,
                         timeCreatedAt     varchar(255)
);


CREATE SEQUENCE seq_ai_turn
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_ai_turn
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_ai_turn.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/


-- Helpful indexes
CREATE INDEX ix_ai_session_user ON ai_session(userId, status);
CREATE INDEX ix_ai_session_seen ON ai_session(lastSeenAt);
CREATE INDEX ix_ai_turn_session ON ai_turn(sessionId, dateCreatedAt);


-- Stores compressed "resume" of a conversation
CREATE TABLE chat_summary (
                              id            VARCHAR2(255) PRIMARY KEY,
                              sessionId    VARCHAR2(255) NOT NULL,
                              userId       VARCHAR2(255) NOT NULL,
                              summaryText  varchar(4000),
                              keywords      VARCHAR2(512),
                              dateCreatedAt        DATE,
                              timeCreatedAt     varchar(255)
);


CREATE SEQUENCE seq_chat_summary
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_chat_summary
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_chat_summary.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/

CREATE TABLE ai_agent_call (
                               id VARCHAR2(255) PRIMARY KEY,
                               userId VARCHAR2(255),
                               sessionId VARCHAR2(255),
                               agent VARCHAR2(32),
                               tokensIn NUMBER(10),
                               tokensOut NUMBER(10),
                               costMga NUMBER(12,2),
                               success CHAR(1),
                               latencyMs NUMBER(10),
                               createdAt DATE
);


CREATE SEQUENCE seq_ai_agent_call
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_ai_agent_call
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_ai_agent_call.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/

CREATE TABLE ai_msg_report (
                               id VARCHAR2(255) PRIMARY KEY,
                               emailAdress VARCHAR2(255),
                               email_msg_type VARCHAR(255)
);

CREATE TABLE ai_msg_report_type (
                                    id VARCHAR2(255) PRIMARY KEY,
                                    val VARCHAR2(255),
                                    desce VARCHAR2(255)
);

CREATE SEQUENCE seq_ai_msg_report
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_ai_msg_report
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_ai_msg_report.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/

CREATE SEQUENCE seq_ai_msg_report_type
    START WITH 1         -- first value returned by NEXTVAL
    INCREMENT BY 1       -- step
    NOCACHE;

create FUNCTION get_seq_ai_msg_report_type
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seq_ai_msg_report_type.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;
/
