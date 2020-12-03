#! /bin/sh
ocpath='/usr/local/www/apache24' #apache24 directory
htuser='www' #user of apache24 server
htgroup='www'  #group of apache24 server
rootuser='root'

echo -e "\033[32m Creating possible missing Directories\033[0m"
mkdir -p ${ocpath}/data
mkdir -p ${ocpath}/assets
mkdir -p ${ocpath}/updater

echo -e "\033[32m chmod Files and Directories\033[0m"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

echo -e "\033[32m chown Directories\033[0m"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/updater/

chmod -x ${ocpath}/occ

echo -e "\033[32m chmod/chown .htaccess\033[0m"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocpath}/data/.htaccess ]
 then
  chmod 0644 ${ocpath}/data/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess
fi
