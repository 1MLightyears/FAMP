#!/bin/sh

# Instructions on how to use this script 

# chmod +x SCRIPTNAME.sh

# sudo ./SCRIPTNAME.sh

# Install Wordpress on FreeBSD after having used the following scripts:
# event-php-fpm.sh
# apache-hardening.sh

# Create the database and user. Mind this is MySQL version 8
# Mind we have Expect already installed on the system because of the previous scripts.
NEW_DATABASE=$(expect -c "
set timeout 10
spawn mysql -u root -p
expect \"Enter password:\"
send \"albertXP-24\r\"
expect \"root@localhost \[(none)\]>\"
send \"CREATE DATABASE Cardona;\r\"
expect \"root@localhost \[(none)\]>\"
send \"CREATE USER 'barrufeta'@'localhost' IDENTIFIED WITH mysql_native_password BY 'barrufetaXP-64';\r\"
expect \"root@localhost \[(none)\]>\"
send \"GRANT ALL PRIVILEGES ON Cardona.* TO 'barrufeta'@'localhost';\r\"
expect \"root@localhost \[(none)\]>\"
send \"FLUSH PRIVILEGES;\r\"
expect \"root@localhost \[(none)\]>\"
send \"exit\r\"
expect eof
")

echo "$NEW_DATABASE"

# Install the missing PHP packages
pkg install -y php74-bz2 php74-curl php74-gd php74-mbstring php74-pecl-mcrypt php74-openssl php74-pdo_mysql php74-zip php74-zlib php74-pecl-imagick-im7

# Because Wordpress and plugins will make use of an .htaccess file, let's enable it.
sed -i -e "278s/AllowOverride None/AllowOverride All/" /usr/local/etc/apache24/httpd.conf

# Restart Apache HTTP so changes take effect
service apache24 restart

# Fetch Wordpress from the official site
fetch https://wordpress.org/latest.tar.gz

# Unpack Wordpress
tar -zxvf latest.tar.gz

# Create the main config file from the sample
cp /root/wordpress/wp-config-sample.php /root/wordpress/wp-config.php

# Add the database name into the wp-config.php file
sed -i -e 's/database_name_here/Cardona/' /root/wordpress/wp-config.php

# Add the username into the wp-config.php file
sed -i -e 's/username_here/barrufeta/' /root/wordpress/wp-config.php

# Add the db password into the wp-config.php file
sed -i -e 's/password_here/barrufetaXP-64/' /root/wordpress/wp-config.php

# Move the content of the wordpress file into the DocumentRoot path
cp -r /root/wordpress/* /usr/local/www/apache24/data

# Change the ownership of the DocumentRoot path content from root to the Apache HTTP user (named www)
chown -R www:www /usr/local/www/apache24/data

# Actions on the CLI are now finished.
echo 'Actions on the CLI are now finished. Please visit the ip/domain of the site with a browser and proceed with the install'
