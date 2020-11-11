# A Developer Machine Bootstrap

Just the way I like it... 

Starting from a fresh Ubuntu 20.04 LTS installation, assuming git installed (with ssh keys configured), and running this from a bash shell.

Running:

    ./install.sh

Running behind a proxy:

    WITH_PROXY=yes \
    PROXY_IP="127.0.0.1" \
    PROXY_NAME="proxy" \
    PROXY_PORT="8888" \
    ./install.sh
    
Once finished there will be some private post config needed for installed software e.g. VPN, etc.
(TODO: document manual setup steps post install here)
