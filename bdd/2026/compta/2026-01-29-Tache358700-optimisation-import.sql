create table typeBanque (
                            id varchar(50) primary key ,
                            val varchar(255),
                            desce varchar(255)
);

insert  into TYPEBANQUE values ('TB1', 'BI', 'BI');
insert  into TYPEBANQUE values ('TB2', 'MC', 'MC');
insert  into TYPEBANQUE values ('TB3', 'BR', 'BR');

alter table CAISSE add (idtypebanque varchar(50));

update CAISSE set idtypebanque = 'TB1' where id = 'CAI000233';
update CAISSE set idtypebanque = 'TB2' where id = 'CAI000234';
update CAISSE set idtypebanque = 'TB3' where id = 'CAI000229';
update CAISSE set idtypebanque = 'TB1' where id = 'CAI000237';
