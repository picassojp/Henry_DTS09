use henry_m3;

-- 1. Obtener un listado del nombre y apellido de cada cliente
-- que haya adquirido algun producto junto al id del producto y su respectivo precio.
SELECT c.Nombre_y_Apellido, v.IdProducto, v.Precio
FROM cliente c
JOIN venta v ON(c.idCliente = v.idCliente);

-- 2. Obteber un listado de clientes con la cantidad de productos adquiridos,
-- incluyendo aquellos que nunca compraron algún producto.
SELECT c.IdCliente, c.Nombre_y_Apellido,
		SUM(v.Cantidad) AS cantidad_productos_null,
        SUM(ifnull(v.Cantidad, 0)) AS cantidad_productos
FROM cliente c
LEFT JOIN venta v ON(c.idCliente = v.idCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido
ORDER BY cantidad_productos DESC;

-- SELECT ifnull(null, 0);

-- 3. Obtener un listado de cual fue el volumen de compra (cantidad) por año de cada cliente. 
SELECT c.IdCliente, c.Nombre_y_Apellido, year(v.Fecha), count(v.idVenta) AS total_compras
FROM venta v
JOIN cliente c ON(c.idCliente = v.idCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, year(v.Fecha)
ORDER BY 1, 3;

-- 4. Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto
-- junto al id del producto, la cantidad de productos adquiridos y el precio promedio.
SELECT c.IdCliente, c.Nombre_y_Apellido, v.IdProducto,
		SUM(v.Cantidad) as cantidad_productos,
        ROUND(avg(v.Precio),2) as precio_promedio
FROM cliente c
JOIN venta v ON(c.idCliente = v.idCliente)
GROUP BY c.IdCliente, c.Nombre_y_Apellido, v.IdProducto
ORDER BY c.IdCliente;

-- 5. Cacular la cantidad de productos vendidos y la suma total de ventas para cada
-- localidad, presentar el análisis en un listado con el nombre de cada localidad.
SELECT p.Provincia, l.Localidad,
		SUM(v.Cantidad) AS cantidad_productos,
        SUM(v.Precio * v.Cantidad) AS total_venta,
        count(v.IdVenta) AS volumen_venta
FROM venta v
-- JOIN sucursal s ON(v.IdSucursal = s.IdSucursal)
JOIN cliente c ON(c.idCliente = v.idCliente)
JOIN localidad l ON (c.IdLocalidad = l.IdLocalidad)
-- JOIN localidad l ON (s.IdLocalidad = l.IdLocalidad)
JOIN provincia p ON(l.IdProvincia = p.IdProvincia)
WHERE v.Outlier = 1
GROUP BY p.Provincia, l.Localidad
ORDER BY p.Provincia, l.Localidad;

-- 6. Cacular la cantidad de productos vendidos y la suma total de ventas
-- para cada provincia, presentar el análisis en un listado con el nombre
-- de cada provincia, pero solo en aquellas donde la suma total de las ventas fue superior a $100.000.
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
HAVING total_venta > 100000
ORDER BY p.Provincia;

-- 7. Obtener un listado de cantidad de productos vendidos por rango etario
-- y las ventas totales en base a esta misma dimensión.
SELECT c.Rango_Etario,
		SUM(v.Cantidad) AS cantidad_productos,
        SUM(v.Precio * v.Cantidad) AS total_venta
FROM venta v
JOIN cliente c ON(c.idCliente = v.idCliente)
WHERE v.Outlier = 1
GROUP BY c.Rango_Etario
ORDER BY total_venta DESC;

-- 8. Obtener la cantidad de clientes por provincia.
SELECT p.IdProvincia, p.Provincia, count(c.IdCliente) AS cantidad_clientes
FROM provincia p
LEFT JOIN localidad l ON(p.IdProvincia = l.IdProvincia)
LEFT JOIN cliente c ON(l.IdLocalidad = c.IdLocalidad)
GROUP BY p.IdProvincia, p.Provincia
ORDER BY p.Provincia;
