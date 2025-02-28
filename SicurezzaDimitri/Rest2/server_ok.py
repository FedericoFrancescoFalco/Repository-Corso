from flask import Flask, jsonify, request
from myjson import JsonDeserialize, JsonSerialize

api = Flask(__name__)

file_path = "anagrafe.json"
cittadini = JsonDeserialize(file_path)

file_path_utenti = "utenti.json"
utenti = JsonDeserialize(file_path_utenti)

@api.route('/login', methods=['POST'])
def gestisciLogin():
    content_type = request.headers.get('Content-Type')
    if content_type == 'application/json':
        jsonReq = request.json
        sUsernameInseritoDalClient = jsonReq["username"]
        if sUsernameInseritoDalClient in utenti:
            sPasswordInseritaDalClient = jsonReq["password"]
            if  sPasswordInseritaDalClient == utenti[sUsernameInseritoDalClient]["password"]:
                sPriv =  utenti[sUsernameInseritoDalClient]["privilegi"]
                return jsonify({"username": sUsernameInseritoDalClient, "privilegi": sPriv})
            else:
                return jsonify({"Esito": "001", "Msg": "Credenziali errate"})
        else:
            return jsonify({"Esito": "001", "Msg": "Credenziali errate"})
    else:
        return jsonify({"Esito": "002", "Msg": "Formato richiesta errato"})


@api.route('/add_cittadino', methods=['POST'])
def GestisciAddCittadino():
    content_type = request.headers.get('Content-Type')
    if content_type == 'application/json':
        jsonReq = request.json
        
        #prima di tutto verifico utente, password e privilegio 
        #dove utente e password me l'ha inviato il client
        #mentre il privilegio lo vado a leggere nel mio file  (utenti.json)

        codice_fiscale = jsonReq.get('codFiscale')
        if codice_fiscale in cittadini:
            return jsonify({"Esito": "001", "Msg": "Cittadino già esistente"})
        else:
            cittadini[codice_fiscale] = jsonReq
            JsonSerialize(cittadini, file_path) 
            return jsonify({"Esito": "000", "Msg": "Cittadino aggiunto con successo"})
    else:
        return jsonify({"Esito": "002", "Msg": "Formato richiesta non valido"})



"""
Questa funzione sta sul SERVER. Riceve il codice fiscale dal client 
e verifica se il codice e d i dati associati stanno in anagrafe.json
"""

@api.route('/read_cittadino/<codice_fiscale>', methods=['GET'])
def read_cittadino(codice_fiscale):

    cittadino = cittadini.get(codice_fiscale)
    if cittadino:
        return jsonify({"Esito": "000", "Msg": "Cittadino trovato", "Dati": cittadino})
    else:
        return jsonify({"Esito": "001", "Msg": "Cittadino non trovato"})






@api.route('/update_cittadino', methods=['PUT'])
def update_cittadino():

    #prima di tutto verifico utente, password e privilegio 
    #dove utente e password me l'ha inviato il client
    #mentre il privilegio lo vado a leggere nel mio file  (utenti.json)

    content_type = request.headers.get('Content-Type')
    if content_type == 'application/json':
        jsonReq = request.json
        codice_fiscale = jsonReq.get('codFiscale')
        if codice_fiscale in cittadini:
            cittadini[codice_fiscale] = jsonReq
            JsonSerialize(cittadini, file_path)  
            return jsonify({"Esito": "000", "Msg": "Cittadino aggiornato con successo"})
        else:
            return jsonify({"Esito": "001", "Msg": "Cittadino non trovato"})
    else:
        return jsonify({"Esito": "002", "Msg": "Formato richiesta non valido"})






@api.route('/elimina_cittadino', methods=['DELETE'])
def elimina_cittadino():

    #prima di tutto verifico utente, password e privilegio 
    #dove utente e password me l'ha inviato il client
    #mentre il privilegio lo vado a leggere nel mio file  (utenti.json)
    
    content_type = request.headers.get('Content-Type')
    if content_type == 'application/json':
        cod = request.json.get('codFiscale')
        if cod in cittadini:
            del cittadini[cod]
            JsonSerialize(cittadini, file_path)  
            return jsonify({"Esito": "000", "Msg": "Cittadino rimosso con successo"})
        else:
            return jsonify({"Esito": "001", "Msg": "Cittadino non trovato"})
    else:
        return jsonify({"Esito": "002", "Msg": "Formato richiesta non valido"})

api.run(host="127.0.0.1", port=8080, ssl_context="adhoc")

