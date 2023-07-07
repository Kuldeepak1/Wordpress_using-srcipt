
#!/bin/bash

# Ask user to enter site name
if [ -z "$1" ]; then
    echo "Please provide a site name:"
    exit 1
fi

# Variables
site_name="$1"
wordpress_dir="/var/www/html/$site_name"
nginx_conf="/etc/nginx/sites-available/$site_name"
nginx_conf_link="/etc/nginx/sites-enabled/$site_name"

echo "============================================================================================================="
# Check if WordPress directory is already present for provided site name
if [ -d "$wordpress_dir" ]; then
    echo "The Site $wordpress_dir is already exists. Please pic a different site name."
    exit 1
fi
echo "============================================================================================================="
# Install required packages required for set up
echo "============================================================================================================="
apt-get update
apt-get install -y nginx mariadb-server php-fpm php-mysql
echo "============================================================================================================="

# Start Nginx and MySQL services
echo "============================================================================================================="
systemctl start nginx
systemctl start mariadb
echo "============================================================================================================="
# Configure Nginx server
echo "Configuring Nginx"
echo "============================================================================================================="
cp /etc/nginx/sites-available/default "$nginx_conf"
sed -i "s|/var/www/html|$wordpress_dir|g" "$nginx_conf"
ln -s "$nginx_conf" "$nginx_conf_link"
systemctl restart nginx
echo "============================================================================================================="
# Configure MySQL
echo "Setting up Database for Wordpress"
echo "============================================================================================================="
#mysql_secure_installation

mysql -e "CREATE DATABASE $dbname;"
echo "Creating new user..."
echo "============================================================================================================="
mysql -e "CREATE USER '$user'@'%' IDENTIFIED BY '$pass';"
echo "User successfully created!"
echo "============================================================================================================="
echo "Granting ALL privileges on $dbname to $user!"
echo "============================================================================================================="
mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$user'@'%';"
echo "============================================================================================================="
mysql -e "FLUSH PRIVILEGES;"
echo "Database setup is successfull :)"
echo "============================================================================================================="


# Download and extract WordPress
echo "Downloading latest version of WordPress "
echo "============================================================================================================="
wget -qO /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf /tmp/latest.tar.gz -C /tmp/

# Move WordPress files to the desired directory
echo "Copying files to /tmp"
mv /tmp/wordpress "$wordpress_dir"

# Configure WordPress
echo "Configuring WordPress in progress..."
echo "============================================================================================================="
#cp "$wordpress_dir/wp-config-sample.php" "$wordpress_dir/wp-config.php"
#sed -i "s/database_name_here/$site_name/g" "$wordpress_dir/wp-config.php"
#sed -i "s/username_here/root/g" "$wordpress_dir/wp-config.php"
#sed -i "s/password_here/root_password/g" "$wordpress_dir/wp-config.php"

# Set permissions
echo "Permission configuration in progress..."
echo "============================================================================================================="

chown -R www-data:www-data "$wordpress_dir"
chmod -R 755 "$wordpress_dir"

# Restart services
echo "Restarting LEMP services"
echo "============================================================================================================="
systemctl restart nginx
systemctl restart php7.4-fpm

# Clean up temporary files
echo "Cleaning up temporary files and data"
echo "============================================================================================================="
rm -rf /tmp/latest.tar.gz
echo "============================================================================================================="
echo "WordPress site '$site_name' has been created successfully."
echo "============================================================================================================="
echo "Open the brower and enter https://<server-url>/'$site_name'"

echo "$site_name" > /etc/hosts

