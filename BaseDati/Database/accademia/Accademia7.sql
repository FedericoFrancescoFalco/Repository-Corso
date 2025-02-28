1.Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati?

R. Per calcolare la media e la deviazione standard degli stipendi per ogni categoria di strutturati (cioè per le posizioni Ricercatore, Professore Associatoe Professore Ordinario), possiamo utilizzare la seguente query SQL:

SELECT 
    posizione,
    AVG(stipendio) AS media_stipendio,
    STDDEV(stipendio) AS deviazione_standard
FROM 
    Persona
WHERE 
    posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    posizione;




2.Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media della loro categoria?

R. Per ottenere tutti gli attributi dei ricercatori che hanno uno stipendio superiore alla media della loro categoria, possiamo utilizzare una query SQL che prima calcola la media dello stipendio per la categoria Ricercatore e poi seleziona i ricercatori il cui stipendio è superiore a questa media.

WITH MediaStipendioRicercatori AS (
    SELECT 
        AVG(stipendio) AS media_stipendio
    FROM 
        Persona
    WHERE 
        posizione = 'Ricercatore'
)
SELECT 
    p.*
FROM 
    Persona p
JOIN 
    MediaStipendioRicercatori ms ON p.stipendio > ms.media_stipendio
WHERE 
    p.posizione = 'Ricercatore';



3.per ogni categoria di strutturati quante sono le persone con uno stipendio che differisce di al massimo una deviazione standard dalla media della loro categoria?

R. Per rispondere a questa richiesta, dobbiamo calcolare la media e la deviazione standard dello stipendio per ciascuna categoria di strutturati (Ricercatore, Professore Associato, Professore Ordinario). Successivamente, Contiamo quante persone per ciascuna categoria hanno uno stipendio che rientra nell'intervallo di una deviazione standard sopra o sotto la media.

WITH StatisticheStipendio AS (
    SELECT 
        posizione,
        AVG(stipendio) AS media_stipendio,
        STDDEV(stipendio) AS dev_std_stipendio
    FROM 
        Persona
    WHERE 
        posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
    GROUP BY 
        posizione
)
SELECT 
    p.posizione,
    COUNT(p.id) AS numero_persone
FROM 
    Persona p
JOIN 
    StatisticheStipendio ss ON p.posizione = ss.posizione
WHERE 
    p.stipendio BETWEEN (ss.media_stipendio - ss.dev_std_stipendio) 
                     AND (ss.media_stipendio + ss.dev_std_stipendio)
GROUP BY 
    p.posizione;


4. Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività progettuali? Restituire tutti i loro dati e il numero di ore lavorate.

R. Per rispondere a questa richiesta, possiamo sommare il numero di ore (oreDurata) per ciascuna persona nelle attività progettua li e filtrare i ruoli "strutturati" (ossia Ricercatore, Professore Associato, Professore Ordinario). Infine, selezioniamo solo quelli che hanno lavorato almeno 20 ore complessive.


SELECT 
    p.*,
    SUM(ap.oreDurata) AS ore_totali
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.id
HAVING 
    SUM(ap.oreDurata) >= 20;



5.
Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività progettuali? Restituire tutti i loro dati e il numero di ore lavorate.

R.Per ottenere gli strutturati che hanno lavorato almeno 20 ore complessive in attività progettuali, possiamo sommare il numero di ore (oreDurata) per ciascuna persona che ha partecipato a una AttivitaProgetto e filtrare per i ruoli di tipo "'strutturato" (quindi, solo per i ruoli Ricercatore, Professore Associato, e Professore Ordinario). Infine, filtriamo per chi ha lavorato almeno 20 ore.


SELECT 
    p.*,
    SUM(ap.oreDurata) AS ore_totali
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.id
HAVING 
    SUM(ap.oreDurata) >= 20;



5.Quali sono i progetti la cui durata è superiore alla media delle durate di tutti i progetti? Restituire nome dei progetti e loro durata in giorni.

WITH DurataProgetti AS (
    SELECT 
        id,
        nome,
        DATEDIFF(fine, inizio) AS durata_giorni
    FROM 
        Progetto
),
MediaDurata AS (
    SELECT 
        AVG(durata_giorni) AS media_durata
    FROM 
        DurataProgetti
)
SELECT 
    dp.nome AS nome_progetto,
    dp.durata_giorni
FROM 
    DurataProgetti dp,
    MediaDurata md
WHERE 
    dp.durata_giorni > md.media_durata;


6.Quali sono i progetti terminati in data odierna che hanno avuto attività di tipo “Dimostrazione”? Restituire nome di ogni progetto e il numero complessivo delle ore dedicate a tali attività nel progetto.

R. Per ottenere
superiore alla media delle durate di tutti i progetti, possiamo calcolare la durata di ciascun progetto come la differenza tra la data di fine e la data di inizio, quindi confrontarla con la media delle durate.

SELECT 
    p.nome AS nome_progetto,
    SUM(ap.oreDurata) AS ore_totali_dimostrazione
FROM 
    Progetto p
JOIN 
    AttivitaProgetto ap ON p.id = ap.progetto
WHERE 
    p.fine = CURRENT_DATE
    AND ap.tipo = 'Dimostrazione'
GROUP BY 
    p.nome;


7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del numero di assenze medio per malattia dei professori associati? Restituire id, nome e cognome del professore e il numero di giorni di assenza per malattia.


R. Per ottenere l'elenco dei progetti terminati nella data odierna che hanno avuto attività di tipo "Dimostrazione", insieme al numero complessivo di ore dedicate a tali attività, possiamo eseguire la seguente query SQL. La query selezionerà il nome di ciascun progetto e la somma totale delle ore dedicate a queste attività.

WITH Assenze_Professori_Ordinari AS (
    SELECT 
        p.id,
        p.nome,
        p.cognome,
        COUNT(a.giorno) AS assenze_malattia
    FROM 
        Persona p
    JOIN 
        Assenza a ON p.id = a.persona
    WHERE 
        p.posizione = 'Professore Ordinario' 
        AND a.tipo = 'Malattia'
    GROUP BY 
        p.id, p.nome, p.cognome
),
Media_Associati AS (
    SELECT 
        AVG(assenze_assoc) AS media_assenze_malattia
    FROM (
        SELECT 
            COUNT(a.giorno) AS assenze_assoc
        FROM 
            Persona p
        JOIN 
            Assenza a ON p.id = a.persona
        WHERE 
            p.posizione = 'Professore Associato' 
            AND a.tipo = 'Malattia'
        GROUP BY 
            p.id
    ) AS conteggio_assoc
)
SELECT 
    apo.id,
    apo.nome,
    apo.cognome,
    apo.assenze_malattia
FROM 
    Assenze_Professori_Ordinari apo,
    Media_Associati ma
WHERE 
    apo.assenze_malattia > ma.media_assenze_malattia;




BONUS 

Ecco alcune ulteriori richieste e le relative soluzioni SQL per analizzare i dati della tua base di dati di strutturati:

1. Numero di Ricercatori per Posizione e Stipendio

Richiesta: Qual è il numero di ricercatori in base alle fasce di stipendio (es. <2000, 2000-3000, >3000)?

SELECT 
    CASE 
        WHEN stipendio < 2000 THEN '<2000'
        WHEN stipendio BETWEEN 2000 AND 3000 THEN '2000-3000'
        ELSE '>3000'
    END AS fascia_stipendio,
    COUNT(*) AS numero_ricercatori
FROM 
    Persona
WHERE 
    posizione = 'Ricercatore'
GROUP BY 
    fascia_stipendio;

2. Elenco dei Professori Associati con Stipendio Maggiore della Media

Richiesta: Chi sono i professori associati con uno stipendio maggiore della media della loro categoria?

WITH MediaStipendioProfessoriAssociati AS (
    SELECT 
        AVG(stipendio) AS media_stipendio
    FROM 
        Persona
    WHERE 
        posizione = 'Professore Associato'
)
SELECT 
    p.*
FROM 
    Persona p
JOIN 
    MediaStipendioProfessoriAssociati mp ON p.stipendio > mp.media_stipendio
WHERE 
    p.posizione = 'Professore Associato';

3. Stipendio Massimo e Minimo per Ogni Categoria di Strutturati

Richiesta: Qual è lo stipendio massimo e minimo per ciascuna categoria di strutturati?

SELECT 
    posizione,
    MAX(stipendio) AS stipendio_massimo,
    MIN(stipendio) AS stipendio_minimo
FROM 
    Persona
WHERE 
    posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    posizione;

4. Numero Totale di Attività Progettuali per Ogni Strutturato

Richiesta: Qual è il numero totale di attività progettuali a cui ha partecipato ogni strutturato?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(ap.id) AS numero_attivita
FROM 
    Persona p
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.id, p.nome, p.cognome;

5. Media delle Ore Lavorate per Attività Non Progettuali

Richiesta: Qual è la media delle ore lavorate in attività non progettuali per ogni strutturato?

SELECT 
    p.posizione,
    AVG(an.oreDurata) AS media_ore_non_progettuali
FROM 
    Persona p
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.posizione;

6. Stipendi dei Ricercatori Ordinati per Stipendio

Richiesta: Restituire gli stipendi dei ricercatori ordinati in ordine decrescente.

SELECT 
    nome,
    cognome,
    stipendio
FROM 
    Persona
WHERE 
    posizione = 'Ricercatore'
ORDER BY 
    stipendio DESC;

7. Numero di Assenze per Causa di Assenza

Richiesta: Qual è il numero totale di assenze per ciascuna causa di assenza (es. Malattia, Maternità, etc.)?

SELECT 
    tipo,
    COUNT(*) AS numero_assenze
FROM 
    Assenza
GROUP BY 
    tipo;

8. Ricercatori con Più di un'Attività Progettuale

Richiesta: Quali sono i ricercatori che hanno partecipato a più di una attività progettuale?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.posizione = 'Ricercatore'
GROUP BY 
    p.id
HAVING 
    COUNT(ap.id) > 1;

9. Media delle Ore di Attività Progettuali e Non Progettuali

Richiesta: Qual è la media delle ore lavorate in attività progettuali e non progettuali per ogni categoria di strutturati?

SELECT 
    p.posizione,
    AVG(ap.oreDurata) AS media_ore_progettuali,
    AVG(an.oreDurata) AS media_ore_non_progettuali
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.posizione;

10. Progetti con Maggiore Numero di Ore Lavorate

Richiesta: Quali sono i progetti con il maggiore numero complessivo di ore lavorate?

SELECT 
    wp.progetto,
    SUM(ap.oreDurata) AS ore_totali
FROM 
    WP wp
JOIN 
    AttivitaProgetto ap ON wp.id = ap.wp AND wp.progetto = ap.progetto
GROUP BY 
    wp.progetto
ORDER BY 
    ore_totali DESC;

11. Ricercatori con Assenze per Malattia

Richiesta: Quali ricercatori hanno avuto assenze per malattia, restituendo tutti i loro dati?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    p.posizione = 'Ricercatore' AND a.tipo = 'Malattia';

12. Progetti e Numero di Strutturati Coinvolti

Richiesta: Quali sono i progetti e il numero di strutturati coinvolti in ciascun progetto?

SELECT 
    pr.nome,
    COUNT(DISTINCT ap.persona) AS numero_strutturati
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    pr.nome;

13. Elenco dei Progetti con Stipendio Medio dei Coinvolti

Richiesta: Quali sono i progetti e qual è lo stipendio medio dei strutturati coinvolti?

SELECT 
    pr.nome,
    AVG(p.stipendio) AS stipendio_medio
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    pr.nome;

