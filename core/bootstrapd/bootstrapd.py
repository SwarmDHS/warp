import os
import server

BOOTSTRAPD_CONFIG: str = "/etc/bootstrapd/bootstrapd.conf"
config: dict = {}

CONFIG_FILES: list = [
    "/etc/dhcpcd.conf",
    "/etc/sysctl.d/routed-ap.conf",
    "/etc/sysctl.conf",
    "/etc/dnsmasq.conf",
    "/etc/hostapd/hostapd.conf",
    "/etc/hostapd/hostapd.conf",
    "/etc/default/hostapd",
]

# Check if configuration has already been loaded

os.system("chmod +x /usr/core/bootstrapd/ap_conf.sh && sh /usr/core/bootstrapd/ap_conf.sh")

# Start the flask server
server.start()
