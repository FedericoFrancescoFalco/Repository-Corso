-- DOMINI 
create domain CodFis as varchar(16) check (value ~ '^[A-Z0-9]+$');

-- TABELLE
CREATE TABLE Nazione (
    nome varchar(100) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE Regione (
    nome varchar(100) NOT NULL,
    nazione varchar(100) NOT NULL,
    PRIMARY KEY (nome, nazione),
    FOREIGN KEY (nazione) REFERENCES Nazione(nome)
);

CREATE TABLE Citta (
    nome varchar(100) NOT NULL,
    regione varchar(100) NOT NULL,
    nazione varchar(100) NOT NULL,
    PRIMARY KEY (nome, regione, nazione),
    FOREIGN KEY (regione, nazione) REFERENCES Regione(nome, nazione)
);

CREATE TABLE Marca (
    nome varchar(100) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE TipoVeicolo (
    nome varchar(50) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE Modello (
    nome varchar(100) NOT NULL,
    marca varchar(100) NOT NULL,
    TipoVeicolo varchar(50) NOT NULL,
    PRIMARY KEY (nome, marca, TipoVeicolo),
    FOREIGN KEY (marca) REFERENCES Marca(nome),
    FOREIGN KEY (TipoVeicolo) REFERENCES TipoVeicolo(nome)
);

CREATE TABLE Veicolo (
    targa varchar(20) NOT NULL,
    immatricolazione integer NOT NULL,
    modello_nome varchar(100) NOT NULL,
    modello_marca varchar(100) NOT NULL,
    modello_TipoVeicolo varchar(50) NOT NULL,
    PRIMARY KEY (targa),
    FOREIGN KEY (modello_nome, modello_marca, modello_TipoVeicolo) REFERENCES Modello(nome, marca, TipoVeicolo)
);

CREATE TABLE Riparazione (
    codice serial NOT NULL,
    inizio timestamp NOT NULL,
    riconsegna timestamp,
    PRIMARY KEY (codice)
);

CREATE TABLE Persona (
    cf CodFis NOT NULL,
    nome varchar(100) NOT NULL,
    indirizzo varchar(255) NOT NULL,
    telefono varchar(15) NOT NULL,
    PRIMARY KEY (cf)
);

CREATE TABLE Cliente (
    persona CodFis NOT NULL,
    PRIMARY KEY (persona),
    FOREIGN KEY (persona) REFERENCES Persona(cf)
);

CREATE TABLE Staff (
    persona CodFis NOT NULL,
    PRIMARY KEY (persona),
    FOREIGN KEY (persona) REFERENCES Persona(cf)
);

CREATE TABLE Dipendente (
    staff CodFis NOT NULL,
    PRIMARY KEY (staff),
    FOREIGN KEY (staff) REFERENCES Staff(persona)
);

CREATE TABLE Direttore (
    staff CodFis NOT NULL,
    PRIMARY KEY (staff),
    FOREIGN KEY (staff) REFERENCES Staff(persona)
);

CREATE TABLE Officina (
    id serial NOT NULL,
    nome varchar(100) NOT NULL,
    indirizzo varchar(255) NOT NULL,
    direttore CodFis NOT NULL,
    citta_nome varchar(100) NOT NULL,
    citta_regione varchar(100) NOT NULL,
    citta_nazione varchar(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (direttore) REFERENCES Direttore(staff),
    FOREIGN KEY (citta_nome, citta_regione, citta_nazione) REFERENCES Citta(nome, regione, nazione)
);

CREATE TABLE Lavorare (
    dipendente CodFis NOT NULL,
    officina integer NOT NULL,
    assunzione date NOT NULL,
    PRIMARY KEY (dipendente, officina),
    FOREIGN KEY (dipendente) REFERENCES Dipendente(staff),
    FOREIGN KEY (officina) REFERENCES Officina(id)
);
