echo "Configuring access point..."

sudo systemctl unmask hostapd
sudo systemctl enable hostapd

tee /etc/dhcpcd.conf <<EOF
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF

tee /etc/sysctl.d/routed-ap.conf <<EOF
net.ipv4.ip_forward=1
EOF

tee /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF

tee /etc/dnsmasq.conf <<EOF
interface=wlan0 
bind-interfaces 
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
domain=wlan
address=/gw.wlan/192.168.4.1
EOF

tee /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
ssid=PiSetup
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=PassphrasePassphrase
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

tee /etc/default/hostapd <<EOF
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF

sudo netfilter-persistent save

echo "Finished configuring access point, rebooting"
