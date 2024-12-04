<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$pass = "";
$db = "sistem_pustaka";

try {
    $conn = new mysqli($host, $user, $pass, $db);

    if ($conn->connect_error) {
        throw new Exception($conn->connect_error);
    }


    $conn->set_charset("utf8");
} catch (Exception $e) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Koneksi database gagal: ' . $e->getMessage()
    ]));
}

function sendJSON($data, $status = 200)
{
    http_response_code($status);
    echo json_encode($data);
    exit();
}
