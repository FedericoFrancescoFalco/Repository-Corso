import re
from collections import defaultdict, Counter
import zipfile
from datetime import datetime

# Funzione per parsare una riga del log
def parse_log_line(line):
    pattern = r'^(\S+) - - \[(.*?)\] "(.*?)" (\d+) (\d+|-)$'
    match = re.match(pattern, line)
    if match:
        host = match.group(1)
        timestamp = match.group(2)
        request = match.group(3)
        status_code = match.group(4)
        bytes_transferred = match.group(5)
        bytes_transferred = int(bytes_transferred) if bytes_transferred != "-" else 0
        
        # Estrazione dell'ora dal timestamp
        try:
            datetime_obj = datetime.strptime(timestamp, "%d/%b/%Y:%H:%M:%S -0400")
            hour = datetime_obj.strftime("%Y-%m-%d %H:00")  # Fascia oraria con precisione di un'ora
        except ValueError:
            hour = "Unknown"

        return host, timestamp, request, status_code, bytes_transferred, hour
    return None

# Analizzare il log
def analyze_log(file_path):
    visits = 0
    hosts = defaultdict(int)
    pages = defaultdict(int)
    hours = defaultdict(int)
    bytes_per_hour = defaultdict(int)  # Nuovo dizionario per i dati scambiati per fascia oraria

    with zipfile.ZipFile(file_path, 'r') as z:
        log_files = z.namelist()
        if not log_files:
            print("Errore: Nessun file trovato nell'archivio ZIP.")
            return None, None, None, None, None

        with z.open(log_files[0]) as f:
            for line in f:
                line = line.decode('utf-8', errors='replace')
                parsed = parse_log_line(line)
                if parsed:
                    host, timestamp, request, status_code, bytes_transferred, hour = parsed
                    visits += 1
                    hosts[host] += 1
                    hours[hour] += 1  # Conta le richieste per fascia oraria
                    bytes_per_hour[hour] += bytes_transferred  # Somma i byte per fascia oraria
                    
                    # Estrai solo l'URL dalla richiesta
                    request_parts = request.split()
                    if len(request_parts) > 1:
                        page = request_parts[1]
                    else:
                        page = request
                    pages[page] += 1

    return visits, hosts, pages, hours, bytes_per_hour

# Generare i report
def generate_reports(visits, hosts, pages, hours, bytes_per_hour):
    if visits is None:
        return
    
    print(f"Numero totale di visite: {visits}")
    
    print("\nTop 10 IP/Domini sorgente per numero di visite:")
    for host, count in Counter(hosts).most_common(10):
        print(f"{host}: {count} visite")
    
    print("\nTop 10 pagine visitate:")
    for page, count in Counter(pages).most_common(10):
        print(f"{page}: {count} visite")

    print("\nTop 10 fasce orarie con più traffico:")
    for hour, count in Counter(hours).most_common(10):
        print(f"{hour}: {count} richieste")

    print("\nTop 10 fasce orarie per dati scambiati:")
    for hour, data in Counter(bytes_per_hour).most_common(10):
        print(f"{hour}: {data / (1024 * 1024):.2f} MB trasferiti")  # Conversione da byte a MB

# Percorso del file zip
file_path = 'NASA_access_log_Aug95.zip'

# Analisi del log e generazione dei report
visits, hosts, pages, hours, bytes_per_hour = analyze_log(file_path)
generate_reports(visits, hosts, pages, hours, bytes_per_hour)
