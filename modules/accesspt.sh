RUN sudo systemctl unmask hostapd
RUN sudo systemctl enable hostapd

mkdir -p deploy/helpers/etc
cat <<EOF >> deploy/helpers/etc/dhcpcd.conf
interface wlan0
    static ip_address=192.168.0.10/24
    nohook wpa_supplicant
EOF
INSTALL "deploy/helpers/etc/dhcpcd.conf" "/etc/dhcpcd.conf"

mkdir -p deploy/helpers/etc/sysctl.d
echo "net.ipv4.ip_forward=1" > deploy/helpers/etc/sysctl.d/routed-ap.conf
INSTALL "deploy/helpers/etc/sysctl.d/routed-ap.conf" "/etc/sysctl.d/routed-ap.conf"

RUN sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

RUN sudo netfilter-persistent save

cat <<EOF >> deploy/helpers/etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
domain=wlan
address=/gw.wlan/192.168.4.1
EOF
INSTALL "deploy/helpers/etc/dnsmasq.conf" "/etc/dnsmasq.conf"

mkdir -p deploy/helpers/etc/hostapd
cat <<EOF > deploy/helpers/etc/hostapd/hostapd.conf
interface=wlan0
ssid=pi
wpa_passphrase=test
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

INSTALL "deploy/helpers/etc/hostapd/hostapd.conf" "/etc/hostapd/hostapd.conf"