14. Assenze Totali per Categoria di Strutturati

Richiesta: Qual è il numero totale di assenze per ogni categoria di strutturati?

SELECT 
    p.posizione,
    COUNT(a.id) AS numero_assenze
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    p.posizione IN ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.posizione;

15. Totale Ore Lavorate per Ogni Ricercatore

Richiesta: Qual è il totale delle ore lavorate da ciascun ricercatore in attività progettuali e non progettuali?

SELECT 
    p.nome,
    p.cognome,
    COALESCE(SUM(ap.oreDurata), 0) AS ore_progettuali,
    COALESCE(SUM(an.oreDurata), 0) AS ore_non_progettuali,
    COALESCE(SUM(ap.oreDurata), 0) + COALESCE(SUM(an.oreDurata), 0) AS ore_totali
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
WHERE 
    p.posizione = 'Ricercatore'
GROUP BY 
    p.nome, p.cognome;

Ecco una serie di nuove query SQL che esplorano diverse analisi sui dati della tabella dei strutturati. Queste query utilizzano le tabelle disponibili e coprono vari aspetti, come assenze, stipendi, attività e progetti.

16. Totale Assenze per Persona

Richiesta: Qual è il totale delle assenze per ciascuna persona?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(a.id) AS totale_assenze
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.id, p.nome, p.cognome;

17. Progetti con Nessuna Attività di Tipo "Management"

Richiesta: Quali sono i progetti che non hanno avuto attività di tipo "Management"?

SELECT 
    pr.nome
FROM 
    Progetto pr
WHERE 
    pr.id NOT IN (
        SELECT 
            ap.progetto
        FROM 
            AttivitaProgetto ap
        WHERE 
            ap.tipo = 'Management'
    );

18. Strutturati con Stipendio Superiore alla Media Generale

Richiesta: Quali sono i strutturati con stipendio superiore alla media generale di tutti gli stipendi?

SELECT 
    p.*
FROM 
    Persona p
WHERE 
    p.stipendio > (SELECT AVG(stipendio) FROM Persona);

19. Attività Progettuali per Mese

Richiesta: Qual è il numero di attività progettuali per mese?

SELECT 
    EXTRACT(YEAR FROM giorno) AS anno,
    EXTRACT(MONTH FROM giorno) AS mese,
    COUNT(*) AS numero_attivita
FROM 
    AttivitaProgetto
GROUP BY 
    anno, mese
ORDER BY 
    anno, mese;

20. Numero di Strutturati per Categoria

Richiesta: Qual è il numero di strutturati per ciascuna categoria (Ricercatore, Professore Associato, Professore Ordinario)?

SELECT 
    posizione,
    COUNT(*) AS numero_strutturati
FROM 
    Persona
GROUP BY 
    posizione;

21. Media Ore Lavorate per Causa di Assenza

Richiesta: Qual è la media delle ore lavorate dai strutturati che hanno avuto assenze, suddivisa per causa di assenza?

SELECT 
    a.tipo,
    AVG(COALESCE(ap.oreDurata, 0)) AS media_ore_lavorate
FROM 
    Assenza a
JOIN 
    Persona p ON a.persona = p.id
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    a.tipo;

22. Progetti in Corso con Attività di Ricerca

Richiesta: Quali progetti sono attualmente in corso e hanno attività di tipo "Ricerca"?

SELECT 
    pr.nome
FROM 
    Progetto pr
WHERE 
    pr.inizio <= CURRENT_DATE AND pr.fine >= CURRENT_DATE
    AND pr.id IN (
        SELECT 
            ap.progetto
        FROM 
            AttivitaProgetto ap
        WHERE 
            ap.tipo = 'Ricerca'
    );

23. Strutturati Senza Attività di Progetto

Richiesta: Quali sono i strutturati che non hanno partecipato a nessuna attività progettuale?

SELECT 
    p.*
FROM 
    Persona p
WHERE 
    p.id NOT IN (
        SELECT 
            ap.persona
        FROM 
            AttivitaProgetto ap
    );

24. Progetti con Budget Superiore a 100.000

Richiesta: Quali progetti hanno un budget superiore a 100.000?

SELECT 
    nome
FROM 
    Progetto
WHERE 
    budget > 100000;

25. Assenze per Malattia per Categoria di Strutturati

Richiesta: Qual è il numero di assenze per malattia suddiviso per categoria di strutturati?

SELECT 
    p.posizione,
    COUNT(a.id) AS assenze_malattia
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Malattia'
GROUP BY 
    p.posizione;

26. Strutturati con Maggior Numero di Attività Progettuali

Richiesta: Chi sono i 5 strutturati con il maggior numero di attività progettuali?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(ap.id) AS numero_attivita
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    p.id, p.nome, p.cognome
ORDER BY 
    numero_attivita DESC
LIMIT 5;

27. Progetti e Numero di Attività Associate

Richiesta: Quali sono i progetti e quante attività sono state associate a ciascun progetto?

SELECT 
    pr.nome,
    COUNT(ap.id) AS numero_attivita
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome;

28. Stipendio Massimo e Minimo per Categoria di Strutturati

Richiesta: Qual è lo stipendio massimo e minimo per ciascuna categoria di strutturati?

SELECT 
    posizione,
    MAX(stipendio) AS stipendio_max,
    MIN(stipendio) AS stipendio_min
FROM 
    Persona
GROUP BY 
    posizione;

29. Attività Progettuali Non Completate

Richiesta: Quali attività progettuali non sono state completate (in base alla data)?

SELECT 
    ap.*
FROM 
    AttivitaProgetto ap
JOIN 
    WP wp ON ap.wp = wp.id
WHERE 
    wp.fine > CURRENT_DATE;

30. Strutturati con Assenze Totali Maggiori di 5 Giorni

Richiesta: Quali strutturati hanno avuto più di 5 giorni di assenza totali?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.id
HAVING 
    COUNT(a.id) > 5;

Ecco altre query SQL da utilizzare con le tabelle dei dati di strutturati, continuando ad esplorare diverse analisi.

31. Totale Ore di Assenze per Categoria di Strutturati

Richiesta: Qual è il totale delle ore di assenze per ciascuna categoria di strutturati?

SELECT 
    p.posizione,
    SUM(COALESCE(a.oreDurata, 0)) AS totale_ore_assenze
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.posizione;

32. Progetti con Attività per Ogni Mese

Richiesta: Qual è il numero di progetti con almeno un'attività per mese?

SELECT 
    EXTRACT(YEAR FROM wp.giorno) AS anno,
    EXTRACT(MONTH FROM wp.giorno) AS mese,
    COUNT(DISTINCT wp.progetto) AS numero_progetti
FROM 
    WP wp
JOIN 
    AttivitaProgetto ap ON wp.id = ap.wp
GROUP BY 
    anno, mese
ORDER BY 
    anno, mese;

33. Stipendio Medio per Ricercatore

Richiesta: Qual è lo stipendio medio dei ricercatori?

SELECT 
    AVG(stipendio) AS stipendio_medio_ricercatori
FROM 
    Persona
WHERE 
    posizione = 'Ricercatore';

34. Attività di Tipo "Didattica"

Richiesta: Quali strutturati hanno svolto attività di tipo "Didattica"?

SELECT 
    DISTINCT p.*
FROM 
    Persona p
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
WHERE 
    an.tipo = 'Didattica';

35. Progetti e Budget Totale

Richiesta: Qual è il budget totale dei progetti in corso?

SELECT 
    SUM(budget) AS budget_totale
FROM 
    Progetto
WHERE 
    inizio <= CURRENT_DATE AND fine >= CURRENT_DATE;

36. Strutturati con Assenze per Maternità

Richiesta: Quali strutturati hanno avuto assenze per maternità?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Maternita';

37. Attività Progettuali in Corso

Richiesta: Quali sono le attività progettuali che sono attualmente in corso?

SELECT 
    ap.*
FROM 
    AttivitaProgetto ap
JOIN 
    WP wp ON ap.wp = wp.id
WHERE 
    wp.fine > CURRENT_DATE;

38. Media Ore Lavorate dai Professori

Richiesta: Qual è la media delle ore lavorate in attività progettuali dai professori (associati e ordinari)?

SELECT 
    p.posizione,
    AVG(ap.oreDurata) AS media_ore_lavorate
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.posizione IN ('Professore Associato', 'Professore Ordinario')
GROUP BY 
    p.posizione;

39. Progetti con Budget e Ore Lavorate

Richiesta: Quali progetti hanno un budget superiore a 50.000 e hanno avuto attività con più di 100 ore lavorate?

SELECT 
    pr.nome,
    pr.budget,
    SUM(ap.oreDurata) AS totale_ore
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome, pr.budget
HAVING 
    pr.budget > 50000 AND totale_ore > 100;

40. Differenza tra Stipendio Massimo e Minimo per Categoria

Richiesta: Qual è la differenza tra lo stipendio massimo e minimo per ciascuna categoria di strutturati?

SELECT 
    posizione,
    MAX(stipendio) - MIN(stipendio) AS differenza_stipendi
FROM 
    Persona
GROUP BY 
    posizione;

41. Assenze in Percentuale per Causa

Richiesta: Qual è la percentuale di assenze per ciascuna causa rispetto al totale delle assenze?

SELECT 
    a.tipo,
    COUNT(a.id) * 100.0 / (SELECT COUNT(*) FROM Assenza) AS percentuale_assenze
FROM 
    Assenza a
GROUP BY 
    a.tipo;

42. Strutturati con Più di 10 Attività Non Progettuali

Richiesta: Chi sono i strutturati che hanno svolto più di 10 attività non progettuali?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
GROUP BY 
    p.id
HAVING 
    COUNT(an.id) > 10;

43. Progetti e Partecipazione al Budget

Richiesta: Quali progetti hanno avuto una partecipazione al budget superiore alla media?

SELECT 
    pr.nome,
    pr.budget
FROM 
    Progetto pr
WHERE 
    pr.budget > (SELECT AVG(budget) FROM Progetto);

44. Ore Lavorate per Strutturati in Attività Non Progettuali

Richiesta: Qual è il totale delle ore lavorate da ciascun strutturato in attività non progettuali?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    SUM(an.oreDurata) AS totale_ore_non_progettuali
FROM 
    Persona p
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
GROUP BY 
    p.id, p.nome, p.cognome;

45. Progetti con Attività Superiore alla Media

Richiesta: Quali progetti hanno avuto un numero di attività superiore alla media?

SELECT 
    pr.nome,
    COUNT(ap.id) AS numero_attivita
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome
HAVING 
    numero_attivita > (SELECT AVG(attività_count) FROM (
        SELECT COUNT(id) AS attività_count 
        FROM AttivitaProgetto 
        GROUP BY progetto) AS subquery);

46. Strutturati e Numero di Assenze per Maternità

Richiesta: Quali strutturati hanno avuto assenze per maternità e quante assenze hanno avuto?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(a.id) AS numero_assenze_maternita
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Maternita'
GROUP BY 
    p.id, p.nome, p.cognome;

47. Attività Progettuali con Ore Maggiori di 5

Richiesta: Quali attività progettuali hanno avuto più di 5 ore di durata?

SELECT 
    ap.*
FROM 
    AttivitaProgetto ap
WHERE 
    ap.oreDurata > 5;

48. Stipendi Superiori alla Media di Ciascuna Categoria

Richiesta: Quali sono i strutturati con stipendio superiore alla media della loro categoria?

SELECT 
    p.*
FROM 
    Persona p
WHERE 
    p.stipendio > (
        SELECT AVG(stipendio) 
        FROM Persona 
        WHERE posizione = p.posizione
    );

