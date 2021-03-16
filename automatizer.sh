#!/bin/bash

ROOT_DATABASE_PASS="why_4r3_w3_3v3n_d01ng_th1s"
WP_DATABASE_PASS="th3y_t0ld_m3_t0_m4ke_1t_s3cur3"
WP_ADMIN_PASS="secure"
ROOT_FLAG="THM{4dm1n,wh4t_h4v3_u_d0ne???}"
USER_FLAG="THM{h3lp_m3_guy5_1ts_t00_hard}"
ROOT_PASSWORD="00psi3\!1_m3ss3d_up_th3_c0nf1g5"

sudo hostnamectl set-hostname verysecurecorp
sudo apt update && sudo apt upgrade -y 
sudo apt install apache2 openssh-server mysql-server php libapache2-mod-php php-mysql vim curl unzip php7.2-cli -y
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp cli update
sudo chown -R www-data:www-data /var/www
cd /var/www/html

sudo -u www-data rm /var/www/html/index.html
mysqladmin -u root password "$ROOT_DATABASE_PASS"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY'$DATABASE_PASS'"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "DELETE FROM mysql.user WHERE user=''"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "DELETE FROM mysql.db WHERE db='test' OR db='test\_%'"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "CREATE DATABASE wordpress"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "CREATE USER 'wpuser' IDENTIFIED BY '$WP_DATABASE_PASS'"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'"
mysql -u root -p"$ROOT_DATABASE_PASS" -e "FLUSH PRIVILEGES"

sudo -u www-data wp core download
sudo -u www-data wp config create --dbname=wordpress --dbuser=wpuser --dbpass="$WP_DATABASE_PASS"
sudo -u www-data wp core install --url="http://verysecurecorp.thm" --title="Welcome to VerySecureCorp!" --admin_user=admin --admin_email="support@verysecurecorp.thm"
sudo -u www-data wp user update admin --user_pass="$WP_ADMIN_PASS"
cd /var/www/html/wp-content/plugins
sudo -u www-data wget https://downloads.wordpress.org/plugin/wp-file-manager.6.0.zip
sudo -u www-data unzip wp-file-manager.6.0.zip
sudo -u www-data rm wp-file-manager.6.0.zip
sudo -u www-data mv wp-file-manager/*.zip ./wp-file-manager.zip
sudo -u www-data rm -rf wp-file-manager
sudo -u www-data unzip wp-file-manager.zip
sudo -u www-data rm wp-file-manager.zip
sudo -u www-data chmod -R 755 wp-file-manager/
sudo -u www-data wp theme install twentysixteen --activate
sudo -u www-data wp post create --post_content="We just got a new intern!" --post_title="Congratulations!" --post_status=publish --comment_status="open"
sudo -u www-data wp post create --post_content="Our internal pentesting team told us that our wordpress blog is insecure! Guess who will be fixing it!" --post_title="New tasks for our intern" --post_status=publish --comment_status="open"
sudo -u www-data wp post create --post_content="Our intern did an amazing job at changing the passwords! They are really secure now! Hope we're safe now!" --post_title="Updates" --post_status=publish --comment_status="open"
sudo -u www-data echo "define ( 'DISALLOW FILE EDIT' , true );" >> /var/www/html/wp-config.php
cd /
sudo mkdir backups
sudo chmod 777 backups
sudo echo "* * * * * root cd /backups && tar -czf logs.tar.gz /var/log/apache2/access.log" >> /etc/crontab
sudo echo "$ROOT_FLAG" > /root/root.txt
echo "$USER_FLAG" > /home/intern/user.txt
sudo ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/intern/.bash_history
sudo echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | sudo passwd root
sudo sed -i 's|PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin|PATH=.:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin|g' /etc/crontab
sudo deluser intern adm
sudo deluser intern cdrom
sudo deluser intern sudo
sudo deluser intern dip
sudo deluser intern plugdev
sudo deluser intern lpadmin
sudo deluser intern lxd
sudo deluser intern sambashare
