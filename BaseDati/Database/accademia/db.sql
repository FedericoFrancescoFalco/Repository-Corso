
create domain StringaM as varchar(100);
create domain DecimalN as 
    integer CHECK (voto >= 0 AND voto <= 5);

create domain PosInteger as integer check (value >= 0);

create type TipoVideo as
    enum("video","VideoCensurato");

CREATE TABLE Utente (
    nome StringaM NOT N,
    iscrizione TIMESTAMP NOT NULL,
    PRIMARY KEY (nome)
);


CREATE TABLE Video (
    titolo StringaM NOT NULL,
    descrizione StringaM,
    istante TIMESTAMP NOT NULL,
    tipo tipoVideo NOT NULL,
    ragione StringaM,
    istante_vid TIMESTAMP
    PRIMARY KEY (titolo)
);


CREATE TABLE Valutazione (
    utente StringaM NOT NULL,
    video StringaM NOT NULL,
    voto DecimalN NOT NULL,
    istante TIMESTAMP NOT NULL,
    PRIMARY KEY (utente, video),
    FOREIGN KEY (utente) REFERENCES Utente(nome),
    FOREIGN KEY (video) REFERENCES Video(titolo)
);


CREATE TABLE Tag (
    nome StringaM NOT NULL
    PRIMARY KEY (nome)
);


CREATE TABLE Vid_Tag (
    video StringaM NOT NULL,
    tag StringaM NOT NULL,
    PRIMARY KEY (video, tag),
    FOREIGN KEY (video) REFERENCES Video(titolo),
    FOREIGN KEY (tag) REFERENCES Tag(nome)
);