49. Progetti con Attività Suddivisi per Causa di Assenza

Richiesta: Quali progetti hanno attività associate a strutturati che hanno avuto assenze per malattia?

SELECT DISTINCT 
    pr.nome
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Malattia';

50. Assenze Totali per Strutturati per Tipo di Attività

Richiesta: Qual è il numero totale di assenze per ogni strutturato, suddiviso per tipo di attività?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    SUM(COALESCE(an.oreDurata, 0)) AS totale_ore_attivita_non_progettuali,
    SUM(COALESCE(ap.oreDurata, 0)) AS totale_ore_attivita_progettuali,
    COUNT(a.id) AS totale_assenze
FROM 
    Persona p
LEFT JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
LEFT JOIN 
    Assenza a


51. Strutturati senza Attività Progettuali

Richiesta: Quali strutturati non hanno svolto attività progettuali?

SELECT 
    p.*
FROM 
    Persona p
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.id IS NULL;

52. Attività Progettuali Suddivise per Tipo

Richiesta: Qual è il numero di attività progettuali suddivise per tipo di lavoro?

SELECT 
    tipo,
    COUNT(*) AS numero_attivita
FROM 
    AttivitaProgetto
GROUP BY 
    tipo;

53. Progetti e Strutturati Coinvolti

Richiesta: Quali progetti hanno coinvolto più di 5 strutturati?

SELECT 
    pr.nome,
    COUNT(DISTINCT ap.persona) AS numero_strutturati
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome
HAVING 
    numero_strutturati > 5;

54. Strutturati con Stipendi Inferiori alla Media

Richiesta: Chi sono i strutturati con stipendi inferiori alla media?

SELECT 
    p.*
FROM 
    Persona p
WHERE 
    p.stipendio < (SELECT AVG(stipendio) FROM Persona);

55. Progetti con Attività e Stipendi

Richiesta: Quali progetti hanno avuto attività e il totale degli stipendi dei partecipanti?

SELECT 
    pr.nome,
    SUM(p.stipendio) AS totale_stipendi
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
GROUP BY 
    pr.nome;

56. Causa di Assenza più Comune

Richiesta: Qual è la causa di assenza più comune?

SELECT 
    tipo,
    COUNT(*) AS numero_assenze
FROM 
    Assenza
GROUP BY 
    tipo
ORDER BY 
    numero_assenze DESC
LIMIT 1;

57. Attività Non Progettuali per Strutturati

Richiesta: Quali attività non progettuali hanno avuto più di 10 ore di durata?

SELECT 
    an.*
FROM 
    AttivitaNonProgettuale an
WHERE 
    an.oreDurata > 10;

58. Media Ore Lavorate in Progetti

Richiesta: Qual è la media delle ore lavorate in attività progettuali per ciascun progetto?

SELECT 
    wp.progetto,
    AVG(wp.oreDurata) AS media_ore_lavorate
FROM 
    WP wp
JOIN 
    AttivitaProgetto ap ON wp.id = ap.wp
GROUP BY 
    wp.progetto;

59. Numero di Assenze per Tipo di Strutturato

Richiesta: Qual è il numero di assenze per ciascuna categoria di strutturati?

SELECT 
    p.posizione,
    COUNT(a.id) AS numero_assenze
FROM 
    Persona p
LEFT JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.posizione;

60. Attività Progettuali e Giorni

Richiesta: Quante attività progettuali si sono svolte in ciascun giorno?

SELECT 
    giorno,
    COUNT(*) AS numero_attivita
FROM 
    AttivitaProgetto
GROUP BY 
    giorno;

61. Strutturati con Budget di Progetto Superiore

Richiesta: Quali strutturati hanno lavorato in progetti con un budget superiore a 100.000?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
JOIN 
    Progetto pr ON ap.progetto = pr.id
WHERE 
    pr.budget > 100000;

62. Stipendio Minimo per Categoria

Richiesta: Qual è lo stipendio minimo per ciascuna categoria di strutturati?

SELECT 
    posizione,
    MIN(stipendio) AS stipendio_minimo
FROM 
    Persona
GROUP BY 
    posizione;

63. Attività Lavorate per Strutturati

Richiesta: Qual è il totale delle ore lavorate in attività progettuali e non progettuali da ciascun strutturato?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COALESCE(SUM(ap.oreDurata), 0) AS ore_progettuali,
    COALESCE(SUM(an.oreDurata), 0) AS ore_non_progettuali
FROM 
    Persona p
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
LEFT JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
GROUP BY 
    p.id, p.nome, p.cognome;

64. Progetti in Base alla Loro Durata

Richiesta: Quali sono i progetti con una durata inferiore alla media di tutti i progetti?

SELECT 
    nome,
    (fine - inizio) AS durata
FROM 
    Progetto
WHERE 
    (fine - inizio) < (SELECT AVG(fine - inizio) FROM Progetto);

65. Attività di Tipo "Management"

Richiesta: Quali strutturati hanno svolto attività di tipo "Management"?

SELECT 
    DISTINCT p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.tipo = 'Management';

66. Assenze per Giorno

Richiesta: Qual è il numero di assenze registrate in ciascun giorno?

SELECT 
    giorno,
    COUNT(*) AS numero_assenze
FROM 
    Assenza
GROUP BY 
    giorno;

67. Categorie di Strutturati con Stipendio Massimo

Richiesta: Qual è il massimo stipendio per ciascuna categoria di strutturati?

SELECT 
    posizione,
    MAX(stipendio) AS stipendio_massimo
FROM 
    Persona
GROUP BY 
    posizione;

68. Ore Totali Lavorate da Strutturati

Richiesta: Qual è il totale delle ore lavorate da ciascun strutturato in attività progettuali?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    SUM(ap.oreDurata) AS ore_totali
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    p.id, p.nome, p.cognome;

69. Progetti con Assenze per Malattia

Richiesta: Quali progetti hanno attività associate a strutturati che hanno avuto assenze per malattia?

SELECT DISTINCT 
    pr.nome
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Malattia';

70. Strutturati con Assenze Totali

Richiesta: Qual è il totale delle assenze per ogni strutturato?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(a.id) AS totale_assenze
FROM 
    Persona p
LEFT JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.id, p.nome, p.cognome;

Se hai bisogno di ulteriori query o di approfondire un argomento specifico, fammi sapere!

71. Progetti Attivi

Richiesta: Quali progetti sono attualmente attivi (ovvero non ancora conclusi)?

SELECT 
    nome
FROM 
    Progetto
WHERE 
    fine > CURRENT_DATE;

72. Strutturati con Più di un Progetto

Richiesta: Quali strutturati hanno partecipato a più di un progetto?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(DISTINCT ap.progetto) AS numero_progetti
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    p.id, p.nome, p.cognome
HAVING 
    numero_progetti > 1;

73. Progetti senza Attività

Richiesta: Quali progetti non hanno attività associate?

SELECT 
    pr.nome
FROM 
    Progetto pr
LEFT JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
WHERE 
    ap.id IS NULL;

74. Assenze per Causa

Richiesta: Qual è il numero totale di assenze per ciascuna causa di assenza?

SELECT 
    tipo,
    COUNT(*) AS totale
FROM 
    Assenza
GROUP BY 
    tipo;

75. Progetti con Maggiore Budget

Richiesta: Quali sono i progetti con un budget superiore a 500.000?

SELECT 
    nome,
    budget
FROM 
    Progetto
WHERE 
    budget > 500000;

76. Attività di Tipo "Didattica"

Richiesta: Chi sono gli strutturati che hanno svolto attività di tipo "Didattica"?

SELECT 
    DISTINCT p.*
FROM 
    Persona p
JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
WHERE 
    an.tipo = 'Didattica';

77. Attività Lavorate per Giorno

Richiesta: Quante ore sono state lavorate in attività progettuali in ciascun giorno?

SELECT 
    giorno,
    SUM(oreDurata) AS ore_lavorate
FROM 
    AttivitaProgetto
GROUP BY 
    giorno;

78. Strutturati senza Assenze

Richiesta: Chi sono gli strutturati che non hanno mai avuto assenze?

SELECT 
    p.*
FROM 
    Persona p
LEFT JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.id IS NULL;

79. Progetti e Giorni Rimanenti

Richiesta: Quali progetti hanno più di 10 giorni rimanenti fino alla loro conclusione?

SELECT 
    nome,
    (fine - CURRENT_DATE) AS giorni_rimanenti
FROM 
    Progetto
WHERE 
    (fine - CURRENT_DATE) > 10;

80. Stipendi e Durata delle Attività

Richiesta: Qual è la media degli stipendi per gli strutturati che hanno lavorato in attività di progetto con durata superiore a 5 ore?

SELECT 
    AVG(p.stipendio) AS media_stipendi
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.oreDurata > 5;

81. Categorie di Attività

Richiesta: Qual è la quantità di ciascun tipo di attività (progettuale e non) eseguita da ciascun strutturato?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    SUM(CASE WHEN ap.tipo IS NOT NULL THEN 1 ELSE 0 END) AS attivita_progettuale,
    SUM(CASE WHEN an.tipo IS NOT NULL THEN 1 ELSE 0 END) AS attivita_non_progettuale
FROM 
    Persona p
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
LEFT JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
GROUP BY 
    p.id, p.nome, p.cognome;

82. Progetti con Attività di "Ricerca e Sviluppo"

Richiesta: Quali progetti hanno avuto attività di tipo "Ricerca e Sviluppo"?

SELECT DISTINCT 
    pr.nome
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
WHERE 
    ap.tipo = 'Ricerca e Sviluppo';

83. Durata Totale delle Attività

Richiesta: Qual è la durata totale delle attività progettuali per ciascun progetto?

SELECT 
    ap.progetto,
    SUM(ap.oreDurata) AS durata_totale
FROM 
    AttivitaProgetto ap
GROUP BY 
    ap.progetto;

84. Assenze e Posizioni

Richiesta: Qual è il numero di assenze per ogni posizione strutturata?

SELECT 
    p.posizione,
    COUNT(a.id) AS numero_assenze
FROM 
    Persona p
LEFT JOIN 
    Assenza a ON p.id = a.persona
GROUP BY 
    p.posizione;

85. Progetti e Partecipanti

Richiesta: Quali progetti hanno il numero maggiore di partecipanti?

SELECT 
    pr.nome,
    COUNT(ap.persona) AS numero_partecipanti
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome
ORDER BY 
    numero_partecipanti DESC
LIMIT 1;

86. Ore Lavorate in Attività Non Progettuali

Richiesta: Qual è il totale delle ore lavorate in attività non progettuali?

SELECT 
    SUM(oreDurata) AS totale_ore_non_progettuali
FROM 
    AttivitaNonProgettuale;

87. Stipendi Superiori a una Soglia

Richiesta: Chi sono gli strutturati con stipendi superiori a 70.000?

SELECT 
    *
FROM 
    Persona
WHERE 
    stipendio > 70000;

88. Progetti con Attività e Causa di Assenza

Richiesta: Quali progetti hanno attività collegate a strutturati che hanno assenze per malattia?

SELECT DISTINCT 
    pr.nome
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Malattia';

89. Causa di Assenza e Partecipazione ai Progetti

Richiesta: Qual è la causa di assenza più comune tra gli strutturati che partecipano a progetti?

SELECT 
    a.tipo,
    COUNT(*) AS numero_assenze
FROM 
    Assenza a
JOIN 
    Persona p ON a.persona = p.id
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    a.tipo
ORDER BY 
    numero_assenze DESC
LIMIT 1;

90. Strutturati con Stipendio e Ore Lavorate

