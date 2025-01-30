#!/bin/bash
set -e
apt update -y && apt install -y nginx
echo "Deployed via Terraform" > /var/www/html/index.html
systemctl start nginx
systemctl enable nginx
