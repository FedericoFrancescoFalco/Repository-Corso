
12. Quali sono i voli (codice, nome della compagnia e durata) che hanno una durata compresa tra 2 e 4 ore?

sql

SELECT codice, comp, durataMinuti 
FROM volo 
WHERE durataMinuti BETWEEN 120 AND 240;

13. Quali sono i voli (codice e nome della compagnia) che partono dall'aeroporto 'HTR'?

sql

SELECT codice, comp 
FROM arrpart 
WHERE partenza = 'HTR';

14. Quali sono i nomi degli aeroporti nelle città che hanno voli diretti da 'Roma' a 'New York'?

sql

SELECT DISTINCT aero.nome 
FROM aeroporto aero 
JOIN luogoaeroporto luogo ON aero.codice = luogo.aeroporto 
JOIN arrpart arr ON (arr.partenza = aero.codice OR arr.arrivo = aero.codice)
WHERE 
    (arr.partenza IN (SELECT aeroporto FROM luogoaeroporto WHERE citta = 'Roma') 
    AND arr.arrivo IN (SELECT aeroporto FROM luogoaeroporto WHERE citta = 'New York'));

15. Qual è il numero totale di voli per ogni compagnia?

sql

SELECT comp, COUNT(*) AS numero_voli 
FROM volo 


cos'è un DBMS
Sistema software che gestisce una collezione di dati (anche di grandissime dimensioni) su memoria di massa,
garantendo: accesso e condivisione dei dati controllati, granulari, e disciplinati. supporto all’esecuzione concorrente delle letture e scritture.meccanismi sofisticati per l’interrogazione e manipolazione efficiente dei dati.

Quali sono i tipi di DBMS?
DBMS relazionali (oggetto di questa unità)
• DBMS a grafo, chiave/valore, etc. (oggetto di altre unità)

cOS'è una ennupla?
tutta la riga. rappresentano i dati 

che sono i vincoli di integrità?
Esprimono condizioni sui valori di ciascuna ennupla di una tabella, indipendentemente dalle altre
ennuple. Es voto >= 18 and voto <= 30

che sono i Vincoli di chiave (vincoli sulle “colonne”)
Dichiarano che non possono esistere più ennuple della stessa tabella che coincidono sul valore di
uno o più attributi. Es non esistono due studenti con la stessa matricola

In presenza di valori NULL, i valori degli attributi che formano una chiave di una tabella:
• non permettono di identificare univocamente le ennuple della tabella
• non permettono di realizzare facilmente i riferimenti con dati di altre tabelle

Chiavi primarie
• Tra le chiavi di una tabella, se ne sceglie una, la chiave primaria
• Gli attributi della chiave primaria non possono avere valori NULL
• Gli attributi della chiave primaria di una tabella sono indicati sottolineati

Che succede se si tenta di effettuare una modifica al DB che violerebbe un vincolo di foreign key?
> Il DB rileva che la modifica violerebbe il vincolo di FK (perché esiste una ennupla in RicambioRip che violerebbe
il vincolo) . Il DB rifiuta l’operazione, mantenendo il vincolo soddisfatto

Tentativo: cancellare l’ennupla (CarFix, 1, AA 662 XQ) nella tabella Riparazione
—> Il DB rileva che la modifica violerebbe il vincolo di FK (perché esiste una ennupla in
RicambioRip che violerebbe il vincolo)
—> Il DB rifiuta l’operazione, mantenendo il vincolo soddisfatto

Tentativo: cancellare l’ennupla (CarFix, 1, AA 662 XQ) nella tabella Riparazione
—> Il DBMS rileva che la modifica violerebbe il vincolo di FK (perché esiste una ennupla in RicambioRip che violerebbe il vincolo)
—> Il DBMS modifica la ennupla problematica di RicambioRip in (NULL, NULL, A991), mantenendo il vincolo soddisfatto
—> in questo caso, essendo questi attributi parte della chiave primaria, il DBMS non può lasciare la situazione così, ed è
costretto ad annullare tutte le modifiche.