Richiesta: Quali strutturati hanno uno stipendio superiore alla media e hanno lavorato più di 15 ore in attività progettuali?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    p.stipendio > (SELECT AVG(stipendio) FROM Persona) 
    AND SUM(ap.oreDurata) > 15;

Ecco ulteriori query per le tue tabelle:

91. Progetti con Durata Media Maggiore di 30 Giorni

Richiesta: Quali progetti hanno una durata media superiore a 30 giorni?

SELECT 
    nome,
    DATEDIFF(fine, inizio) AS durata
FROM 
    Progetto
WHERE 
    DATEDIFF(fine, inizio) > 30;

92. Strutturati con Più Assenze per Maternità

Richiesta: Chi sono gli strutturati con il maggior numero di assenze per maternità?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COUNT(a.id) AS numero_assenze
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    a.tipo = 'Maternita'
GROUP BY 
    p.id, p.nome, p.cognome
ORDER BY 
    numero_assenze DESC
LIMIT 1;

93. Numero Totale di Attività per Tipo

Richiesta: Qual è il numero totale di attività progettuali e non progettuali?

SELECT 
    'Progettuali' AS tipo,
    COUNT(*) AS numero_attivita
FROM 
    AttivitaProgetto
UNION ALL
SELECT 
    'Non Progettuali' AS tipo,
    COUNT(*) AS numero_attivita
FROM 
    AttivitaNonProgettuale;

94. Progetti con Budget Inferiore alla Media

Richiesta: Quali progetti hanno un budget inferiore alla media di tutti i progetti?

SELECT 
    nome,
    budget
FROM 
    Progetto
WHERE 
    budget < (SELECT AVG(budget) FROM Progetto);

95. Ore Totali Lavorate da Ogni Strutturato

Richiesta: Qual è il totale delle ore lavorate in attività progettuali e non progettuali per ciascun strutturato?

SELECT 
    p.id,
    p.nome,
    p.cognome,
    COALESCE(SUM(ap.oreDurata), 0) AS ore_progettuali,
    COALESCE(SUM(an.oreDurata), 0) AS ore_non_progettuali,
    COALESCE(SUM(ap.oreDurata), 0) + COALESCE(SUM(an.oreDurata), 0) AS ore_totali
FROM 
    Persona p
LEFT JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
LEFT JOIN 
    AttivitaNonProgettuale an ON p.id = an.persona
GROUP BY 
    p.id, p.nome, p.cognome;

96. Causa di Assenza e Lavoro Progettuale

Richiesta: Quali sono le cause di assenza più comuni tra gli strutturati che hanno lavorato in attività progettuali?

SELECT 
    a.tipo,
    COUNT(*) AS numero_assenze
FROM 
    Assenza a
JOIN 
    Persona p ON a.persona = p.id
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
GROUP BY 
    a.tipo
ORDER BY 
    numero_assenze DESC;

97. Progetti con Più di un Tipo di Attività

Richiesta: Quali progetti hanno avuto più di un tipo di attività?

SELECT 
    pr.nome,
    COUNT(DISTINCT ap.tipo) AS numero_tipologie
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY 
    pr.nome
HAVING 
    numero_tipologie > 1;

98. Strutturati con Attività Progettuali negli Ultimi 30 Giorni

Richiesta: Chi sono gli strutturati che hanno lavorato in attività progettuali negli ultimi 30 giorni?

SELECT DISTINCT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.giorno >= CURRENT_DATE - INTERVAL '30 DAY';

99. Progetti con Assenze Collegate

Richiesta: Quali progetti hanno assenze collegate a strutturati che hanno lavorato su di essi?

SELECT DISTINCT 
    pr.nome
FROM 
    Progetto pr
JOIN 
    AttivitaProgetto ap ON pr.id = ap.progetto
JOIN 
    Persona p ON ap.persona = p.id
JOIN 
    Assenza a ON p.id = a.persona;

100. Stipendi e Assenze

Richiesta: Quali strutturati hanno uno stipendio inferiore alla media e hanno avuto almeno una assenza?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    Assenza a ON p.id = a.persona
WHERE 
    p.stipendio < (SELECT AVG(stipendio) FROM Persona)
GROUP BY 
    p.id;

101. Attività Non Progettuali e Ore

Richiesta: Quali attività non progettuali hanno avuto una durata complessiva superiore a 10 ore?

SELECT 
    tipo,
    SUM(oreDurata) AS totale_ore
FROM 
    AttivitaNonProgettuale
GROUP BY 
    tipo
HAVING 
    totale_ore > 10;

102. Progetti e Causa di Assenza

Richiesta: Qual è la causa di assenza più comune tra i membri di un progetto specifico?

SELECT 
    a.tipo,
    COUNT(*) AS numero_assenze
FROM 
    Assenza a
JOIN 
    Persona p ON a.persona = p.id
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.progetto = :progetto_id -- Sostituire :progetto_id con l'ID del progetto desiderato
GROUP BY 
    a.tipo
ORDER BY 
    numero_assenze DESC
LIMIT 1;

103. Strutturati con Più di 10 Ore in Progetti

Richiesta: Chi sono gli strutturati che hanno lavorato più di 10 ore in almeno un progetto?

SELECT 
    p.*
FROM 
    Persona p
JOIN 
    AttivitaProgetto ap ON p.id = ap.persona
WHERE 
    ap.oreDurata > 10;

104. Progetti senza Attività Non Progettuali

Richiesta: Quali progetti non hanno attività non progettuali associate?

SELECT 
    pr.nome
FROM 
    Progetto pr
LEFT JOIN 
    AttivitaNonProgettuale an ON pr.id = an.progetto
WHERE 
    an.id IS NULL;

105. Attività Progettuali per Giorno

Richiesta: Quante ore sono state lavorate in attività progettuali per ogni giorno?

SELECT 
    giorno,
    SUM(oreDurata) AS ore_totali
FROM 
    AttivitaProgetto
GROUP BY 
    giorno;




1. Operazioni di base

1.1 Recuperare tutti i professori ordinari

SELECT * 
FROM Persona 
WHERE posizione = 'Professore Ordinario';

1.2 Elencare tutti i progetti che hanno un budget superiore a 1.000.000

SELECT * 
FROM Progetto 
WHERE budget > 1000000;

1.3 Trovare tutte le attività non progettuali svolte da una persona in una certa data

SELECT * 
FROM AttivitaNonProgettuale 
WHERE persona = 123 AND giorno = '2024-11-01';

1.4 Elencare tutte le assenze di tipo "Malattia"

SELECT * 
FROM Assenza 
WHERE tipo = 'Malattia';


---

2. Query con JOIN

2.1 Trovare il nome, cognome e stipendio di chi lavora al progetto "AI Research"

SELECT p.nome, p.cognome, p.stipendio 
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
JOIN Progetto pr ON ap.progetto = pr.id
WHERE pr.nome = 'AI Research';

2.2 Elencare tutti i Work Package (WP) di un progetto specifico

SELECT wp.*
FROM WP wp
JOIN Progetto pr ON wp.progetto = pr.id
WHERE pr.nome = 'Quantum Computing';

2.3 Trovare i dettagli delle attività di "Ricerca e Sviluppo" svolte in un Work Package

SELECT ap.*
FROM AttivitaProgetto ap
JOIN WP wp ON ap.wp = wp.id AND ap.progetto = wp.progetto
WHERE ap.tipo = 'Ricerca e Sviluppo';


---

3. Analisi di aggregazione

3.1 Calcolare il totale delle ore lavorate da una persona in un mese

SELECT persona, SUM(oreDurata) AS totale_ore
FROM AttivitaProgetto
WHERE EXTRACT(MONTH FROM giorno) = 11
GROUP BY persona;

3.2 Determinare il numero totale di assenze per tipo

SELECT tipo, COUNT(*) AS totale
FROM Assenza
GROUP BY tipo;

3.3 Calcolare la media degli stipendi per ogni tipo di posizione

SELECT posizione, AVG(stipendio) AS stipendio_medio
FROM Persona
GROUP BY posizione;


---

4. Analisi temporale

4.1 Trovare tutte le attività progettuali svolte in un determinato intervallo di date

SELECT * 
FROM AttivitaProgetto
WHERE giorno BETWEEN '2024-10-01' AND '2024-10-31';

4.2 Elencare i progetti attivi in una certa data

SELECT * 
FROM Progetto
WHERE inizio <= '2024-11-01' AND fine >= '2024-11-01';


---

5. Query avanzate

5.1 Trovare tutte le persone che non hanno svolto attività progettuali

SELECT p.*
FROM Persona p
WHERE NOT EXISTS (
    SELECT 1 
    FROM AttivitaProgetto ap
    WHERE ap.persona = p.id
);

5.2 Elencare i progetti che non hanno WP

SELECT *
FROM Progetto p
WHERE NOT EXISTS (
    SELECT 1 
    FROM WP wp
    WHERE wp.progetto = p.id
);

5.3 Trovare tutte le sovrapposizioni tra attività progettuali e non progettuali di una persona

SELECT ap.id AS id_progettuale, anp.id AS id_non_progettuale, ap.giorno
FROM AttivitaProgetto ap
JOIN AttivitaNonProgettuale anp 
  ON ap.persona = anp.persona AND ap.giorno = anp.giorno;


---

6. Modifica dei dati

6.1 Aggiornare il budget di un progetto

UPDATE Progetto
SET budget = budget + 50000
WHERE nome = 'Machine Learning Upgrade';

6.2 Rimuovere tutte le attività non progettuali svolte prima di una certa data

DELETE FROM AttivitaNonProgettuale
WHERE giorno < '2024-01-01';

6.3 Aumentare lo stipendio del 10% per tutti i professori associati

UPDATE Persona
SET stipendio = stipendio * 1.1
WHERE posizione = 'Professore Associato';


---

7. Validazione dei vincoli

7.1 Controllare i Work Package con date errate

SELECT * 
FROM WP 
WHERE inizio >= fine;

7.2 Trovare progetti senza attività associate

SELECT p.* 
FROM Progetto p
WHERE NOT EXISTS (
    SELECT 1 
    FROM AttivitaProgetto ap
    WHERE ap.progetto = p.id
);

---

8. Query su combinazioni di dati

8.1 Trovare le persone che hanno lavorato sia a progetti che in attività non progettuali nello stesso giorno

SELECT DISTINCT p.id, p.nome, p.cognome
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
JOIN AttivitaNonProgettuale anp ON p.id = anp.persona AND ap.giorno = anp.giorno;

8.2 Elencare i progetti che coinvolgono persone con diverse posizioni accademiche

SELECT pr.id, pr.nome
FROM Progetto pr
JOIN AttivitaProgetto ap ON pr.id = ap.progetto
JOIN Persona p ON ap.persona = p.id
GROUP BY pr.id, pr.nome
HAVING COUNT(DISTINCT p.posizione) > 1;


---

9. Analisi delle assenze

9.1 Determinare il numero totale di giorni di assenza per ogni persona

SELECT persona, COUNT(*) AS totale_giorni_assenza
FROM Assenza
GROUP BY persona;

9.2 Trovare le persone che hanno avuto più giorni di assenza di tipo "Maternità"

SELECT p.id, p.nome, p.cognome, COUNT(a.id) AS totale_assenze
FROM Persona p
JOIN Assenza a ON p.id = a.persona
WHERE a.tipo = 'Maternità'
GROUP BY p.id, p.nome, p.cognome
ORDER BY totale_assenze DESC;


---

10. Budget e costi

10.1 Calcolare il costo totale del lavoro svolto in ogni progetto

