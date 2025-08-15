#!/bin/bash

# Message Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No color

# Print message function
print_message () {
  local color=$1
  local message=$2
  echo -e "${color}\n${message}${NC}"
}

APACHE_ROOT="/var/www/html"
CGI_PATH="/usr/lib/cgi-bin"
SERVER_URL="http://localhost"
PORT=80

print_message $YELLOW  "--- Updating and upgrading the system ---"
sudo apt update && sudo apt upgrade -y

print_message $YELLOW  "--- Installing Apache ---"
sudo apt install apache2 -y

print_message $YELLOW "--- Installing CGI ---"
sudo a2enmod cgi

print_message $YELLOW  "--- Restarting Apache ---"
sudo systemctl restart apache2

print_message $YELLOW "--- Creating CGI dir ---"
sudo mkdir -p ${CGI_PATH}

print_message $YELLOW "--- Inserting content to 'uptime.sh' (CGI dir) ---"
cat << 'EOF' | sudo tee ${CGI_PATH}/uptime.sh > /dev/null
#!/bin/bash
echo "Content-type: text/plain"
echo ""
uptime
EOF

print_message $YELLOW  "--- Changing the access mode of 'uptime.sh' to execution ---"
sudo chmod 777 ${CGI_PATH}/uptime.sh

print_message $YELLOW  "--- Verifying CGI whether is enabled ---"
sudo a2enconf serve-cgi-bin
sudo systemctl reload apache2

print_message $YELLOW  "--- Configuring UFW firewall for Apache ---"
sudo ufw allow ${PORT}/tcp

print_message $YELLOW  "--- Verifying Apache installation status ---"
sudo systemctl status apache2 --no-pager # --no-pager prevents long output from pausing

print_message $YELLOW  "--- Deleting default web page ---"
sudo rm -f ${APACHE_ROOT}/index.html

print_message $YELLOW  "--- Copying new 'index.html' to apache dir ---"
sudo cp index.html ${APACHE_ROOT}

print_message $YELLOW  "--- Changing the ownership of 'index.html' to 'www-data' user and group ---"
sudo chown www-data:www-data ${APACHE_ROOT}/index.html

print_message $YELLOW  "--- Changing the access mode of 'index.html' ---"
sudo chmod 644 ${APACHE_ROOT}/index.html
# sudo chmod u=rw,go=r ${APACHE_ROOT}/index.html # Alternative

print_message $YELLOW  "--- Obtaining public IP ---"
MY_IP=$(curl -s ifconfig.me) # -s for silent mode
echo -e "My public IP: ${MY_IP}"

print_message $YELLOW  "--- Verifying the site ---"
# Give Apache a moment to be fully ready, though usually not needed after systemctl status.
# Also, ensure your host firewall/security group allows port 80.
sleep 5 # Small delay in case network setup isn't instantaneous
curl ${SERVER_URL}:${PORT}