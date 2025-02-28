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
GROUP BY comp;

16. Quali sono le città (senza duplicati) che hanno almeno un aeroporto?

sql

SELECT DISTINCT citta 
FROM luogoaeroporto;

17. Quali sono le compagnie che hanno voli che partono e arrivano nella stessa città?

sql

SELECT DISTINCT comp 
FROM arrpart ap 
JOIN luogoaeroporto l1 ON ap.partenza = l1.aeroporto 
JOIN luogoaeroporto l2 ON ap.arrivo = l2.aeroporto 
WHERE l1.citta = l2.citta;

18. Quali sono i voli con il codice e il nome della compagnia che partono da 'Roma' e atterrano in un aeroporto diverso da 'New York'?

sql

SELECT codice, comp 
FROM arrpart 
WHERE partenza IN (SELECT aeroporto FROM luogoaeroporto WHERE citta = 'Roma') 
    AND arrivo NOT IN (SELECT aeroporto FROM luogoaeroporto WHERE citta = 'New York');

19. Quali sono gli aeroporti (codice e nome) dove arriva almeno un volo della compagnia 'Apitalia'?

sql

SELECT DISTINCT aero.codice, aero.nome 
FROM aeroporto aero 
JOIN arrpart arr ON aero.codice = arr.arrivo 
WHERE arr.comp = 'Apitalia';

20. Quali sono le compagnie che operano in almeno 3 aeroporti diversi?

sql

SELECT comp 
FROM arrpart 
GROUP BY comp 
HAVING COUNT(DISTINCT partenza) >= 3;

21. Quali sono i voli (codice e nome della compagnia) che arrivano all’aeroporto 'JFK' e durano più di 4 ore?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
WHERE arrpart.arrivo = 'JFK' AND volo.durataMinuti > 240;

22. Quali sono le città che hanno voli che partono dall’aeroporto 'FCO'?

sql

SELECT DISTINCT luogo.citta 
FROM luogoaeroporto luogo 
JOIN arrpart ON luogo.aeroporto = arrpart.partenza 
WHERE arrpart.partenza = 'FCO';

23. Quali sono le compagnie fondate prima dell'anno 2000 che operano voli di durata superiore a 3 ore?

sql

SELECT DISTINCT compagnia.nome 
FROM compagnia 
JOIN volo ON compagnia.nome = volo.comp 
WHERE compagnia.annoFondaz < 2000 AND volo.durataMinuti > 180;

24. Quali sono i voli (codice e compagnia) che partono dall’aeroporto 'FCO' e arrivano in un aeroporto situato in Italia?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto 
WHERE arrpart.partenza = 'FCO' AND luogoaeroporto.nazione = 'Italia';

25. Quali sono i voli (codice e compagnia) che partono e arrivano nella stessa nazione?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.nazione = arrivo.nazione;

26. Quali sono le compagnie che non hanno voli in partenza dall’aeroporto 'CIA'?

sql

SELECT compagnia.nome 
FROM compagnia 
WHERE compagnia.nome NOT IN (SELECT comp FROM arrpart WHERE partenza = 'CIA');

27. Quali sono gli aeroporti (codice e nome) che non hanno voli in arrivo?

sql

SELECT aeroporto.codice, aeroporto.nome 
FROM aeroporto 
WHERE aeroporto.codice NOT IN (SELECT arrivo FROM arrpart);

28. Quali sono le compagnie che hanno voli tra aeroporti in città diverse?

sql

SELECT DISTINCT arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.citta <> arrivo.citta;

29. Qual è il numero di voli per ogni coppia di città (partenza e arrivo)?

sql

SELECT partenza.citta AS citta_partenza, arrivo.citta AS citta_arrivo, COUNT(*) AS numero_voli 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
GROUP BY partenza.citta, arrivo.citta;

30. Quali sono i voli (codice, compagnia) con una durata superiore alla media di tutti i voli?

sql

SELECT codice, comp 
FROM volo 
WHERE durataMinuti > (SELECT AVG(durataMinuti) FROM volo);

31. Quali sono i voli (codice e nome della compagnia) che partono da aeroporti situati nella stessa nazione della compagnia aerea?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto luogo ON arrpart.partenza = luogo.aeroporto 
JOIN compagnia ON arrpart.comp = compagnia.nome 
WHERE luogo.nazione = 'Italia' AND compagnia.nome = arrpart.comp;

32. Quali sono le compagnie che hanno voli con destinazioni in almeno due nazioni diverse?

sql

SELECT comp 
FROM arrpart 
JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto 
GROUP BY comp 
HAVING COUNT(DISTINCT luogoaeroporto.nazione) >= 2;

33. Qual è la durata media dei voli per ciascuna compagnia?

sql

SELECT comp, AVG(durataMinuti) AS durata_media 
FROM volo 
GROUP BY comp;

34. Quali sono le compagnie che hanno voli con arrivo o partenza da aeroporti situati nella stessa città?

sql

SELECT DISTINCT comp 
FROM arrpart 
JOIN luogoaeroporto luogo1 ON arrpart.partenza = luogo1.aeroporto 
JOIN luogoaeroporto luogo2 ON arrpart.arrivo = luogo2.aeroporto 
WHERE luogo1.citta = luogo2.citta;

35. Quali sono le città che hanno voli diretti verso aeroporti situati in nazioni diverse?

sql

SELECT DISTINCT partenza.citta 
FROM luogoaeroporto partenza 
JOIN arrpart ON partenza.aeroporto = arrpart.partenza 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.nazione <> arrivo.nazione;

36. Quali sono i voli che partono da aeroporti situati nella stessa città in cui ha sede la compagnia?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto luogo ON arrpart.partenza = luogo.aeroporto 
JOIN compagnia ON arrpart.comp = compagnia.nome 
WHERE luogo.citta = compagnia.nome;

37. Qual è il numero di voli operati da ciascuna compagnia verso ciascuna città di arrivo?

sql

SELECT arrpart.comp, arrivo.citta AS citta_arrivo, COUNT(*) AS numero_voli 
FROM arrpart 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
GROUP BY arrpart.comp, arrivo.citta;

38. Quali sono le compagnie che hanno voli con arrivo in almeno tre diverse città?

sql

SELECT comp 
FROM arrpart 
JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto 
GROUP BY comp 
HAVING COUNT(DISTINCT luogoaeroporto.citta) >= 3;

39. Quali sono i voli che partono da una città diversa rispetto alla città di sede della compagnia aerea?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto luogo ON arrpart.partenza = luogo.aeroporto 
JOIN compagnia ON arrpart.comp = compagnia.nome 
WHERE luogo.citta <> compagnia.nome;

40. Quali sono le nazioni che hanno voli diretti da una città italiana a una città non italiana?

sql

SELECT DISTINCT arrivo.nazione 
FROM luogoaeroporto partenza 
JOIN arrpart ON partenza.aeroporto = arrpart.partenza 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.nazione = 'Italia' AND arrivo.nazione <> 'Italia';

41. Quali sono le città che hanno almeno due aeroporti?

sql

SELECT citta 
FROM luogoaeroporto 
GROUP BY citta 
HAVING COUNT(aeroporto) >= 2;

42. Quali sono le compagnie che operano voli tra aeroporti in nazioni diverse e sono state fondate prima del 1990?

sql

SELECT DISTINCT arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
JOIN compagnia ON arrpart.comp = compagnia.nome 
WHERE partenza.nazione <> arrivo.nazione AND compagnia.annoFondaz < 1990;

43. Quali sono i voli (codice e compagnia) che atterrano in aeroporti situati in nazioni confinanti con l'Italia?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE arrivo.nazione IN ('Francia', 'Svizzera', 'Austria', 'Slovenia');

44. Qual è la durata massima dei voli per ciascun aeroporto di partenza?

sql

