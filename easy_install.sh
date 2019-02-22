#!/bin/bash
sudo sh -c 'echo root:thispasswordforroot | chpasswd
su root

echo "allow-hotplug uap0
auto uap0
iface uap0 inet static
    address 10.3.141.1
    netmask 255.255.255.0" > /etc/network/interfaces.d/ap
    
    
echo "ACTION=="add", SUBSYSTEM=="ieee80211", KERNEL=="phy0", \
    RUN+="/sbin/iw phy %k interface add uap0 type __ap"" > /etc/udev/rules.d/90-wireless.rules




echo "if [ -z "$wpa_supplicant_conf" ]; then
	for x in \
		/etc/wpa_supplicant/wpa_supplicant-"$interface".conf \
		/etc/wpa_supplicant/wpa_supplicant.conf \
		/etc/wpa_supplicant-"$interface".conf \
		/etc/wpa_supplicant.conf \
	; do
		if [ -s "$x" ]; then
			wpa_supplicant_conf="$x"
			break
		fi
	done
fi
: ${wpa_supplicant_conf:=/etc/wpa_supplicant.conf}

if [ "$ifwireless" = "1" ] && \
    type wpa_supplicant >/dev/null 2>&1 && \
    type wpa_cli >/dev/null 2>&1
then
	if [ "$reason" = "IPV4LL" ]; then
		wpa_supplicant -B -iwlan0 -f/var/log/wpa_supplicant.log -c/etc/wpa_supplicant/wpa_supplicant.conf
	fi
fi" > /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant

echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=IN

network={
    ssid="_ST_SSID_"
    psk="_ST_PASSWORD_"
    key_mgmt=WPA-PSK
} " > /etc/wpa_supplicant/wpa_supplicant.conf

apt-get update
apt-get install -y hostapd dnsmasq iptables-persistent

echo "interface=uap0
ssid=_AP_SSID_
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=_AP_PASSWORD_
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" >/etc/hostapd/hostapd.conf

echo " DAEMON_CONF="/etc/hostapd/hostapd.conf" >> /etc/default/hostapd


echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.3.141.0/24 ! -d 10.3.141.0/24 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4


