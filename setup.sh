#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1

echo "Mises à jour et installation des paquets..."
apt update -y -q
apt install -y -q git nginx mysql-server php-fpm php-mysql php-xml php-gd php-curl php-zip php-intl php-mbstring unzip

systemctl stop apache2 2>/dev/null
apt-get purge -y apache2* 2>/dev/null

echo "Configuration de MySQL..."
systemctl start mysql
mysql -e "CREATE DATABASE IF NOT EXISTS madavanille;"
mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'qwerty';"
mysql -e "GRANT ALL PRIVILEGES ON madavanille.* TO 'admin'@'localhost';"

echo "Téléchargement de PrestaShop ..."
# Nettoyage vital de vos essais précédents
rm -rf /tmp/prestashop* /var/www/html/mada-vanille

cd /tmp
wget --show-progress https://github.com/PrestaShop/PrestaShop/releases/download/8.1.4/prestashop_8.1.4.zip

echo "Extraction des fichiers..."
# L'option "-o" force l'écrasement sans demander l'avis de l'humain
unzip -o -q prestashop_8.1.4.zip
unzip -o -q prestashop.zip -d /var/www/html/mada-vanille

chown -R www-data:www-data /var/www/html/mada-vanille
chmod -R 755 /var/www/html/mada-vanille

echo "Configuration de Nginx..."
cat <<EOF > /etc/nginx/sites-available/mada-vanille
server {
    listen 80;
    server_name 192.168.121.45;
    root /var/www/html/mada-vanille;
    index index.php index.html;

    fastcgi_read_timeout 300;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;

    location / { try_files \$uri \$uri/ /index.php?\$args; }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }
}
EOF

ln -sf /etc/nginx/sites-available/mada-vanille /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

echo "Ouvrir http://192.168.121.45"
