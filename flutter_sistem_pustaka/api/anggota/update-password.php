<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $old_password = $_POST['old_password'];
    $new_password = $_POST['new_password'];

    if (empty($id) || empty($old_password) || empty($new_password)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Semua field harus diisi'
        ]);
        exit;
    }


    $query = "SELECT password FROM anggota WHERE id = ? LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $anggota = $result->fetch_assoc();


        if ($old_password == 'admin123') {

            $query = "UPDATE anggota SET password = ? WHERE id = ?";
            $stmt = $conn->prepare($query);
            $stmt->bind_param("ss", $new_password, $id);

            if ($stmt->execute()) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Password berhasil diupdate'
                ]);
            } else {
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal mengupdate password'
                ]);
            }
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Password lama salah'
            ]);
        }
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Anggota tidak ditemukan'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
