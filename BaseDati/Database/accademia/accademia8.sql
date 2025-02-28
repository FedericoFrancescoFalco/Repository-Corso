-- 1. Quali sono le persone (id, nome e cognome) che hanno avuto assenze solo nei
-- giorni in cui non avevano alcuna attivitÃ (progettuali o non progettuali)?
SELECT DISTINCT p.id, p.nome, p.cognome
FROM Persona p
WHERE p.id NOT IN (
    SELECT ap.persona
    FROM AttivitaProgetto ap
    );
    AND p.id NOT IN (
    SELECT anp.persona
    FROM AttivitaNonProgettuale anp
    );
    AND p.id IN (
        SELECT a.persona
        FROM Assenza a
    );

-- 2. Quali sono le persone (id, nome e cognome) che non hanno mai partecipato ad
-- alcun progetto durante la durata del progetto “Pegasus”?
SELECT p.id, p.nome, p.cognome
FROM Persona p
WHERE p.id NOT IN (
    SELECT ap.persona
    FROM AttivitaProgetto ap
    WHERE ap.progetto IN (
        SELECT id
        FROM WP
        WHERE nome = 'Pegasus'
        )
);

-- 3. Quali sono id, nome, cognome e stipendio dei ricercatori con stipendio maggiore
-- di tutti i professori (associati e ordinari)?
SELECT p.id, p.nome, p.cognome, p.stipendio
FROM Persona p
WHERE p.id IN (
    SELECT id
    FROM Persona
    WHERE posizione = 'Ricercatore'
) AND p.stipendio > (
    SELECT MAX(stipendio)
    FROM Persona
    WHERE posizione = 'Professore Associato' OR posizione = 'Professore Ordinario'
);

-- 4. Quali sono le persone che hanno lavorato su progetti con un budget superiore alla
-- media dei budget di tutti i progetti?
SELECT DISTINCT p.id, p.nome, p.cognome
FROM Persona p, AttivitaProgetto ap, WP w, Progetto pr
WHERE p.id = ap.persona 
AND ap.progetto = w.id 
AND w.progetto = pr.id
AND pr.budget > (
    SELECT AVG(budget)
    FROM Progetto
);

-- 5. Quali sono i progetti con un budget inferiore allala media, ma con un numero
-- complessivo di ore dedicate alle attività di ricerca sopra la media?
SELECT DISTINCT pr.id, pr.nome
FROM Progetto pr, WP w, AttivitaProgetto ap
WHERE pr.id = w.progetto
AND w.id = ap.wp
WHERE pr.budget < (
    SELECT AVG(budget)
    FROM Progetto
    ) AND ap.oreDurata > (
        SELECT AVG(oreDurata)
        FROM AttivitaProgetto ap
        WHERE ap.tipo = 'Ricerca e Sviluppo'
);