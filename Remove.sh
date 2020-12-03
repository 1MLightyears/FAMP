#! /bin/sh


# This is an Uninstall bash script.
# Make sure to run it at where Install.sh runs.
# Unproper installation of FAMP-N would cause failure and trouble for future re-installation,
# so always use this script to uninstall.


service apache24 stop
service mysql-server stop
rm -r ./nextcloud
rm nextcloud.zip
pkg remove -y apache24
pkg remove -y mysql80-server
pkg remove -y php73
pkg autoremove -y
rm server.key
rm server.csr
rm server.crt
cd ~
rm ./.mysql*
rm -r /usr/local/www/apache24
rm -r /usr/local/etc/apache24
rm -r /var/db/mysql
rm /usr/local/server.key
rm /usr/local/server.crt
