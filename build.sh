#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running MMR   #
#################################################################
sudo apt-get update
#################################################################
# Build MMR from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building MMR           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/MMRX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/sigtproject/MMRX.git
fi

cd /usr/local/MMRX/src
file=/usr/local/MMRX/src/MMRdhttps://github.com/anonfgc/MMR
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/MMRX/src/MMRd /usr/bin/MMRd

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.MMR
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.MMR
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.MMR/MMR.conf
file=/etc/init.d/MMR
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo MMRd' | sudo tee /etc/init.d/MMR
        sudo chmod +x /etc/init.d/MMR
        sudo update-rc.d MMR defaults
fi

/usr/bin/MMRd
echo "MMR has been setup successfully and is running..."
exit 0

