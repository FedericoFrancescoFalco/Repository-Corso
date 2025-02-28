Ecco le query SQL riscritte in modo più semplice, utilizzando costrutti basilari per una migliore leggibilità.

---

### 1. Voli di durata maggiore della durata media di tutti i voli della stessa compagnia
```sql
SELECT DISTINCT V.codice, V.comp, V.durataMinuti
FROM Volo AS V
WHERE V.durataMinuti > (
    SELECT AVG(V1.durataMinuti)
    FROM Volo AS V1
    WHERE V1.comp = V.comp
);
```

---

### 2. Città con più di un aeroporto e almeno un volo operato da “Apitalia”
```sql
SELECT DISTINCT L.citta
FROM LuogoAeroporto AS L
JOIN Aeroporto AS A ON L.aeroporto = A.codice
WHERE (SELECT COUNT(*) 
       FROM Aeroporto AS A1 
       WHERE A1.codice = L.aeroporto) > 1
  AND EXISTS (
      SELECT 1
      FROM ArrPart AS AP
      WHERE AP.arrivo = A.codice AND AP.comp = 'Apitalia'
  );
```

---

### 3. Coppie di aeroporti (A, B) con lo stesso numero di voli in entrambe le direzioni
```sql
SELECT DISTINCT A1.partenza AS A, A1.arrivo AS B
FROM ArrPart AS A1
WHERE (SELECT COUNT(*) 
       FROM ArrPart AS A2 
       WHERE A2.partenza = A1.arrivo AND A2.arrivo = A1.partenza) = 
      (SELECT COUNT(*) 
       FROM ArrPart AS A3 
       WHERE A3.partenza = A1.partenza AND A3.arrivo = A1.arrivo);
```

---

### 4. Compagnie con durata media superiore alla media di tutte le compagnie
```sql
SELECT DISTINCT V.comp
FROM Volo AS V
WHERE (SELECT AVG(V.durataMinuti) 
       FROM Volo AS V1 
       WHERE V1.comp = V.comp) > 
      (SELECT AVG(V2.durataMinuti) 
       FROM Volo AS V2);
```

---

### 5. Aeroporti con voli verso almeno 2 nazioni diverse
```sql
SELECT DISTINCT A.codice
FROM Aeroporto AS A
JOIN ArrPart AS AP ON A.codice = AP.partenza
JOIN LuogoAeroporto AS L ON AP.arrivo = L.aeroporto
WHERE (SELECT COUNT(DISTINCT L.nazione)
       FROM ArrPart AS AP1
       JOIN LuogoAeroporto AS L1 ON AP1.arrivo = L1.aeroporto
       WHERE AP1.partenza = A.codice) >= 2;
```

---

### 6. Voli da città con un unico aeroporto
```sql
SELECT DISTINCT V.codice, V.comp, AP.partenza, AP.arrivo
FROM Volo AS V
JOIN ArrPart AS AP ON V.codice = AP.codice AND V.comp = AP.comp
WHERE EXISTS (
    SELECT 1
    FROM LuogoAeroporto AS L
    WHERE L.aeroporto = AP.partenza
    GROUP BY L.citta
    HAVING COUNT(*) = 1
);
```

---

### 7. Aeroporti raggiungibili da “JFK” con voli diretti e indiretti
```sql
WITH Raggiungibili AS (
    SELECT DISTINCT AP.arrivo

```sql
    FROM ArrPart AS AP
    WHERE AP.partenza = 'JFK'
    UNION
    SELECT DISTINCT AP2.arrivo
    FROM ArrPart AS AP1
    JOIN ArrPart AS AP2 ON AP1.arrivo = AP2.partenza
    WHERE AP1.partenza = 'JFK'
)
SELECT DISTINCT R.arrivo
FROM Raggiungibili AS R;
```

---

### 8. Città raggiungibili da Roma con voli diretti e indiretti
```sql
SELECT DISTINCT L.citta
FROM ArrPart AS AP
JOIN LuogoAeroporto AS L ON AP.arrivo = L.aeroporto
WHERE AP.partenza IN (
    SELECT A.codice
    FROM LuogoAeroporto AS LA
    JOIN Aeroporto AS A ON LA.aeroporto = A.codice
    WHERE LA.citta = 'Roma'
)
UNION
SELECT DISTINCT L2.citta
FROM ArrPart AS AP1
JOIN ArrPart AS AP2 ON AP1.arrivo = AP2.partenza
JOIN LuogoAeroporto AS L2 ON AP2.arrivo = L2.aeroporto
WHERE AP1.partenza IN (
    SELECT A1.codice
    FROM LuogoAeroporto AS LA1
    JOIN Aeroporto AS A1 ON LA1.aeroporto = A1.codice
    WHERE LA1.citta = 'Roma'
);
```

---

### 9. Città raggiungibili con esattamente uno scalo da “JFK”
```sql
SELECT DISTINCT L.citta
FROM ArrPart AS AP1
JOIN ArrPart AS AP2 ON AP1.arrivo = AP2.partenza
JOIN LuogoAeroporto AS L ON AP2.arrivo = L.aeroporto
WHERE AP1.partenza = 'JFK' AND AP1.arrivo <> AP2.arrivo AND AP1.partenza <> AP2.arrivo;
```

---

Queste query sono state semplificate utilizzando costrutti diretti, unendo approcci basilari come `JOIN`, subquery e l'operatore `EXISTS` per garantire la chiarezza del codice.