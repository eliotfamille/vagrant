#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1

echo "================================================================="
echo "Mises à jour et installation des paquets..."
echo "================================================================="
apt update -y -q
apt install -y -q git nginx mysql-server php-fpm php-mysql php-xml php-gd php-curl php-zip php-intl php-mbstring unzip

systemctl stop apache2 2>/dev/null
apt-get purge -y apache2* 2>/dev/null

echo "================================================================="
echo "Configuration de MySQL..."
echo "================================================================="
systemctl start mysql
mysql -e "CREATE DATABASE IF NOT EXISTS madavanille;"
mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'qwerty';"
mysql -e "GRANT ALL PRIVILEGES ON madavanille.* TO 'admin'@'localhost';"

echo "================================================================="
echo "Téléchargement de PrestaShop..."
echo "================================================================="
rm -rf /tmp/prestashop* /var/www/html/mada-vanille

cd /tmp
wget --show-progress https://github.com/PrestaShop/PrestaShop/releases/download/8.1.4/prestashop_8.1.4.zip

echo "Extraction des fichiers..."
unzip -o -q prestashop_8.1.4.zip
unzip -o -q prestashop.zip -d /var/www/html/mada-vanille

chown -R www-data:www-data /var/www/html/mada-vanille
chmod -R 755 /var/www/html/mada-vanille

echo "================================================================="
echo "Configuration de Nginx (Routage Symfony & Admin fix)..."
echo "================================================================="
# Utilisation de 'EOF' sécurisé : aucun symbole $ n'a besoin d'être échappé
cat << 'EOF' > /etc/nginx/sites-available/mada-vanille
server {
    listen 80;
    server_name 192.168.121.45 mada-vanille Mada-vanille;
    root /var/www/html/mada-vanille;
    index index.php index.html;

    fastcgi_read_timeout 300;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ /\. { deny all; }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
    }

    location ~ [^/]\.php(/|$) {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;

        if (!-f $document_root$fastcgi_script_name) {
            return 404;
        }

        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;

        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
EOF

ln -sf /etc/nginx/sites-available/mada-vanille /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

echo "================================================================="
echo "Installation automatisée de PrestaShop via CLI..."
echo "================================================================="
cd /var/www/html/mada-vanille/install

sudo -u www-data php -d memory_limit=512M index_cli.php \
    --language=fr \
    --country=mg \
    --domain=192.168.121.45 \
    --db_server=127.0.0.1 \
    --db_name=madavanille \
    --db_user=admin \
    --db_password=qwerty \
    --shop="MadaVanille" \
    --email=admin@madavanille.local \
    --password=password1234

# Suppression réglementaire du dossier d'installation
rm -rf /var/www/html/mada-vanille/install

# Détection automatique du nom du dossier admin généré
ADMIN_FOLDER=$(basename $(find /var/www/html/mada-vanille -maxdepth 1 -type d -name "admin*"))

# Ajustement final des permissions pour Nginx
chown -R www-data:www-data /var/www/html/mada-vanille
chmod -R 755 /var/www/html/mada-vanille
#echo $ADMIN_FOLDER
echo -e "\n"
echo "================================================================="
echo "🎉 INFRASTRUCTURE MADA-VANILLE DÉPLOYÉE AVEC SUCCÈS !"
echo "================================================================="
echo "🛒 Site Front-Office : http://192.168.121.45"
echo "🔐 Back-Office (Admin) : http://192.168.121.45/$ADMIN_FOLDER/"
echo "================================================================="
echo "👤 Identifiant  : admin@madavanille.local"
echo "🔑 Mot de passe : password1234"
echo "================================================================="
