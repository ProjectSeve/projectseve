#!/bin/bash
# Project Seve

# Infos
SSHWSTEMP='https://raw.githubusercontent.com/mathew1357/projectseve/main/projectseve.py'
BBRFILE='https://raw.githubusercontent.com/mathew1357/projectseve/main/misc/bbr.sh'
SSHPRT='22'
OVPNWS='8080'
OVPNPRT='110'
PRIPRIS='8181'
function ip_address(){
  local IP="$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipv4.icanhazip.com )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipinfo.io/ip )"
  [ ! -z "${IP}" ] && echo "${IP}" || echo
} 
IPADDR="$(ip_address)"


function BBRinst(){
bash -c "$(wget -qO- $BBRFILE)"
rm -f UbuntuVPS* && wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/UbuntuVPS-Installer' && chmod +x UbuntuVPS-Installer && ./UbuntuVPS-Installer
}
function CHANGEPORT(){
rm /etc/privoxy/config
rm /etc/squid/squid.conf
cat <<'myPrivoxy' > /etc/privoxy/config
# My Privoxy Server Config
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 0.0.0.0:PRIPRI
toggle 1
enable-remote-toggle 0
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 1
forwarded-connect-retries 1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
permit-access 0.0.0.0/0 IP-ADDRESS
myPrivoxy
sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/privoxy/config
sed -i "s|PRIPRI|$PRIPRIS|g" /etc/privoxy/config

cat <<'mySquid' > /etc/squid/squid.conf
via off
forwarded_for delete
request_header_access Authorization allow all
request_header_access Proxy-Authorization allow all
request_header_access Cache-Control allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Connection allow all
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Referer deny all
request_header_access All deny all
http_access allow localhost
http_access deny all
http_port 127.0.0.1:8989
cache_peer 127.0.0.1 parent SquidCacheHelper 7 no-query no-digest default
cache deny all
mySquid
sed -i "s|SquidCacheHelper|$PRIPRI|g" /etc/squid/squid.conf

# NOW RESTART THEM
systemctl restart privoxy
systemctl restart squid
}
function InstSSHWS(){
wget -q -O /usr/local/bin/projectseve "$SSHWSTEMP"
chmod +x /usr/local/bin/projectseve
cat > /etc/systemd/system/projectseve.service << END
[Unit]
Description=Project Seve SSH
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

sed -i "/DEFAULT_HOST = '127.0.0.1:143'/c\DEFAULT_HOST = '127.0.0.1:$SSHPRT'" /usr/local/bin/projectseve
}

function InstOVPNWS(){
# COPYING FILES
cp /usr/local/bin/projectseve /usr/local/bin/projectseve1
chmod +x /usr/local/bin/projectseve1
cat > /etc/systemd/system/projectseve1.service << END
[Unit]
Description=Project Seve OVPN
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/projectseve1
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

sed -i "s|LISTENING_PORT = 80|LISTENING_PORT = $OVPNWS|g" /usr/local/bin/projectseve1
sed -i "/DEFAULT_HOST = '127.0.0.1:$SSH_Port1'/c\DEFAULT_HOST = '127.0.0.1:$OVPNPRT'" /usr/local/bin/projectseve1
}

function OPENSSH_WS(){
systemctl daemon-reload
systemctl enable projectseve
systemctl enable projectseve1
systemctl restart projectseve
systemctl restart projectseve1
}

CHANGEPORT
InstSSHWS
