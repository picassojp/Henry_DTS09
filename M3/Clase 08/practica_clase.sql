use henry_m3;

-- Clientes que no efectuaron compras
SELECT *
FROM cliente
WHERE IdCliente NOT IN
	(SELECT DISTINCT IdCliente
	FROM venta)
ORDER BY 1;

use henry;
SELECT idAlumno, nombre, apellido, fechaIngreso
FROM alumno
WHERE fechaIngreso >
	(SELECT MIN(fechaIngreso) as fecha
	FROM alumno);
    
SELECT c.IdCliente, c.Nombre_y_Apellido, v.Precio * v.Cantidad AS venta
FROM venta v
JOIN cliente c ON(v.IdCliente = c.IdCliente)
WHERE v.Precio * v.Cantidad >
				(SELECT avg(v.Precio * v.Cantidad)
                FROM venta v
                WHERE v.Outlier = 1)
GROUP BY c.IdCliente, c.Nombre_y_Apellido;

-- Vistas
CREATE VIEW buenos_clientes AS
SELECT c.IdCliente, c.Nombre_y_Apellido, v.Precio * v.Cantidad AS venta
FROM venta v
JOIN cliente c ON(v.IdCliente = c.IdCliente)
WHERE v.Precio * v.Cantidad >
				(SELECT avg(v.Precio * v.Cantidad)
                FROM venta v
                WHERE v.Outlier = 1)
GROUP BY c.IdCliente, c.Nombre_y_Apellido;


ALTER VIEW venta_provincia AS
SELECT 	p.IdProvincia,
		p.Provincia,
		SUM(v.Cantidad) AS cantidad_productos,
        SUM(v.Precio * v.Cantidad) AS total_venta,
        count(v.IdVenta) AS volumen_venta
FROM venta v
JOIN cliente c ON(c.idCliente = v.idCliente)
JOIN localidad l ON (c.IdLocalidad = l.IdLocalidad)
JOIN provincia p ON(l.IdProvincia = p.IdProvincia)
WHERE v.Outlier = 1
GROUP BY p.IdProvincia, p.Provincia
HAVING total_venta > 10000000
ORDER BY p.Provincia;
