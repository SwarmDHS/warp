import json, re, os
import flask
from flask import Flask, request
import command, network, config

app = flask.Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def render():
    hostname: str = get_hostname()
    uptime: str = get_uptime()
    ssids: list = network.get_ssids()
    toggled: bool = config.is_config_active()    

    if flask.request.method == "POST":
        if request.form.get("network_table"):
            # Should look something like `up_SSID`
            network_table: str = request.form.get("network_table").split("_")
            action: str = network_table[0]
            ssid: str = network_table[1]
            
            if action == "up":
                network.move_item(ssid, 1)
            elif action == "down":
                network.move_item(ssid, 1)
            elif action == "remove":
                network.remove_item(ssid)
        elif request.form.get("wifi_enabled"):
            successful = config.config_toggle()
            
            if successful:
                toggled = successful
            
    wifi_enabled: str = "enabled" if toggled else "disabled"
    
    return flask.render_template(
        "index.html",
        hostname=hostname,
        uptime=uptime,
        networks=ssids,
        wifi_enabled=wifi_enabled
    )

@app.route("/execute/<command>", methods=["POST"])
def execute(command):
    pass

def get_time():
    return command.run("date")
    
def get_uptime():
    # TODO: Use regex instead of this monstrosity
    return " ".join(command.run("uptime").split(",")[0].split(" ")[2::])

def get_hostname():
    return command.run("hostname")

# We need to control when this starts programmatically
def start():
    app.run(host="0.0.0.0", port=8080, debug=True)

if __name__ == "__main__":
    start()
