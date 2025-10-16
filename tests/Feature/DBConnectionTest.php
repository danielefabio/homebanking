<?php

use Illuminate\Support\Facades\DB;

test('can connect to the database', function () {
    $pdo = DB::connection()->getPdo();

    expect($pdo)->toBeInstanceOf(PDO::class);
});