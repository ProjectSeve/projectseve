#!/bin/bash
# Project Seve


# Install AutoScript
wget http://evira.us/ubi18.sh
chmod +x ubi18.sh
./ubi18.sh
rm ubi18.sh

# Dropbear Setup
sed -i 's|DROPBEAR_EXTRA_ARGS="-p 80".*|DROPBEAR_EXTRA_ARGS="-p 90"|g' /etc/default/dropbear
/etc/init.d/dropbeat restart


# Getting Proxy Template
wget -q -O /usr/local/bin/projectseve https://raw.githubusercontent.com/mathew1357/projectseve/main/projectseve.py
chmod +x /usr/local/bin/projectseve

# Installing Service
cat > /etc/systemd/system/projectseve.service << END
[Unit]
Description=Project Seve
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/projectseve
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable projectseve
systemctl restart projectseve

clear

echo "Gawa kana ng SSH Account"
read -n 1 -s -r -p "Press Enter Key to create New Account"
usernew
