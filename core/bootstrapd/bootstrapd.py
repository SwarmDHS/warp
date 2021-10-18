import os
import config, server

FIRST_START: str = "/etc/bootstrapd/start"
ACCESS_POINT_CONF: str = "/usr/core/bootstrapd/ap_conf.sh"
settings: dict = config.parse()

if not os.path.isfile(FIRST_START):
    # Create the file, the system is no longer fresh
    open(FIRST_START, "w").close()
    
    # Run the access point startup script, create files and save
    # network preferences
    os.system(f"chmod +x {ACCESS_POINT_CONF} && sh {ACCESS_POINT_CONF}")

# Start the flask server
server.start()
