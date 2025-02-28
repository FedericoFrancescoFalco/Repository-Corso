"1. Quali sono i cognomi distinti di tutti gli strutturati?"

select distinct cognome from Persona;

   cognome   
-------------
 Verona
 Costa
 Greco
 Giordano
 Spada
 Vitali
 Bianchi
 Quadro
 Ferrari
 Zante
 Rossi
 Martinelli
 Valentini
 Spensierato
 Riva
 Donati
 Basile
 Longo
 Burso
 Martino
(20 rows)

###############################################################

"2. Quali sono i Ricercatori (con nome e cognome)?"

select * from Persona where posizione = 'Ricercatore';

 id |  nome   |  cognome   |  posizione  | stipendio 
----+---------+------------+-------------+-----------
  0 | Anna    | Bianchi    | Ricercatore |   45500.3
  1 | Mario   | Rossi      | Ricercatore |     35500
  2 | Barbara | Burso      | Ricercatore |   40442.5
  3 | Gino    | Spada      | Ricercatore |   35870.9
 12 | Dario   | Basile     | Ricercatore |     42566
 18 | Giulia  | Costa      | Ricercatore |     40220
 20 | Carla   | Martinelli | Ricercatore |   42030.2
(7 rows)

###############################################################

"3. Quali sono i Professori Associati il cui cognome comincia con la lettera 'V'?"

select * from Persona where (posizione = 'Professore Associato' and cognome like 'V%');

 id |  nome  |  cognome  |      posizione       | stipendio 
----+--------+-----------+----------------------+-----------
  7 | Andrea | Verona    | Professore Associato |  39002.05
 16 | Paolo  | Valentini | Professore Associato |     39200
(2 rows)

###############################################################

"4. Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera 'V'?"

select * 
from Persona 
where 
    cognome like 'V%' and 
    (posizione = 'Professore Associato' or posizione = 'Professore Ordinario');

 id |   nome   |  cognome  |      posizione       | stipendio 
----+----------+-----------+----------------------+-----------
  7 | Andrea   | Verona    | Professore Associato |  39002.05
 15 | Leonardo | Vitali    | Professore Ordinario |   38779.8
 16 | Paolo    | Valentini | Professore Associato |     39200
(3 rows)

###############################################################

"5. Quali sono i Progetti gia terminati alla data odierna?"

select * from Progetto where fine < current_date;

 id |     nome      |   inizio   |    fine    | budget 
----+---------------+------------+------------+--------
  0 | Artemide      | 2000-01-01 | 2002-12-31 | 255000
  1 | Pegasus       | 2012-01-01 | 2014-12-31 | 330000
  2 | WineSharing   | 1999-01-01 | 2003-12-31 | 998000
  3 | Simap         | 2010-02-01 | 2014-03-17 | 158000
  4 | DropDiscovery | 2010-09-13 | 2013-01-20 |  99000
(5 rows)

###############################################################

"6. Quali sono i nomi di tutti i Progetti ordinari in ordine crescente di data di inizio"

select nome, inizio from Progetto order by inizio asc;

     nome      |   inizio   
---------------+------------
 WineSharing   | 1999-01-01
 Artemide      | 2000-01-01
 Simap         | 2010-02-01
 DropDiscovery | 2010-09-13
 Pegasus       | 2012-01-01
(5 rows)

###############################################################

"7. Quali sono i nome dei WP ordinati in ordine crescente per nome?"

select nome from WP order by nome asc;

       nome       
------------------
 Dissemination
 Main Activity
 Main Research
 State of the Art
 WP1
 WP1
 WP2
 WP2
 WP3
 WP3
(10 rows)

###############################################################

"8. Quali sono (distinte) le cause di assenza di tutti gli stutturati?"

select distinct tipo from Assenza;

          tipo          
------------------------
 Malattia
 Chiusura Universitaria
 Maternita
(3 rows)

###############################################################

"9. Quali sono (distinte) le tipologie di attivita di progetto di tutti gli strutturati?"

select distinct tipo from AttivitaProgetto;

        tipo        
--------------------
 Altro
 Management
 Ricerca e Sviluppo
 Dimostrazione
(4 rows)

###############################################################

"10. QUali sono i giorni distinti nei qualli del personale ha effetuato attività non progettuali di tipo 'Didatico'?"

select distinct giorno from AttivitaNonProgettuale where tipo = 'Didattica' order by giorno asc;

   giorno   
------------
 2011-03-15
 2011-05-07
 2012-04-18
 2014-04-01
 2014-04-03
(5 rows)

###############################################################