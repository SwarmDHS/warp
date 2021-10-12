RUN echo "Enabling WiFi..."

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

RUN echo "Generating ${WPA_CONFIG}..."

mkdir -p deploy/helpers/boot
mkdir -p deploy/helpers/var

# Generate wpa_supplicant.conf in /boot so pi will copy it and disable rfkill on startup
RUN echo ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev > deploy/helpers/boot/wpa_supplicant.conf
RUN echo update_config=1 >> deploy/helpers/boot/wpa_supplicant.conf
RUN echo country=${BOOTSTRAP_WPA_COUNTRY} >> deploy/helpers/boot/wpa_supplicant.conf
RUN echo wpa_passphrase ${BOOTSTRAP_WPA_SSID} ${BOOTSTRAP_WPA_PASSPHRASE} >> deploy/helpers/boot/wpa_supplicant.conf

RUN echo "Finished enabling WiFi"
