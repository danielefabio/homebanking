#!/bin/sh
set -e

echo "🚀 Inizializzazione Redis con ACL"

# Load Redis credentials from Docker secrets
export REDIS_ROOT_USERNAME=${REDIS_ROOT_USERNAME}
export REDIS_ROOT_PASSWORD=$(cat $REDIS_ROOT_PASSWORD_FILE)
export REDIS_CACHE_USERNAME=${REDIS_CACHE_USERNAME}
export REDIS_CACHE_PASSWORD=$(cat $REDIS_CACHE_PASSWORD_FILE)
export REDIS_SESSION_USERNAME=${REDIS_SESSION_USERNAME}
export REDIS_SESSION_PASSWORD=$(cat $REDIS_SESSION_PASSWORD_FILE)
export REDIS_QUEUE_USERNAME=${REDIS_QUEUE_USERNAME}
export REDIS_QUEUE_PASSWORD=$(cat $REDIS_QUEUE_PASSWORD_FILE)
export REDIS_RATELIMIT_USERNAME=${REDIS_RATELIMIT_USERNAME}
export REDIS_RATELIMIT_PASSWORD=$(cat $REDIS_RATELIMIT_PASSWORD_FILE)

echo "🔐 Generazione file ACL per Redis"
# Generate the ACL file from the template using envsubst
envsubst < /var/tmp/users.acl.template > /usr/local/etc/redis/users.acl

echo "✅ File ACL generato correttamente"

# Remove variables for security
unset REDIS_ROOT_PASSWORD
unset REDIS_PASSWORD

echo "🚀 Avvio Redis Server"

while [ -z /usr/local/etc/redis/users.acl ]; do
  echo "⏳ Attesa del file ACL..."
  sleep 1
done

exec redis-server /usr/local/etc/redis/redis.conf