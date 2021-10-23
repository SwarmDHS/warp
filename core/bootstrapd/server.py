import flask
import subprocess

app = flask.Flask(__name__)

@app.route("/")
def render():
    return flask.render_template("index.html")
    
def start():
    ip: str = subprocess.run(['hostname', '-I'], stdout=subprocess.PIPE).stdout.decode("utf-8").split(" ")[0]
    app.run(host=ip, port=8000)
