-- Stefan

ALTER TABLE TransfertStockDetails
    ADD idFournisseur VARCHAR2(255);

ALTER TABLE TransfertStockDetails
    ADD CONSTRAINT fk_tsd_fournisseur
        FOREIGN KEY (idFournisseur)
            REFERENCES Fournisseur(id);
