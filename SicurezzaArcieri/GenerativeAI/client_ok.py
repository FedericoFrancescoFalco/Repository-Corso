import requests, json, sys, subprocess
import urllib3
from myjson import *
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

base_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key="
google_api_key = "AIzaSyCKgr8_0FnSeVyqMLIPoYKI67ZYKLiRmaY"
api_url = base_url + google_api_key

def ComponiJsonPerImmagine(sImagePath):
  subprocess.run(["rm", "./image.jpg"])
  subprocess.run(["rm", "./request.json"])
  subprocess.run(["cp", sImagePath,"./image.jpg"])
  subprocess.run(["bash", "./creajsonpersf.sh"])




def EseguiOperazione(iOper, sServizio, dDatiToSend):
    try:
        if iOper == 1:
            response = requests.post(sServizio, json=dDatiToSend)
        if iOper == 2:
            response = requests.get(sServizio)
        if iOper == 3:
            response = requests.post(sServizio, json=dDatiToSend)
        if iOper == 4:
            response = requests.delete(sServizio, json=dDatiToSend)

        if response.status_code==200:
            print(response.json())
        else:
            print("Attenzione, errore " + str(response.status_code))
    except:
        print("Problemi di comunicazione con il server, riprova più tardi.")
            


iFlag = 0
while iFlag==0:
    print("\nOperazioni disponibili:")
    print("1. Creare una favola")
    print("2. Rispondere a una domanda")
    print("3. Rispondere a una domanda su un argomento")
    print("4. Rispondere a una domanda su un img")
    print("5. Esci")


    try:
        iOper = int(input("Cosa vuoi fare? "))
    except ValueError:
        print("Inserisci un numero valido!")
        continue


    if iOper == 1:
        sArgomento = input("Inserisci l'argomento della favola: ")
        sArgomento2 = "crea favola su" + sArgomento + "in italiano"
        
        jsonDataRequest = {"contents":[{"parts":[{"text":sArgomento2}]}]}
        #EseguiOperazione(1, api_url, jsonDataRequest)
        response = requests.post(api_url, json= jsonDataRequest, verify = False)
        if response.status_code ==200:
            dataRequested: str = sArgomento2
            jsonRecieved: dict = response.json()
            dataRecieved: str = jsonRecieved["candidates"][0]["content"]["parts"][0]["text"]
            print(f"\nRichiesta: {dataRequested}\n\n{dataRecieved}")

    
    # elif iOper == 2:
    #     print("Richiesta dati cittadino")
    #     api_url = base_url + "/read_cittadino"
    #     jsonDataRequest = GetCodicefiscale()
    #     EseguiOperazione(2, api_url + "/" + jsonDataRequest['codFiscale'],None)

    elif iOper == 3:
        sFile = input("inserisci il path completo del file che vuoi analizzare")
        ComponiJsonPerImmagine(sFile)
        dJsonRequest = JsonDeserialize("request.json")
        response = requests.post(api_url , json=  dJsonRequest, verify = False)
        if response.status_code == 200:
            print(response.json())

    # elif iOper == 4:
    #     print("Eliminazione cittadino")
    #     api_url = base_url + "/elimina_cittadino"
    #     jsonDataRequest = GetCodicefiscale()
    #     EseguiOperazione(4, api_url, jsonDataRequest)

    elif iOper == 5:
        print("Buona giornata!")
        iFlag = 1

    else:
        print("Operazione non riuscita")