SELECT arrpart.partenza AS aeroporto_partenza, MAX(volo.durataMinuti) AS durata_massima 
FROM arrpart 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
GROUP BY arrpart.partenza;

45. Quali sono le compagnie che non hanno voli in arrivo in aeroporti italiani?

sql

SELECT compagnia.nome 
FROM compagnia 
WHERE compagnia.nome NOT IN (
    SELECT arrpart.comp 
    FROM arrpart 
    JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto 
    WHERE luogoaeroporto.nazione = 'Italia'
);

46. Quali sono gli aeroporti (codice e nome) in cui partono voli di durata inferiore alla media?

sql

SELECT DISTINCT aeroporto.codice, aeroporto.nome 
FROM aeroporto 
JOIN arrpart ON aeroporto.codice = arrpart.partenza 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
WHERE volo.durataMinuti < (SELECT AVG(durataMinuti) FROM volo);

47. Quali sono le nazioni che non hanno voli in partenza da nessun aeroporto del proprio territorio?

sql

SELECT DISTINCT luogoaeroporto.nazione 
FROM luogoaeroporto 
WHERE luogoaeroporto.nazione NOT IN (
    SELECT partenza.nazione 
    FROM arrpart 
    JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
);

48. Qual è la media della durata dei voli per ogni coppia di città di partenza e arrivo?

sql

SELECT partenza.citta AS citta_partenza, arrivo.citta AS citta_arrivo, AVG(volo.durataMinuti) AS durata_media 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
GROUP BY partenza.citta, arrivo.citta;

49. Quali sono i voli (codice, compagnia) che hanno lo stesso aeroporto di partenza e arrivo?

sql

SELECT codice, comp 
FROM arrpart 
WHERE partenza = arrivo;

50. Quali sono le compagnie che hanno voli internazionali e nazionali (dove la nazione di partenza è uguale a quella di arrivo)?

sql

SELECT DISTINCT arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
GROUP BY arrpart.comp 
HAVING SUM(CASE WHEN partenza.nazione <> arrivo.nazione THEN 1 ELSE 0 END) > 0 
   AND SUM(CASE WHEN partenza.nazione = arrivo.nazione THEN 1 ELSE 0 END) > 0;

51. Qual è il numero totale di voli per ciascuna nazione di partenza?

sql

SELECT partenza.nazione, COUNT(*) AS numero_voli 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
GROUP BY partenza.nazione;

52. Quali sono i voli (codice e compagnia) che durano tra 2 e 5 ore e collegano due città diverse?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE volo.durataMinuti BETWEEN 120 AND 300 AND partenza.citta <> arrivo.citta;

53. Quali sono le compagnie che operano esclusivamente voli nazionali (nessun volo internazionale)?

sql

SELECT compagnia.nome 
FROM compagnia 
WHERE compagnia.nome NOT IN (
    SELECT arrpart.comp 
    FROM arrpart 
    JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
    JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
    WHERE partenza.nazione <> arrivo.nazione
);

54. Qual è la durata media dei voli in arrivo per ogni aeroporto?

sql

SELECT arrpart.arrivo AS aeroporto_arrivo, AVG(volo.durataMinuti) AS durata_media 
FROM arrpart 
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp 
GROUP BY arrpart.arrivo;

55. Quali sono i voli che partono da un aeroporto di una città e atterrano in un aeroporto della stessa città?

sql

SELECT arrpart.codice, arrpart.comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.citta = arrivo.citta;

56. Quali sono le compagnie con almeno due voli internazionali che collegano la stessa coppia di città?

sql

SELECT comp 
FROM arrpart 
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto 
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto 
WHERE partenza.nazione <> arrivo.nazione 
GROUP BY comp, partenza.citta, arrivo.citta 
HAVING COUNT(*) >= 2;

57. Qual è il numero medio di voli giornalieri per ogni compagnia (ipotizzando che ogni volo sia operato una volta al giorno)?

sql

SELECT comp, COUNT(*) / 365 AS media_voli_giornalieri 
FROM volo 
GROUP BY comp;

58. Quali sono le coppie di aeroporti che non hanno alcun volo diretto tra di loro?

sql

SELECT a1.codice AS aeroporto1, a2.codice AS aeroporto2 
FROM aeroporto a1 
JOIN aeroporto a2 ON a1.codice <> a2.codice 
WHERE (a1.codice, a2.codice) NOT IN (
    SELECT partenza, arrivo 
    FROM arrpart
);

59. Quali sono i voli che durano più della durata media dei voli della stessa compagnia?

sql

SELECT volo.codice, volo.comp 
FROM volo 
JOIN (
    SELECT comp, AVG(durataMinuti) AS media_durata 
    FROM volo 
    GROUP BY comp
) AS durata_media_comp ON volo.comp = durata_media_comp.comp 
WHERE volo.durataMinuti > durata_media_comp.media_durata;

60. Quali sono le compagnie che hanno voli che collegano tre o più città diverse?

sql

SELECT comp 
FROM arrpart 
JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto 
GROUP BY comp 
HAVING COUNT(DISTINCT luogoaeroporto.citta) >= 3;


61. Qual è la distanza totale percorsa da ciascun volo, considerando la distanza tra ogni aeroporto di partenza e di arrivo (inserendo una tabella DistanzaAeroporto con aeroporto_partenza, aeroporto_arrivo, distanza_km)?

sql

SELECT volo.codice, volo.comp, SUM(distanza.distanza_km) AS distanza_totale
FROM volo
JOIN arrpart ON volo.codice = arrpart.codice AND volo.comp = arrpart.comp
JOIN DistanzaAeroporto distanza ON arrpart.partenza = distanza.aeroporto_partenza AND arrpart.arrivo = distanza.aeroporto_arrivo
GROUP BY volo.codice, volo.comp;

62. Elenca gli aeroporti che hanno voli internazionali in arrivo ma nessuno in partenza.

sql

SELECT DISTINCT arrivo.aeroporto
FROM luogoaeroporto arrivo
JOIN arrpart ON arrivo.aeroporto = arrpart.arrivo
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
WHERE arrivo.nazione <> partenza.nazione
  AND arrivo.aeroporto NOT IN (SELECT partenza FROM arrpart);

63. Trova i voli che partono dall'Italia e arrivano in nazioni con meno di 5 aeroporti.

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione = 'Italia'
  AND arrivo.nazione IN (
    SELECT nazione FROM luogoaeroporto GROUP BY nazione HAVING COUNT(aeroporto) < 5
  );

64. Quali sono le coppie di compagnie che condividono almeno un volo con lo stesso aeroporto di partenza e arrivo?

sql

SELECT a.comp AS compagnia1, b.comp AS compagnia2, a.partenza, a.arrivo
FROM arrpart a
JOIN arrpart b ON a.partenza = b.partenza AND a.arrivo = b.arrivo AND a.comp < b.comp
GROUP BY a.comp, b.comp, a.partenza, a.arrivo;

65. Qual è l’aeroporto con il maggior numero di voli in arrivo e in partenza?

sql

SELECT aeroporto, SUM(arrivi + partenze) AS totale_voli
FROM (
    SELECT arrivo AS aeroporto, COUNT(*) AS arrivi, 0 AS partenze FROM arrpart GROUP BY arrivo
    UNION ALL
    SELECT partenza AS aeroporto, 0 AS arrivi, COUNT(*) AS partenze FROM arrpart GROUP BY partenza
) AS voli
GROUP BY aeroporto
ORDER BY totale_voli DESC
LIMIT 1;

66. Trova le compagnie che operano voli solo in specifiche nazioni (ad esempio, solo in Italia e Francia).

sql

