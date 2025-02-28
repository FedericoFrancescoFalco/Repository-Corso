
CREATE TABLE Nazione (
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY(nome)
);


CREATE TABLE Regione (
    nome VARCHAR(100) NOT NULL,
    nazione VARCHAR(100) NOT NULL,
    PRIMARY KEY(nome, nazione),
    FOREIGN KEY (nazione) REFERENCES Nazione(nome)
);


CREATE TABLE Citta (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    regione VARCHAR(100) NOT NULL,
    nazione VARCHAR(100) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (nome, regione, nazione),
    FOREIGN KEY (regione, nazione) REFERENCES Regione(nome, nazione)
);

CREATE TABLE Sede (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    citta INTEGER NOT NULL,
    regione VARCHAR(100) NOT NULL,
    nazione VARCHAR(100) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (citta) REFERENCES Citta(id)
);


CREATE TABLE Sala (
    nome VARCHAR(100) NOT NULL,
    sede INTEGER NOT NULL,
    PRIMARY KEY (nome, sede),
    FOREIGN KEY (sede) REFERENCES Sede(id)
);


CREATE TABLE Settore (
    nome VARCHAR(100) NOT NULL,
    sala VARCHAR(100) NOT NULL,
    sede INTEGER NOT NULL,
    PRIMARY KEY (nome, sala, sede),
    FOREIGN KEY (sala, sede) REFERENCES Sala(nome, sede)
);

CREATE TABLE Posto (
    id INTEGER NOT NULL,
    fila INTEGER NOT NULL,
    colonna INTEGER NOT NULL,
    settore VARCHAR(100) NOT NULL,
    sala VARCHAR(100) NOT NULL,
    sede INTEGER NOT NULL,
    PRIMARY KEY(id, fila, colonna, settore),
    FOREIGN KEY (settore, sala, sede) REFERENCES Settore(nome, sala, sede)
);


CREATE TABLE Evento (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    ora TIME NOT NULL,
    sede INTEGER NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (sede) REFERENCES Sede(id)
);


CREATE TABLE TipoTariffa (
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (nome)
);


CREATE TABLE Tariffa (
    id INTEGER NOT NULL,
    prezzo DECIMAL(10, 2) NOT NULL,
    tipoTariffa VARCHAR(100) NOT NULL,
    settore VARCHAR(100) NOT NULL,
    evento INTEGER NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (settore) REFERENCES Settore(nome),
    FOREIGN KEY (evento) REFERENCES Evento(id),
    FOREIGN KEY (tipoTariffa) REFERENCES TipoTariffa(nome)
);


CREATE TABLE Prenotazione (
    id INTEGER NOT NULL,
    posto INTEGER NOT NULL,
    evento INTEGER NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (posto) REFERENCES Posto(id),
    FOREIGN KEY (evento) REFERENCES Evento(id)
);



CREATE TABLE PrePosto (
    id INTEGER NOT NULL,
    prenotazione INTEGER NOT NULL,
    posto INTEGER NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (prenotazione) REFERENCES Prenotazione(id),
    FOREIGN KEY (posto) REFERENCES Posto(id)
);


CREATE TABLE Artista (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);


CREATE TABLE TipologiaSpettacolo (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);


CREATE TABLE Genere (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Utente (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    PRIMARY KEY(id)
);



