import os
import config, server

ACCESS_POINT_CONF: str = "ap_conf.sh"
# settings: dict = config.parse()

# Check if this is the first time the system's booted
if not os.path.isfile(config.FIRST_START):
    # Create the file, the system is no longer fresh
    open(config.FIRST_START, "w").close()
    
    # Run the access point startup script, create files and save
    # network preferences
    os.system(f"chmod +x {ACCESS_POINT_CONF} && sudo sh {ACCESS_POINT_CONF}")

# We don't want to keep the server unnecessarily running
# Only start if in access point mode
if config.is_config_active():
    server.start()
