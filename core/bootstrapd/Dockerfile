FROM python:3

# Install build dependencies in the container
RUN pip3 install flask

COPY . /bootstrapd
COPY ./test/wpa_supplicant.conf /etc/wpa_supplicant.conf
COPY ./test/dhcpcd.conf /etc/dhcpcd.conf

WORKDIR /bootstrapd

CMD python3 server.py
