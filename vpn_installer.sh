# UC VPN installation (without using Java)

# Author: Sounak Gupta
# Email : guptask@mail.uc.edu
# Source: http://www.scc.kit.edu/scc/net/juniper-vpn/linux/

#!/bin/bash

if test "$#" -ne 1; then
    echo "===================================================================="
    echo "Incorrect number of arguments. Type 'bash $0 <6+2 id>'"
    echo "===================================================================="
    exit
fi

# Install the required packages by checking the Linux distribution
OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)
sudo apt-get install libc6-i386 lib32z1 lib32nss-mdns
#sudo yum install glibc.i686 zlib.i686 nss.i686

# Delete old installation files (if present)
sudo rm -rf ~/.juniper_networks/
sudo rm -f /usr/local/bin/jnc

# Download the network connect app
wget http://homepages.uc.edu/~guptask/vpn/ncLinuxApp.jar -P ~/Downloads/

# Create the installation path
mkdir -p ~/.juniper_networks/network_connect/

# Unzip and copy the installation files
unzip ~/Downloads/ncLinuxApp.jar -d ~/.juniper_networks/network_connect/

# Delete the downloaded network connect app
rm ~/Downloads/ncLinuxApp.jar

# Change the installation directory permissions
sudo chown root:root ~/.juniper_networks/network_connect/ncsvc
sudo chmod 6711 ~/.juniper_networks/network_connect/ncsvc
chmod 744 ~/.juniper_networks/network_connect/ncdiag

# Download the vpn login/logoff perl script and change its permission
sudo wget http://homepages.uc.edu/~guptask/vpn/jnc -P /usr/local/bin/
sudo chmod a+x /usr/local/bin/jnc

# Create a config directory on the installation path
sudo mkdir -p ~/.juniper_networks/network_connect/config
cd ~/.juniper_networks/network_connect/

# Create the certificate and store it in the config path
sudo bash getx509certificate.sh sslvpn.uc.edu config/uc.crt

# Download the user config script
sudo wget http://homepages.uc.edu/~guptask/vpn/uc.conf \
    -P ~/.juniper_networks/network_connect/config/

# Replace the user field with 6+2 id (first argument)
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
