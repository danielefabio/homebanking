#!/bin/sh

echo "🚀 Starting entrypoint script..."

# Exit on error
set -e

# Attendi che il DB sia pronto
echo "⏳ Waiting for database..."
until php -r "new PDO('mysql:host=${DB_HOST};dbname=${DB_NAME}', '${DB_USER}', '${DB_PASSWORD}');" 2>/dev/null; do
  sleep 2
  timeout=$((timeout - 2))
  [ $timeout -le 0 ] && echo "❌ Timeout waiting for DB" && exit 1
done

echo "✅ Database is ready!"

# Esegui le migrazioni
echo "🚀 Running migrations..."
php artisan migrate:status | grep 'Pending' | tail -n 1 | grep -q 'Pending' && php artisan migrate --seed --force

# Avvia Apache
exec apache2-foreground