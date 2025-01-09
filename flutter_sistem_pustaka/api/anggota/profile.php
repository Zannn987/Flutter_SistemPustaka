<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $id = isset($_GET['id']) ? $_GET['id'] : '';

    if (empty($id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'ID anggota tidak ditemukan'
        ]);
        exit;
    }


    $query = "SELECT id, nama, alamat, jenis_kelamin FROM anggota WHERE id = ? LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $profile = $result->fetch_assoc();
        echo json_encode([
            'status' => 'success',
            'data' => $profile
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Profile tidak ditemukan'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
