CREATE TABLE TypeTva (
                         id    VARCHAR(20) NOT NULL PRIMARY KEY,
                         val   VARCHAR(100) NOT NULL,
                         desce VARCHAR(255)
);

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA01', 'Aucune', 'Aucune TVA applicable');

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA02', 'Bien Locaux', 'TVA applicable aux biens locaux');

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA03', 'Bien Importer', 'TVA applicable aux biens importés');

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA04', 'Service Locaux', 'TVA applicable aux services locaux');

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA05', 'Service Importer', 'TVA applicable aux services importés');

INSERT INTO TypeTva (id, val, desce) VALUES
    ('TVA06', 'Immobilisation', 'TVA applicable aux immobilisations');