SELECT comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
GROUP BY comp
HAVING COUNT(DISTINCT partenza.nazione) = 2 AND COUNT(DISTINCT arrivo.nazione) = 2
       AND 'Italia' IN (SELECT DISTINCT nazione FROM luogoaeroporto WHERE aeroporto IN (arrpart.partenza, arrpart.arrivo))
       AND 'Francia' IN (SELECT DISTINCT nazione FROM luogoaeroporto WHERE aeroporto IN (arrpart.partenza, arrpart.arrivo));

67. Qual è l’orario medio (durata in minuti) per ogni coppia di aeroporti collegati direttamente?

sql

SELECT arrpart.partenza, arrpart.arrivo, AVG(volo.durataMinuti) AS durata_media
FROM arrpart
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp
GROUP BY arrpart.partenza, arrpart.arrivo;

68. Elenca le compagnie che hanno voli con almeno tre scali in aeroporti intermedi prima di raggiungere l'aeroporto di destinazione.

sql

WITH Scali AS (
    SELECT arrpart1.comp, arrpart1.codice AS primo_volo, arrpart2.codice AS secondo_volo, arrpart3.codice AS terzo_volo
    FROM arrpart AS arrpart1
    JOIN arrpart AS arrpart2 ON arrpart1.arrivo = arrpart2.partenza AND arrpart1.comp = arrpart2.comp
    JOIN arrpart AS arrpart3 ON arrpart2.arrivo = arrpart3.partenza AND arrpart2.comp = arrpart3.comp
)
SELECT DISTINCT comp FROM Scali;

69. Trova le città con il maggior numero di compagnie che operano voli in arrivo.

sql

SELECT arrivo.citta, COUNT(DISTINCT arrpart.comp) AS numero_compagnie
FROM arrpart
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
GROUP BY arrivo.citta
ORDER BY numero_compagnie DESC;

70. Quali sono i voli (codice, compagnia) che partono e arrivano in città con lo stesso nome ma in nazioni diverse?

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.citta = arrivo.citta AND partenza.nazione <> arrivo.nazione;

61. Qual è la distanza totale percorsa da ciascun volo, considerando la distanza tra ogni aeroporto di partenza e di arrivo (inserendo una tabella DistanzaAeroporto con aeroporto_partenza, aeroporto_arrivo, distanza_km)?

sql

SELECT volo.codice, volo.comp, SUM(distanza.distanza_km) AS distanza_totale
FROM volo
JOIN arrpart ON volo.codice = arrpart.codice AND volo.comp = arrpart.comp
JOIN DistanzaAeroporto distanza ON arrpart.partenza = distanza.aeroporto_partenza AND arrpart.arrivo = distanza.aeroporto_arrivo
GROUP BY volo.codice, volo.comp;

62. Elenca gli aeroporti che hanno voli internazionali in arrivo ma nessuno in partenza.

sql

SELECT DISTINCT arrivo.aeroporto
FROM luogoaeroporto arrivo
JOIN arrpart ON arrivo.aeroporto = arrpart.arrivo
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
WHERE arrivo.nazione <> partenza.nazione
  AND arrivo.aeroporto NOT IN (SELECT partenza FROM arrpart);

63. Trova i voli che partono dall'Italia e arrivano in nazioni con meno di 5 aeroporti.

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione = 'Italia'
  AND arrivo.nazione IN (
    SELECT nazione FROM luogoaeroporto GROUP BY nazione HAVING COUNT(aeroporto) < 5
  );

64. Quali sono le coppie di compagnie che condividono almeno un volo con lo stesso aeroporto di partenza e arrivo?

sql

SELECT a.comp AS compagnia1, b.comp AS compagnia2, a.partenza, a.arrivo
FROM arrpart a
JOIN arrpart b ON a.partenza = b.partenza AND a.arrivo = b.arrivo AND a.comp < b.comp
GROUP BY a.comp, b.comp, a.partenza, a.arrivo;

65. Qual è l’aeroporto con il maggior numero di voli in arrivo e in partenza?

sql

SELECT aeroporto, SUM(arrivi + partenze) AS totale_voli
FROM (
    SELECT arrivo AS aeroporto, COUNT(*) AS arrivi, 0 AS partenze FROM arrpart GROUP BY arrivo
    UNION ALL
    SELECT partenza AS aeroporto, 0 AS arrivi, COUNT(*) AS partenze FROM arrpart GROUP BY partenza
) AS voli
GROUP BY aeroporto
ORDER BY totale_voli DESC
LIMIT 1;

66. Trova le compagnie che operano voli solo in specifiche nazioni (ad esempio, solo in Italia e Francia).

sql

SELECT comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
GROUP BY comp
HAVING COUNT(DISTINCT partenza.nazione) = 2 AND COUNT(DISTINCT arrivo.nazione) = 2
       AND 'Italia' IN (SELECT DISTINCT nazione FROM luogoaeroporto WHERE aeroporto IN (arrpart.partenza, arrpart.arrivo))
       AND 'Francia' IN (SELECT DISTINCT nazione FROM luogoaeroporto WHERE aeroporto IN (arrpart.partenza, arrpart.arrivo));

67. Qual è l’orario medio (durata in minuti) per ogni coppia di aeroporti collegati direttamente?

sql

SELECT arrpart.partenza, arrpart.arrivo, AVG(volo.durataMinuti) AS durata_media
FROM arrpart
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp
GROUP BY arrpart.partenza, arrpart.arrivo;

68. Elenca le compagnie che hanno voli con almeno tre scali in aeroporti intermedi prima di raggiungere l'aeroporto di destinazione.

sql

WITH Scali AS (
    SELECT arrpart1.comp, arrpart1.codice AS primo_volo, arrpart2.codice AS secondo_volo, arrpart3.codice AS terzo_volo
    FROM arrpart AS arrpart1
    JOIN arrpart AS arrpart2 ON arrpart1.arrivo = arrpart2.partenza AND arrpart1.comp = arrpart2.comp
    JOIN arrpart AS arrpart3 ON arrpart2.arrivo = arrpart3.partenza AND arrpart2.comp = arrpart3.comp
)
SELECT DISTINCT comp FROM Scali;

69. Trova le città con il maggior numero di compagnie che operano voli in arrivo.

sql

SELECT arrivo.citta, COUNT(DISTINCT arrpart.comp) AS numero_compagnie
FROM arrpart
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
GROUP BY arrivo.citta
ORDER BY numero_compagnie DESC;

70. Quali sono i voli (codice, compagnia) che partono e arrivano in città con lo stesso nome ma in nazioni diverse?

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.citta = arrivo.citta AND partenza.nazione <> arrivo.nazione;

Hai detto:
altre 
ChatGPT ha detto:
ChatGPT

Ecco altre query avanzate e variegate:

71. Quali compagnie hanno voli con la durata maggiore rispetto a tutti i voli di altre compagnie?

sql

SELECT volo.comp
FROM volo
WHERE volo.durataMinuti = (SELECT MAX(durataMinuti) FROM volo);

72. Trova i voli che partono e arrivano in aeroporti appartenenti allo stesso fuso orario.
(Immaginando di avere una tabella FusoOrario con aeroporto e fuso per ogni aeroporto)

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN FusoOrario partenza ON arrpart.partenza = partenza.aeroporto
JOIN FusoOrario arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.fuso = arrivo.fuso;

73. Elenca le città che sono collegate direttamente tra di loro da voli operati da almeno due compagnie diverse.

sql

SELECT partenza.citta AS citta_partenza, arrivo.citta AS citta_arrivo
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
GROUP BY partenza.citta, arrivo.citta
HAVING COUNT(DISTINCT arrpart.comp) >= 2;

74. Trova il numero totale di voli internazionali per ogni compagnia.

sql

SELECT arrpart.comp, COUNT(*) AS voli_internazionali
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione <> arrivo.nazione
GROUP BY arrpart.comp;

75. Quali sono i voli (codice, compagnia) che fanno scalo in aeroporti in almeno due nazioni diverse?

sql

