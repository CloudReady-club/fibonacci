from distutils.log import error
from datetime import datetime

from flask import Flask
app = Flask(__name__)


@app.route('/healthz')
def hello():
    
    return "ok"

@app.route('/fibonacci')
def fibonacci():
   startExecution = datetime.now().timestamp()
   getFibonacci()
   duration = datetime.now().timestamp() -startExecution
   millisec=duration * 1000
   return str(millisec)

def getFibonacci():
    a = 0
    b = 1
    limit = 10 ** 9999
    while a < limit:
        a = a + b
        a,b = b,a

    return a


if __name__ == "__main__":
    from waitress import serve
    serve(app, host="0.0.0.0", port=8080)