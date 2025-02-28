import re
from collections import defaultdict, Counter
import zipfile
from datetime import datetime


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


def analyze_log(file_path):
    visits = 0
    hosts = defaultdict(int)
    pages = defaultdict(int)
    frequency = defaultdict(int)
    suspicious_status_codes = defaultdict(int)
    large_requests = []
    suspicious_ips = defaultdict(int)
    http_methods = defaultdict(int)

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
                        if method in ['GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS']:  
                            http_methods[method] += 1
                except Exception as e:
                    print(f"Errore durante l'elaborazione della riga: {line}. Dettagli errore: {e}")

    return visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods


def write_report_to_file(visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods):
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
        
        report_file.write("\nTop 20 Richieste di grandi dimensioni (potenziale esfiltrazione di dati):\n")
        for req in sorted(large_requests, key=lambda x: int(x[3]), reverse=True)[:20]:  
            report_file.write(f"{req[0]} {req[1]} {req[2]} {req[3]} bytes\n")
        
        report_file.write("\nTop 20 IP sospetti:\n")
        for ip, count in Counter(suspicious_ips).most_common(20):  
            report_file.write(f"{ip}: {count} occorrenze\n")
        
        report_file.write("\nMetodi HTTP utilizzati:\n")
        for method, count in http_methods.items():
            report_file.write(f"{method}: {count} occorrenze\n")


file_path = 'NASA_access_log_Aug95.zip'


visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods = analyze_log(file_path)


write_report_to_file(visits, hosts, pages, frequency, suspicious_status_codes, large_requests, suspicious_ips, http_methods)

print("Report generato con successo: 'report.txt'")
