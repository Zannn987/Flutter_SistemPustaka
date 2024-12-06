<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include_once '../config/database.php';

try {
    $query = "SELECT * FROM anggota";
    $result = mysqli_query($conn, $query);
    $anggota = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $anggota[] = array(
                'id' => $row['id'],
                'nim' => $row['nim'],
                'nama' => $row['nama'],
                'alamat' => $row['alamat'],
                'jenis_kelamin' => $row['jenis_kelamin']
            );
        }
        echo json_encode([
            'status' => 'success',
            'data' => $anggota
        ]);
    } else {
        echo json_encode([
            'status' => 'success',
            'data' => []
        ]);
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