Dunque: in caso di modifiche che violerebbero un vincolo di FK, per default il DBMS rifiuta l’operazione
Il progettista del DB può modificare questo comportamento di default, scegliendo un’altra azione compensativa
Esempio 6: cancellazione in cascata delle ennuple orfane,Tentativo: cancellare l’ennupla (CarFix, 1, AA 662 XQ) nella tabella Riparazione
—> Il DB rileva che la modifica violerebbe il vincolo di FK (perché esiste una ennupla in RicambioRip che violerebbe
il vincolo)
—> Il DB cancella la ennupla problematica di RicambioRip, mantenendo il vincolo soddisfatto

Tentativo: modificare l’ennupla (CarFix, 1, AA 662 XQ) nella tabella Riparazione in (CarFix, 2, AA 662 XQ)
—> Il DB rileva che la modifica violerebbe il vincolo di FK (perché esiste una ennupla in RicambioRip che violerebbe il
vincolo)
—> Il DB modifica la ennupla problematica di RicambioRip in (CarFix, 2, A991), mantenendo il vincolo soddisfatto

Le azioni compensative per UPDATE e DELETE si possono comporre
FK: RicambioRip(officina, rip) ref.
Riparazione
ON DELETE SET NULL ON UPDATE CASCADE
(officina, codice)

Standard ANSI/SPARC
1. Livello interno: implementa le strutture fisiche di memorizzazione
(file sequenziali, file hash, indici, etc.)
2. Livello logico: fornisce un modello logico dei dati, indipendente da
come sono memorizzati fisicamente: =⇒ modello relazionale
3. Livello esterno: fornisce una o più descrizioni di porzioni di interesse
della base dati, indipendenti dal modello logico. Può prevedere
organizzazioni dei dati alternative e diverse rispetto a quelle
utilizzate nello schema logico

Architettura standard a 3 livelli per i DBMS (2)
Livello interno: strutture interne di memorizzazione
Livello logico: modello relazionale dei dati
Livello esterno: viste sui dati

Il linguaggio SQL fornisce costrutti per operare:
▶ a livello logico:
▶ Data Definition Language (DDL) per creare schemi di relazioni
▶ Data Manipulation Language (DML) per interrogare ed
aggiornare i dati
▶ a livello esterno: costrutti DDL per creare viste della base dati


Architettura standard a 3 livelli per i DBMS:
1. Livello interno
rappresentazione fisica dei dati, dipende dal DBMS.
2. Livello logico
modello logico dei dati, indipendente da come sono memorizzati
fisicamente =⇒ modello relazionale.
3. Livello esterno
fornisce una o più descrizioni di porzioni di interesse della base dati,
indipendenti dal modello logico. Può prevedere organizzazioni dei
dati alternative e diverse rispetto a quelle utilizzate nello schema
logico.


se ometti nome_schema quando crei un database,creerai uno schema di default

Una tabella SQL non rappresenta in generale una relazione (!)
In particolare, può contenere ennuple uguali
=⇒ affinché rappresenti una relazione, è necessario definire almeno una chiave

Un vincolo di integrità referenziale è una regola utilizzata nelle basi di dati relazionali per garantire che le relazioni tra le tabelle siano coerenti e che i dati siano validi.
 In pratica, assicura che le chiavi esterne in una tabella (chiavi che fanno riferimento a righe in altre tabelle) siano sempre collegate a righe esistenti nella tabella di riferimento.
 Un vincolo di integrità referenziale si applica quando una colonna in una tabella (di solito una "chiave esterna") fa riferimento alla chiave primaria di un'altra tabella.
 In sintesi, il vincolo di integrità referenziale è una misura per mantenere la coerenza dei dati e garantire che le relazioni tra tabelle siano valide, prevenendo
  l'inserimento di dati orfani o la cancellazione non intenzionale di dati legati.
  Ad esempio, in un database che gestisce informazioni su ordini e clienti, la tabella degli ordini potrebbe avere una colonna id_cliente che fa riferimento alla colonna id_cliente della tabella dei clienti.
 Il vincolo assicura che:
