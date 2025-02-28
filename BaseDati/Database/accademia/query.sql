-- QUERY 1
SELECT p.nome, p.cognome, p.stipendio
FROM Persona p
WHERE p.stipendio <= 40000;

-- QUERY 2
SELECT P.id, P.nome, P.cognome, P.stipendio, P.posizione
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
WHERE P.stipendio <= 40000
AND P.posizione = 'Ricercatore';


-- QUERY 3
SELECT SUM(pr.budget) AS budget_totale
FROM Progetto pr;

-- QUERY 4
SELECT P.nome, P.cognome, SUM(Pr.budget) AS budget_totale
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
JOIN Progetto Pr ON AP.progetto = Pr.id
GROUP BY P.nome, P.cognome;

-- QUERY 5
SELECT P.nome, P.cognome, COUNT(AP.progetto) AS numero_progetti
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
WHERE P.posizione = 'Professore Ordinario'
GROUP BY P.nome, P.cognome;


-- QUERY 6

SELECT P.nome, P.cognome, COUNT(A.id) AS numero_assenze
FROM Persona P
JOIN Assenza A ON P.id = A.persona
WHERE P.posizione = 'Professore Associato'
AND A.tipo = 'Malattia'
GROUP BY P.nome, P.cognome;



-- QUERY 7

SELECT P.nome, P.cognome, SUM(AP.oreDurata) AS ore_totali
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
WHERE AP.progetto = 5
GROUP BY P.nome, P.cognome;



--QUERY 8

SELECT P.nome, P.cognome, AVG(AP.oreDurata) AS ore_medie
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
GROUP BY P.nome, P.cognome;



--QUERY 9

SELECT P.nome, P.cognome, SUM(ANP.oreDurata) AS ore_totali
FROM Persona P
JOIN AttivitaNonProgettuale ANP ON P.id = ANP.persona
WHERE ANP.tipo = 'Didattica'
GROUP BY P.nome, P.cognome;




--QUERY 10 

SELECT P.nome, P.cognome, SUM(AP.oreDurata) AS ore_totali
FROM Persona P
JOIN AttivitaProgetto AP ON P.id = AP.persona
WHERE AP.progetto = 3 AND AP.wp = 5
GROUP BY P.nome, P.cognome;





