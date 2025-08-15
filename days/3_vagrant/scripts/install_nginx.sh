#!/bin/bash

echo "¡Hola desde el provisionamiento!" > /tmp/hola.txt
apt update && apt install -y nginx

cp /vagrant/scripts/index.html /var/www/html/index.html

systemctl start nginx