Ogni valore di chiave esterna nella tabella degli ordini deve corrispondere a un valore esistente nella tabella dei clienti.
Non è possibile inserire un ordine con un id_cliente che non esiste nella tabella dei clienti.
Non è possibile eliminare un cliente dalla tabella dei clienti se esistono ordini associati a quel cliente, a meno che non vengano adottate azioni specifiche come "cascading" o "set null". 


Tipi di azioni in caso di violazione del vincolo:
Quando si manipolano i dati (ad esempio, si inseriscono, aggiornano o eliminano righe), il database può applicare diverse azioni in caso di violazione del vincolo referenziale:
CASCADE: Se una riga nella tabella di riferimento viene eliminata o aggiornata, le righe corrispondenti nelle tabelle dipendenti vengono automaticamente eliminate o aggiornate.
SET NULL: Se una riga nella tabella di riferimento viene eliminata o aggiornata, i valori di chiave esterna nelle tabelle dipendenti vengono impostati su NULL.
NO ACTION: Non viene effettuata alcuna azione. Se la violazione del vincolo è rilevata, l'operazione viene bloccata.
RESTRICT: Simile a "NO ACTION", ma l'operazione è impedita immediatamente, senza ritardi.

Generazione di Valori Progressivi
Prenotazione (id:integer, istante:timestamp)

CREATE SEQUENCE Prenotazione_i_d_seq
  START WITH 1
  INCREMENT BY 1;

CREATE TABLE Prenotazione (
  id INTEGER DEFAULT NEXTVAL('Prenotazione_i_d_seq') NOT NULL,
  istante TIMESTAMP NOT NULL,
  PRIMARY KEY (id)
);


Viste sui Dati
Vista: tabella le cui ennuple sono calcolate a partire da una
interrogazione su altre tabelle (e/o viste).
c r e a t e view <Nome v i s t a > as
s e l e c t
Non è possibile invocare insert , delete, update su una vista

CREATE VIEW RedditoMedioPerEta AS
SELECT eta, AVG(reddito) AS reddito_medio
FROM Persona
GROUP BY eta;

Definire una vista che mostri le età delle persone che hanno
reddito medio massimo.

CREATE VIEW EtaRedditoToMax AS
SELECT eta
FROM ReddiToMedioperEta
WHERE redditoMedio = (
    SELECT MAX(redditoMedio)
    FROM ReddiToMedioperEta
);



In SQL, per creare un nuovo utente e assegnargli una password, puoi usare il comando CREATE USER. Il comando completo sarà simile a questo:

CREATE USER <NomeUtente> WITH PASSWORD '<password>';
Esempio pratico
Se vuoi creare un utente chiamato utente_test con la password secure123, il comando sarà:

CREATE USER utente_test WITH PASSWORD 'secure123';


I DBMS prevedono (almeno) i seguenti privilegi:
▶ insert: permette di inserire un nuovo oggetto (ad es., ennupla) nella
risorsa (ad es., tabella)
▶ update: permette di aggiornare il valore di un oggetto (ad es.,
ennupla) della risorsa (ad es., tabella)
▶ delete: permette di eliminare oggetti (ad es., ennuple) dalla risorsa
(ad es., tabella)
▶ select: permette di leggere la risorsa (ad es., tabella)
▶ references: permette che venga fatto un riferimento alla risorsa (ad
es., tabella) durante la definizione dello schema di una tabella
▶ usage: permette di utilizzare la risorsa (ad es., dominio) in una
definizione (ad es., dello schema di una tabella)
▶ all privileges: permette qualunque azione sulla risorsa.


Per concedere dei privilegi ad un insieme di utenti:
GRANT <Privilegi> ON <Risorsa> TO <Utenti> [WITH GRANT OPTION];
GRANT SELECT, INSERT ON Ordini TO utente1, utente2;

