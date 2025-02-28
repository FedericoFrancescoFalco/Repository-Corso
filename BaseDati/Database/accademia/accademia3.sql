
'''
il database Accademia è definito sul seguente insieme di domini e sul seguente schema
relazionale con vincoli.
Definizione dei domini
• Strutturato
enum (’Ricercatore’, ’Professore Associato’, ’Professore Ordinario’)
• LavoroProgetto
enum (’Ricerca e Sviluppo’, ’Dimostrazione’, ’Management’, ’Altro’)
• LavoroNonProgettuale
enum (’Didattica’, ’Ricerca’, ’Missione’, ’Incontro Dipartimentale’, ’Incontro
Accademico’, ’Altro’)
• CausaAssenza
enum (’Chiusura Universitaria’, ’Maternita’, ’Malattia’)
• PosInteger
integer ≥ 0
• StringaM
varchar(100)
• NumeroOre
integer tra 0 e 8
• Denaro
real ≥ 0


Schema relazionale con vincoli della base dati
Persona (id: PosInteger, nome: StringaM, cognome: StringaM, posizione: Strut-
turato, stipendio: Denaro)
Progetto (id: PosInteger, nome: StringaM, inizio: date, fine: date, budget:
Denaro)
[VincoloDB.1] altra chiave: (nome)
[VincoloDB.2] ennupla: inizio < fine
WP (progetto: PosInteger, id: PosInteger, nome: StringaM, inizio: date, fine:
date)
[VincoloDB.3] ennupla: inizio < fine
[VincoloDB.4] altra chiave: (progetto, nome)
[VincoloDB.5] foreign key: progetto references Progetto(id)
AttivitaProgetto (id: PosInteger, persona: PosInteger, progetto: PosInteger,
wp: PosInteger, giorno: date, tipo: LavoroProgetto, oreDurata: NumeroOre)
[VincoloDB.6] foreign key: persona references Persona(id)
[VincoloDB.7] foreign key: (progetto, wp) references WP(progetto, id)
AttivitaNonProgettuale (id: PosInteger, persona: PosInteger, tipo: Lavoro-
NonProgettuale, giorno: date, oreDurata: NumeroOre)
[VincoloDB.8] foreign key: persona references Persona(id)
Assenza (id: PosInteger, persona: PosInteger, tipo: CausaAssenza, giorno: date)
[VincoloDB.9] altra chiave: persona, giorno
[VincoloDB.10] foreign key: persona references Persona(id)
'''



create domain PosInteger as integer
    check (value >= 0);

create domain StringaM as varchar(100);

create domain NumeroOre as integer
    default 0
    check (value >= 0 and value <= 8);

create domain Denaro as real
    default 0
    check (value >= 0);

create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');

create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');

create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro
Accademico', 'Altro');

create type CausaAssenza as enum ('Chiusura Universitaria', 'Maternita', 'Malattia');

create table Persona (
    id PosInteger not null,
    nome StringaM not null,
    cognome StringaM not null,
    posizione Strutturato not null,
    stipendio Denaro not null,
    primary key (id)
);

create table Progetto (
    id PosInteger not null,
    nome StringaM not null,
    inizio date not null,
    fine date not null
        check (inizio < fine),
    budget Denaro not null,
    primary key (id),
    unique (nome)
);

create table WP (
    progetto PosInteger,
    id PosInteger,
    nome StringaM,
    inizio date,
    fine date
        check (inizio < fine),
    primary key (progetto, id),
    unique (progetto, nome),
    foreign key (progetto) references Progetto (id)
);

create table AttivitaProgetto (
    id PosInteger not null,
    persona PosInteger not null,
    progetto PosInteger not null,
    wp PosInteger not null,
    giorno date not null,
    tipo LavoroProgetto not null,
    oreDurata NumeroOre not null,
    primary key (id),
    foreign key (persona) references Persona (id),
    foreign key (progetto, wp) references WP (progetto, id)
);

create table AttivitaNonProgettuale (
    id PosInteger not null,
    persona PosInteger not null,
    tipo LavoroNonProgettuale not null,
    giorno date not null,
    oreDurata NumeroOre not null,
    primary key (id),
    foreign key (persona) references Persona (id)
);

create table Assenza (
    id PosInteger not null,
    persona PosInteger not null,
    tipo CausaAssenza not null,
    giorno date not null,
    unique (persona),
    unique (giorno),
    primary key (id),
    foreign key (persona) references Persona (id)
);