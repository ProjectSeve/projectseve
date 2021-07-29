#!/bin/bash
# Project Seve


# Install AutoScript
rm -f UbuntuVPS* && wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/UbuntuVPS-Installer' && chmod +x UbuntuVPS-Installer && ./UbuntuVPS-Installer

# Dropbear Setup
# No need


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

sed -i "/DEFAULT_HOST = '127.0.0.1:143'/c\DEFAULT_HOST = '127.0.0.1:550'" /usr/local/bin/projectseve

systemctl daemon-reload
systemctl enable projectseve
systemctl restart projectseve

clear

sleep 2
echo "DONE now type, 'usernew' ro create a ssh account"
