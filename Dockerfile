# redis_server
FROM redis:7 AS redis_server

# Installa envsubst (parte di gettext)
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Crea la cartella di configurazione
RUN mkdir -p /usr/local/etc/redis \
    && chown redis:redis /usr/local/etc/redis

# Copia il file di configurazione personalizzato
COPY ./docker/compose/redis.conf /usr/local/etc/redis/redis.conf
# Imposta i permessi sul file di configurazione
RUN chown redis:redis /usr/local/etc/redis/redis.conf

# Crea la cartella di log
#RUN mkdir -p /var/log/redis \
#    && chown redis:redis /var/log/redis
#RUN touch /var/log/redis/redis-server.log \
#    && chown redis:redis /var/log/redis/redis-server.log

# Copia lo script di inizializzazione
COPY docker/compose/init_redis.sh /usr/local/bin/entrypoint.sh
# Rende eseguibile lo script di inizializzazione
RUN chmod +x /usr/local/bin/entrypoint.sh
# Imposta lo script di inizializzazione come entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]



# app
FROM php:8.3-apache AS php_app

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
    iproute2 \
    && pecl install redis mongodb \
    && docker-php-ext-enable redis mongodb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-install pdo_mysql zip exif pcntl bcmath gd

# Abilita mod_rewrite per Apache (necessario per le route di Laravel)
RUN a2enmod rewrite
# Abilita mod_proxy e mod_proxy_http per Apache (se necessario)
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
#RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
#    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Elimina il link simbolico in public/storage (se esiste)
RUN [ -L public/storage ] && rm -f public/storage || echo "No symbolic link to remove"

# Espone la porta 80
EXPOSE 80

# Avvia Apache
#CMD ["apache2-foreground"]

RUN ./docker/init_sql.sh

COPY docker/compose/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]