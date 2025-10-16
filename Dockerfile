FROM php:8.3-apache

ARG WWWGROUP

# Aggiorna tutti i pacchetti per ridurre le vulnerabilità
RUN apt-get update && apt-get upgrade -y

# Installa pacchetti di sistema e librerie necessarie
RUN apt-get update && \
    apt-get install -y \
    git \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    libpq-dev \
    libmagickwand-dev \
    iproute2

RUN docker-php-ext-install pdo_mysql zip exif pcntl bcmath gd

# Abilita mod_rewrite per Apache (necessario per le route di Laravel)
RUN a2enmod rewrite
#RUN a2enmod proxy proxy_http

# Sovrascrive il file di configurazione di Apache per puntare a /var/www/html/public
#RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Oppure copia direttamente il file di configurazione personalizzato
# Configura Apache per puntare a /var/www/html/public
COPY ./docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Imposta la working directory
WORKDIR /var/www/html

# Copia i file del progetto (ma le dipendenze verranno installate dal container composer)
COPY . /var/www/html

# Permessi per storage e cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Elimina il link simbolico in public/storage (se esiste)
RUN [ -L public/storage ] && rm -f public/storage || echo "No symbolic link to remove"

# Espone la porta 80
EXPOSE 80

# Avvia Apache
#CMD ["apache2-foreground"]

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]