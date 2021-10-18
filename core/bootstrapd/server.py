import flask

app = flask.Flask(__name__)

@app.route("/")
def render():
    return flask.render_template("index.html")

def start():
    app.run(port=8000)
