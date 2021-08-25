#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "PROJECT SEVE TCP Tweaker 1.0" ; tput sgr0
cur_dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

#
#   CREATED BY PROJECT SEVE
#

# Check if running in ROOT
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
	fi

# Create Backup file of SYSTEMCTL
mainconf="/etc/sysctl.conf.bak"
if [ -f "$mainconf" ]; then
    echo "Backup Already Created"
else 
    echo "Creating Backup..."
    sleep 3
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
    echo "Backup Created"
    sleep 1
    clear
fi

if [[ `grep -c "^#ATSL PROJECT" /etc/sysctl.conf` -eq 1 ]]
then
	echo ""
	echo "TCP Tweaker network configuration if added to the system!"
	echo ""
	read -p "Do you want to remove the TCP Tweaker settings?  [y/n]: " -e -i n projectseve0
	if [[ "$projectseve0" = 'y' ]]; then
		grep -v "^#ATSL PROJECT
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null
cp /etc/sysctl.conf.bak /etc/sysctl.conf
		echo ""
		echo "TCP Tweaker network settings were removed successfully." | tee ${cur_dir}/ps_tcp.log
		echo ""
	exit
	else 
		echo ""
		exit
	fi
else
	echo ""
	read -p "Do you want to continue with the installation? [y/n]: " -e -i n resposta
	if [[ "$resposta" = 'y' ]]; then
	echo ""
	echo "Modifying the following settings:"
	echo " " >> /etc/sysctl.conf
	echo "#ATSL PROJECT" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
echo ""
sysctl -p /etc/sysctl.conf
sysctl -w net.core.rmem_max=26214400
sysctl -w net.core.rmem_default=26214400
		echo ""
		echo "The network settings with TCP Tweaker were added correctly."
		echo "Restart your VPS to apply Settings."
		echo ""
	else
		echo ""
		echo "Installation was canceled by user!" 
		echo ""
	fi
fi
# Delete logs from installation to prevent Stealing
rm -rf /root/.bash_history && history -c && echo '' > /var/log/syslog
exit