WITH Scali AS (
    SELECT arrpart1.comp, arrpart1.codice AS primo_volo, partenza.nazione AS nazione_partenza, scalo.nazione AS nazione_scalo
    FROM arrpart AS arrpart1
    JOIN arrpart AS arrpart2 ON arrpart1.arrivo = arrpart2.partenza AND arrpart1.comp = arrpart2.comp
    JOIN luogoaeroporto partenza ON arrpart1.partenza = partenza.aeroporto
    JOIN luogoaeroporto scalo ON arrpart1.arrivo = scalo.aeroporto
)
SELECT DISTINCT primo_volo, comp
FROM Scali
WHERE nazione_partenza <> nazione_scalo;

76. Quali compagnie hanno voli che partono dall'Italia e hanno scali in aeroporti in almeno tre nazioni diverse prima di arrivare a destinazione?

sql

WITH Scali AS (
    SELECT arrpart1.comp, arrpart1.partenza, COUNT(DISTINCT scalo.nazione) AS nazioni_scalo
    FROM arrpart AS arrpart1
    JOIN arrpart AS arrpart2 ON arrpart1.arrivo = arrpart2.partenza AND arrpart1.comp = arrpart2.comp
    JOIN luogoaeroporto partenza ON arrpart1.partenza = partenza.aeroporto
    JOIN luogoaeroporto scalo ON arrpart1.arrivo = scalo.aeroporto
    WHERE partenza.nazione = 'Italia'
    GROUP BY arrpart1.comp, arrpart1.partenza
)
SELECT DISTINCT comp
FROM Scali
WHERE nazioni_scalo >= 3;

77. Trova le compagnie che non operano voli in aeroporti situati in città capitali.
(Immaginando di avere una tabella Capitale con citta e nazione per ogni capitale)

sql

SELECT comp
FROM compagnia
WHERE nome NOT IN (
    SELECT arrpart.comp
    FROM arrpart
    JOIN luogoaeroporto ON arrpart.arrivo = luogoaeroporto.aeroporto
    JOIN Capitale ON luogoaeroporto.citta = Capitale.citta AND luogoaeroporto.nazione = Capitale.nazione
);

78. Quali aeroporti hanno voli che arrivano da almeno cinque città diverse?

sql

SELECT arrpart.arrivo AS aeroporto, COUNT(DISTINCT partenza.citta) AS numero_citta
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
GROUP BY arrpart.arrivo
HAVING COUNT(DISTINCT partenza.citta) >= 5;

79. Elenca le compcagnie che non hanno voli che arrivano o partono dagli aeroporti delle principali città turistiche.
(Immaginando una tabella Turistica con aeroporto per le città turistiche)

sql

SELECT nome 
FROM compagnia 
WHERE nome NOT IN (
    SELECT comp 
    FROM arrpart 
    WHERE partenza IN (SELECT aeroporto FROM Turistica) OR arrivo IN (SELECT aeroporto FROM Turistica)
);

80. Trova i voli (codice, compagnia) che collegano direttamente due città con lo stesso nome (ad es. Parigi in Francia e Parigi in Texas).

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.citta = arrivo.citta AND partenza.nazione <> arrivo.nazione;

81. Elenca le compagnie aeree che operano voli solo nazionali (partenza e arrivo nella stessa nazione).

sql

SELECT DISTINCT arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione = arrivo.nazione
GROUP BY arrpart.comp
HAVING COUNT(DISTINCT partenza.nazione) = 1;

82. Trova i voli che partono da un aeroporto situato in una capitale e atterrano in un aeroporto non situato in una capitale.

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN Capitale cap ON partenza.citta = cap.citta AND partenza.nazione = cap.nazione
WHERE arrpart.arrivo NOT IN (
    SELECT aeroporto FROM Capitale
);

83. Quali sono le compagnie che operano voli con scali in aeroporti che hanno lo stesso nome della compagnia?

sql

SELECT DISTINCT arrpart.comp
FROM arrpart
JOIN luogoaeroporto scalo ON arrpart.arrivo = scalo.aeroporto
WHERE scalo.citta = arrpart.comp;

84. Trova il numero di voli internazionali per ogni aeroporto di partenza.

sql

SELECT partenza.aeroporto, COUNT(*) AS voli_internazionali
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione <> arrivo.nazione
GROUP BY partenza.aeroporto;

85. Quali sono i voli che partono dall'aeroporto 'FCO' e hanno una durata superiore alla media di tutti i voli?

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp
WHERE arrpart.partenza = 'FCO' AND volo.durataMinuti > (SELECT AVG(durataMinuti) FROM volo);

86. Elenca gli aeroporti con il maggior numero di voli di ritorno (stessa compagnia, partenza e arrivo invertiti).

sql

SELECT arrpart.partenza AS aeroporto, COUNT(*) AS voli_ritorno
FROM arrpart
JOIN arrpart AS arrpart2 ON arrpart.partenza = arrpart2.arrivo AND arrpart.arrivo = arrpart2.partenza AND arrpart.comp = arrpart2.comp
GROUP BY arrpart.partenza
ORDER BY voli_ritorno DESC;

87. Trova le città con più di un aeroporto e che hanno voli in partenza da ciascun aeroporto.

sql

SELECT luogoaeroporto.citta
FROM luogoaeroporto
JOIN arrpart ON luogoaeroporto.aeroporto = arrpart.partenza
GROUP BY luogoaeroporto.citta
HAVING COUNT(DISTINCT luogoaeroporto.aeroporto) > 1;

88. Quali sono i voli diretti tra due aeroporti che hanno un fuso orario diverso?
(Immaginando di avere una tabella FusoOrario con aeroporto e fuso per ogni aeroporto)

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN FusoOrario partenza ON arrpart.partenza = partenza.aeroporto
JOIN FusoOrario arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.fuso <> arrivo.fuso;

89. Trova i voli che partono da un aeroporto in una città costiera (immaginando una tabella CittàCostiere con città e nazione).

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
WHERE partenza.citta IN (SELECT citta FROM CittàCostiere);

90. Elenca le compagnie che hanno il maggior numero di voli annullati.
(Immaginando di avere un campo stato in arrpart per identificare se un volo è stato annullato)

sql

SELECT arrpart.comp, COUNT(*) AS voli_annullati
FROM arrpart
WHERE stato = 'annullato'
GROUP BY arrpart.comp
ORDER BY voli_annullati DESC;

91. Trova i voli che partono da un aeroporto e atterrano nello stesso aeroporto (voli circolari).

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
WHERE arrpart.partenza = arrpart.arrivo;

92. Quali compagnie hanno voli che partono da un aeroporto situato in una capitale e atterrano in un altro aeroporto situato in una capitale?

sql

SELECT DISTINCT arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione IN (SELECT nazione FROM Capitale) 
  AND arrivo.nazione IN (SELECT nazione FROM Capitale);

93. Trova i voli con la durata più lunga per ogni compagnia.

sql

SELECT comp, MAX(durataMinuti) AS durata_lunga
FROM volo
GROUP BY comp;

94. Quali sono i voli che partono e arrivano nello stesso giorno?
(Immaginando di avere una colonna data in arrpart per il giorno del volo)

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
WHERE data_partenza = data_arrivo;

95. Elenca le compagnie che non hanno voli in partenza dall'aeroporto 'CIA'.

sql

SELECT nome
FROM compagnia
WHERE nome NOT IN (
    SELECT comp
    FROM arrpart
    WHERE partenza = 'CIA'
);

96. Trova gli aeroporti con il maggior numero di voli in partenza.

sql

SELECT partenza.aeroporto, COUNT(*) AS numero_voli
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
GROUP BY partenza.aeroporto
ORDER BY numero_voli DESC;

97. Quali sono le compagnie che operano voli diretti tra aeroporti della stessa nazione?

sql