SELECT pr.id, pr.nome, SUM(p.stipendio / 160 * ap.oreDurata) AS costo_totale
FROM Progetto pr
JOIN AttivitaProgetto ap ON pr.id = ap.progetto
JOIN Persona p ON ap.persona = p.id
GROUP BY pr.id, pr.nome;

10.2 Trovare i progetti che stanno superando il budget

SELECT pr.id, pr.nome, SUM(p.stipendio / 160 * ap.oreDurata) AS costo_totale, pr.budget
FROM Progetto pr
JOIN AttivitaProgetto ap ON pr.id = ap.progetto
JOIN Persona p ON ap.persona = p.id
GROUP BY pr.id, pr.nome, pr.budget
HAVING SUM(p.stipendio / 160 * ap.oreDurata) > pr.budget;


---

11. Query sulle attività

11.1 Elencare i tipi di lavoro progettuale più comuni

SELECT tipo, COUNT(*) AS frequenza
FROM AttivitaProgetto
GROUP BY tipo
ORDER BY frequenza DESC;

11.2 Determinare quante ore sono state dedicate a ciascun tipo di lavoro non progettuale

SELECT tipo, SUM(oreDurata) AS totale_ore
FROM AttivitaNonProgettuale
GROUP BY tipo;


---

12. Validazione avanzata

12.1 Controllare sovrapposizioni tra progetti e Work Package

SELECT wp.*
FROM WP wp
JOIN Progetto pr ON wp.progetto = pr.id
WHERE wp.inizio < pr.inizio OR wp.fine > pr.fine;

12.2 Verificare se ci sono attività che superano il limite massimo di 8 ore al giorno

SELECT * 
FROM AttivitaProgetto
WHERE oreDurata > 8;


---

13. Interrogazioni avanzate

13.1 Trovare i progetti che hanno avuto il massimo numero di persone coinvolte

SELECT pr.id, pr.nome, COUNT(DISTINCT ap.persona) AS totale_persone
FROM Progetto pr
JOIN AttivitaProgetto ap ON pr.id = ap.progetto
GROUP BY pr.id, pr.nome
ORDER BY totale_persone DESC
LIMIT 1;

13.2 Elencare le persone che non hanno mai avuto assenze

SELECT p.*
FROM Persona p
WHERE NOT EXISTS (
    SELECT 1
    FROM Assenza a
    WHERE a.persona = p.id
);


---

14. Operazioni complesse

14.1 Calcolare il carico di lavoro medio giornaliero per ogni persona

SELECT persona, AVG(oreDurata) AS carico_medio
FROM (
    SELECT persona, giorno, SUM(oreDurata) AS oreDurata
    FROM (
        SELECT persona, giorno, oreDurata 
        FROM AttivitaProgetto
        UNION ALL
        SELECT persona, giorno, oreDurata 
        FROM AttivitaNonProgettuale
    ) AS tutte_attivita
    GROUP BY persona, giorno
) AS carico
GROUP BY persona;

14.2 Trovare i progetti a cui hanno lavorato più di 10 persone nello stesso giorno

SELECT ap.progetto, ap.giorno, COUNT(DISTINCT ap.persona) AS numero_persone
FROM AttivitaProgetto ap
GROUP BY ap.progetto, ap.giorno
HAVING COUNT(DISTINCT ap.persona) > 10;


---
Considerando la vastità del database Accademia e delle possibili operazioni, possiamo ancora esplorare query più specifiche, che si focalizzano su dettagli o scenari particolari. Ecco un ulteriore set di interrogazioni che potrebbero capitarti:


---

15. Query sulle prestazioni

15.1 Trovare le persone che hanno lavorato il massimo numero di ore in un singolo giorno

SELECT persona, giorno, SUM(oreDurata) AS totale_ore
FROM (
    SELECT persona, giorno, oreDurata 
    FROM AttivitaProgetto
    UNION ALL
    SELECT persona, giorno, oreDurata 
    FROM AttivitaNonProgettuale
) AS tutte_attivita
GROUP BY persona, giorno
ORDER BY totale_ore DESC
LIMIT 1;

15.2 Identificare le persone con lo stipendio più alto in relazione al numero di ore lavorate

SELECT p.id, p.nome, p.cognome, p.stipendio, SUM(ap.oreDurata) AS totale_ore, (p.stipendio / SUM(ap.oreDurata)) AS stipendio_per_ora
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
GROUP BY p.id, p.nome, p.cognome, p.stipendio
ORDER BY stipendio_per_ora DESC;


---

16. Query temporali

16.1 Trovare i progetti che non hanno avuto attività registrate in un certo mese

SELECT pr.id, pr.nome
FROM Progetto pr
LEFT JOIN AttivitaProgetto ap ON pr.id = ap.progetto AND EXTRACT(MONTH FROM ap.giorno) = 6
WHERE ap.id IS NULL;

16.2 Trovare gli anni con il massimo numero di progetti avviati

SELECT EXTRACT(YEAR FROM inizio) AS anno, COUNT(*) AS numero_progetti
FROM Progetto
GROUP BY EXTRACT(YEAR FROM inizio)
ORDER BY numero_progetti DESC;


---

17. Query sulle differenze

17.1 Identificare le persone che hanno lavorato a progetti ma non hanno mai partecipato ad attività non progettuali

SELECT DISTINCT p.id, p.nome, p.cognome
FROM Persona p
WHERE EXISTS (
    SELECT 1
    FROM AttivitaProgetto ap
    WHERE ap.persona = p.id
)
AND NOT EXISTS (
    SELECT 1
    FROM AttivitaNonProgettuale anp
    WHERE anp.persona = p.id
);

17.2 Identificare i progetti senza alcuna assenza tra i partecipanti

SELECT DISTINCT pr.id, pr.nome
FROM Progetto pr
JOIN AttivitaProgetto ap ON pr.id = ap.progetto
WHERE NOT EXISTS (
    SELECT 1
    FROM Assenza a
    WHERE a.persona = ap.persona
    AND a.giorno = ap.giorno
);


---

18. Query avanzate su Work Package

18.1 Elencare i Work Package attivi in un determinato intervallo di date

SELECT wp.*
FROM WP wp
WHERE wp.inizio <= '2024-11-01' AND wp.fine >= '2024-11-15';

18.2 Trovare Work Package con sovrapposizioni temporali all'interno dello stesso progetto

SELECT wp1.progetto, wp1.id AS wp1_id, wp2.id AS wp2_id
FROM WP wp1
JOIN WP wp2 ON wp1.progetto = wp2.progetto
WHERE wp1.id < wp2.id AND wp1.fine > wp2.inizio AND wp2.fine > wp1.inizio;


---

19. Analisi basate su assenze

19.1 Determinare l'impatto delle assenze sul carico di lavoro giornaliero

SELECT giorno, COUNT(*) AS numero_assenze, 
    (SELECT SUM(oreDurata) FROM AttivitaProgetto WHERE giorno = a.giorno) AS ore_totali_progetti,
    (SELECT SUM(oreDurata) FROM AttivitaNonProgettuale WHERE giorno = a.giorno) AS ore_totali_non_progetti
FROM Assenza a
GROUP BY giorno
ORDER BY numero_assenze DESC;

19.2 Trovare il mese con il massimo numero di assenze

SELECT EXTRACT(MONTH FROM giorno) AS mese, COUNT(*) AS totale_assenze
FROM Assenza
GROUP BY EXTRACT(MONTH FROM giorno)
ORDER BY totale_assenze DESC
LIMIT 1;


---

20. Confronti tra progetti

20.1 Confrontare i budget di progetti simili per nome

SELECT p1.nome AS progetto1, p2.nome AS progetto2, p1.budget AS budget1, p2.budget AS budget2
FROM Progetto p1
JOIN Progetto p2 ON p1.nome LIKE p2.nome || '%' AND p1.id < p2.id;

20.2 Trovare i progetti con la durata maggiore rispetto alla media

SELECT id, nome, (fine - inizio) AS durata
FROM Progetto
WHERE (fine - inizio) > (
    SELECT AVG(fine - inizio) 
    FROM Progetto
);


---

21. Altre query specifiche

21.1 Elencare le attività progettuali ordinate per priorità di tipo (ad esempio "Ricerca e Sviluppo" ha priorità maggiore)

SELECT * 
FROM AttivitaProgetto
ORDER BY FIELD(tipo, 'Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');

21.2 Determinare il totale delle ore lavorate per Work Package in base al tipo di attività

SELECT wp.id AS wp_id, ap.tipo, SUM(ap.oreDurata) AS totale_ore
FROM WP wp
JOIN AttivitaProgetto ap ON wp.id = ap.wp
GROUP BY wp.id, ap.tipo;


---

1. Elenco delle persone e le loro posizioni

SELECT nome, cognome, posizione 
FROM Persona;

2. Ricercatori con stipendio superiore a 50.000

SELECT nome, cognome 
FROM Persona 
WHERE posizione = 'Ricercatore' AND stipendio > 50000;

3. Budget totale di tutti i progetti

SELECT SUM(budget) AS budget_totale 
FROM Progetto;

4. Progetti attivi al 2024-11-17

SELECT nome 
FROM Progetto 
WHERE '2024-11-17' BETWEEN inizio AND fine;

5. Dettagli dei progetti con durata inferiore a un anno

SELECT nome, inizio, fine 
FROM Progetto 
WHERE (fine - inizio) < 365;

6. Elenco delle attività progettuali per ogni persona

SELECT Persona.nome, Persona.cognome, AttivitaProgetto.tipo,

AttivitaProgetto.oreDurata, AttivitaProgetto.giorno
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona;

7. Elenco delle attività non progettuali di tipo 'Didattica'

SELECT Persona.nome, Persona.cognome, AttivitaNonProgettuale.oreDurata, AttivitaNonProgettuale.giorno
FROM Persona
JOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.persona
WHERE AttivitaNonProgettuale.tipo = 'Didattica';

8. Numero di ore totali svolte da ogni persona nei progetti

SELECT Persona.nome, Persona.cognome, SUM(AttivitaProgetto.oreDurata) AS ore_totali
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
GROUP BY Persona.nome, Persona.cognome;

9. Progetti con budget superiore a 1 milione

SELECT nome, budget
FROM Progetto
WHERE budget > 1000000;

10. Elenco delle assenze per malattia

SELECT Persona.nome, Persona.cognome, Assenza.giorno
FROM Persona
JOIN Assenza ON Persona.id = Assenza.persona
WHERE Assenza.tipo = 'Malattia';


11. Ore totali per attività non progettuali di ogni persona

SELECT Persona.nome, Persona.cognome, SUM(AttivitaNonProgettuale.oreDurata) AS ore_totali
FROM Persona
JOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.persona
GROUP BY Persona.nome, Persona.cognome;

12. Progetti iniziati nel 2023

SELECT nome, inizio 
FROM Progetto 
WHERE YEAR(inizio) = 2023;

13. Elenco delle persone coinvolte in più di 3 progetti

SELECT Persona.nome, Persona.cognome, COUNT(DISTINCT AttivitaProgetto.progetto) AS numero_progetti
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
GROUP BY Persona.nome, Persona.cognome
HAVING COUNT(DISTINCT AttivitaProgetto.progetto) > 3;

14. Elenco dei work package (WP) di un progetto specifico

SELECT WP.nome, WP.inizio, WP.fine
FROM WP
JOIN Progetto ON WP.progetto = Progetto.id
WHERE Progetto.nome = 'Nome del Progetto'; -- Sostituire con il nome del progetto

15. Assenze per maternità nel 2024

SELECT Persona.nome, Persona.cognome, Assenza.giorno
FROM Persona
JOIN Assenza ON Persona.id = Assenza.persona
WHERE Assenza.tipo = 'Maternità' AND YEAR(Assenza.giorno) = 2024;