<Privilegi>: specifica i tipi di permessi che desideri concedere (ad esempio, SELECT, INSERT, UPDATE, DELETE).
<Risorsa>: indica la risorsa (come una tabella o una vista) su cui stai concedendo i privilegi.
<Utenti>: lista di utenti ai quali vuoi assegnare i privilegi.

Quando usi GRANT senza WITH GRANT OPTION, l'utente riceve solo il privilegio specifico, ma non può passarlo ad altri utenti.
GRANT SELECT ON Impiegato TO Carlo

Quando aggiungi WITH GRANT OPTION, l'utente non solo riceve il privilegio, ma ha anche l'autorizzazione a concedere lo stesso privilegio ad altri utenti.
GRANT SELECT ON Impiegato TO claudia WITH GRANT OPTION;

In SQL, il comando REVOKE serve a revocare i privilegi concessi agli utenti su una determinata risorsa
REVOKE <Privilegi> ON <Risorsa> FROM <Utenti> [RESTRICT | CASCADE];
REVOKE SELECT ON Impiegato FROM user1 RESTRICT;

RESTRICT: rimuove i privilegi solo se non ci sono dipendenze (comportamento predefinito). Se l'utente ha passato il privilegio ad altri utenti, la revoca non sarà possibile senza CASCADE.
CASCADE: revoca i privilegi e rimuove anche quelli concessi da questi utenti ad altri. revoca il privilegio all'utente e anche a qualsiasi altro utente a cui il privilegio è stato successivamente concesso.


Gli Indici possono essere:
primari: le ennuple sono memorizzate nello stesso indice o, sebbene
in un file separato, sono memorizzate ordinate per il valore della
pseudo-chiave
▶ secondari: l’ordinamento dell’indice è indipendente da quello delle
ennuple nel file che memorizza la relazione. L’indice contiene
puntatori alle ennuple.

Per crearne:
create index <Nome> on <Tabella> (<Attributi>)
using <Metodo>
▶ drop index <Nome>

Tipi di vincoli di integrità
Vincoli di chiave
primary key e unique dentro create table e alter table
▶ Vincoli di dominio
check in create domain e alter domain
check e not NULL in create table e alter table
▶ Vincoli di ennupla
check in create table e alter table
▶ Vincoli di foreign key
foreign key in create table e alter table


Nello standard SQL, le asserzioni (assertions) sono un modo potente per imporre vincoli di integrità che si applicano su più tabelle,
 permettendo di definire regole complesse per il controllo dei dati. 
Le asserzioni sono utili quando un vincolo deve essere verificato su una combinazione di tabelle diverse.
CREATE ASSERTION check_date_wp
CHECK (
    NOT EXISTS (
        SELECT * 
        FROM WP w, Progetto p
        WHERE w.progetto = p.nome
        AND (w.inizio < p.inizio OR w.fine > p.fine)
    )
);

trigger
Un trigger in SQL è una procedura che viene eseguita automaticamente in risposta a determinati eventi su una tabella o una vista.
 Gli eventi che attivano un trigger possono essere operazioni di modifica dei dati come INSERT, UPDATE o DELETE. 
 I trigger sono usati per implementare logiche complesse, automatizzare controlli sui dati o mantenere l'integrità del database.
  Il trigger può essere eseguito prima (BEFORE) o dopo (AFTER) che l'evento specificato abbia luogo.
  si attiva quando avviene uno specifico evento (inserimento, aggiornamento o cancellazione).

  Per inserire ennupla:
  INSERT INTO Officina (nome, indirizzo)
  VALUES ('MotorGo', 'piazza Turing 1');

  cancellare ennupla:
DELETE FROM Officina
WHERE nome = 'MotorGo'
AND indirizzo = 'piazza Turing 1';

modifica ennupla:
UPDATE Officina
SET indirizzo = 'viale Einstein 25'
WHERE nome = 'MotorGo'
AND indirizzo = 'piazza Turing 1';

