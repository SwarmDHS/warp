import json, re
import flask
import command, network

app = flask.Flask(__name__)

@app.route("/")
def render():
    return flask.render_template("index.html")

@app.route("/network", defaults={"ssid": None})
@app.route("/network/<ssid>", methods=["POST", "DELETE"])
@app.route("/network/<ssid>/up", methods=["POST"])
@app.route("/network/<ssid>/down", methods=["POST"])
def net(ssid: str):
    current_route: str = flask.request.path.split("/")

    networks: list = network.get_config().get("networks")
    
    if ssid:
        if "up" in current_route:
            network.move_item(ssid, -1)
        elif "down" in current_route:
            network.move_item(ssid, 1)
    
    return json.dumps([network.get("ssid") for network in networks])

@app.route("/execute/<command>", methods=["POST"])
def execute(command):
    pass

@app.route("/time")
def time():
    return json.dumps({"time": command.run("date")})
    
@app.route("/uptime")
def uptime():
    return json.dumps({"uptime": re.findall(command.run("uptime"), r"[^\n]{2}")})

@app.route("/hostname")
def hostname():
    return json.dumps({"hostname": command.run("hostname")})
    
# We need to control when this starts programmatically
def start():
    app.run(host="0.0.0.0", port=8000, debug=True)
    
if __name__ == "__main__":
    start()
