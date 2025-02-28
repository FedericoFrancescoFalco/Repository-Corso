import os, base64
import requests
import PyPDF2
import docx  
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyCKgr8_0FnSeVyqMLIPoYKI67ZYKLiRmaY"

sRoot = input("Inserisci la root directory: ")
sStringaDaCercare = input("Inserisci la stringa da cercare: ").lower()

def AnalizzaImmagineConGemini(Img):
    """Invia un'immagine all'API di Gemini per creare una sua descrizione."""
    with open(Img, "rb") as img_file:
        encoded_img = base64.b64encode(img_file.read()).decode("utf-8")
    
    data = {"contents": [{"parts": [{"text": "Descrivimi l'immagine nel dettaglio"},
                                    {"inline_data": {"mime_type": "image/jpeg", "data": encoded_img}}
                                    ]}]}
    
    response = requests.post(api_url, json=data, verify=False)
    if response.status_code == 200:
        return response.json()["candidates"][0]["content"]["parts"][0]["text"].lower()
    print(f"Errore API: {response.status_code}")
    return False

def CercaStringaInFileContent(sFile, sString):
    """Estrae il testo dal file e verifica se contiene la stringa specificata."""
    ext = os.path.splitext(sFile)[1].lower()
    text = ""
    
    try:
        if ext == ".pdf":
            pdf_reader = PyPDF2.PdfReader(sFile)
            text = " ".join(page.extract_text().lower() for page in pdf_reader.pages)
        elif ext in [".doc", ".docx"]:
            doc = docx.Document(sFile)
            text = " ".join(para.text.lower() for para in doc.paragraphs)
        elif ext in [".jpg", ".jpeg", ".png"]:
            text = AnalizzaImmagineConGemini(sFile)
        elif ext == ".txt":
            with open(sFile, "r", encoding="utf-8") as file:
                text = file.read().lower()
        
        
        return sString in text
    except Exception as e:
        print(f"Errore nella lettura del file {sFile}: {e}")
        return False


iNumFileTrovati = 0
for root, _, files in os.walk(sRoot):
    print(f"Esploro la directory: {root}")
    for filename in files:
        pathCompleto = os.path.join(root, filename)
        if CercaStringaInFileContent(pathCompleto, sStringaDaCercare):
            print("Trovato:", filename)
            iNumFileTrovati += 1

print(f"Numero totale di file trovati: {iNumFileTrovati}")