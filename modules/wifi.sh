HOST echo "Enabling WiFi..."

WPA_CONFIG=/boot/wpa_supplicant.conf

BOOTSTRAP_WPA_COUNTRY=US

HOST <<EOF
if [[ -z "${BOOTSTRAP_WPA_SSID}" || -z "${BOOTSTRAP_WPA_PASSPHRASE}" ]]; then
    printf "\n\nWARNING: WPA environment variables not set, failed to generate ${WPA_CONFIG}.\n"
    echo "To fix this, you create a file called \"credentials\" and insert:"
    echo "  BOOTSTRAP_WPA_SSID=your_wifi_ssid"
    echo "  BOOTSTRAP_WPA_PASSPHRASE=your_wifi_passphrase"
    echo "Aborting."
    exit 1
fi
EOF

HOST echo "Generating ${WPA_CONFIG}..."

# HOST mkdir -p deploy/helpers/boot
# HOST mkdir -p deploy/helpers/var

# HOST tee deploy/helpers/boot/wpa_supplicant.conf <<EOF
# network={
#     ssid=${BOOTSTRAP_WPA_SSID}
#     scan_ssid=1
#     key_mgmt=WPA-PSK
#     psk=${BOOTSTRAP_WPA_PASSPHRASE}
# }
# EOF

RUN <<EOF
# Generate wpa_supplicant.conf in /boot so pi will copy it and disable rfkill on startup
echo ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev > /boot/wpa_supplicant.conf
echo update_config=1 >> /boot/wpa_supplicant.conf
echo country=${BOOTSTRAP_WPA_COUNTRY} >> /boot/wpa_supplicant.conf
wpa_passphrase ${BOOTSTRAP_WPA_SSID} ${BOOTSTRAP_WPA_PASSPHRASE} >> /boot/wpa_supplicant.conf
EOF

HOST echo "Finished enabling WiFi"
