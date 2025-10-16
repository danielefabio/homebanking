-- Crea il database se non esiste
CREATE DATABASE IF NOT EXISTS laravel
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Crea l'utente dedicato
CREATE USER IF NOT EXISTS 'hbdbus4er'@'%' IDENTIFIED BY 'xSg4v_Oi2u3t!A';

-- Concede i privilegi necessari a Laravel
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, REFERENCES
ON hbdb_01.* TO 'hbdbus4er'@'%';

-- Applica i privilegi
FLUSH PRIVILEGES;