CREATE TABLE Nazione (
    nome varchar not null,
    PRIMARY KEY(nome),


);

CREATE TABLE  Regione (
    nome varchar not null,
    nazione varchar not null,
    PRIMARY KEY(nome, nazione),
    FOREIGN KEY (nazione) REFERENCES Nazione(nome),

);

CREATE TABLE Citta (
    nome Varchar not null,
    regione varchar not null,
    nazione  varchar not null,
    PRIMARY KEY(nome, regione, nazione),
    FOREIGN KEY (regione, nazione) REFERENCES Regione(nome, nazione),
);

CREATE TABLE marca (
    nome varchar not null,
    PRIMARY KEY(nome),
);

CREATE TABLE modello (
    nome varchar not null,
    marca varchar not null,
    TipoVeicolo varchar not null.
    PRIMARY KEY(nome, marca, TipoVeicolo),
    FOREIGN KEY (marca) REFERENCES marca(nome),
    FOREIGN KEY (TipoVeicolo) REFERENCES TipoVeicolo(nome),

);

CREATE TABLE Veicolo(
    targa varchar not null,
    immatricolazione integer not null,
    FOREIGN key (modello) references  modello(nome, marca, TipoVeicolo),
);

CREATE Riparazione (
    codice integer not null,
    inizio timestamp not null,
    riconsegna timestamp ,
    primary key(codice),
);

CREATE table Persona (
    cf CodFis not null,
    nome varchar not null,
    indirizzo not null,
    telefono varchar not null,
    primary key(cf),

);

CREATE table Cliente (
    persona COdFis not null,
    PRIMARY KEY(persona),


);

CREATE TABLE Staff (
persona COdFis not null,
PRIMARY KEY(persona),
FOREIGN KEY (staff) REFERENCES Staff(cf),
);

CREATE TABLE Dipendente (
    staff CodFis not null
    primary key (staff);
    FOREIGN key (staff) references Staff(cf),

);

CREATE TABLE Direttore (
    staff  CodFis not null,
    primary  key (staff),
    FOREIGN key (staff) references Staff(cf),

);

CREATE TABLE Lavorare (
    dipendente CodFis not null,
    id Integer not null,
    assunzione date not null,
    primary key (dipendente, id)
    FOREIGN KEY (dipendente) references (cf),
    FOREIGN KEY (officina) references (id),

);

CREATE TABLE Officina (
id Integer not null,
nome varchar not null,
indirizzo not null,
direttore CodFis not null,
citta varchar not null,
primary key (id),
foreign key (direttore) references (cf),
foreign key (citta) references citta(id),
);