restituire i dati delle persone che hanno un cognome che inizia
per ‘R’
SELECT *
FROM Persona
WHERE cognome LIKE 'R%';


Target List

se si utilizzano funzioni di aggregazione (come SUM, COUNT, AVG, MIN, MAX), generalmente 
non è possibile includere attributi non aggregati a meno che questi non siano inclusi in una clausola GROUP BY.
La target-list di una interrogazione select ... from ... where ... deve
essere omogenea: se contiene funzioni aggregate non può contenere
attributi e viceversa (con una eccezione, v. seguito)



union distinct : elimina i duplicati (default!!)
▶ union all : mantiene i duplicati
SELECT padre, figlio
FROM paternita
UNION
SELECT madre, figlio
FROM maternita;


La clausola from può contenere sotto-query

le query annidate può contenere condizioni di sotto-query
SELECT DISTINCT p.nome, p.reddito
FROM Persona p, Paternita pat, Persona f
WHERE p.nome = pat.padre 
  AND f.nome = pat.figlio
  AND f.reddito > 20;

Le query annidate possono porre problemi di efficienza: i DBMS
non sono bravi ad ottimizzarle (in special modo quelle correlate).
▶ In particolar modo, i DBMS non sono in grado di ottimizzare a
dovere le query annidate e correlate.
▶ Le query annidate (soprattutto se correlate) andrebbero quindi
evitate il più possibile, anche se talvolta sono più leggibili.

Le sotto-query di una query annidata devono rispettare alcune limitazioni:
▶ Le sotto-query non possono contenere operatori insiemistici (union,
intersect , except o minus)
▶ Sebbene una sotto-query può far riferimento a variabili definite in
blocchi più esterni (interrogazioni annidate e correlate), non è
possibile, in una query, fare riferimento a variabili definite in blocchi
più interni (ovviamente!).


LEFT OUTER JOIN (comunemente chiamato LEFT JOIN)
Il LEFT JOIN (o LEFT OUTER JOIN) restituisce tutte le righe dalla tabella di sinistra (la tabella indicata prima di JOIN),
 e le righe corrispondenti dalla tabella di destra (la tabella dopo JOIN). Se non ci sono righe corrispondenti nella tabella di destra, 
vengono comunque restituiti i valori della tabella di sinistra, ma i valori delle colonne della tabella di destra saranno NULL.

Il termine OUTER JOIN è un tipo di join più generale che si divide in LEFT OUTER JOIN, RIGHT OUTER JOIN e FULL OUTER JOIN.

LEFT OUTER JOIN (LEFT JOIN)
Come già descritto, restituisce tutte le righe della tabella di sinistra e le righe corrispondenti della tabella di destra.

RIGHT OUTER JOIN (RIGHT JOIN)
Il RIGHT JOIN (o RIGHT OUTER JOIN) funziona al contrario del LEFT JOIN. 
Restituisce tutte le righe dalla tabella di destra e le righe corrispondenti dalla tabella di sinistra.
Se non ci sono righe corrispondenti nella tabella di sinistra, vengono comunque restituiti i valori della tabella di destra, ma i valori delle colonne della tabella di sinistra saranno NULL.

FULL OUTER JOIN
Il FULL OUTER JOIN restituisce tutte le righe da entrambe le tabelle. 
Se non c'è corrispondenza in una delle tabelle, i valori delle colonne mancanti saranno NULL.







