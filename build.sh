#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running GUY   #
#################################################################
sudo apt-get update
#################################################################
# Build GUY from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building GUY           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/GUYX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/GUYproject/GUYX.git
fi

cd /usr/local/GUYX/src
file=/usr/local/GUYX/src/GUYd
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/GUYX/src/GUYd /usr/bin/GUYd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.GUY
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.GUY
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.GUY/GUY.conf
file=/etc/init.d/GUY
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo GUYd' | sudo tee /etc/init.d/GUY
        sudo chmod +x /etc/init.d/GUY
        sudo update-rc.d GUY defaults
fi

/usr/bin/GUYd
echo "GUY has been setup successfully and is running..."
exit 0

