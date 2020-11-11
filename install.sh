#!/bin/bash

#set -xe

# flush sudo prompt before anything else...
sudo echo "sudo'n" > /dev/null

if [ "$WITH_PROXY" == "yes" ]; then
    echo "---------- performing proxy configuration..."
    HTTP_PROXY_URL="http://$PROXY_NAME:$PROXY_PORT"
    echo "Proxy: $HTTP_PROXY_URL"

    FILE=/etc/hosts
    echo "---------- proxy update for: $FILE"
    grep e "${PROXY_NAME}$" $FILE || (echo "$PROXY_IP $PROXY_NAME" | sudo tee -a $FILE)

    FILE=/etc/environment
    echo "---------- proxy update for: $FILE"
    grep "^http_proxy=" $FILE || (echo "http_proxy=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^HTTP_PROXY=" $FILE || (echo "HTTP_PROXY=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^https_proxy=" $FILE || (echo "https_proxy=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^HTTPS_PROXY=" $FILE || (echo "HTTPS_PROXY=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^ftp_proxy=" $FILE || (echo "ftp_proxy=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^FTP_PROXY=" $FILE || (echo "FTP_PROXY=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^socks_proxy=" $FILE || (echo "socks_proxy=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^SOCKS_PROXY=" $FILE || (echo "SOCKS_PROXY=\"$HTTP_PROXY_URL/\"" | sudo tee -a $FILE)
    grep "^NO_PROXY=" $FILE || (echo "NO_PROXY=\"localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24\"" | sudo tee -a $FILE)

    FILE=/etc/apt/apt.conf
    echo "---------- proxy update for: $FILE"
    grep "^Acquire::http::proxy " $FILE || (echo "Acquire::http::proxy \"$HTTP_PROXY_URL/\";" | sudo tee -a $FILE)
    grep "^Acquire::https::proxy " $FILE || (echo "Acquire::https::proxy \"$HTTP_PROXY_URL/\";" | sudo tee -a $FILE)
    grep "^Acquire::ftp::proxy " $FILE || (echo "Acquire::ftp::proxy \"$HTTP_PROXY_URL/\";" | sudo tee -a $FILE)
    grep "^Acquire::socks::proxy " $FILE || (echo "Acquire::socks::proxy \"$HTTP_PROXY_URL/\";" | sudo tee -a $FILE)

else
    echo "---------- performing non-proxy configuration..."
fi

# bootstrap ansible
if hash ansible 2>/dev/null; then
    echo "---------- ansible installed, good, not touching it..."
else
    echo "---------- ansible not installed, installing it..."
    sudo apt update
    sudo apt install --yes software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install --yes ansible
fi

echo "--------- Ansible: $(ansible --version)"
echo "--------- Running Ansible Now..."

sudo ansible-playbook -vvvv main.yml