16. Ore di lavoro per ogni tipo di attività progettuale

SELECT tipo, SUM(oreDurata) AS ore_totali
FROM AttivitaProgetto
GROUP BY tipo;

17. Progetti con work package che terminano dopo la fine del progetto

SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wp
FROM WP
JOIN Progetto ON WP.progetto = Progetto.id
WHERE WP.fine > Progetto.fine;

18. Persone che hanno lavorato almeno 8 ore in un giorno

SELECT Persona.nome, Persona.cognome, AttivitaProgetto.giorno, SUM(AttivitaProgetto.oreDurata) AS ore_totali
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
GROUP BY Persona.id, AttivitaProgetto.giorno
HAVING SUM(AttivitaProgetto.oreDurata) >= 8;

19. Progetti senza alcun work package

SELECT Progetto.nome
FROM Progetto
LEFT JOIN WP ON Progetto.id = WP.progetto
WHERE WP.id IS NULL;

20. Ore totali di lavoro per progetto

SELECT Progetto.nome, SUM(AttivitaProgetto.oreDurata) AS ore_totali
FROM Progetto
JOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progetto
GROUP BY Progetto.nome;

21. Media dello stipendio per posizione

SELECT posizione, AVG(stipendio) AS stipendio_medio
FROM Persona
GROUP BY posizione;

---

1. Elenco delle persone che hanno lavorato su progetti con budget superiore a 500.000

SELECT DISTINCT Persona.nome, Persona.cognome
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
JOIN Progetto ON AttivitaProgetto.progetto = Progetto.id
WHERE Progetto.budget > 500000;


---

2. Dettagli dei progetti in cui la durata di almeno un WP è superiore alla durata del progetto

SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wp, WP.inizio, WP.fine, Progetto.inizio AS inizio_progetto, Progetto.fine AS fine_progetto
FROM Progetto
JOIN WP ON Progetto.id = WP.progetto
WHERE DATEDIFF(WP.fine, WP.inizio) > DATEDIFF(Progetto.fine, Progetto.inizio);


---

3. Elenco delle persone che hanno lavorato più ore nei progetti rispetto ad attività non progettuali

SELECT nome, cognome
FROM Persona
WHERE (
    SELECT COALESCE(SUM(oreDurata), 0)
    FROM AttivitaProgetto
    WHERE AttivitaProgetto.persona = Persona.id
) > (
    SELECT COALESCE(SUM(oreDurata), 0)
    FROM AttivitaNonProgettuale
    WHERE AttivitaNonProgettuale.persona = Persona.id
);


---

4. Elenco dei progetti senza attività assegnate

SELECT nome
FROM Progetto
WHERE id NOT IN (
    SELECT DISTINCT progetto
    FROM AttivitaProgetto
);


---

5. Nome e stipendio delle persone che hanno svolto attività di 'Didattica' per più di 20 ore in totale

SELECT Persona.nome, Persona.cognome, Persona.stipendio
FROM Persona
JOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.persona
WHERE AttivitaNonProgettuale.tipo = 'Didattica'
GROUP BY Persona.id, Persona.nome, Persona.cognome, Persona.stipendio
HAVING SUM(AttivitaNonProgettuale.oreDurata) > 20;


---

6. Elenco delle persone coinvolte nei progetti con il maggior numero di work package

SELECT DISTINCT Persona.nome, Persona.cognome
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
WHERE AttivitaProgetto.progetto IN (
    SELECT progetto
    FROM WP
    GROUP BY progetto
    HAVING COUNT(id) = (
        SELECT MAX(conta_wp)
        FROM (
            SELECT COUNT(id) AS conta_wp
            FROM WP
            GROUP BY progetto
        ) AS subquery
    )
);


---

7. Progetti con work package che terminano prima dell'inizio del progetto

SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wp, WP.inizio AS inizio_wp, WP.fine AS fine_wp
FROM Progetto
JOIN WP ON Progetto.id = WP.progetto
WHERE WP.fine < Progetto.inizio;


---

8. Elenco delle persone che hanno più assenze rispetto alle attività totali svolte

SELECT Persona.nome, Persona.cognome
FROM Persona
WHERE (
    SELECT COUNT(*)
    FROM Assenza
    WHERE Assenza.persona = Persona.id
) > (
    SELECT COUNT(*)
    FROM AttivitaProgetto
    WHERE AttivitaProgetto.persona = Persona.id
) + (
    SELECT COUNT(*)
    FROM AttivitaNonProgettuale
    WHERE AttivitaNonProgettuale.persona = Persona.id
);


---

9. Stipendi delle persone coinvolte nei progetti con almeno un WP terminato in ritardo

SELECT DISTINCT Persona.nome, Persona.cognome, Persona.stipendio
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
WHERE AttivitaProgetto.progetto IN (
    SELECT WP.progetto
    FROM WP
    JOIN Progetto ON WP.progetto = Progetto.id
    WHERE WP.fine > Progetto.fine
);


---

10. Work package con durata maggiore rispetto alla media di tutti i WP

SELECT nome, progetto, DATEDIFF(fine, inizio) AS durata
FROM WP
WHERE DATEDIFF(fine, inizio) > (
    SELECT AVG(DATEDIFF(fine, inizio))
    FROM WP
);


---

11. Elenco dei progetti con più di 10 attività assegnate

SELECT Progetto.nome, COUNT(AttivitaProgetto.id) AS numero_attivita
FROM Progetto
JOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progetto
GROUP BY Progetto.id, Progetto.nome
HAVING COUNT(AttivitaProgetto.id) > 10;


---

12. Persone che hanno lavorato su progetti con il budget massimo

SELECT DISTINCT Persona.nome, Persona.cognome
FROM Persona
JOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona
WHERE AttivitaProgetto.progetto IN (
    SELECT id
    FROM Progetto
    WHERE budget = (SELECT MAX(budget) FROM Progetto)
);


---

13. Work package più lunghi per ogni progetto

SELECT WP.progetto, WP.nome, DATEDIFF(WP.fine, WP.inizio) AS durata
FROM WP
WHERE DATEDIFF(WP.fine, WP.inizio) = (
    SELECT MAX(DATEDIFF(fine, inizio))
    FROM WP AS WP_sub
    WHERE WP_sub.progetto = WP.progetto
);


---

14. Progetti in cui tutte le attività progettuali durano meno di 4 ore

SELECT nome
FROM Progetto
WHERE NOT EXISTS (
    SELECT 1
    FROM AttivitaProgetto
    WHERE AttivitaProgetto.progetto = Progetto.id AND AttivitaProgetto.oreDurata >= 4
);


---

15. Persone che non hanno svolto attività non progettuali

SELECT nome, cognome
FROM Persona
WHERE id NOT IN (
    SELECT DISTINCT persona
    FROM AttivitaNonProgettuale
);


---

16. Progetti con almeno una persona con stipendio superiore alla media

SELECT DISTINCT Progetto.nome
FROM Progetto
JOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progetto
JOIN Persona ON AttivitaProgetto.persona = Persona.id
WHERE Persona.stipendio > (
    SELECT AVG(stipendio)
    FROM Persona
);


---

17. Numero di work package per ciascun progetto terminato nel 2024

SELECT Progetto.nome, COUNT(WP.id) AS numero_wp
FROM Progetto
JOIN WP ON Progetto.id = WP.progetto
WHERE YEAR(Progetto.fine) = 2024
GROUP BY Progetto.nome;


---

18. Elenco delle attività progettuali con durata superiore alla media delle attività di quel progetto

SELECT AttivitaProgetto.progetto, AttivitaProgetto.tipo, AttivitaProgetto.oreDurata
FROM AttivitaProgetto
WHERE AttivitaProgetto.oreDurata > (
    SELECT AVG(oreDurata)
    FROM AttivitaProgetto AS sub
    WHERE sub.progetto = AttivitaProgetto.progetto
);


---

19. Persone con almeno 5 attività non progettuali di tipo 'Ricerca'

SELECT Persona.nome, Persona.cognome
FROM Persona
JOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.persona
WHERE AttivitaNonProgettuale.tipo = 'Ricerca'
GROUP BY Persona.id, Persona.nome, Persona.cognome
HAVING COUNT(AttivitaNonProgettuale.id) >= 5;


---

20. Progetti con durata inferiore alla media dei progetti

SELECT nome, DATEDIFF(fine, inizio) AS durata
FROM Progetto
WHERE DATEDIFF(fine, inizio) < (
    SELECT AVG(DATEDIFF(fine, inizio))
    FROM Progetto
);


---

21. Persone che hanno assenze ma non hanno svolto attività progettuali

SELECT Persona.nome, Persona.cognome
FROM Persona
WHERE id IN (
    SELECT persona
    FROM Assenza
) AND id NOT IN (
    SELECT DISTINCT persona
    FROM AttivitaProgetto
);
____
1. Operazioni di base
1.1 Recuperare tutti i professori ordinari
SELECT * FROM Persona WHERE posizione = 'Professore Ordinario';
1.2 Elencare tutti i progetti che hanno un budget superiore a 1.000.000
SELECT * FROM Progetto WHERE budget > 1000000;
1.3 Trovare tutte le attività non progettuali svolte da una persona in una certa data
SELECT * FROM AttivitaNonProgettuale WHERE persona = 123 AND giorno = '2024-11-01';
1.4 Elencare tutte le assenze di tipo "Malattia"
SELECT * FROM Assenza WHERE tipo = 'Malattia';

---
2. Query con JOIN
2.1 Trovare il nome, cognome e stipendio di chi lavora al progetto "AI Research"
SELECT p.nome, p.cognome, p.stipendio FROM Persona pJOIN AttivitaProgetto ap ON p.id = ap.personaJOIN Progetto pr ON ap.progetto = pr.idWHERE pr.nome = 'AI Research';
2.2 Elencare tutti i Work Package (WP) di un progetto specifico
SELECT wp.*FROM WP wpJOIN Progetto pr ON wp.progetto = pr.idWHERE pr.nome = 'Quantum Computing';
2.3 Trovare i dettagli delle attività di "Ricerca e Sviluppo" svolte in un Work Package
SELECT ap.*FROM AttivitaProgetto apJOIN WP wp ON ap.wp = wp.id AND ap.progetto = wp.progettoWHERE ap.tipo = 'Ricerca e Sviluppo';

---
3. Analisi di aggregazione
3.1 Calcolare il totale delle ore lavorate da una persona in un mese
SELECT persona, SUM(oreDurata) AS totale_oreFROM AttivitaProgettoWHERE EXTRACT(MONTH FROM giorno) = 11GROUP BY persona;
3.2 Determinare il numero totale di assenze per tipo
SELECT tipo, COUNT(*) AS totaleFROM AssenzaGROUP BY tipo;
3.3 Calcolare la media degli stipendi per ogni tipo di posizione
SELECT posizione, AVG(stipendio) AS stipendio_medioFROM PersonaGROUP BY posizione;

---
4. Analisi temporale
4.1 Trovare tutte le attività progettuali svolte in un determinato intervallo di date
SELECT * FROM AttivitaProgettoWHERE giorno BETWEEN '2024-10-01' AND '2024-10-31';
4.2 Elencare i progetti attivi in una certa data
SELECT * FROM ProgettoWHERE inizio <= '2024-11-01' AND fine >= '2024-11-01';

