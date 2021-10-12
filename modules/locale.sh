RUN echo "Setting up locale and timezone..."

LOCALE="en_US.UTF-8"
TIMEZONE="America/Los_Angeles"
KEYBOARD_LAYOUT="English (US)"
KEYBOARD_KEYMAP="us"

# Set the timezone
RUN echo ${TIMEZONE} > /etc/timezone

RUN echo "Finished setting up locale and timezone"
