#!/bin/bash

###########################################################
#
# UC VPN installer
# Author: Sounak Gupta
# Email : guptask@mail.uc.edu
# Source: http://www.scc.kit.edu/scc/net/juniper-vpn/linux/
#
###########################################################

# Check the number of arguments
if test "$#" -ne 1; then
    echo "================================================================="
    echo "Incorrect number of arguments. Type '$0 <6+2 id>'"
    echo "================================================================="
    exit
fi

# Install the required packages by checking the Linux distribution
OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)

case ${OS} in
Debian)
    sudo apt-get install libc6-i386 lib32z1 lib32nss-mdns
    ;;
Ubuntu)
    sudo apt-get realpath install libc6-i386 lib32z1 lib32nss-mdns
    ;;
*)
    #sudo yum install glibc.i686 zlib.i686 nss.i686
    echo "======================================================================="
    echo "Debian and Ubuntu supported currently. Fedora Core support coming soon."
    echo "======================================================================="
    exit
    ;;
esac

# Create the installation path
mkdir -p ~/.juniper_networks/network_connect/

# Find the absolute path of the script
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

# Unzip and copy the installation files
unzip ${SCRIPTPATH}/installer_files/ncLinuxApp.jar -d ~/.juniper_networks/network_connect/

# Change the installation directory permissions
sudo chown root:root ~/.juniper_networks/network_connect/ncsvc
sudo chmod 6711 ~/.juniper_networks/network_connect/ncsvc
chmod 744 ~/.juniper_networks/network_connect/ncdiag

# Copy the vpn login/logoff perl script and change its permission
sudo cp ${SCRIPTPATH}/installer_files/jnc /usr/local/bin/
sudo chmod a+x /usr/local/bin/jnc

# Create a config directory on the installation path
sudo mkdir -p ~/.juniper_networks/network_connect/config

# Copy the user config script
sudo cp ${SCRIPTPATH}/installer_files/uc.conf ~/.juniper_networks/network_connect/config/

# Create the certificate and store it in the config path
# Replace the user field with 6+2 id (first argument)
cd ~/.juniper_networks/network_connect/
sudo bash getx509certificate.sh sslvpn.uc.edu config/uc.crt

eval username="$1"
prefix="sudo sed -i -e 's/unknown/"
suffix="/g' ~/.juniper_networks/network_connect/config/uc.conf"
sedcmd=$prefix$username$suffix
eval $sedcmd

# Post-installation logs
echo "====================================================================="
echo "Installation complete. Check whether it works by logging into UC VPN."
echo "Command for logging  in to UC VPN : jnc --nox uc"
echo "Command for logging out of UC VPN : jnc stop"
echo "====================================================================="

