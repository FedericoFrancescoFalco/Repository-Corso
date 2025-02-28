from flask import Flask, render_template, request

api = Flask(__name__)

utenti = [
    {"email": "mariorossi@gmail.com", "CF": "mariorossi85", "password": "baubau66", "registrato": "1"}
]

@api.route('/registrati', methods=['GET'])
def registra():
    email = request.args.get("email")
    CF = request.args.get("CF")
    password = request.args.get("passw")
    
    for utente in utenti:
        if utente["email"] == email and utente["CF"] == CF and utente["password"] == password:
            utente["registrato"] = "1"
            return render_template("reg_ok.html")
    
    return render_template("reg_ko.html")


@api.route('/', methods=["GET"])
def index():
    return render_template('index.html')

api.run(host="0.0.0.0", port=8805,ssl_context=('./certificati/02.pem','./certificati/01.key'))



