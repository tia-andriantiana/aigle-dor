CREATE TABLE typefacturefournisseur (
    id varchar(255) primary key,
    val VARCHAR(255),
    desce VARCHAR(255)
);

INSERT INTO TYPEFACTUREFOURNISSEUR (ID, VAL, DESCE) VALUES ('FAE', 'FAE', 'Facture à Éditer');
INSERT INTO TYPEFACTUREFOURNISSEUR (ID, VAL, DESCE) VALUES ('FAR', 'FAR', 'Facture à Recevoir');

ALTER TABLE FACTUREFOURNISSEUR ADD
typeFactureFournisseur VARCHAR(255);