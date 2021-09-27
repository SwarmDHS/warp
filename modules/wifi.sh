# Install dependencies
RUN apt-get install -y wpasupplicant

WPA_CONFIG=/boot/wpa_supplicant.conf

BOOTSTRAP_WPA_COUNTRY=US

if [[ -z "${BOOTSTRAP_WPA_SSID}" || -z "${BOOTSTRAP_WPA_PASSPHRASE}" ]]; then
    printf "\n\nWARNING: WPA environment variables not set, failed to generate ${WPA_CONFIG}.\n"
    echo "To fix this, you create a file called \"credentials\" and insert:"
    echo "  BOOTSTRAP_WPA_SSID=your_wifi_ssid"
    echo "  BOOTSTRAP_WPA_PASSPHRASE=your_wifi_passphrase"
    echo "Aborting."
    exit 1
fi

echo "Generating ${WPA_CONFIG}..."

# Redirect output to prevent echoing sensitive information to stdout
RUN << EOF &> /dev/null
# Generate wpa_supplicant.conf in /boot so pi will copy it and disable rfkill on startup
echo ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev > /boot/wpa_supplicant.conf
echo update_config=1 >> /boot/wpa_supplicant.conf
echo country=${BOOTSTRAP_WPA_COUNTRY} >> /boot/wpa_supplicant.conf
wpa_passphrase ${BOOTSTRAP_WPA_SSID} ${BOOTSTRAP_WPA_PASSPHRASE} >> /boot/wpa_supplicant.conf
EOF

echo "Done."
