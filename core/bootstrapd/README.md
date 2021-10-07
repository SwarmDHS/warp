# bootstrapd

Bootstrapd is a service that automatically starts up at boot and handles additional initialization. Primarily, it runs a flask server in the background, exposing an interface to allow users to configure WiFi networks and run simple shell commands remotely.

Bootstrapd runs as root, and so has access to configuration files that the normal `pi` user does not. It acts as a gateway to the information in these files. For example, it exposes the list of known WiFi SSIDs to the user instead of giving access to the entire `wpa_supplicant.conf` file.