---
5. Query avanzate
5.1 Trovare tutte le persone che non hanno svolto attività progettuali
SELECT p.*FROM Persona pWHERE NOT EXISTS (    SELECT 1     FROM AttivitaProgetto ap    WHERE ap.persona = p.id);
5.2 Elencare i progetti che non hanno WP
SELECT *FROM Progetto pWHERE NOT EXISTS (    SELECT 1     FROM WP wp    WHERE wp.progetto = p.id);
5.3 Trovare tutte le sovrapposizioni tra attività progettuali e non progettuali di una persona
SELECT ap.id AS id_progettuale, anp.id AS id_non_progettuale, ap.giornoFROM AttivitaProgetto apJOIN AttivitaNonProgettuale anp   ON ap.persona = anp.persona AND ap.giorno = anp.giorno;

---
6. Modifica dei dati
6.1 Aggiornare il budget di un progetto
UPDATE ProgettoSET budget = budget + 50000WHERE nome = 'Machine Learning Upgrade';
6.2 Rimuovere tutte le attività non progettuali svolte prima di una certa data
DELETE FROM AttivitaNonProgettualeWHERE giorno < '2024-01-01';
6.3 Aumentare lo stipendio del 10% per tutti i professori associati
UPDATE PersonaSET stipendio = stipendio * 1.1WHERE posizione = 'Professore Associato';

---
7. Validazione dei vincoli
7.1 Controllare i Work Package con date errate
SELECT * FROM WP WHERE inizio >= fine;
7.2 Trovare progetti senza attività associate
SELECT p.* FROM Progetto pWHERE NOT EXISTS (    SELECT 1     FROM AttivitaProgetto ap    WHERE ap.progetto = p.id);
---
8. Query su combinazioni di dati
8.1 Trovare le persone che hanno lavorato sia a progetti che in attività non progettuali nello stesso giorno
SELECT DISTINCT p.id, p.nome, p.cognomeFROM Persona pJOIN AttivitaProgetto ap ON p.id = ap.personaJOIN AttivitaNonProgettuale anp ON p.id = anp.persona AND ap.giorno = anp.giorno;
8.2 Elencare i progetti che coinvolgono persone con diverse posizioni accademiche
SELECT pr.id, pr.nomeFROM Progetto prJOIN AttivitaProgetto ap ON pr.id = ap.progettoJOIN Persona p ON ap.persona = p.idGROUP BY pr.id, pr.nomeHAVING COUNT(DISTINCT p.posizione) > 1;

---
9. Analisi delle assenze
9.1 Determinare il numero totale di giorni di assenza per ogni persona
SELECT persona, COUNT(*) AS totale_giorni_assenzaFROM AssenzaGROUP BY persona;
9.2 Trovare le persone che hanno avuto più giorni di assenza di tipo "Maternità"
SELECT p.id, p.nome, p.cognome, COUNT(a.id) AS totale_assenzeFROM Persona pJOIN Assenza a ON p.id = a.personaWHERE a.tipo = 'Maternità'GROUP BY p.id, p.nome, p.cognomeORDER BY totale_assenze DESC;

---
10. Budget e costi
10.1 Calcolare il costo totale del lavoro svolto in ogni progetto
SELECT pr.id, pr.nome, SUM(p.stipendio / 160 * ap.oreDurata) AS costo_totaleFROM Progetto prJOIN AttivitaProgetto ap ON pr.id = ap.progettoJOIN Persona p ON ap.persona = p.idGROUP BY pr.id, pr.nome;
10.2 Trovare i progetti che stanno superando il budget
SELECT pr.id, pr.nome, SUM(p.stipendio / 160 * ap.oreDurata) AS costo_totale, pr.budgetFROM Progetto prJOIN AttivitaProgetto ap ON pr.id = ap.progettoJOIN Persona p ON ap.persona = p.idGROUP BY pr.id, pr.nome, pr.budgetHAVING SUM(p.stipendio / 160 * ap.oreDurata) > pr.budget;

---
11. Query sulle attività
11.1 Elencare i tipi di lavoro progettuale più comuni
SELECT tipo, COUNT(*) AS frequenzaFROM AttivitaProgettoGROUP BY tipoORDER BY frequenza DESC;
11.2 Determinare quante ore sono state dedicate a ciascun tipo di lavoro non progettuale
SELECT tipo, SUM(oreDurata) AS totale_oreFROM AttivitaNonProgettualeGROUP BY tipo;

---
12. Validazione avanzata
12.1 Controllare sovrapposizioni tra progetti e Work Package
SELECT wp.*FROM WP wpJOIN Progetto pr ON wp.progetto = pr.idWHERE wp.inizio < pr.inizio OR wp.fine > pr.fine;
12.2 Verificare se ci sono attività che superano il limite massimo di 8 ore al giorno
SELECT * FROM AttivitaProgettoWHERE oreDurata > 8;

---
13. Interrogazioni avanzate
13.1 Trovare i progetti che hanno avuto il massimo numero di persone coinvolte
SELECT pr.id, pr.nome, COUNT(DISTINCT ap.persona) AS totale_personeFROM Progetto prJOIN AttivitaProgetto ap ON pr.id = ap.progettoGROUP BY pr.id, pr.nomeORDER BY totale_persone DESCLIMIT 1;
13.2 Elencare le persone che non hanno mai avuto assenze
SELECT p.*FROM Persona pWHERE NOT EXISTS (    SELECT 1    FROM Assenza a    WHERE a.persona = p.id);

---
14. Operazioni complesse
14.1 Calcolare il carico di lavoro medio giornaliero per ogni persona
SELECT persona, AVG(oreDurata) AS carico_medioFROM (    SELECT persona, giorno, SUM(oreDurata) AS oreDurata    FROM (        SELECT persona, giorno, oreDurata         FROM AttivitaProgetto        UNION ALL        SELECT persona, giorno, oreDurata         FROM AttivitaNonProgettuale    ) AS tutte_attivita    GROUP BY persona, giorno) AS caricoGROUP BY persona;
14.2 Trovare i progetti a cui hanno lavorato più di 10 persone nello stesso giorno
SELECT ap.progetto, ap.giorno, COUNT(DISTINCT ap.persona) AS numero_personeFROM AttivitaProgetto apGROUP BY ap.progetto, ap.giornoHAVING COUNT(DISTINCT ap.persona) > 10;

---Considerando la vastità del database Accademia e delle possibili operazioni, possiamo ancora esplorare query più specifiche, che si focalizzano su dettagli o scenari particolari. Ecco un ulteriore set di interrogazioni che potrebbero capitarti:

---
15. Query sulle prestazioni
15.1 Trovare le persone che hanno lavorato il massimo numero di ore in un singolo giorno
SELECT persona, giorno, SUM(oreDurata) AS totale_oreFROM (    SELECT persona, giorno, oreDurata     FROM AttivitaProgetto    UNION ALL    SELECT persona, giorno, oreDurata     FROM AttivitaNonProgettuale) AS tutte_attivitaGROUP BY persona, giornoORDER BY totale_ore DESCLIMIT 1;
15.2 Identificare le persone con lo stipendio più alto in relazione al numero di ore lavorate
SELECT p.id, p.nome, p.cognome, p.stipendio, SUM(ap.oreDurata) AS totale_ore, (p.stipendio / SUM(ap.oreDurata)) AS stipendio_per_oraFROM Persona pJOIN AttivitaProgetto ap ON p.id = ap.personaGROUP BY p.id, p.nome, p.cognome, p.stipendioORDER BY stipendio_per_ora DESC;

---
16. Query temporali
16.1 Trovare i progetti che non hanno avuto attività registrate in un certo mese
SELECT pr.id, pr.nomeFROM Progetto prLEFT JOIN AttivitaProgetto ap ON pr.id = ap.progetto AND EXTRACT(MONTH FROM ap.giorno) = 6WHERE ap.id IS NULL;
16.2 Trovare gli anni con il massimo numero di progetti avviati
SELECT EXTRACT(YEAR FROM inizio) AS anno, COUNT(*) AS numero_progettiFROM ProgettoGROUP BY EXTRACT(YEAR FROM inizio)ORDER BY numero_progetti DESC;

---
17. Query sulle differenze
17.1 Identificare le persone che hanno lavorato a progetti ma non hanno mai partecipato ad attività non progettuali
SELECT DISTINCT p.id, p.nome, p.cognomeFROM Persona pWHERE EXISTS (    SELECT 1    FROM AttivitaProgetto ap    WHERE ap.persona = p.id)AND NOT EXISTS (    SELECT 1    FROM AttivitaNonProgettuale anp    WHERE anp.persona = p.id);
17.2 Identificare i progetti senza alcuna assenza tra i partecipanti
SELECT DISTINCT pr.id, pr.nomeFROM Progetto prJOIN AttivitaProgetto ap ON pr.id = ap.progettoWHERE NOT EXISTS (    SELECT 1    FROM Assenza a    WHERE a.persona = ap.persona    AND a.giorno = ap.giorno);

---
18. Query avanzate su Work Package
18.1 Elencare i Work Package attivi in un determinato intervallo di date
SELECT wp.*FROM WP wpWHERE wp.inizio <= '2024-11-01' AND wp.fine >= '2024-11-15';
18.2 Trovare Work Package con sovrapposizioni temporali all'interno dello stesso progetto
SELECT wp1.progetto, wp1.id AS wp1_id, wp2.id AS wp2_idFROM WP wp1JOIN WP wp2 ON wp1.progetto = wp2.progettoWHERE wp1.id < wp2.id AND wp1.fine > wp2.inizio AND wp2.fine > wp1.inizio;

---
19. Analisi basate su assenze
19.1 Determinare l'impatto delle assenze sul carico di lavoro giornaliero
SELECT giorno, COUNT(*) AS numero_assenze,     (SELECT SUM(oreDurata) FROM AttivitaProgetto WHERE giorno = a.giorno) AS ore_totali_progetti,    (SELECT SUM(oreDurata) FROM AttivitaNonProgettuale WHERE giorno = a.giorno) AS ore_totali_non_progettiFROM Assenza aGROUP BY giornoORDER BY numero_assenze DESC;
19.2 Trovare il mese con il massimo numero di assenze
SELECT EXTRACT(MONTH FROM giorno) AS mese, COUNT(*) AS totale_assenzeFROM AssenzaGROUP BY EXTRACT(MONTH FROM giorno)ORDER BY totale_assenze DESCLIMIT 1;

---
20. Confronti tra progetti
20.1 Confrontare i budget di progetti simili per nome
SELECT p1.nome AS progetto1, p2.nome AS progetto2, p1.budget AS budget1, p2.budget AS budget2FROM Progetto p1JOIN Progetto p2 ON p1.nome LIKE p2.nome || '%' AND p1.id < p2.id;
20.2 Trovare i progetti con la durata maggiore rispetto alla media
SELECT id, nome, (fine - inizio) AS durataFROM ProgettoWHERE (fine - inizio) > (    SELECT AVG(fine - inizio)     FROM Progetto);

