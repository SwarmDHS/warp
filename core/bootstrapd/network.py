import os, json, subprocess

WPA_SUPPLICANT_CONF: str = "/etc/wpa_supplicant.conf"
supplicant_handle = open(WPA_SUPPLICANT_CONF, "r+")

# Keep a global config that we can edit
network_config: dict = {
    "networks": []
}

def parse():
    lock = False
    
    for line in supplicant_handle:
        line = line.strip()
        
        # Skip if the line is empty
        if not line or line[0] == "#":
            continue
        
        if line == "}":
            lock = False
            continue
        
        key, value = line.split("=", 1)
        
        value = value.strip("\"")
        
        if value == "{":
            lock = True
            continue
    
        if lock:
            if key == "ssid":
                network_config.get("networks").append({
                    "ssid": value,
                })
            else:
                networks = network_config.get("networks")
                
                networks[len(networks) - 1][key] = value
                
            continue

        network_config[key] = value
        
def write():
    # We want the contents of the file to be completety gone
    with (open(WPA_SUPPLICANT_CONF, "w")) as f:
        
        for key in network_config:
            value = network_config.get(key)
            
            if type(value) == list:
                for obj in value:
                    f.write("network={\n")
                    
                    for key in obj:
                        f.write(f"\t{key}=\"{obj.get(key)}\"\n")
                
                    f.write("}\n")
            else:
                f.write(f"{key}={value}\n")
        
def get_config() -> dict:
    parse()
    return network_config
    
def get_ssids() -> list:
    return [cur_network.get("ssid") for cur_network in get_config().get("networks")]

def move_item(ssid: str, direction: int) -> bool:
    networks = network_config.get("networks")
    
    item = next((item for item in networks if item["ssid"] == ssid), None)
    index = networks.index(item) + direction
    
    if index < 0 or index >= len(networks):
        return False
        
    networks.remove(item)
    networks.insert(index, item)
    
    write()
    
    return True
    
def add_item(ssid: str, psk: str):
    networks = network_config["networks"]
    
    networks.append({
        "ssid": ssid,
        "psk": psk
    })
    
    networks = list(set(networks))
    
    write()
    
def remove_item(ssid):
    networks = network_config.get("networks")
    item = next((item for item in networks if item["ssid"] == ssid), None)
    
    network_config["networks"].remove(item)
    write()
