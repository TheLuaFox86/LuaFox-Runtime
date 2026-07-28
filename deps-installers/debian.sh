echo "make sure to run with sudo"
apt install git
apt install wget curl
# install luaver
apt update
apt install build-essential libgirepository-2.0-dev libglib2.0-dev 
sudo apt-get install libreadline-dev 
curl -fsSL https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh | sh -s - -r v1.1.0
#install the rest
mkdir -p /usr/local/lib/lua/5.3
wget https://raw.githubusercontent.com/pkulchenko/serpent/refs/heads/master/src/serpent.lua -O /usr/local/lib/lua/5.3/serpent.lua
. ~/.bashrc #reset shell
luaver install 5.3.6
luaver install-luarocks 3.13.0
#install deps
luarocks install pegasus
luarocks install lunajson
luarocks install luagobject
luarocks install linenoise
luarocks install copas

