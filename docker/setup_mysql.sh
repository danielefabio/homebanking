#!/bin/bash
set -e

if [ -f "$MYSQL_ROOT_PASSWORD_FILE"] && [ -n "$MYSQL_ROOT_PASSWORD_FILE" ]; then
  MYSQL_ROOT_PASSWORD=$(cat $MYSQL_ROOT_PASSWORD_FILE)
fi

if [ -f "$MYSQL_APP_PASSWORD_FILE" ] && [ -n "$MYSQL_APP_PASSWORD_FILE" ]; then
  MYSQL_APP_PASSWORD=$(cat $MYSQL_APP_PASSWORD_FILE)
fi

echo "Debug MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"
echo "Debug MYSQL_APP_PASSWORD: $MYSQL_APP_PASSWORD"

if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_APP_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_APP_USER" ]; then
  echo "❌ Errore: variabili d'ambiente mancanti."
  exit 1
fi

# Usa MYSQL_PWD per evitare warning "Using a password on the command line"
export MYSQL_PWD="$MYSQL_ROOT_PASSWORD"

mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER '$MYSQL_APP_USER'@'%' IDENTIFIED BY "$MYSQL_APP_PASSWORD";
GRANT SELECT, INSERT, UPDATE, DELETE ON $MYSQL_DATABASE.* TO '$MYSQL_APP_USER'@'%';
FLUSH PRIVILEGES;
EOSQL

# Infine resetta la variabile per sicurezza
unset MYSQL_PWD
