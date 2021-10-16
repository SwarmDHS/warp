HOST echo "Setting up locale and timezone..."

RUN tee /etc/default/locale <<EOF
LANG=en_US.utf-8
TZ=America/Los_Angeles
EOF

HOST echo "Finished setting up locale and timezone"
