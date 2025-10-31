#!/bin/bash

echo "🔍 Verifica ambiente di sviluppo Apache + Docker"

echo -e "\n📦 1. Verifica porta 80 esposta nel container:"
ss -tuln | grep ':80' || echo "❌ Porta 80 non esposta"

echo -e "\n🧭 2. Verifica ServerName globale:"
grep -i 'ServerName' /etc/apache2/apache2.conf || echo "❌ ServerName non impostato globalmente"

echo -e "\n🧾 3. Verifica VirtualHost attivo:"
apachectl -S | grep hb01.local || echo "❌ VirtualHost hb01.local non attivo"

#echo -e "\n🔧 4. Verifica moduli Apache:"
#apachectl -M | grep proxy && apachectl -M | grep proxy_http || echo "❌ Moduli proxy non attivi"

echo -e "\n🚀 5. Verifica Laravel in ascolto su porta 8000:"
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000 || echo "❌ Laravel non risponde su porta 8000"

echo -e "\n📂 6. Verifica configurazione Directory:"
grep -A5 '<Directory /var/www/html/public>' /etc/apache2/sites-enabled/*.conf || echo "❌ Directory non configurata correttamente"

echo -e "\n✅ Verifica completata."