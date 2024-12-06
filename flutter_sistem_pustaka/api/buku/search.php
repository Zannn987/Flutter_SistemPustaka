<?php
require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $keyword = isset($_GET['keyword']) ? $_GET['keyword'] : '';

    if (empty($keyword)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Keyword pencarian tidak boleh kosong'
        ]);
        exit;
    }


    $search = "%$keyword%";
    $query = "SELECT * FROM buku 
             WHERE judul LIKE ? 
             OR pengarang LIKE ? 
             OR penerbit LIKE ?
             ORDER BY judul ASC";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("sss", $search, $search, $search);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result) {
        $buku = array();
        while ($row = $result->fetch_assoc()) {
            $buku[] = array(
                'id' => $row['id'],
                'judul' => $row['judul'],
                'pengarang' => $row['pengarang'],
                'penerbit' => $row['penerbit'],
                'tahun_terbit' => $row['tahun_terbit'],
                'stok' => $row['stok']
            );
        }

        echo json_encode([
            'status' => 'success',
            'message' => 'Pencarian buku berhasil',
            'data' => $buku
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Gagal melakukan pencarian buku'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
