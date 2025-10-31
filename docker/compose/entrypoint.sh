#!/bin/sh
set -e

echo "📦 Entrypoint avviato per ambiente: ${APP_ENV:-local}"

# Imposta owner e permessi corretti per Laravel
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "USER: $DB_MIGRATION_USERNAME connection to DB: $DB_HOST/$DB_DATABASE";
#MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
#MYSQL_MIGRATION_PASSWORD=$(cat /run/secrets/db_migration_password)
DB_MIGRATION_PASSWORD=$(cat $DB_MIGRATION_PASSWORD_FILE)

# Attendi che il DB sia pronto
echo "⏳ Attendo il database (${DB_HOST})..."
timeout=60
while ! php -r "new PDO('mysql:host=${DB_HOST};dbname=${DB_DATABASE}', '${DB_MIGRATION_USERNAME}', '${DB_MIGRATION_PASSWORD}');" 2>/dev/null; do
  sleep 2
  timeout=$((timeout - 2))
  [ $timeout -le 0 ] && echo "❌ Timeout connessione DB" && exit 1
done
echo "✅ Database pronto!"

# Esegui comandi Laravel comuni
echo "🔧 Cache e link storage..."
php artisan config:clear
php artisan config:cache
php artisan route:cache
# php artisan storage:link || true

# Esegui migrazioni solo in ambienti non di produzione
if [ "$APP_ENV" != "production" ]; then
  echo "🗝️  Verifica APP_KEY..."
  # Genera APP_KEY se non esiste
  if [ ! -f /var/www/html/.env ]; then
    echo "⚠️  .env non trovato, copia da .env.example"
    cp /var/www/html/.env.example /var/www/html/.env
  fi
  echo "🔑 Controllo chiave applicazione..."
  if ! grep -q "APP_KEY=" /var/www/html/.env || [ -z "$(grep APP_KEY= /var/www/html/.env | cut -d= -f2)" ]; then
    echo "⚠️  APP_KEY non trovata, generazione nuova chiave..."
    php artisan key:generate
  fi

  echo "🛠️  Migrazioni e seeding (env: $APP_ENV)..."
  #php artisan migrate --seed --force
  php artisan migrate:status | tail -n 2 | grep -q 'Ran' || php artisan migrate --seed --force
else
  echo "🔒 Ambiente production: migrazioni disabilitate"
fi

# Avvia Apache
echo "🚀 Avvio Apache..."
exec apache2-foreground