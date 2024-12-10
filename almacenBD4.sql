SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
--
-- Base de datos: `almacen`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getArticulo` (IN `nombre_` VARCHAR(100))   SELECT Nombre, Precio, Stock
from articulos
where Nombre=nombre_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getArticuloPrecio` (IN `precio_` DOUBLE)   SELECT *
from articulos
where Precio > precio_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCantCliente` (IN `ape` VARCHAR(100), OUT `c` INT)   select count(id_cliente)
into c
from clientes
where Apellido like ape$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClienteFacturacion` (IN `id_` INT)   SELECT f.Letra, f.Numero, a.Nombre, f.Fecha, f.Monto 
from facturas as f
INNER JOIN articulos as a
on f.id_articulo = a.id_articulo
where f.id_cliente = id_$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClientesApellido` (IN `letra_` VARCHAR(1))   SELECT *
from clientes
where Apellido LIKE CONCAT(letra_, '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProductoFacturacion` (IN `id` INT, OUT `cant` INT)   SELECT COUNT(id_articulo)
from facturas
WHERE id_articulo = id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

CREATE TABLE `articulos` (
  `id_articulo` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Precio` double UNSIGNED NOT NULL,
  `Stock` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `articulos`
--

INSERT INTO `articulos` (`id_articulo`, `Nombre`, `Precio`, `Stock`) VALUES
(6, 'azucar', 80.5, 30),
(7, 'fideos', 90, 70),
(8, 'yerba', 120.3, 10),
(9, 'gaseosa', 50.3, 70),
(10, 'galletas', 90, 50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Apellido` varchar(35) NOT NULL,
  `CUIT` char(16) DEFAULT NULL,
  `Direccion` varchar(50) DEFAULT NULL,
  `Observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `Nombre`, `Apellido`, `CUIT`, `Direccion`, `Observaciones`) VALUES
(1, 'Daniel', 'Perez', '20-21987654-3', 'Serrano 231', NULL),
(2, 'Sofia', 'Alarcon', '20-86394810-2', 'Las Araucuarias 123', NULL),
(3, 'Pablo', 'Romero', '20-9174803-3', 'Meñoz 111', NULL),
(4, 'Maria', 'Ramirez', '20-93048592-3', 'Lima 312', NULL),
(5, 'Jorge', 'Alarcon', '20-10375829-3', 'Serrano 987', NULL),
(6, 'Leo', 'Messi', '20-6725654-3', 'Serrano 231', NULL),
(7, 'Anibal', 'Chacon', '20-86390913-2', 'Las Araucuarias 123', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `Letra` char(1) NOT NULL,
  `Numero` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `Fecha` date DEFAULT NULL,
  `Monto` double UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`Letra`, `Numero`, `id_cliente`, `id_articulo`, `Fecha`, `Monto`) VALUES
('a', 1, 3, 6, '2022-05-20', 90),
('a', 2, 1, 7, '2022-03-01', 80.5),
('a', 3, 3, 8, '2022-05-02', 120.3),
('a', 4, 3, 9, '2022-05-20', 90),
('a', 5, 5, 10, '2022-03-12', 80.5),
('b', 1, 5, 8, '2022-01-20', 90),
('b', 2, 4, 7, '2022-02-02', 120.3),
('b', 3, 2, 9, '2022-03-02', 50.3);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`id_articulo`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `CUIT` (`CUIT`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`Letra`,`Numero`),
  ADD KEY `fk_cli` (`id_cliente`),
  ADD KEY `fk_art` (`id_articulo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulos`
--
ALTER TABLE `articulos`
  MODIFY `id_articulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `fk_articulo` FOREIGN KEY (`id_articulo`) REFERENCES `articulos` (`id_articulo`),
  ADD CONSTRAINT `fk_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);
COMMIT;