SELECT DISTINCT arrpart.comp
FROM arrpart
JOIN luogoaeroporto partenza ON arrpart.partenza = partenza.aeroporto
JOIN luogoaeroporto arrivo ON arrpart.arrivo = arrivo.aeroporto
WHERE partenza.nazione = arrivo.nazione;

98. Trova le compagnie che operano voli da più di tre aeroporti diversi.

sql

SELECT comp, COUNT(DISTINCT partenza) AS numero_aeroporti
FROM arrpart
GROUP BY comp
HAVING numero_aeroporti > 3;

99. Quali voli hanno una durata inferiore alla durata media dei voli della stessa compagnia?

sql

SELECT arrpart.codice, arrpart.comp
FROM arrpart
JOIN volo ON arrpart.codice = volo.codice AND arrpart.comp = volo.comp
WHERE volo.durataMinuti < (
    SELECT AVG(durataMinuti)
    FROM volo
    WHERE comp = arrpart.comp
);

100. Trova le città con aeroporti che hanno almeno due compagnie aeree diverse che operano voli.

sql

SELECT luogoaeroporto.citta
FROM luogoaeroporto
JOIN arrpart ON luogoaeroporto.aeroporto = arrpart.partenza
GROUP BY luogoaeroporto.citta
HAVING COUNT(DISTINCT arrpart.comp) >= 2;

Cielo. 


1. Elenco dei voli con la loro durata in minuti e la compagnia aerea associata.
SELECT codice, comp, durataMinuti FROM Volo;

2. Lista di tutti gli aeroporti con i rispettivi codici IATA e nomi.
SELECT codice, nome FROM Aeroporto;

3. Tutte le compagnie aeree con il loro anno di fondazione (anche se NULL).
SELECT nome, annoFondaz FROM Compagnia;

4. Elenco delle città e nazioni dove si trovano gli aeroporti.
SELECT citta, nazione FROM LuogoAeroporto;

5. Elenco delle partenze e arrivi per ciascun volo.
SELECT codice, comp, arrivo, partenza FROM ArrPart;



---
Query con JOIN
6. Elenco dei voli con i nomi degli aeroporti di partenza e arrivo.
SELECT v.codice, v.comp, a1.nome AS aeroporto_partenza, a2.nome AS aeroporto_arrivoFROM ArrPart apJOIN Aeroporto a1 ON ap.partenza = a1.codiceJOIN Aeroporto a2 ON ap.arrivo = a2.codiceJOIN Volo v ON ap.codice = v.codice AND ap.comp = v.comp;

7. Compagnie aeree con i voli che partono da un determinato aeroporto (es. 'FCO').
SELECT c.nome AS compagnia, v.codice AS voloFROM Compagnia cJOIN Volo v ON c.nome = v.compJOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.compWHERE ap.partenza = 'FCO';

8. Dettagli dei voli con la città e la nazione degli aeroporti di partenza.
SELECT v.codice, v.comp, v.durataMinuti, la.citta, la.nazioneFROM Volo vJOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.compJOIN LuogoAeroporto la ON ap.partenza = la.aeroporto;



---
Query con filtri
9. Voli con una durata superiore a 120 minuti.
SELECT codice, comp, durataMinuti FROM Volo WHERE durataMinuti > 120;

10. Aeroporti situati in Italia.
SELECT aeroporto, citta FROM LuogoAeroporto WHERE nazione = 'Italia';

11. Compagnie fondate prima del 2000.
SELECT nome FROM Compagnia WHERE annoFondaz IS NOT NULL AND annoFondaz < 2000;



---
Query con aggregazioni
12. Numero totale di voli per ogni compagnia.
SELECT comp, COUNT(*) AS numero_voli FROM Volo GROUP BY comp;

13. Durata media dei voli per ogni compagnia.
SELECT comp, AVG(durataMinuti) AS durata_media FROM Volo GROUP BY comp;

14. Numero di aeroporti in ogni nazione.
SELECT nazione, COUNT(*) AS numero_aeroporti FROM LuogoAeroporto GROUP BY nazione;

15. Compagnie con il numero massimo di voli.
WITH VoliPerCompagnia AS (    SELECT comp, COUNT(*) AS numero_voli     FROM Volo     GROUP BY comp)SELECT comp FROM VoliPerCompagnia WHERE numero_voli = (SELECT MAX(numero_voli) FROM VoliPerCompagnia);



---
Query con subquery
16. Voli che partono da aeroporti con più di 5 voli totali.
SELECT codice, comp FROM ArrPart apWHERE partenza IN (    SELECT partenza     FROM ArrPart     GROUP BY partenza     HAVING COUNT(*) > 5);

17. Compagnie che operano voli da aeroporti in Italia.
SELECT DISTINCT comp FROM ArrPart apJOIN LuogoAeroporto la ON ap.partenza = la.aeroportoWHERE la.nazione = 'Italia';

18. Elenco di voli che atterrano in aeroporti che non hanno voli in partenza.
SELECT codice, comp FROM ArrPart apWHERE arrivo NOT IN (    SELECT partenza     FROM ArrPart);



---
Query con vincoli e valori NULL
19. Compagnie che non hanno una data di fondazione registrata.
SELECT nome FROM Compagnia WHERE annoFondaz IS NULL;

20. Elenco dei voli che rispettano i vincoli di referential integrity (codice e compagnia presenti in ArrPart).
SELECT v.codice, v.comp FROM Volo vWHERE (v.codice, v.comp) IN (    SELECT codice, comp     FROM ArrPart);

21. Aeroporti che non sono collegati a nessun volo (partenze o arrivi).
SELECT codice, nome FROM Aeroporto aWHERE codice NOT IN (    SELECT arrivo     FROM ArrPart)AND codice NOT IN (    SELECT partenza     FROM ArrPart);



---
Query complesse
22. Trova il volo più lungo per ogni compagnia.
WITH MaxDurata AS (    SELECT comp, MAX(durataMinuti) AS durata_massima     FROM Volo     GROUP BY comp)SELECT v.codice, v.comp, v.durataMinuti FROM Volo vJOIN MaxDurata md ON v.comp = md.comp AND v.durataMinuti = md.durata_massima;

23. Elenco delle nazioni con più di 3 aeroporti internazionali (codice IATA con 3 lettere).
SELECT nazione FROM LuogoAeroporto GROUP BY nazione HAVING COUNT(aeroporto) > 3;

24. Coppie di voli che condividono l'aeroporto di partenza e quello di arrivo.
SELECT a1.codice AS volo1, a2.codice AS volo2, a1.partenza, a1.arrivoFROM ArrPart a1JOIN ArrPart a2 ON a1.partenza = a2.partenza AND a1.arrivo = a2.arrivoWHERE a1.codice <> a2.codice;---
Query di ricerca avanzata
1. Trova i voli che partono da un aeroporto e arrivano nello stesso aeroporto.
SELECT codice, comp, partenza, arrivo FROM ArrPart WHERE partenza = arrivo;

2. Elenco degli aeroporti che servono almeno due compagnie diverse.
SELECT aeroporto FROM LuogoAeroporto laJOIN ArrPart ap ON la.aeroporto = ap.partenza OR la.aeroporto = ap.arrivoGROUP BY aeroporto HAVING COUNT(DISTINCT comp) >= 2;

3. Trova i voli con durata maggiore della media di tutti i voli.
SELECT codice, comp, durataMinuti FROM Volo WHERE durataMinuti > (SELECT AVG(durataMinuti) FROM Volo);



---
Query con UNION e INTERSECT
4. Aeroporti che sono sia di partenza che di arrivo.
SELECT partenza AS aeroporto FROM ArrPart INTERSECTSELECT arrivo AS aeroporto FROM ArrPart;

