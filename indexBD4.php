<?php
// Configuración de la base de datos
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "almacen";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Función para ejecutar un procedimiento almacenado con parámetros opcionales
function ejecutarProcedimiento($conn, $procedimiento, $params = []) {
    $query = "CALL $procedimiento(";
    $query .= implode(", ", array_fill(0, count($params), "?")) . ")";
    
    $stmt = $conn->prepare($query);
    
    if (!empty($params)) {
        $types = str_repeat("s", count($params)); // Usar 's' para todos los parámetros
        $stmt->bind_param($types, ...$params);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result) {
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
    return ["error" => $conn->error];
}

// Comenzar la página HTML
echo "<!DOCTYPE html>";
echo "<html lang='es'>";
echo "<head><meta charset='UTF-8'><title>Resultados de Procedimientos</title></head>";
echo "<body>";
echo "<h1>Resultados de los Procedimientos Almacenados</h1>";

// Procedimientos almacenados
echo "<h2>Resultado de getArticulo('azucar')</h2>";
$result = ejecutarProcedimiento($conn, 'getArticulo', ['azucar']);
if (isset($result['error'])) {
    echo "<p>Error: " . $result['error'] . "</p>";
} else {
    foreach ($result as $row) {
        echo "<p>Nombre: {$row['Nombre']}, Precio: {$row['Precio']}, Stock: {$row['Stock']}</p>";
    }
}

echo "<h2>Resultado de getArticuloPrecio(50)</h2>";
$result = ejecutarProcedimiento($conn, 'getArticuloPrecio', [50]);
if (isset($result['error'])) {
    echo "<p>Error: " . $result['error'] . "</p>";
} else {
    foreach ($result as $row) {
        echo "<p>ID: {$row['id_articulo']}, Nombre: {$row['Nombre']}, Precio: {$row['Precio']}, Stock: {$row['Stock']}</p>";
    }
}

echo "<h2>Resultado de getClientesApellido('A')</h2>";
$result = ejecutarProcedimiento($conn, 'getClientesApellido', ['A']);
if (isset($result['error'])) {
    echo "<p>Error: " . $result['error'] . "</p>";
} else {
    foreach ($result as $row) {
        echo "<p>ID: {$row['id_cliente']}, Nombre: {$row['Nombre']}, Apellido: {$row['Apellido']}</p>";
    }
}

echo "<h2>Resultado de getCantCliente('A%')</h2>";
$cantClientes = null;
$stmt = $conn->prepare("CALL getCantCliente(?, @c)");
$stmt->bind_param("s", $apellidoEjemplo = 'A%');
$stmt->execute();
$cantClientesResult = $conn->query("SELECT @c AS cantidad");
if ($cantClientesResult) {
    $cantClientes = $cantClientesResult->fetch_assoc();
    echo "<p>Cantidad de clientes con apellido 'A%': {$cantClientes['cantidad']}</p>";
} else {
    echo "<p>Error al ejecutar getCantCliente</p>";
}

echo "<h2>Resultado de getClienteFacturacion(3)</h2>";
$result = ejecutarProcedimiento($conn, 'getClienteFacturacion', [3]);
if (isset($result['error'])) {
    echo "<p>Error: " . $result['error'] . "</p>";
} else {
    foreach ($result as $row) {
        echo "<p>Letra: {$row['Letra']}, Número: {$row['Numero']}, Nombre: {$row['Nombre']}, Fecha: {$row['Fecha']}, Monto: {$row['Monto']}</p>";
    }
}

echo "<h2>Resultado de getProductoFacturacion(6)</h2>";
$cantProductos = null;
$stmt = $conn->prepare("CALL getProductoFacturacion(?, @cant)");
$stmt->bind_param("i", $productoEjemplo = 6);
$stmt->execute();
$cantProductosResult = $conn->query("SELECT @cant AS cantidad");
if ($cantProductosResult) {
    $cantProductos = $cantProductosResult->fetch_assoc();
    echo "<p>Cantidad de facturas del producto con ID 6: {$cantProductos['cantidad']}</p>";
} else {
    echo "<p>Error al ejecutar getProductoFacturacion</p>";
}

// Cerrar conexión
$conn->close();

// Terminar la página HTML
echo "</body>";
echo "</html>";
?>
