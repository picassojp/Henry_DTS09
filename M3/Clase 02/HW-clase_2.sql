use henry_m3_hw;

ALTER TABLE cliente CHANGE ID IdCliente INT(11) NOT NULL; -- cambia el nombre de la columna, también permite modificar el tipo de dato
ALTER TABLE empleado CHANGE IDEmpleado IdEmpleado INT(11) NOT NULL;

-- ante de modificar una columna, es una buena práctica crear una copia donde probar las queries y una vez que funcionan ok, eliminar la columna sobrante
ALTER TABLE cliente ADD latitud DECIMAL (13, 10) NOT NULL DEFAULT '0' AFTER Y, -- DEFAULT para completar todas las celdas con ese valor
	ADD longitud DECIMAL (13, 10) NOT NULL DEFAULT '0' AFTER latitud; -- AFTER para indicar donde insertar la columna agregada
    
UPDATE cliente SET Y = '0' WHERE Y = ''; -- UPDATE modifica la tabla según cierta condición
UPDATE cliente SET X = '0' WHERE X = '';
UPDATE cliente SET Latitud = REPLACE(Y,',','.');
UPDATE cliente SET Longitud = REPLACE(X,',','.');

ALTER TABLE cliente DROP Y;
ALTER TABLE cliente DROP X;

SELECT * FROM cliente;
	
ALTER TABLE empleado ADD Salario DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER Salario2;
UPDATE empleado SET Salario = replace(Salario2, ',','.');
ALTER TABLE empleado DROP Salario2;

SELECT * FROM empleado;

UPDATE `venta` set `Precio` = 0 WHERE `Precio` = '';
ALTER TABLE `venta` CHANGE `Precio` `Precio` DECIMAL(15,3) NOT NULL DEFAULT '0'; -- cambia el formato del atributo/columna

SELECT * FROM venta;

SELECT * FROM empleado;

SELECT IDEmpleado, count(*)
FROM empleado
GROUP BY IDEmpleado
HAVING count(*) >1;

SELECT * FROM sucursal;