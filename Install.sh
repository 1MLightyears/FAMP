#!/bin/sh

#setting authorities
echo -e "\033[36m =====================Setting attr========================= \033[0m"
chmod -R 700 FAMP/*.sh
chmod -R 700 *.sh

#install famp stack
echo -e "\033[36m ====================Installing famp======================= \033[0m"
./FAMP/stdard-famp.sh
wait

#using wget to download nextcloud
echo -e "\033[36m =================Downloading nextcloud==================== \033[0m"
wget -O nextcloud.zip https://download.nextcloud.com/server/releases/nextcloud-18.0.0.zip
wait

#unzip it 
echo -e "\033[36m ==================Unzipping nextcloud===================== \033[0m"
unzip -q nextcloud.zip -d .
wait

#defaultly, the root path of apache is /usr/local/www/apache24/data ,
#so there is where nextcloud stuff should be placed at.
net_path="/usr/local/www/apache24/data"
echo -e "\033[36m ===================Moving nextcloud======================= \033[0m"
mv ./nextcloud/* ${net_path}/

#install extra modules for nextclouds 
echo -e "\033[36m ===============Installing Extra modules=================== \033[0m"
pkg install -y php73-zip
pkg install -y php73-mbstring
pkg install -y php73-gd
pkg install -y php73-zlib
pkg install -y php73-cURL
pkg install -y php73-OpenSSL

#Done. The nextcloud server should be able to access at http://localhost/ .


### SETTING UP https. ###

# install openssl
echo -e "\033[36m =====================Setting https======================== \033[0m"
pkg install -y openssl

# generate key
openssl genrsa -out server.key 2048

# make the key a private .csr file
openssl req -new -key server.key -out server.csr

# create a self-signed certificate
openssl req -new -x509 -nodes -sha1 -days 3650 -key server.key -out server.crt -extensions usr_cert

# now the certs are made. Apache https needs server.key and server.crt placed at apache/conf.
local_path="/usr/local"
mv server.key ${local_path}
mv server.crt ${local_path}

# edit httpd.conf
echo -e "\033[36m =======================Sedding============================ \033[0m"
cat Edit_httpd.txt >> ${local_path}/etc/apache24/httpd.conf
wait


# set authentication for apache24
echo -e "\033[36m =====================Auth_set-ing========================= \033[0m"
./auth_set.sh
wait

# now cert are installed .Restart all the service to enable.
echo -e "\033[36m ===================Restarting server====================== \033[0m"
service mysql-server restart
service apache24 restart
