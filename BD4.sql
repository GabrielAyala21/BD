create PROCEDURE getClientes(IN nombre_ varchar(100))
SELECT Nombre, Precio, Stock
from articulos
where Nombre=nombre_;

create PROCEDURE getArticuloPrecio(IN precio_ double)
SELECT *
from articulos
where Precio > precio_;

create PROCEDURE getClientesApellido(IN letra_ varchar(1))
SELECT *
from clientes
where Apellido LIKE CONCAT(letra_, '%');

create PROCEDURE cetClienteFacturacion(IN id_ int)
SELECT f.Letra, f.Numero, a.Nombre, f.Fecha, f.Monto 
from facturas as f
INNER JOIN articulos as a
on f.id_articulo = a.id_articulo
where f.id_cliente = id_;

create PROCEDURE getProductoFacturacion(IN id_ int, OUT cantidad_ int)
select count(id_cliente)
into c
from clientes;
