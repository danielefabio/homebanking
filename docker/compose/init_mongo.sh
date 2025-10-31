# init.sh
set -e

MONGODB_PASSWORD=$(cat $MONGO_PASSWORD_FILE)

mongosh <<EOF
use admin
db.createUser({
  user: '$MONGO_USER',
  pwd:  '$MONGODB_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: '$MONGO_DATABASE'
  }]
})
EOF