'''
progettazione
Lo schema concettuale va corredato di documenti di specico:
Specica dei tipi di dato:
Genere: tipo enumerativo a valori {M,F}
• Voto: tipo intervallo di interi in 18..30
• CodiceFiscale: stringa di 16 caratteri secondo il seguente standard: …
• Indirizzo: tipo composto dai seguenti campi (tipo record):
• via: stringa
• civico: stringa secondo il seguente standard: …
• cap: stringa di 5 cifre numeriche

Denisce tutti i tipi di dato non standard utilizzati nello schema concettuale

Specifica di una classe:
Definisce cosa calcola ogni operazione di classe e se e come modica gli oggetti/link esistenti (i dati)
Esempio: Specifica della classe Studente
Ogni istanza di questa classe rappresenta uno studente
media_no_a(d:Data) : Reale in 18..30
pre-condizioni: …
post-condizioni: …
(…specica delle altre operazioni della classe)


Specifica di uno use-case:
Specica dello use-case Verbalizzazione
verbalizza(s:Studente, c:Corso, d:Data, v:18..30)
pre-condizioni:
• (s,c) non è (già) un link di assoc. “esame”
post-condizioni:
• viene creato il link (s,c) di assoc. “esame”, con valori
“d” e “v” per gli attributi “data” e “voto”
(specica delle altre operazioni dello use-case)

Definisce l’insieme delle operazioni di uno use-case. Per ogni operazione, denisce cosa calcola e se e come
modica gli oggetti/link esistenti (i dati)


Specica dei vincoli esterni:
esempio: I direttori devono:
1. afferire al dipartimento che dirigono, e
2. devono farlo da almeno 5 anni
Il vincolo 1. è modellabile con una generalizzazione tra associazioni:
dirige is-a afferenza
Ma non c’è modo di modellare il requisito 2. nel diagramma delle
classi!
Denisce ulteriori vincoli (non esprimibili nel diagramma della classi, di qui il nome “esterni”) che gli oggetti/link
devono soddisfare






Diagramma UML degli user case:Modellano le funzionalità che il sistema deve realizzare, in termini di use-case (scenari di utilizzo)
Gli Use-case Cattura un insieme omogeneo di funzionalità accedute da un gruppo omogeneo di utenti. 
Tipicamente coinvolge concetti rappresentati da più classi e associazioni del diagramma delle classi.

Attore:Ruolo che un utente (umano o sistema esterno) gioca interagendo con il sistema. Lo stesso utente può essere rappresentato da più attori (può giocare più ruoli).
 Più utenti possono essere rappresentati dallo stesso attore.

Cosa è un Grafo? 
Un diagramma UML degli use-case è un grafo in cui:
 • i nodi rappresentano attori e use-case
  • gli archi rapprentano: 
  • la possibilità per un attore di invocare uno use-case
   • la possibilità per uno use-case di invocare un altro use-case
   • la generalizzazione tra attori e tra use-case

Il diagramma degli use-case è molto semplice, e dà solo una visione di alto livello di:
 • quali attori possono usare il sistema
 • quali macro-funzionalità sono accessibili ai diversi attori
 • Definisce inoltre come le diverse macro-funzionalità vadano modularizzate
  • Si tratta di un diagramma facilmente comprensibile anche al committente 
  • Il diagramma non definisce le singole operazioni all’interno di ogni use-case
  • Ogni use-case del diagramma andrà affiancato da un documento di specifica che entra nel dettaglio (v. seguito)
• Il diagramma UML delle classi non definisce nel dettaglio cosa calcolano le operazioni di classe, né se e come modificano gli oggetti esistenti (i dati)
• Il diagramma UML degli use-case non definisce quali sono le operazioni di ogni use-case, né cosa calcolano, né se e come modificano gli oggetti esistenti (i dati)


Specifica dei tipi di dato: Definisce tutti i tipi di dato non standard utilizzati nello schema concettuale
Esempio: Genere: tipo enumerativo a valori {M,F} 
• Voto: tipo intervallo di interi in 18..30
 • CodiceFiscale: stringa di 16 caratteri secondo il seguente standard: …Genere: tipo enumerativo a valori {M,F} 
 • Voto: tipo intervallo di interi in 18..30
  • CodiceFiscale: stringa di 16 caratteri secondo il seguente standard: … 

Specifica di una classe: Definisce cosa calcola ogni operazione di classe e se e come modifica gli oggetti/link esistenti (i dati)
Esempio:
Specifica della classe StudenteOgni istanza di questa classe rappresenta uno studente media_fino_a(d:Data) : Reale in 18..30 pre-condizioni:
 • l’oggetto di invocazione (“this”) è coinvolto in almeno un link dell’associazione “esame” con valore per l’attributo “data” non successivo al valore “d”post-condizioni:
  • l’operazione non modifica il livello estensionale (gli oggetti)
   • il valore del risultato (“result”) è definito come segue: • sia E l’insieme dei link di assoc. “esame” che coinvolgono “this” tali da avere un valore per l’attributo “data” non successivo al valore “d”
   • sia S la somma dei valori dell’attributo “voto” di tutti i link nell’insieme E• sia N la cardinalità (ovvero il numero di elementi) di E • result = S/N (“il valore di S diviso per il valore di N”)


Specifica di uno use-case: 
Definisce l’insieme delle operazioni di uno use-case. Per ogni operazione, definisce cosa calcola e se e come modifica gli oggetti/link esistenti (i dati)

Specifica dello use-case
 Iscrizione iscrizione(mat:intero > 0, nome:stringa) : Studentepre-condizioni:
  • non esiste alcun oggetto di classe Studente con valore “mat” per l’attributo matricola.post-condizioni: • viene creato e restituito un nuovo oggetto result:Studente con i valori “mat” e “nome” per, rispettivamente, gli attributi matricola e nome(specifica delle altre operazioni dello use-case)

Specifica dei vincoli esterni:
 Definisce ulteriori vincoli (non esprimibili nel diagramma della classi, di qui il nome “esterni”) che gli oggetti/link devono soddisfare
Esempio:
I direttori devono:
 1. afferire al dipartimento che dirigono, e
  2. devono farlo da almeno 5 anni Il vincolo
   1. è modellabile con una generalizzazione tra associazioni: dirige is-a afferenza.
    Ma non c’è modo di modellare il requisito 2. nel diagramma delle classi!


    vincoli di molteplicità
    impiegato 0..*  nascita 1..1 città
    perché una città può far nascere da zero a infiniti impiegati
    ma un impiegato può nascere solo in una città.


tipo di dato enumerativo
denisce esplicitamente e completamente l’insieme dei valori possibili per l’attributo
Ad esempio: {maschio, femmina}, {Africa, America, Antartide, Asia, Europa, Oceania}, etc

Tipi di dato composti 
• Tipo Genere = {maschio, femmina}
• Tipo Indirizzo = (via:stringa, civico:intero>0, cap:intero>0)
(Attenzione: la scelta di usare il tipo ‘intero>0’ per i campi
‘civico’ e ‘cap’ non è affatto adeguata: è solo un semplice
esempio!)

Vincoli di molteplicità sugli attributi
email: Stringa [1..*]
indirizzo: Indirizzo [0..1]
genere: Genere 

Ogni studente ha associato esattamente un nome e un genere
• Ogni studente ha associato uno o più indirizzi email
• Ogni studente ha associato al più un indirizzo

vincolo di identicazione di classe

: CodiceFiscale {id1}
nome: Stringa {id2}
cognome: Stringa {id2}
nascita: Data {id2}
Non possono esistere due persone con lo stesso
codice scale (“{id1}”) e non possono esistere persone
con, simultaneamente, lo stesso nome, cognome e data di
nascita (“{id2}”)

oppure nonn possono esistere due studenti con la stessa matricola nella stessa università. In questo caso l'id va sull'attributo di molteplicità che non può essere diverso da 1.1

• Una classe può essere sottoclasse di più classi

Sintassi per la segnatura dell’operazione:
• nome_operazione(argomenti) : tipo_ritorno
media_no_a(d:Data): Reale in 18..30

In una generalizzazione, una sottoclasse non solo può avere proprietà aggiuntive rispetto alla superclasse,
ma può anche specializzare le proprietà ereditate dalla superclasse, restringendone il tipo

Ricordiamo che un’associazione con attributi si chiama “association class” e dunque… è anche
una classe, e dunque… può a sua volta essere terminale di associazioni
'''