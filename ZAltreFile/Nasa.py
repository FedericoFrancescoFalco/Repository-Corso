import re
from collections import defaultdict, Counter
import zipfile
from datetime import datetime

# Funzione per parsare una riga del log
def parse_log_line(line):
    pattern = r'^(\S+) - - \[(.*?)\] "(.*?)" (\d+) (\d+)$'
    match = re.match(pattern, line)
    if match:
        host = match.group(1)
        timestamp = match.group(2)
        request = match.group(3)
        status_code = match.group(4)
        bytes_transferred = match.group(5)
        return host, timestamp, request, status_code, bytes_transferred
    return None

# Analizzare il log
def analyze_log(file_path):
    visits = 0
    hosts = defaultdict(int)
    pages = defaultdict(int)
    frequency = defaultdict(int)

    with zipfile.ZipFile(file_path, 'r') as z:
        with z.open(z.namelist()[0]) as f:
            for line in f:
                line = line.decode('utf-8')
                parsed = parse_log_line(line)
                if parsed:
                    host, timestamp, request, status_code, bytes_transferred = parsed
                    visits += 1
                    hosts[host] += 1
                    pages[request] += 1
                    frequency[host] += 1

    return visits, hosts, pages, frequency

#generare i report
def generate_reports(visits, hosts, pages, frequency):
    print(f"Numero totale di visite: {visits}")
    
    print("\nTop 10 IP/Domini sorgente per numero di visite:")
    for host, count in Counter(hosts).most_common(10):
        print(f"{host}: {count} visite")
    
    print("\nTop 10 pagine visitate:")
    for page, count in Counter(pages).most_common(10):
        print(f"{page}: {count} visite")
    
    print("\nTop 10 IP/Domini per frequenza di collegamento:")
    for host, count in Counter(frequency).most_common(10):
        print(f"{host}: {count} collegamenti")

# Percorso del file zip
file_path = 'NASA_access_log_Aug95.zip'

# Analisi del log e generazione dei report
visits, hosts, pages, frequency = analyze_log(file_path)
generate_reports(visits, hosts, pages, frequency)