5. Aeroporti che non sono mai stati usati come partenza o arrivo.
SELECT codice FROM Aeroporto EXCEPT(SELECT partenza FROM ArrPart UNION SELECT arrivo FROM ArrPart);

6. Voli che sono operati sia in partenza che in arrivo dallo stesso aeroporto.
SELECT codice, comp FROM ArrPart WHERE partenza IN (    SELECT arrivo     FROM ArrPart);



---
Query con funzioni stringa
7. Compagnie che contengono la parola 'Air' nel nome.
SELECT nome FROM Compagnia WHERE nome LIKE '%Air%';

8. Aeroporti il cui nome inizia con 'A'.
SELECT nome FROM Aeroporto WHERE nome LIKE 'A%';

9. Elenco delle città con nomi più lunghi di 10 caratteri.
SELECT citta FROM LuogoAeroporto WHERE LENGTH(citta) > 10;



---
Query sui vincoli referenziali
10. Trova aeroporti senza una città associata (che violerebbero il vincolo).
SELECT codice FROM Aeroporto aLEFT JOIN LuogoAeroporto la ON a.codice = la.aeroportoWHERE la.citta IS NULL;

11. Voli che non rispettano i vincoli di riferimento alla tabella ArrPart.
SELECT v.codice, v.comp FROM Volo vWHERE NOT EXISTS (    SELECT 1     FROM ArrPart ap     WHERE v.codice = ap.codice AND v.comp = ap.comp);



---
Query con dati mancanti (NULL)
12. Elenco delle compagnie senza anno di fondazione registrato.
SELECT nome FROM Compagnia WHERE annoFondaz IS NULL;

13. Voli con aeroporti di partenza o arrivo non specificati (NULL).
SELECT codice, comp FROM ArrPart WHERE partenza IS NULL OR arrivo IS NULL;



---
Query gerarchiche e ricorsive
14. Trova aeroporti collegati direttamente o indirettamente tramite voli.
WITH RECURSIVE AeroportiCollegati AS (    SELECT partenza AS aeroporto     FROM ArrPart    UNION    SELECT arrivo     FROM ArrPart)SELECT DISTINCT aeroporto FROM AeroportiCollegati;

15. Trova percorsi di voli che collegano due aeroporti specifici (es. FCO e JFK).
WITH Percorsi AS (    SELECT partenza, arrivo, 1 AS step     FROM ArrPart    WHERE partenza = 'FCO'    UNION ALL    SELECT p.partenza, a.arrivo, p.step + 1     FROM Percorsi p    JOIN ArrPart a ON p.arrivo = a.partenza)SELECT * FROM Percorsi WHERE arrivo = 'JFK';



