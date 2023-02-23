## Homework

### Normalización

/*1) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. 
A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias.
Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.*/

use henry_m3_hw;

SELECT DISTINCT Localidad, Provincia
FROM cliente;

SELECT DISTINCT Ciudad, Provincia
FROM proveedor;

DROP TABLE IF EXISTS `aux_Localidad`;
CREATE TABLE IF NOT EXISTS `aux_Localidad` ( -- se crea una tabla auxiliar para trabajar con los datos
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER -- una vez modificada toda la tabla, se define como primary key
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- juntar todas las tablas con datos de localidad y provincia
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION -- para eliminar los duplicados
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor -- en esta tabla, figura 'ciudad' en lugar de 'localidad'
ORDER BY 2, 1;

INSERT INTO aux_Localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad) 
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION -- para eliminar los duplicados
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor -- en esta tabla, figura 'ciudad' en lugar de 'localidad'
ORDER BY 2, 1;

SELECT *
FROM aux_Localidad; -- se revisa la tabla

-- se revisan todas las variantes de las mismas provincias
SELECT DISTINCT Provincia_Original FROM aux_Localidad ORDER BY 1;

UPDATE aux_Localidad SET Provincia_Normalizada = 'Buenos Aires'
WHERE Provincia_Original IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires'); -- se normalizan los campos de Buenos Aires en la columna correspondiente

SELECT DISTINCT Provincia_Original, Provincia_Normalizada FROM aux_Localidad ORDER BY 2; -- se revisa el cambio


SELECT DISTINCT Provincia_Original FROM aux_Localidad ORDER BY 1;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Córdoba'
WHERE Provincia_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba');

SELECT DISTINCT Provincia_Original, Provincia_Normalizada FROM aux_Localidad ORDER BY 2; -- se revisa el cambio

SELECT DISTINCT Provincia_Original FROM aux_Localidad ORDER BY 1;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Entre Ríos'
WHERE Provincia_Original IN ('Entre RÃ­os');

SELECT DISTINCT Provincia_Original, Provincia_Normalizada FROM aux_Localidad ORDER BY 2; -- se revisa el cambio


-- se revisan todas las variantes de las mismas localidades
SELECT DISTINCT Localidad_Original FROM aux_Localidad WHERE Provincia_Normalizada = 'Buenos Aires' ORDER BY 1;

UPDATE aux_Localidad SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires'; -- se normalizan los campos de Capital Federal en la columna correspondiente

SELECT DISTINCT Localidad_Original, Localidad_Normalizada FROM aux_Localidad WHERE Provincia_Normalizada = 'Buenos Aires' ORDER BY 1; -- se revisa el cambio

UPDATE `aux_localidad` SET Localidad_Normalizada = 'Córdoba'
WHERE Localidad_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba')
AND Provincia_Normalizada = 'Córdoba';

/*2) Es necesario discretizar el campo edad en la tabla cliente.

### Outliers

1) Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad.
Realizar diversas consultas para verificar la importancia de haber detectado Outliers. Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.

### ETL

1) Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, aplicar las transformaciones o reglas de negocio necesarias a los datos y generar el modelo final que va a ser consumido desde los reportes. 
Este proceso debe ser claro y autodocumentado.
¿Se puede armar un esquema, donde sea posible detectar con mayor facilidad futuros errores en los datos?

### KPI

1) Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables, por lo tanto debemos asegurarnos de contar con los datos adecuados.
¿Necesito tener el claro las métricas que voy a utilizar? 
¿La métrica necesaria debe tener algún filtro en especial? 
La Meta que se definió ¿se calcula con la misma métrica?*/