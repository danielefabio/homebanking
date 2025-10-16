<!--
	README per il progetto: homebanking
	Scopo: file in italiano, strutturato e gradevole, per guidare lo sviluppo e l'apprendimento
-->

<p align="center">
	<img src="https://raw.githubusercontent.com/danielefabio/homebanking/main/assets/logo-placeholder.png" alt="HomeBanking" width="280" style="max-width:100%;">
</p>

<p align="center">
	<a href="https://github.com/danielefabio/homebanking/actions"><img src="https://img.shields.io/github/actions/workflow/status/danielefabio/homebanking/ci.yml?label=CI&logo=github" alt="CI"></a>
	<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/badge/framework-Laravel-red" alt="Laravel"></a>
	<a href="https://www.php.net/"><img src="https://img.shields.io/badge/php-%3E=%208.1-777bb4" alt="PHP"></a>
	<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-brightgreen" alt="License"></a>
</p>

## HomeBanking — Progetto didattico

HomeBanking è un progetto personale creato per esercitarsi con architetture software, problem solving, sicurezza applicativa e le funzionalità tipiche di una applicazione bancaria: gestione utenti, conti, transazioni, pagamenti e reportistica. L'obiettivo non è solo far funzionare le feature, ma imparare a progettare componenti manutenibili, testabili e sicure.

### Perché questo progetto

- Esercitare la progettazione di un'app reale con requisiti non banali.
- Mettere in pratica concetti architetturali (DDD, CQRS, service layer, events).
- Migliorare competenze pratiche: autenticazione/autorizzazione, sicurezza, testing, CI/CD.

## Contratto minimo del progetto

- Input: richieste HTTP (web/UI o API) e dati persistenti (DB).
- Output: interfaccia web e API REST JSON per le operazioni bancarie.
- Error modes: validazione dati, transazioni fallite (rollback), autorizzazioni negate.

## Caratteristiche principali

- Autenticazione e autorizzazione (ruoli: user, manager, admin)
- Gestione conti correnti (apertura, chiusura, saldo)
- Transazioni (bonifici interni, pagamenti, storicizzazione)
- Elenchi e filtri: movimenti, estratti conto, report PDF/CSV
- Notifiche (e-mail / job asincroni per estratti e avvisi)
- Pannello amministrazione base (monitoring, gestione utenti)

## Tech stack

- Backend: PHP 8.3, Laravel 12
- Database: MySQL / SQLite (per sviluppo/test)
- Frontend: Blade + Vite (opzionale: React/Vue per SPA)
- Code style & tools: PHPStan, Pest/PHPUnit, Pint, GitHub Actions

## Requisiti locali

- PHP >= 8.3 con estensioni PDO
- Composer
- Node.js + npm (per asset)
- MySQL o SQLite

## Setup rapido (Windows PowerShell)

1) Clona il repository e posizionati nella cartella del progetto

```powershell
git clone https://github.com/danielefabio/homebanking.git
cd homebanking
```

- PER DOCKER
	2) Lancia il comando per creare i vari container e volume:

	```powershell
	docker-compose up -d --build
	```

- IN LOCALE

	2) Installa le dipendenze PHP e Node

	```powershell
	composer install --no-interaction --prefer-dist
	npm install
	```

	3) Configura l'ambiente

	```powershell
	cp .env.example .env
	# personalizza .env (DB, MAIL, ecc.)
	php artisan key:generate
	```

	4) Crea il database e applica le migration

	```powershell
	php artisan migrate --seed
	```

	5) Avvia l'app in sviluppo

	```powershell
	npm run dev
	php artisan serve --host=127.0.0.1 --port=8000
	```

Visita http://127.0.0.1:8000

## Esempi di comandi utili

- Tests (Pest / PHPUnit)

```powershell
./vendor/bin/pest
# oppure su Windows se ci sono .bat
vendor\bin\pest.bat
```

- Analisi statica

```powershell
./vendor/bin/phpstan analyse
```

## Architettura e convenzioni

- Organizzazione dei domini (app/Models, app/Services, app/Actions)
- Controller sottili: i controller orchestrano, la logica è nei Services/Actions
- Repositori per l'accesso ai dati se serve disaccoppiare Eloquent
- Eventi e listener per side-effect (es. invio mail, aggiornamento contatori)

Nota: segui le convenzioni PSR-12 e usa i tool automatici (Pint, PHPStan) per mantenere qualità.

## Sicurezza e pratiche consigliate

- Usa transazioni DB per operazioni che toccano più entità (es. bonifico).
- Limita importi per richiesta e valida sempre lato server.
- Proteggi le rotte sensibili con middleware (auth, role-check).
- Non salvare dati sensibili in chiaro (es. numeri di carte): applica masking e crittografia a riposo quando necessario.

## Testing

Implementa test automatici per:

- Flusso di apertura conto e primo deposito (happy path + fallimenti)
- Transazioni tra conti (con rollback)
- Permessi/ruoli (accesso alle risorse)

Esempio rapido per creare un test con Pest:

```php
it('crea un conto per un utente', function () {
		// arrange: crea utente
		// act: chiama l'action che crea il conto
		// assert: verifica saldo iniziale, owner
});
```

## API (breve esempio)

- Autenticazione: POST /api/login -> { email, password } -> token
- Richiedi saldo: GET /api/accounts/{id}/balance (auth)
- Esegui bonifico: POST /api/transactions/transfer { from_account_id, to_account_id, amount }

Documenta le rotte API con Swagger/OpenAPI o con Postman collection nella cartella `docs/`.

## Esempi d'uso (flussi utente)

- Utente: registrazione -> verifica email -> login -> crea conto -> effettua bonifico
- Admin: visualizza report -> approva richieste manuali -> genera estratti conto

## Roadmap (possibili estensioni)

1. Integrazione con gateway di pagamento (sandbox)
2. Supporto multi-valuta e tassi di cambio
3. Dashboard analitica con grafici (es. saldo storico)
4. Webhooks per integrazione esterna
5. Refactor CQRS per partizioni di carico

## Come contribuire

1. Apri una issue per discutere la feature/bug.
2. Crea un branch dal tipo `feature/*` o `fix/*`.
3. Scrivi test per la funzionalità.
4. Apri una pull request descrivendo le modifiche.

## Note finali

Questo repository è pensato come laboratorio personale: ogni folder e convenzione sono scelti per facilitare l'apprendimento. Se vuoi, posso:

- aggiungere una checklist di sviluppo (task board)
- generare una collection Postman / OpenAPI
- creare template di test e una CI base

Indicami quale vuoi prima e lo preparo.

---

© Daniele — Progetto HomeBanking • License: MIT

