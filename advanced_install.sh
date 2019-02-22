if [ $# -ne 1 ]
then
	echo "Usage: $0 install"
	echo "       $0 uninstall"
else
	if [ $1 = "install" ]
	then
		sudo ln -s etc_files/ap /etc/network/interfaces.d/ap
		sudo mv /etc/network/interfaces /etc/network/interfaces.org
		sudo ln -s etc_files/interfaces /etc/network/interfaces
		sudo ln -s etc_files/90-wireless.rules /etc/udev/rules.d/90-wireless.rules
		sudo mv /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant.org
		sudo ln -s etc_files/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
		sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.org
		sudo ln -s etc_files/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
		apt-get update
		sudo apt-get update
		sudo apt-get install -y hostapd dnsmasq iptables-persistent
		sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.org
		sudo ln -s etc_files/dnsmasq.conf /etc/dnsmasq.conf
		sudo ln -s etc_files/hostapd.conf /etc/hostapd/hostapd.conf
		sudo mv /etc/default/hostapd /etc/default/hostapd.org
		sudo ln -s /home/pi/etc_files/hostapd /etc/default/hostapd
    
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.3.141.0/24 ! -d 10.3.141.0/24 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4
    
	elif [ $1 = "uninstall" ]
	then
		sudo mv /etc/network/interfaces.org /etc/network/interfaces
		sudo rm /etc/network/interfaces.d/ap
		sudo rm /etc/udev/rules.d/90-wireless.rules
		sudo mv /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant.org /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
		sudo mv /etc/wpa_supplicant/wpa_supplicant.conf.org /etc/wpa_supplicant/wpa_supplicant.conf
		sudo mv /etc/dnsmasq.conf.org /etc/dnsmasq.conf
		sudo rm /etc/hostapd/hostapd.conf
		sudo mv /etc/default/hostapd.org /etc/default/hostapd
    sed -i '$d' /etc/sysctl.conf
    echo 0 > /proc/sys/net/ipv4/ip_forward
    rm -f /etc/iptables/rules.v4
    
    
	fi
fi
