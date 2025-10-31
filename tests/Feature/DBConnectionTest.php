<?php

# MySQL connection test
use Illuminate\Support\Facades\DB;
test('can connect to MySQL', function () {
    $pdo = DB::connection()->getPdo();

    expect($pdo)->toBeInstanceOf(PDO::class);
});

# MongoDB connection test
use MongoDB\Database as MongoDB;
test('can connect to MongoDB and insert a value', function () {
    $mongodb = DB::connection('mongodb')->getMongoDB();
    expect($mongodb)->toBeInstanceOf(MongoDB::class);

    // Ottieni la collection
    $collection = $mongodb->selectCollection('test_connection');
    // Inserisci un documento
    $result = $collection->insertOne(['status' => 'ok']);
    // Verifica che l’inserimento sia avvenuto
    expect($result->getInsertedCount())->toBe(1);
});


# Redis connection test
use Illuminate\Support\Facades\Redis;
test('can connect to Redis and set a new key with exp time', function () {
    $redis = Redis::connection();
    $test_key = config('database.redis.keys.session') . 'test_connection';
    echo "Using Redis key pattern: " . $test_key . "\n";
    $redis->set($test_key, 'ok', 10);
    $value = $redis->get($test_key);

    expect($value)->toBe('ok');

    // wait for expiry and assert it disappears (sleep only for integration checks)
    sleep(10);
    $expired = Cache::get($test_key);
    expect($expired)->toBeNull();
});

# Cache test
use Illuminate\Support\Facades\Cache;
test('can store and retrieve from cache', function () {
    Cache::put('test_key', 'test_value', 10); // Store for 10 seconds
    echo "PREFIX= " . env('REDIS_CACHE_PREFIX')."\n";
    $value = Cache::get('test_key');
    echo "Value: ".$value."\n";
    expect($value)->toBe('test_value');
});

# Session test
use Illuminate\Support\Facades\Session;
test('can store and retrieve from session', function () {
    Session::put('session_key', 'session_value');
    echo "PREFIX= " . env('REDIS_SESSION_PREFIX')."\n";
    $value = Session::get('session_key');
    echo "Value: ".$value."\n";
    expect($value)->toBe('session_value');
});

# Database migration test
/*use Illuminate\Support\Facades\Artisan;
test('can run database migrations', function () {
    $exitCode = Artisan::call('migrate', ['--force' => true]);
    expect($exitCode)->toBe(0);
});
*/

# Database seeding test
/*
test('can run database seeders', function () {
    $exitCode = Artisan::call('db:seed', ['--force' => true]);
    expect($exitCode)->toBe(0);
});
*/