---
21. Altre query specifiche
21.1 Elencare le attività progettuali ordinate per priorità di tipo (ad esempio "Ricerca e Sviluppo" ha priorità maggiore)
SELECT * FROM AttivitaProgettoORDER BY FIELD(tipo, 'Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
21.2 Determinare il totale delle ore lavorate per Work Package in base al tipo di attività
SELECT wp.id AS wp_id, ap.tipo, SUM(ap.oreDurata) AS totale_oreFROM WP wpJOIN AttivitaProgetto ap ON wp.id = ap.wpGROUP BY wp.id, ap.tipo;

---
1. Elenco delle persone e le loro posizioni
SELECT nome, cognome, posizione FROM Persona;
2. Ricercatori con stipendio superiore a 50.000
SELECT nome, cognome FROM Persona WHERE posizione = 'Ricercatore' AND stipendio > 50000;
3. Budget totale di tutti i progetti
SELECT SUM(budget) AS budget_totale FROM Progetto;
4. Progetti attivi al 2024-11-17
SELECT nome FROM Progetto WHERE '2024-11-17' BETWEEN inizio AND fine;
5. Dettagli dei progetti con durata inferiore a un anno
SELECT nome, inizio, fine FROM Progetto WHERE (fine - inizio) < 365;
6. Elenco delle attività progettuali per ogni persona
SELECT Persona.nome, Persona.cognome, AttivitaProgetto.tipo,
AttivitaProgetto.oreDurata, AttivitaProgetto.giornoFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.persona;
7. Elenco delle attività non progettuali di tipo 'Didattica'
SELECT Persona.nome, Persona.cognome, AttivitaNonProgettuale.oreDurata, AttivitaNonProgettuale.giornoFROM PersonaJOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.personaWHERE AttivitaNonProgettuale.tipo = 'Didattica';
8. Numero di ore totali svolte da ogni persona nei progetti
SELECT Persona.nome, Persona.cognome, SUM(AttivitaProgetto.oreDurata) AS ore_totaliFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaGROUP BY Persona.nome, Persona.cognome;
9. Progetti con budget superiore a 1 milione
SELECT nome, budgetFROM ProgettoWHERE budget > 1000000;
10. Elenco delle assenze per malattia
SELECT Persona.nome, Persona.cognome, Assenza.giornoFROM PersonaJOIN Assenza ON Persona.id = Assenza.personaWHERE Assenza.tipo = 'Malattia';

11. Ore totali per attività non progettuali di ogni persona
SELECT Persona.nome, Persona.cognome, SUM(AttivitaNonProgettuale.oreDurata) AS ore_totaliFROM PersonaJOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.personaGROUP BY Persona.nome, Persona.cognome;
12. Progetti iniziati nel 2023
SELECT nome, inizio FROM Progetto WHERE YEAR(inizio) = 2023;
13. Elenco delle persone coinvolte in più di 3 progetti
SELECT Persona.nome, Persona.cognome, COUNT(DISTINCT AttivitaProgetto.progetto) AS numero_progettiFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaGROUP BY Persona.nome, Persona.cognomeHAVING COUNT(DISTINCT AttivitaProgetto.progetto) > 3;
14. Elenco dei work package (WP) di un progetto specifico
SELECT WP.nome, WP.inizio, WP.fineFROM WPJOIN Progetto ON WP.progetto = Progetto.idWHERE Progetto.nome = 'Nome del Progetto'; -- Sostituire con il nome del progetto
15. Assenze per maternità nel 2024
SELECT Persona.nome, Persona.cognome, Assenza.giornoFROM PersonaJOIN Assenza ON Persona.id = Assenza.personaWHERE Assenza.tipo = 'Maternità' AND YEAR(Assenza.giorno) = 2024;
16. Ore di lavoro per ogni tipo di attività progettuale
SELECT tipo, SUM(oreDurata) AS ore_totaliFROM AttivitaProgettoGROUP BY tipo;
17. Progetti con work package che terminano dopo la fine del progetto
SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wpFROM WPJOIN Progetto ON WP.progetto = Progetto.idWHERE WP.fine > Progetto.fine;
18. Persone che hanno lavorato almeno 8 ore in un giorno
SELECT Persona.nome, Persona.cognome, AttivitaProgetto.giorno, SUM(AttivitaProgetto.oreDurata) AS ore_totaliFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaGROUP BY Persona.id, AttivitaProgetto.giornoHAVING SUM(AttivitaProgetto.oreDurata) >= 8;
19. Progetti senza alcun work package
SELECT Progetto.nomeFROM ProgettoLEFT JOIN WP ON Progetto.id = WP.progettoWHERE WP.id IS NULL;
20. Ore totali di lavoro per progetto
SELECT Progetto.nome, SUM(AttivitaProgetto.oreDurata) AS ore_totaliFROM ProgettoJOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progettoGROUP BY Progetto.nome;
21. Media dello stipendio per posizione
SELECT posizione, AVG(stipendio) AS stipendio_medioFROM PersonaGROUP BY posizione;
---
1. Elenco delle persone che hanno lavorato su progetti con budget superiore a 500.000
SELECT DISTINCT Persona.nome, Persona.cognomeFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaJOIN Progetto ON AttivitaProgetto.progetto = Progetto.idWHERE Progetto.budget > 500000;

---
2. Dettagli dei progetti in cui la durata di almeno un WP è superiore alla durata del progetto
SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wp, WP.inizio, WP.fine, Progetto.inizio AS inizio_progetto, Progetto.fine AS fine_progettoFROM ProgettoJOIN WP ON Progetto.id = WP.progettoWHERE DATEDIFF(WP.fine, WP.inizio) > DATEDIFF(Progetto.fine, Progetto.inizio);

---
3. Elenco delle persone che hanno lavorato più ore nei progetti rispetto ad attività non progettuali
SELECT nome, cognomeFROM PersonaWHERE (    SELECT COALESCE(SUM(oreDurata), 0)    FROM AttivitaProgetto    WHERE AttivitaProgetto.persona = Persona.id) > (    SELECT COALESCE(SUM(oreDurata), 0)    FROM AttivitaNonProgettuale    WHERE AttivitaNonProgettuale.persona = Persona.id);

---
4. Elenco dei progetti senza attività assegnate
SELECT nomeFROM ProgettoWHERE id NOT IN (    SELECT DISTINCT progetto    FROM AttivitaProgetto);

---
5. Nome e stipendio delle persone che hanno svolto attività di 'Didattica' per più di 20 ore in totale
SELECT Persona.nome, Persona.cognome, Persona.stipendioFROM PersonaJOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.personaWHERE AttivitaNonProgettuale.tipo = 'Didattica'GROUP BY Persona.id, Persona.nome, Persona.cognome, Persona.stipendioHAVING SUM(AttivitaNonProgettuale.oreDurata) > 20;

---
6. Elenco delle persone coinvolte nei progetti con il maggior numero di work package
SELECT DISTINCT Persona.nome, Persona.cognomeFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaWHERE AttivitaProgetto.progetto IN (    SELECT progetto    FROM WP    GROUP BY progetto    HAVING COUNT(id) = (        SELECT MAX(conta_wp)        FROM (            SELECT COUNT(id) AS conta_wp            FROM WP            GROUP BY progetto        ) AS subquery    ));

---
7. Progetti con work package che terminano prima dell'inizio del progetto
SELECT Progetto.nome AS nome_progetto, WP.nome AS nome_wp, WP.inizio AS inizio_wp, WP.fine AS fine_wpFROM ProgettoJOIN WP ON Progetto.id = WP.progettoWHERE WP.fine < Progetto.inizio;

---
8. Elenco delle persone che hanno più assenze rispetto alle attività totali svolte
SELECT Persona.nome, Persona.cognomeFROM PersonaWHERE (    SELECT COUNT(*)    FROM Assenza    WHERE Assenza.persona = Persona.id) > (    SELECT COUNT(*)    FROM AttivitaProgetto    WHERE AttivitaProgetto.persona = Persona.id) + (    SELECT COUNT(*)    FROM AttivitaNonProgettuale    WHERE AttivitaNonProgettuale.persona = Persona.id);

---
9. Stipendi delle persone coinvolte nei progetti con almeno un WP terminato in ritardo
SELECT DISTINCT Persona.nome, Persona.cognome, Persona.stipendioFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaWHERE AttivitaProgetto.progetto IN (    SELECT WP.progetto    FROM WP    JOIN Progetto ON WP.progetto = Progetto.id    WHERE WP.fine > Progetto.fine);

---
10. Work package con durata maggiore rispetto alla media di tutti i WP
SELECT nome, progetto, DATEDIFF(fine, inizio) AS durataFROM WPWHERE DATEDIFF(fine, inizio) > (    SELECT AVG(DATEDIFF(fine, inizio))    FROM WP);

---
11. Elenco dei progetti con più di 10 attività assegnate
SELECT Progetto.nome, COUNT(AttivitaProgetto.id) AS numero_attivitaFROM ProgettoJOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progettoGROUP BY Progetto.id, Progetto.nomeHAVING COUNT(AttivitaProgetto.id) > 10;

---
12. Persone che hanno lavorato su progetti con il budget massimo
SELECT DISTINCT Persona.nome, Persona.cognomeFROM PersonaJOIN AttivitaProgetto ON Persona.id = AttivitaProgetto.personaWHERE AttivitaProgetto.progetto IN (    SELECT id    FROM Progetto    WHERE budget = (SELECT MAX(budget) FROM Progetto));

---
13. Work package più lunghi per ogni progetto
SELECT WP.progetto, WP.nome, DATEDIFF(WP.fine, WP.inizio) AS durataFROM WPWHERE DATEDIFF(WP.fine, WP.inizio) = (    SELECT MAX(DATEDIFF(fine, inizio))    FROM WP AS WP_sub    WHERE WP_sub.progetto = WP.progetto);

---
14. Progetti in cui tutte le attività progettuali durano meno di 4 ore
SELECT nomeFROM ProgettoWHERE NOT EXISTS (    SELECT 1    FROM AttivitaProgetto    WHERE AttivitaProgetto.progetto = Progetto.id AND AttivitaProgetto.oreDurata >= 4);

---
15. Persone che non hanno svolto attività non progettuali
SELECT nome, cognomeFROM PersonaWHERE id NOT IN (    SELECT DISTINCT persona    FROM AttivitaNonProgettuale);

---
16. Progetti con almeno una persona con stipendio superiore alla media
SELECT DISTINCT Progetto.nomeFROM ProgettoJOIN AttivitaProgetto ON Progetto.id = AttivitaProgetto.progettoJOIN Persona ON AttivitaProgetto.persona = Persona.idWHERE Persona.stipendio > (    SELECT AVG(stipendio)    FROM Persona);

---
17. Numero di work package per ciascun progetto terminato nel 2024
SELECT Progetto.nome, COUNT(WP.id) AS numero_wpFROM ProgettoJOIN WP ON Progetto.id = WP.progettoWHERE YEAR(Progetto.fine) = 2024GROUP BY Progetto.nome;

---
18. Elenco delle attività progettuali con durata superiore alla media delle attività di quel progetto
SELECT AttivitaProgetto.progetto, AttivitaProgetto.tipo, AttivitaProgetto.oreDurataFROM AttivitaProgettoWHERE AttivitaProgetto.oreDurata > (    SELECT AVG(oreDurata)    FROM AttivitaProgetto AS sub    WHERE sub.progetto = AttivitaProgetto.progetto);

---
19. Persone con almeno 5 attività non progettuali di tipo 'Ricerca'
SELECT Persona.nome, Persona.cognomeFROM PersonaJOIN AttivitaNonProgettuale ON Persona.id = AttivitaNonProgettuale.personaWHERE AttivitaNonProgettuale.tipo = 'Ricerca'GROUP BY Persona.id, Persona.nome, Persona.cognomeHAVING COUNT(AttivitaNonProgettuale.id) >= 5;

---
20. Progetti con durata inferiore alla media dei progetti
SELECT nome, DATEDIFF(fine, inizio) AS durataFROM ProgettoWHERE DATEDIFF(fine, inizio) < (    SELECT AVG(DATEDIFF(fine, inizio))    FROM Progetto);

---
21. Persone che hanno assenze ma non hanno svolto attività progettuali
SELECT Persona.nome, Persona.cognomeFROM PersonaWHERE id IN (    SELECT persona    FROM Assenza) AND id NOT IN (    SELECT DISTINCT persona    FROM AttivitaProgetto);____