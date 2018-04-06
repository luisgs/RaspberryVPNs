#!/bin/bash
#===============================================================================
#
#          FILE:  startingPoint.sh
# 
#         USAGE:  ./startingPoint.sh 
# 
#   DESCRIPTION:  This is the first and only scripts needs to be run. it will 
#		  call the other scripts and ask you for the additional info.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  LuisGS (), luis.ild
#       COMPANY:  Home
#       VERSION:  1.0
#       CREATED:  04/05/18 11:07:11 UTC
#      REVISION:  ---
#===============================================================================
# Include our variable file
source /home/pi/RaspberryVPNs/variables

# Local variables
folder="/etc/openvpn/easy-rsa"
varsFile="$folder/vars"
# varsFile="/tmp/vars"

# Updating and installing OpenVPN
#echo 'Running script'
#
#echo 'Updating, upgrading and installing OpenVPN'
#apt-get update
#apt-get upgrade
#apt-get install -y openvpn easy-rsa
#
#echo 'Creating folder where to store RSA keys'
mkdir -p /etc/openvpn/easy-rsa
cp -R /usr/share/easy-rsa/* $folder


# Modifying our easy-rsa/vars file with: export EASY_RSA="/etc/openvpn/easy-rsa"
echo "Modifying $varsFile file"
# replace all 15 line with our new variable. 
sed -i '15s@.*@export EASY_RSA='"$folder"'@' $varsFile
#openssl is not found dinamically so I forced it to be 1.0.0
sed -i '29s/.*/export KEY_CONFIG=$EASY_RSA\/openssl-1.0.0.cnf/' $varsFile

# Delete lines with default info
sed -i '64,69d' $varsFile
# Adding lines with our personal info.
echo "Adding KEY values such COUNTRY in our $varsFile $KEY_COUNTRY"
sed -i "63a\export KEY_COUNTRY=\"$KEY_COUNTRY\"" $varsFile
sed -i "64a\export KEY_PROVINCE=\"$KEY_PROVINCE\"" $varsFile
sed -i "65a\export KEY_CITY=\"$KEY_CITY\"" $varsFile
sed -i "66a\export KEY_ORG=\"$KEY_ORG\"" $varsFile
sed -i "67a\export KEY_EMAIL=\"$KEY_EMAIL\"" $varsFile
sed -i "68a\export KEY_OU=\"$KEY_OU\"" $varsFile


# Build our certificate
#echo "Build our certificate!"
#source $folder/./vars
#$folder/./clean-all
#$folder/./build-ca
#
## we now start building up our certs!
#echo "Server certificate is gonna be build"
#echo "PLEASE PRESS Y and leave the rest empty"
#$folder/./build-key-server $rpiName
#
#
## Create keys
#echo "Diffie-Hellman key exchange enables the sharing of secret keys over a public server."
#$folder/./build-dh


# Configure your OpenVPN server
echo "We enable ipv4 forwarding"
sed -i '28s/.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p




# COnfiguring our firewall
echo $rpiAddress
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source $rpiAddress
iptables -t nat -v -L

apt-get install -y iptables-persistent
iptables-save > /etc/iptables/rules.v4
cat /etc/iptables/rules.v4