---
Query con analisi temporali (se applicabile all'anno di fondazione)
16. Compagnie aeree più vecchie di 50 anni.
SELECT nome, annoFondaz FROM Compagnia WHERE annoFondaz IS NOT NULL AND (YEAR(CURRENT_DATE) - annoFondaz) > 50;

17. Trova il volo più lungo registrato nel sistema.
SELECT codice, comp, durataMinuti FROM Volo WHERE durataMinuti = (SELECT MAX(durataMinuti) FROM Volo);

18. Elenco dei voli organizzati da compagnie fondate prima del 1990.
SELECT v.codice, v.comp, v.durataMinuti FROM Volo vJOIN Compagnia c ON v.comp = c.nomeWHERE c.annoFondaz < 1990;



---
Query di ottimizzazione e diagnostica
19. Conta quanti voli non hanno una durata registrata.
SELECT COUNT(*) AS voli_senza_durata FROM Volo WHERE durataMinuti IS NULL;

20. Lista delle rotte con più voli disponibili.
SELECT partenza, arrivo, COUNT(*) AS numero_voli FROM ArrPart GROUP BY partenza, arrivo ORDER BY numero_voli DESC;

21. Elenco di voli duplicati (stesso codice e compagnia).
SELECT codice, comp, COUNT(*) AS duplicati FROM Volo GROUP BY codice, comp HAVING COUNT(*) > 1;



---
Certamente! Ecco un’altra serie di query che esplorano nuovi scenari:

---
Query di aggregazione avanzata
1. Trova la compagnia con il maggior numero di voli registrati.
SELECT comp, COUNT(*) AS numero_voli FROM Volo GROUP BY comp ORDER BY numero_voli DESC LIMIT 1;

2. Trova il totale dei voli per ogni aeroporto (arrivo e partenza combinati).
SELECT aeroporto, COUNT(*) AS totale_voli FROM (    SELECT partenza AS aeroporto FROM ArrPart     UNION ALL     SELECT arrivo AS aeroporto FROM ArrPart) AS unioneGROUP BY aeroportoORDER BY totale_voli DESC;

3. Durata media dei voli per ciascuna compagnia.
SELECT comp, AVG(durataMinuti) AS durata_media FROM Volo GROUP BY comp;



---
Query sui vincoli e integrità referenziale
4. Trova aeroporti che non hanno corrispondenza con la tabella LuogoAeroporto.
SELECT a.codice, a.nome FROM Aeroporto aLEFT JOIN LuogoAeroporto la ON a.codice = la.aeroportoWHERE la.aeroporto IS NULL;

5. Trova rotte definite in ArrPart che non hanno un volo corrispondente in Volo.
SELECT ap.codice, ap.comp FROM ArrPart apLEFT JOIN Volo v ON ap.codice = v.codice AND ap.comp = v.compWHERE v.codice IS NULL;



---
Query su condizioni specifiche
6. Trova i voli che durano meno di 30 minuti.
SELECT codice, comp, durataMinuti FROM Volo WHERE durataMinuti < 30;

7. Trova le rotte tra aeroporti nella stessa città.
SELECT ap.codice, ap.comp, ap.partenza, ap.arrivo FROM ArrPart apJOIN LuogoAeroporto lp1 ON ap.partenza = lp1.aeroportoJOIN LuogoAeroporto lp2 ON ap.arrivo = lp2.aeroportoWHERE lp1.citta = lp2.citta;

8. Trova voli con arrivo e partenza dallo stesso paese.
SELECT ap.codice, ap.comp, ap.partenza, ap.arrivo FROM ArrPart apJOIN LuogoAeroporto lp1 ON ap.partenza = lp1.aeroportoJOIN LuogoAeroporto lp2 ON ap.arrivo = lp2.aeroportoWHERE lp1.nazione = lp2.nazione;



---
Query con funzioni avanzate
9. Trova aeroporti con il nome più lungo.
SELECT nome, LENGTH(nome) AS lunghezza_nome FROM Aeroporto ORDER BY LENGTH(nome) DESC LIMIT 1;

10. Trova la città con più aeroporti registrati.
SELECT citta, COUNT(*) AS numero_aeroporti FROM LuogoAeroporto GROUP BY citta ORDER BY numero_aeroporti DESC LIMIT 1;

11. Trova il volo più breve per ciascuna compagnia.
SELECT comp, MIN(durataMinuti) AS durata_minima FROM Volo GROUP BY comp;



---
Query su dati mancanti o incoerenti
12. Trova rotte con aeroporti non validi (assenza in Aeroporto).
SELECT codice, comp, partenza, arrivo FROM ArrPart apLEFT JOIN Aeroporto a1 ON ap.partenza = a1.codiceLEFT JOIN Aeroporto a2 ON ap.arrivo = a2.codiceWHERE a1.codice IS NULL OR a2.codice IS NULL;

13. Trova compagnie senza alcun volo registrato.
SELECT c.nome FROM Compagnia cLEFT JOIN Volo v ON c.nome = v.compWHERE v.codice IS NULL;

14. Trova aeroporti con codici duplicati nella tabella Aeroporto.
SELECT codice, COUNT(*) AS duplicati FROM Aeroporto GROUP BY codice HAVING COUNT(*) > 1;



---
Query di ottimizzazione
15. Numero totale di voli per ciascun aeroporto di partenza.
SELECT partenza, COUNT(*) AS numero_voli FROM ArrPart GROUP BY partenza ORDER BY numero_voli DESC;

16. Lista degli aeroporti senza voli in partenza.
SELECT codice, nome FROM Aeroporto aLEFT JOIN ArrPart ap ON a.codice = ap.partenzaWHERE ap.partenza IS NULL;



---
Query con ordinamenti particolari
17. Trova i voli con la durata più alta e più bassa.
SELECT * FROM Volo WHERE durataMinuti = (SELECT MAX(durataMinuti) FROM Volo)   OR durataMinuti = (SELECT MIN(durataMinuti) FROM Volo);

18. Trova le compagnie ordinate per numero di voli registrati (in ordine crescente).
SELECT comp, COUNT(*) AS numero_voli FROM Volo GROUP BY comp ORDER BY numero_voli ASC;

19. Elenco delle città ordinate alfabeticamente.
SELECT DISTINCT citta FROM LuogoAeroporto ORDER BY citta ASC;

20. Elenco degli aeroporti, ordinati per nazione e poi per nome.
SELECT aeroporto, citta, nazione FROM LuogoAeroporto ORDER BY nazione, citta;
---
Ecco alcune nuove query che affrontano temi non trattati in precedenza, mantenendo il focus sull'esplorazione e la complessità:

---
Query sui cambiamenti nel database
1. Trova gli aeroporti aggiunti più di recente (ipotizzando una colonna "dataAggiunta").
SELECT codice, nome FROM Aeroporto WHERE dataAggiunta = (SELECT MAX(dataAggiunta) FROM Aeroporto);

2. Trova compagnie aeree che hanno registrato nuovi voli nell'ultimo mese.
SELECT DISTINCT v.comp FROM Volo vWHERE v.dataCreazione >= DATEADD(MONTH, -1, CURRENT_DATE);



---
Query sui pattern geografici
3. Trova nazioni che hanno aeroporti serviti da voli con una durata media superiore a 2 ore.
SELECT la.nazione FROM LuogoAeroporto laJOIN ArrPart ap ON la.aeroporto = ap.partenzaJOIN Volo v ON ap.codice = v.codice AND ap.comp = v.compGROUP BY la.nazioneHAVING AVG(v.durataMinuti) > 120;

4. Trova le città che ospitano aeroporti sia nazionali che internazionali.
SELECT citta FROM LuogoAeroporto GROUP BY citta HAVING COUNT(DISTINCT nazione) > 1;



---
Query con analisi dei percorsi
5. Trova i voli che effettuano collegamenti diretti tra due determinati aeroporti (es. "FCO" e "LHR").
SELECT codice, comp FROM ArrPart WHERE (partenza = 'FCO' AND arrivo = 'LHR')    OR (partenza = 'LHR' AND arrivo = 'FCO');

6. Trova voli che passano da un aeroporto intermedio tra due aeroporti specifici (es. "FCO" e "JFK").
WITH Collegamenti AS (    SELECT partenza, arrivo     FROM ArrPart)SELECT c1.partenza, c1.arrivo AS scalo, c2.arrivo FROM Collegamenti c1JOIN Collegamenti c2 ON c1.arrivo = c2.partenzaWHERE c1.partenza = 'FCO' AND c2.arrivo = 'JFK';



---
Query sui costi e ricavi (ipotizzando campi relativi)
7. Trova la compagnia con il ricavo totale maggiore (es. "prezzoBiglietto").
SELECT comp, SUM(prezzoBiglietto) AS ricavo_totale FROM Volo GROUP BY comp ORDER BY ricavo_totale DESC LIMIT 1;

8. Trova voli con il prezzo medio del biglietto superiore a 200€.
SELECT codice, comp, AVG(prezzoBiglietto) AS prezzo_medio FROM Volo GROUP BY codice, comp HAVING AVG(prezzoBiglietto) > 200;



---
Query sui dati temporali (ipotizzando colonne "dataPartenza" e "dataArrivo")
9. Trova voli che partono entro la prossima settimana.
SELECT codice, comp, dataPartenza FROM ArrPart WHERE dataPartenza BETWEEN CURRENT_DATE AND DATEADD(DAY, 7, CURRENT_DATE);

10. Trova aeroporti più utilizzati negli ultimi tre mesi.
SELECT aeroporto, COUNT(*) AS utilizzo_totale FROM (    SELECT partenza AS aeroporto FROM ArrPart     WHERE dataPartenza >= DATEADD(MONTH, -3, CURRENT_DATE)    UNION ALL     SELECT arrivo AS aeroporto FROM ArrPart     WHERE dataArrivo >= DATEADD(MONTH, -3, CURRENT_DATE)) AS voliGROUP BY aeroporto ORDER BY utilizzo_totale DESC;



---
Query su relazioni avanzate
11. Trova voli operati in partnership tra due compagnie.
SELECT v1.codice, v1.comp AS compagnia1, v2.comp AS compagnia2 FROM Volo v1JOIN Volo v2 ON v1.codice = v2.codice AND v1.comp <> v2.comp;

12. Trova aeroporti che servono voli di compagnie di almeno 3 nazioni diverse.
SELECT la.aeroporto FROM LuogoAeroporto laJOIN ArrPart ap ON la.aeroporto = ap.partenza OR la.aeroporto = ap.arrivoJOIN Compagnia c ON ap.comp = c.nomeGROUP BY la.aeroportoHAVING COUNT(DISTINCT c.nazione) >= 3;



---
Query su analisi di traffico
13. Trova gli aeroporti con il minor traffico di voli (arrivi e partenze).
SELECT aeroporto, COUNT(*) AS traffico FROM (    SELECT partenza AS aeroporto FROM ArrPart     UNION ALL     SELECT arrivo AS aeroporto FROM ArrPart) AS traffico_aeroportoGROUP BY aeroporto ORDER BY traffico ASC LIMIT 1;

14. Trova i voli con il maggior numero di passeggeri (ipotizzando una colonna "numeroPasseggeri").
SELECT codice, comp, MAX(numeroPasseggeri) AS passeggeri FROM Volo GROUP BY codice, comp;



---
Query su dettagli mancanti o incompleti
15. Trova voli che mancano di informazioni su durata e prezzo.
SELECT codice, comp FROM Volo WHERE durataMinuti IS NULL OR prezzoBiglietto IS NULL;

16. Trova aeroporti che non sono stati usati in alcun volo negli ultimi 6 mesi.
SELECT codice, nome FROM Aeroporto aLEFT JOIN ArrPart ap ON a.codice = ap.partenza OR a.codice = ap.arrivoWHERE ap.dataPartenza < DATEADD(MONTH, -6, CURRENT_DATE)   OR ap.dataPartenza IS NULL;_Ecco alcune query con JOIN e sottoquery annidate per il database Cielo:

---
1. Elenco delle compagnie che operano voli con durata superiore alla durata media di tutti i voli
SELECT DISTINCT Compagnia.nomeFROM CompagniaJOIN Volo ON Compagnia.nome = Volo.compWHERE Volo.durataMinuti > (    SELECT AVG(durataMinuti)    FROM Volo);

---
2. Aeroporti che hanno solo voli in partenza ma non in arrivo
SELECT Aeroporto.nomeFROM AeroportoWHERE codice IN (    SELECT partenza    FROM ArrPart    WHERE partenza NOT IN (        SELECT arrivo        FROM ArrPart    ));

---
3. Voli con durata maggiore rispetto alla durata media dei voli della stessa compagnia
SELECT Volo.codice, Volo.comp, Volo.durataMinutiFROM VoloWHERE Volo.durataMinuti > (    SELECT AVG(durataMinuti)    FROM Volo AS sub    WHERE sub.comp = Volo.comp);

---
4. Città e nazioni con aeroporti che non hanno mai voli in partenza
SELECT DISTINCT LuogoAeroporto.citta, LuogoAeroporto.nazioneFROM LuogoAeroportoWHERE aeroporto NOT IN (    SELECT partenza    FROM ArrPart);

---
5. Compagnie che operano voli verso tutti gli aeroporti
SELECT Compagnia.nomeFROM CompagniaWHERE NOT EXISTS (    SELECT Aeroporto.codice    FROM Aeroporto    WHERE Aeroporto.codice NOT IN (        SELECT arrivo        FROM ArrPart        WHERE ArrPart.comp = Compagnia.nome    ));

---
6. Voli con lo stesso aeroporto di partenza e di arrivo
SELECT Volo.codice, Volo.comp, ArrPart.partenza, ArrPart.arrivoFROM VoloJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compWHERE ArrPart.partenza = ArrPart.arrivo;

---
7. Elenco delle compagnie con il numero di voli operati superiori alla media
SELECT Compagnia.nome, COUNT(Volo.codice) AS numero_voliFROM CompagniaJOIN Volo ON Compagnia.nome = Volo.compGROUP BY Compagnia.nomeHAVING COUNT(Volo.codice) > (    SELECT AVG(numero_voli)    FROM (        SELECT COUNT(codice) AS numero_voli        FROM Volo        GROUP BY comp    ) AS subquery);

---
8. Aeroporti di arrivo per i voli di una specifica compagnia
SELECT DISTINCT Aeroporto.nomeFROM AeroportoJOIN ArrPart ON Aeroporto.codice = ArrPart.arrivoWHERE ArrPart.comp = 'NomeCompagnia'; -- Sostituire con il nome della compagnia

---
9. Elenco delle città servite da voli con durata inferiore a 2 ore
SELECT DISTINCT LuogoAeroporto.cittaFROM LuogoAeroportoWHERE aeroporto IN (    SELECT arrivo    FROM ArrPart    JOIN Volo ON ArrPart.codice = Volo.codice AND ArrPart.comp = Volo.comp    WHERE Volo.durataMinuti < 120);

---
10. Voli che partono da un aeroporto in una città specifica
SELECT Volo.codice, Volo.comp, ArrPart.partenza, LuogoAeroporto.cittaFROM VoloJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compJOIN LuogoAeroporto ON ArrPart.partenza = LuogoAeroporto.aeroportoWHERE LuogoAeroporto.citta = 'NomeCittà'; -- Sostituire con il nome della città

---
11. Compagnie che non operano voli verso un aeroporto specifico
SELECT Compagnia.nomeFROM CompagniaWHERE Compagnia.nome NOT IN (    SELECT DISTINCT ArrPart.comp    FROM ArrPart    WHERE ArrPart.arrivo = 'CodIATA'; -- Sostituire con il codice IATA dell'aeroporto);

---
12. Aeroporti con voli di durata massima per ogni compagnia
SELECT Aeroporto.nome, Volo.comp, Volo.durataMinutiFROM VoloJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compJOIN Aeroporto ON ArrPart.arrivo = Aeroporto.codiceWHERE Volo.durataMinuti = (    SELECT MAX(durataMinuti)    FROM Volo AS sub    WHERE sub.comp = Volo.comp);

---
13. Città che ospitano aeroporti con voli diretti verso almeno 3 nazioni diverse
SELECT DISTINCT LuogoAeroporto.cittaFROM LuogoAeroportoJOIN Aeroporto ON LuogoAeroporto.aeroporto = Aeroporto.codiceWHERE Aeroporto.codice IN (    SELECT partenza    FROM ArrPart    WHERE arrivo IN (        SELECT aeroporto        FROM LuogoAeroporto        GROUP BY nazione        HAVING COUNT(DISTINCT nazione) >= 3    ));

---
14. Elenco delle compagnie che non operano voli di durata superiore a 6 ore
SELECT Compagnia.nomeFROM CompagniaWHERE Compagnia.nome NOT IN (    SELECT DISTINCT Volo.comp    FROM Volo    WHERE Volo.durataMinuti > 360);

---
15. Elenco degli aeroporti che sono punti di arrivo e partenza per almeno 5 compagnie
SELECT Aeroporto.nomeFROM AeroportoWHERE codice IN (    SELECT arrivo    FROM ArrPart    GROUP BY arrivo    HAVING COUNT(DISTINCT comp) >= 5)AND codice IN (    SELECT partenza    FROM ArrPart    GROUP BY partenza    HAVING COUNT(DISTINCT comp) >= 5);

---
16. Voli che partono da una città specifica e arrivano in una nazione specifica
SELECT Volo.codice, Volo.comp, ArrPart.partenza, ArrPart.arrivoFROM VoloJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compJOIN LuogoAeroporto AS partenzaLuogo ON ArrPart.partenza = partenzaLuogo.aeroportoJOIN LuogoAeroporto AS arrivoLuogo ON ArrPart.arrivo = arrivoLuogo.aeroportoWHERE partenzaLuogo.citta = 'NomeCittà' AND arrivoLuogo.nazione = 'NomeNazione'; -- Sostituire con la città e la nazione

---
17. Compagnie che operano voli tra due città specifiche
SELECT DISTINCT Compagnia.nomeFROM CompagniaJOIN Volo ON Compagnia.nome = Volo.compJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compWHERE ArrPart.partenza IN (    SELECT aeroporto    FROM LuogoAeroporto    WHERE citta = 'Città1' -- Sostituire con la prima città)AND ArrPart.arrivo IN (    SELECT aeroporto    FROM LuogoAeroporto    WHERE citta = 'Città2' -- Sostituire con la seconda città);

---
18. Aeroporti che servono più voli rispetto alla media
SELECT Aeroporto.nome, COUNT(*) AS numero_voliFROM AeroportoJOIN ArrPart ON Aeroporto.codice = ArrPart.arrivo OR Aeroporto.codice = ArrPart.partenzaGROUP BY Aeroporto.nomeHAVING COUNT(*) > (    SELECT AVG(numero_voli)    FROM (        SELECT COUNT(*) AS numero_voli        FROM ArrPart        GROUP BY arrivo, partenza    ) AS subquery);

---
19. Elenco delle nazioni con voli solo da compagnie fondate prima del 2000
SELECT DISTINCT LuogoAeroporto.nazioneFROM LuogoAeroportoWHERE aeroporto IN (    SELECT arrivo    FROM ArrPart    WHERE comp IN (        SELECT nome        FROM Compagnia        WHERE annoFondaz IS NOT NULL AND annoFondaz < 2000    ));

---
20. Aeroporti con voli diretti verso tutte le città di una nazione specifica
SELECT Aeroporto.nomeFROM AeroportoWHERE codice IN (    SELECT partenza    FROM ArrPart    WHERE arrivo IN (        SELECT aeroporto        FROM LuogoAeroporto        WHERE nazione = 'NomeNazione' -- Sostituire con la nazione specifica    )    GROUP BY partenza    HAVING COUNT(DISTINCT arrivo) = (        SELECT COUNT(*)        FROM LuogoAeroporto        WHERE nazione = 'NomeNazione'    ));

---
21. Compagnie con voli tra aeroporti della stessa città
SELECT DISTINCT Compagnia.nomeFROM CompagniaJOIN Volo ON Compagnia.nome = Volo.compJOIN ArrPart ON Volo.codice = ArrPart.codice AND Volo.comp = ArrPart.compWHERE ArrPart.partenza IN (    SELECT aeroporto    FROM LuogoAeroporto AS partenza    WHERE partenza.citta IN (        SELECT citta        FROM LuogoAeroporto AS arrivo        WHERE partenza.citta = arrivo.citta AND partenza.aeroporto != arrivo.aeroporto    ));

---
Se hai richieste specifiche o ulteriori idee da esplorare, fammi sapere!

