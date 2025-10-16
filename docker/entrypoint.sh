#!/bin/sh

set -e

echo "📦 Entrypoint avviato per ambiente: ${APP_ENV:-local}"

# Attendi che il DB sia pronto
echo "⏳ Attendo il database (${DB_HOST})..."
timeout=60
while ! php -r "new PDO('mysql:host=${DB_HOST};dbname=${DB_NAME}', '${DB_USER}', '${DB_PASSWORD}');" 2>/dev/null; do
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
  echo "🛠️  Migrazioni e seeding (env: $APP_ENV)..."
  #php artisan migrate --seed --force
  php artisan migrate:status | tail -n 2 | grep -q 'Ran' || php artisan migrate --seed --force
else
  echo "🔒 Ambiente production: migrazioni disabilitate"
fi

# Avvia Apache
echo "🚀 Avvio Apache..."
exec apache2-foreground