<?php
$servername = "localhost"; // Servidor MySQL
$username   = "root";      // Usuario de MySQL
$password   = "";          // Contraseña de MySQL
$dbname     = "almacen";  // Nombre de la base de datos
$cant = 0;
// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if($conn->connect_error){
    die("Conexión fallida: " . $conn->connect_error);
}


$sql = "call getCantCliente('Alarcon', @c)";
$conn->query($sql);

$sql = "select @c as cantidad";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
echo $row['cantidad'];
$conn->close();
?>
