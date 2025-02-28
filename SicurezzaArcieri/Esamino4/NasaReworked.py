import re
from collections import defaultdict, Counter
import zipfile
from collections import defaultdict

def parse_log_line(line):
    pattern = r'^(\S+) - - \[(.*?)\] "(.*?)" (\d+) (\d+|-)$'
    match = re.match(pattern, line)
    if match:
        host = match.group(1)
        timestamp = match.group(2)
        request = match.group(3)
        status_code = match.group(4)
        bytes_transferred = match.group(5) if match.group(5) != '-' else '0'
        return host, timestamp, request, status_code, bytes_transferred
    return None

def analyze_log(file_path):
    visits = 0
    hosts = defaultdict(int)
    pages = defaultdict(int)
    frequency = defaultdict(int)
    suspicious_status_codes = defaultdict(int)
    large_requests = []
    suspicious_ips = defaultdict(int)
    http_methods = defaultdict(int)
    strange_requests = defaultdict(list)
    traffic_per_hour_day = defaultdict(int)  # Dizionario per tracciare il traffico per ora e giorno

    with zipfile.ZipFile(file_path, 'r') as z:
        with z.open(z.namelist()[0]) as f:
            for line in f:
                try:
                    line = line.decode('utf-8', errors='ignore')  
                    parsed = parse_log_line(line)
                    if parsed:
                        host, timestamp, request, status_code, bytes_transferred = parsed
                        visits += 1
                        hosts[host] += 1
                        pages[request] += 1
                        frequency[host] += 1

                        if status_code in ['401', '403', '404', '500']:
                            suspicious_status_codes[status_code] += 1
                        
                        if int(bytes_transferred) > 100000:
                            large_requests.append((host, timestamp, request, bytes_transferred))
                        
                        if host.startswith("163.") or host.startswith("199."):
                            suspicious_ips[host] += 1
                        
                        method = request.split()[0]
                        http_methods[method] += 1

                        if method not in ['GET', 'POST', 'HEAD']:
                            strange_requests[method].append(host)

                        # Raccogliamo l'ora e il giorno per determinare il traffico
                        date, time = timestamp.split(":")[0], timestamp.split(":")[1]
                        traffic_per_hour_day[(date, time)] += 1

                except Exception as e:
                    print(f"Errore durante l'elaborazione della riga: {line}. Dettagli errore: {e}")

    return visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods, strange_requests, traffic_per_hour_day

def find_peak_traffic_hours(traffic_per_hour_day):
    # Ordinare il traffico per ora e giorno, e selezionare i 5 picchi più alti
    sorted_traffic = sorted(traffic_per_hour_day.items(), key=lambda x: x[1], reverse=True)
    
    peak_details = []
    for i in range(min(5, len(sorted_traffic))):
        (date, hour), count = sorted_traffic[i]
        peak_details.append((date, hour, count))

    return peak_details

def write_report_to_file(visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods, strange_requests, peak_details):
    with open("report.txt", "w") as report_file:
        report_file.write(f"Numero totale di visite: {visits}\n")
        
        report_file.write("\nTop 10 IP/Domini sorgente per numero di visite:\n")
        for host, count in Counter(hosts).most_common(10):
            report_file.write(f"{host}: {count} visite\n")
        
        report_file.write("\nTop 10 pagine visitate:\n")
        for page, count in Counter(pages).most_common(10):
            report_file.write(f"{page}: {count} visite\n")
        
        report_file.write("\nTop 10 IP/Domini per frequenza di collegamento:\n")
        for host, count in Counter(frequency).most_common(10):
            report_file.write(f"{host}: {count} collegamenti\n")
        
        report_file.write("\nCodici di stato sospetti:\n")
        for status, count in suspicious_status_codes.items():
            report_file.write(f"{status}: {count} occorrenze\n")
        
        report_file.write("\nTop 20 Richieste di grandi dimensioni:\n")
        for req in sorted(large_requests, key=lambda x: int(x[3]), reverse=True)[:20]:  
            report_file.write(f"{req[0]} {req[1]} {req[2]} {req[3]} bytes\n")
        
        report_file.write("\nTop 20 IP sospetti:\n")
        for ip, count in Counter(suspicious_ips).most_common(20):  
            report_file.write(f"{ip}: {count} occorrenze\n")
        
        report_file.write("\nMetodi HTTP utilizzati:\n")
        for method, count in http_methods.items():
            report_file.write(f"{method}: {count} occorrenze\n")
        
        report_file.write("\nRichieste HTTP strane (oltre GET, POST, HEAD) e relativi IP:\n")
        for method, ips in strange_requests.items():
            report_file.write(f"{method}: {len(ips)} richieste da {len(set(ips))} IP unici\n")
            for ip in set(ips):
                report_file.write(f"  - {ip}\n")
        
        # Aggiungere i picchi di traffico
        report_file.write("\nTop 5 picchi di traffico per ora e giorno:\n")
        if peak_details:
            for i, (date, hour, count) in enumerate(peak_details):
                report_file.write(f"Picco {i+1}: Il {date} alle ore {hour}:00 con {count} accessi\n")
        else:
            report_file.write("\nNessun dato sul picco di traffico disponibile.\n")

# Esempio di utilizzo
file_path = 'NASA_access_log_Aug95.zip'

visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods, strange_requests, traffic_per_hour_day = analyze_log(file_path)

peak_details = find_peak_traffic_hours(traffic_per_hour_day)

write_report_to_file(visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods, strange_requests, peak_details)

print("Report generato con successo: 'report.txt'")
