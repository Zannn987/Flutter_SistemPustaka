<?php
require_once "../config/database.php";

// Ambil raw input
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nim = isset($_POST['nim']) ? $_POST['nim'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';


    if (empty($nim) && !empty($input)) {
        $nim = isset($input['nim']) ? $input['nim'] : '';
        $password = isset($input['password']) ? $input['password'] : '';
    }

    if (empty($nim) || empty($password)) {
        sendJSON([
            'status' => 'error',
            'message' => 'NIM dan password harus diisi'
        ], 400);
    }

    $query = "SELECT * FROM anggota WHERE nim = ? AND password = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $nim, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $data = $result->fetch_assoc();
        sendJSON([
            'status' => 'success',
            'message' => 'Login berhasil',
            'data' => $data
        ]);
    } else {
        sendJSON([
            'status' => 'error',
            'message' => 'NIM atau password salah'
        ], 401);
    }
} else {
    sendJSON([
        'status' => 'error',
        'message' => 'Method tidak diizinkan'
    ], 405);
}
