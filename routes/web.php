<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome', [
        'app_name' => config('app.name'),
    ]);
});
