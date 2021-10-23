import os, json

FIRST_START: str = "/etc/bootstrapd/start"
BOOTSTRAPD_CONFIG: str = "/etc/bootstrapd/bootstrapd.conf"
NETWORK_CONFIG: str = "/etc/bootstrapd/network.conf"

config_file = open(BOOTSTRAPD_CONFIG, "w+")
network_config = open(NETWORK_CONFIG, "w+")

EXT_CONFIG_FILES: list = [
    "/etc/dhcpcd.conf",
    "/etc/sysctl.d/routed-ap.conf",
    "/etc/sysctl.conf",
    "/etc/dnsmasq.conf",
    "/etc/hostapd/hostapd.conf",
    "/etc/default/hostapd",
]

VALID_KEYS = []

def parse() -> dict:
    config: dict = {}
    
    # Skip commented files
    for line in config_file:
        if line[0] == "#":
            continue
        
        key, value = line.split("=")
        
        if key in VALID_KEYS:
            config[key] = value
        
    return config

def is_config_active() -> bool:
    return not os.path.isfile(EXT_CONFIG_FILES[0] + ".orig")

def config_toggle() -> bool:
    configs_active: bool = is_config_active()
    
    for path in EXT_CONFIG_FILES:
        src: str = path
        dest: str = path + ".orig"
        
        if not configs_active:
            src = path + ".orig"
            dest = path
            
        status: int = os.system(f"sudo mv {src} {dest}")
        
        if status > 0:
            return False
        
    return True
