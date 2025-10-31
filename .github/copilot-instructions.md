## Quick context for AI-assisted edits

This repository is a monolithic Laravel 12 application (PHP 8.3) used as an educational home-banking project. It uses MySQL, Redis and MongoDB (see `docker-compose.yml`) and Vite for assets. The codebase favors thin controllers and moves business logic into `app/Services` and `app/Actions`. Tests are written with Pest (`tests/`) and static analysis uses PHPStan.

## High-level architecture (what to know first)
- Monolith Laravel app with domain-like folders: `app/Models`, `app/Services`, `app/Actions` and `app/Providers`.
- Controllers are orchestration layers — move logic to Services/Actions. Example: a controller will call an Action in `app/Actions` rather than embedding DB logic.
- Persistence: Eloquent models live under `app/Models` (e.g. `app/Models/User.php`). Migrations: `database/migrations`, seeders: `database/seeders` (see `MySQLUserSeeder.php`).
- Async/side-effects: events & listeners are used for notifications and side effects — follow existing event patterns instead of inlining mail or external calls.

## Important files to reference when changing behavior
- `docker-compose.yml` — local docker setup (MySQL, Redis, MongoDB, Vite, Mailhog). Note: the compose file mounts an absolute path by default; users often modify this to match their host.
- `Dockerfile` — PHP container build stages and entrypoint (`entrypoint.sh`).
- `composer.json` — PHP dependencies and composer scripts (see `setup`, `dev`, `test`).
- `package.json` & `vite.config.js` / `vite.config.local.js` — frontend build & dev server (Vite on port 5173). Rename `vite.config.local.js` to `vite.config.js` for local-only setups as described in README.
- `README.md` — authoritative local/dev instructions (Docker vs Local sections). Use it for run commands and environment notes.

## Developer workflows & concrete commands
Use the README as the primary source of truth. Examples frequently used in this repo:

- Start with Docker (recommended for consistent services):
  ```bash
  docker-compose up -d --build
  # app will be available on port 80; Vite on 5173; MailHog on 8025
  ```

- Local (no Docker) quick start (as in README):
  ```bash
  composer install
  npm install
  cp .env.example .env
  php artisan key:generate
  php artisan migrate --seed
  npm run dev
  php artisan serve --host=127.0.0.1 --port=8000
  ```

- Tests & analysis:
  - Run tests: `./vendor/bin/pest` (or `composer test` script)
  - Static analysis: `./vendor/bin/phpstan analyse`
  - Formatting: use `pint` via Composer dev tooling

## Project-specific conventions for code changes
- Controllers: keep them thin. Move business rules into `app/Services` or `app/Actions`.
- Persistence abstractions: prefer using Eloquent models in `app/Models`; if you introduce a repository, place it under `app/Repositories` and add tests.
- Events: when a change causes side-effects (emails, counters, external calls) prefer dispatching an Event and implementing a Listener.
- Seeding/migrations: update `database/migrations` and add a seeder in `database/seeders` when schema changes are required. Update `database/seeders/DatabaseSeeder.php` if needed.

## Integration & infra notes for edits
- Docker secrets are used in `docker/secrets` and referenced in `docker-compose.yml` (DB credentials, mongo passwords). Avoid hardcoding credentials in code.
- Services names in compose: `db` (MySQL), `redis`, `mongodb`, `vite`, `mailhog`. In code, DB_HOST is expected to be `db` in the Docker environment.
- The `vite` dev container runs `npm ci && npm run dev` and exposes port 5173.

## How to make a change safely (mini-contract)
- Inputs: HTTP request body / DB state / queued job payloads.
- Outputs: HTTP response / DB changes / emitted events and jobs.
- Error modes: validation errors, DB transaction failures (use transactions + rollback), permission errors (use middleware/Policy checks).

When implementing a change:
1. Add/modify migrations and a seeder if the schema changes.
2. Implement logic in `app/Services` or `app/Actions` and keep controllers simple.
3. Add unit/feature tests under `tests/` (Pest). Include at least happy path + one failure case.
4. Run `./vendor/bin/pest` and `./vendor/bin/phpstan analyse` before opening a PR.

## Quick examples to copy-paste
- Typical dev compose start:
  ```bash
  docker-compose up -d --build
  docker-compose exec app php artisan migrate --seed
  ```

- Run tests locally:
  ```bash
  ./vendor/bin/pest --filter YourTestName
  ```

## When you need to ask maintainers
- If a change affects data model, migrations, or public API routes, ask for a review and include DB migration plan and seed/sample data.
- If introducing a new external dependency or service (e.g., a payment gateway), document the integration steps and env variables in `README.md`.

## Final note
Use the README and `docker-compose.yml` as the canonical runtime references. Prefer small, test-covered changes and follow the thin-controller / service-layer pattern across the project.

---
If any part is unclear or you'd like the instructions to focus more on CI, PR checks, or a different contributor workflow, tell me what to expand and I'll update the file.
