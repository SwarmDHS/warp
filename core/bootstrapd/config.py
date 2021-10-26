import os

FIRST_START: str = "/etc/bootstrapd/start"
BOOTSTRAPD_CONFIG: str = "/etc/bootstrapd/bootstrapd.conf"

EXT_CONFIG_FILES: list = [
    "/etc/dhcpcd.conf",
    "/etc/sysctl.d/routed-ap.conf",
    "/etc/sysctl.conf",
    "/etc/dnsmasq.conf",
    "/etc/hostapd/hostapd.conf",
    "/etc/default/hostapd",
]

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
