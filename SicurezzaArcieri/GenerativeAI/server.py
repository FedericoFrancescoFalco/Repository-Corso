from flask import Flask, render_template, request

api = Flask("__name__", template_folder="./templates")

@api.route('/', methods=['GET'])
def index():
    return render_template('sendfile.html')

#api.run(host="0.0.0.0", port=8805)
api.run(host="0.0.0.0", port=8005, ssl_context=('./certificati/01.pem','./certificati/testkey.pem'))


