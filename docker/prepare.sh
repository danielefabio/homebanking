#!/bin/bash
set -e

echo "🚀 Avvio preparazione ambiente Docker..."

if ./docker/init_secrets.sh; then
  echo "❌ Errore durante l'inizializzazione dei segreti"
  exit 1
fi

echo "✅ Preparazione completata."