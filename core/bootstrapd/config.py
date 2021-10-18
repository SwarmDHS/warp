import os

BOOTSTRAPD_CONFIG: str = "/etc/bootstrapd/bootstrapd.conf"

config_file = open(BOOTSTRAPD_CONFIG)

EXT_CONFIG_FILES: list = [
    "/etc/dhcpcd.conf",
    "/etc/sysctl.d/routed-ap.conf",
    "/etc/sysctl.conf",
    "/etc/dnsmasq.conf",
    "/etc/hostapd/hostapd.conf",
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
    
def write(key: str, value: str) -> bool:
    pass

configs_active: bool = True

def get_config_status() -> bool:
    return configs_active

def config_toggle() -> bool:
    for path in EXT_CONFIG_FILES:
        src: str = path
        dest: str = path + ".orig"
        
        if not configs_active:
            src = path + ".orig"
            src = path
            
        os.system(f"sudo mv {src} {dest}")
