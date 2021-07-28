#!/bin/bash
# Project Seve
clear
read -p "New Replace in Status 101: " bake
$bowl = sed '18q;d' /usr/local/bin/projectseve
$bowls = echo "RESPONSE = 'HTTP/1.1 101 <font color="red">$bake</font>\r\n\r\nContent-Length: 104857600000\r\n\r\n'"
sed -i 's|$bowl.*|$bowls|g' /usr/local/bin/projectseve
systemctl restart projectseve
clear
echo "done"
