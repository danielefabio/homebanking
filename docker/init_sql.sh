#!/bin/bash
set -e
source .env

# Pulisci e crea la cartella dei segreti
echo "Inizializzo la cartella dei segreti..."
rm -rf ./docker/secrets
mkdir -p ./docker/secrets
rm -f ./docker/setup.sh

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


# Crea un init script che legge i segreti
echo "✅ Creo lo script di setup MySQL..."
cat > ./docker/compose/setup_mysql.sh << EOF
#!/bin/bash
set -e

if [ -f "\$MYSQL_ROOT_PASSWORD_FILE"] && [ -n "\$MYSQL_ROOT_PASSWORD_FILE" ]; then
  MYSQL_ROOT_PASSWORD=\$(cat \$MYSQL_ROOT_PASSWORD_FILE)
fi

if [ -f "\$MYSQL_APP_PASSWORD_FILE" ] && [ -n "\$MYSQL_APP_PASSWORD_FILE" ]; then
  MYSQL_APP_PASSWORD=\$(cat \$MYSQL_APP_PASSWORD_FILE)
fi

echo "Debug MYSQL_ROOT_PASSWORD: \$MYSQL_ROOT_PASSWORD"
echo "Debug MYSQL_APP_PASSWORD: \$MYSQL_APP_PASSWORD"

if [ -z "\$MYSQL_ROOT_PASSWORD" ] || [ -z "\$MYSQL_APP_PASSWORD" ] || [ -z "\$MYSQL_DATABASE" ] || [ -z "\$MYSQL_APP_USER" ]; then
  echo "❌ Errore: variabili d'ambiente mancanti."
  exit 1
fi

# Usa MYSQL_PWD per evitare warning "Using a password on the command line"
export MYSQL_PWD="\$MYSQL_ROOT_PASSWORD"

mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS \$MYSQL_DATABASE;
CREATE USER '\$MYSQL_APP_USER'@'%' IDENTIFIED BY "\$MYSQL_APP_PASSWORD";
GRANT SELECT, INSERT, UPDATE, DELETE ON \$MYSQL_DATABASE.* TO '\$MYSQL_APP_USER'@'%';
FLUSH PRIVILEGES;
EOSQL

# Infine resetta la variabile per sicurezza
unset MYSQL_PWD
EOF

# Rendi lo script eseguibile
echo "✅ Rendo eseguibile lo script di setup MySQL..."
chmod +x ./docker/compose/setup_mysql.sh

echo "✅ Script di inizializzazione creato con successo."

# Aggiungi /docker/compose/setup_mysql.sh a .gitignore se non già presente
echo "✅ Verifico la presenza di /docker/compose/setup_mysql.sh in .gitignore..."
if ! grep -q "/docker/compose/setup_mysql.sh" .gitignore; then
  echo "/docker/compose/setup_mysql.sh" >> .gitignore
  echo "✅ Aggiunta di /docker/compose/setup_mysql.sh a .gitignore"
fi

echo "✅ Inizializzazione completata."