from flask import Flask, jsonify
from flask import json

from runAutoPhraseHelper import *
from flask import request

app = Flask(__name__)
shell_para = "./tempInput.txt"


@app.route('/')
def hello_world():
    Process = Popen('./phrasal_segmentation.sh %s' % (str(shell_para)), shell=True)
    print(Process.communicate())

    return 'Hello World!'

@app.route('/getlist',methods=['post'])
def getlist():
    request_json = request.form.get('data')
    request_obj = json.loads(request_json)
    document_text = request_obj["text"]
    dict_list = generating_list(document_text)
    return jsonify(results = dict_list)

if __name__ == '__main__':
    app.run(debug = True,host='172.16.32.207')
