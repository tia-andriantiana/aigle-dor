-- Stefan

ALTER TABLE TransfertStock ADD IDDEMANDETRANSFERT VARCHAR2(255);

ALTER TABLE TransfertStock
    ADD CONSTRAINT fk_transfertstock_demande
        FOREIGN KEY (IDDEMANDETRANSFERT)
            REFERENCES DemandeTransfert (ID);