#!/bin/bash
set -e
source .env

# Pulisci e crea la cartella dei segreti
echo "Inizializzo la cartella dei segreti..."
rm -rf ./docker/secrets
mkdir -p ./docker/secrets

#echo "Variabili d’ambiente:"
#echo "MYSQL_DATABASE: $DB_DATABASE"
#echo "MYSQL_APP_USER: $DB_USERNAME"
#echo "MYSQL_APP_PASSWORD: $DB_PASSWORD"
#echo "MYSQL_ROOT_PASSWORD: $DB_ROOT_PASSWORD"

# Salva le password nei file di segreti
echo "Salvo le password nei file di segreti..."
echo $DB_ROOT_PASSWORD > ./docker/secrets/db_root_password.txt
echo $DB_PASSWORD > ./docker/secrets/db_app_password.txt
echo $DB_MIGRATION_PASSWORD > ./docker/secrets/db_migration_password.txt