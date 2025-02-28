select distinct cognome
from Persona;

select nome, cognome
from Persona
where posizione like 'Ricercatore';

select *
from Persona
where posizione = 'Professore Associato' and cognome like 'W%';

select *
from  Persona
where (posizione = 'Professore Associato' or posizione = 'Professore Ordinario') and cognome like 'W%';

select *
from Progetto
where fine < CURRENT_DATE;

select nome
from Progetto
order by inizio ASC;

select nome
from WP
order by nome ASC;

select distinct tipo
from Assenza;

select distinct tipo
from AttivitaProgetto;

select persona, distinct giorno
from AttivitaNonProgettuale
where tipo = 'Didattica'
order by giorno ASC;