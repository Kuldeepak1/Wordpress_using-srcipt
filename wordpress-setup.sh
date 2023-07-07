#!/bin/bash

#apt update && apt upgrade

# install apache2
apt install apache2 -y

#restart the apache 2
systemctl restart apache2

#Install MariaDB
apt install mariadb-server mariadb-client -y

#Install PHP
apt install php php-mysql -y

# Check if site name argument is provided
if [ -z "$1" ]; then
    echo "Please provide a site name as a command-line argument."
    exit 1
fi

# Variables
site_name="$1"
wordpress_dir="/var/www/html/$site_name"
wordpress_latest="https://wordpress.org/latest.tar.gz"

# Check if WordPress directory already exists
if [ -d "$wordpress_dir" ]; then
    echo "The directory $wordpress_dir already exists. Please choose a different site name."
    exit 1
fi

# Download the latest WordPress version
echo "Downloading the latest WordPress version..."
wget -qO /tmp/wordpress.tar.gz "$wordpress_latest"

# Extract the WordPress files
echo "Extracting WordPress files..."
tar -xzf /tmp/wordpress.tar.gz -C /tmp/

# Create the WordPress directory and move files
echo "Creating the WordPress directory..."
mkdir "$wordpress_dir"
mv /tmp/wordpress/* "$wordpress_dir"

user="wp_user"
pass="wordpress123513"
dbname="wp_db"

echo "create db name"
mysql -e "CREATE DATABASE $dbname;"
echo "Creating new user..."
mysql -e "CREATE USER '$user'@'%' IDENTIFIED BY '$pass';"
echo "User successfully created!"
echo "Granting ALL privileges on $dbname to $user!"
mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$user'@'%';"
mysql -e "FLUSH PRIVILEGES;"
echo "Success :)"


# Configure the WordPress installation
#echo "Configuring the WordPress installation..."
#cp "$wordpress_dir/wp-config-sample.php" "$wordpress_dir/wp-config.php"
#sed -i "s/database_name_here/$site_name/g" "$wordpress_dir/wp-config.php"
#sed -i "s/username_here/root/g" "$wordpress_dir/wp-config.php"
#sed -i "s/password_here/root_password/g" "$wordpress_dir/wp-config.php"

# Set correct permissions
echo "Setting permissions..."
chown -R www-data:www-data "$wordpress_dir"
find "$wordpress_dir" -type d -exec chmod 755 {} \;
find "$wordpress_dir" -type f -exec chmod 644 {} \;

mkdir -p /var/www/html/wordpress/wp-content/uploads
chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/

# Clean up temporary files
echo "Cleaning up..."
rm -rf /tmp/wordpress*
echo "WordPress installation complete."

# Optional: Restart web server (uncomment the appropriate line for your server)
# systemctl restart apache2
# systemctl restart nginx
