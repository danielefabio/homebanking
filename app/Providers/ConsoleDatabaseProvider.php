<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class ConsoleDatabaseProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        \Log::debug("ConsoleDatabaseProvider loaded");
        if($this->app->runningInConsole()) {
            \Log::debug("ConsoleDatabaseProvider CONSOLE detected");
            //$this->app->configure('database-cli');
            \Config::set('database.default', 'mysql_migrations');
        }
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
