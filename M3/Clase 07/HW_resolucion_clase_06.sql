## Homework clase 06
use henry_m3;

SET GLOBAL log_bin_trust_function_creators = 1;

/* 1. Crear un procedimiento que recibe como parametro una fecha y muestre el listado de productos que se vendieron en esa fecha.*/
DELIMITER $$
CREATE PROCEDURE -- declarar el tipo de dato que ingresa en el procedimiento
DELIMITER ;
/*2. Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.*/

DELIMITER $$
CREATE FUNCTION margenBruto(precio DECIMAL(15,2), margen DECIMAL(15,2)) RETURNS DECIMAL(15, 2)
BEGIN
	DECLARE margenBruto DECIMAL(15,2);
    SET margenBruto = precio * margen;
    RETURN margenBruto;
END$$

DELIMITER ;

SELECT margenBruto(100, 1.2);

/*3. Obtener un listado de productos de IMPRESION y utilizarlo para cálcular el valor nominal de un margen bruto del 20% de cada uno de los productos.*/

SELECT *
FROM producto p
JOIN tipo_producto tp ON (p.IDProducto = tp.Idproducto AND tp.Idproducto = 'Impresión');

/*4. Crear un procedimiento que permita listar los productos vendidos desde fact_venta a partir de un "Tipo" que determine el usuario.*/

DROP PROCEDURE listaProductosCategoria; -- para eliminar el procedimiento en caso de necesitar modificarlo

DELIMITER $$
CREATE PROCEDURE listaProductosCategoria (categoria VARCHAR(40))
BEGIN 
	SELECT fv.*, dp.Producto
    FROM fact_venta fv
    JOIN dim_producto dp ON(fv.IdProducto = dp.IdProducto)
    JOIN tipo_producto tp ON(dp.IdTipoProducto = tp.IdTipoProducto AND tp.TipoProducto = categoria COLLATE utf8mb4_spanish_ci = categoria); -- se explicita la codificación con COLLATE
END $$
DELIMITER ;

CALL listaProductosCategoria('Limpieza');


/*5. Crear un procedimiento que permita realizar la insercción de datos en la tabla fact_venta.*/

DELIMITER $$
CREATE PROCEDURE cargar_fact_venta()
BEGIN
	INSERT INTO fact_venta
    SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
    FROM venta
    WHERE Outlier = 1
    LIMIT 10;
END $$
DELIMITER ;

CALL cargar_fact_venta;

/* 6. Crear un procedimiento almacenado que reciba un grupo etario y devuelta el total de ventas para ese grupo.*/

DELIMITER $$
CREATE PROCEDURE ventaGrupoEtario(rango_etario VARCHAR(40) CHARSET utf8mb4 COLLATE utf8mb4_spanish_ci)
BEGIN
    SELECT c.Rango_Etario, SUM(v.Precio * v.Cantidad) as total_venta
    FROM venta v
	JOIN cliente c ON(v.IdCliente = c.IdCliente
						AND c.Rango_Etario LIKE concat('%', rango_etario, '%'))
	GROUP BY c.Rango_Etario;
END $$
DELIMITER ;

CALL ventaGrupoEtario;

/*7. Crear una variable que se pase como valor para realizar un filtro sobre Rango_etario en una consulta génerica a dim_cliente.*/
SET @grupo_etario = '4_De 51 a 60 años' COLLATE utf8mb4_spanish_ci;

SELECT *
FROM dim_cliente
WHERE Rango_Etario = @grupo_etario;


/* 8. Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan descripciones para todas las tablas.*/

/*Función y Procedimiento provistos*/
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;



/*9. Utilizar el procedimiento provisto 'Llenar_Calendario' para poblar la tabla de calendario. */

DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension calendario*/
DROP TABLE IF EXISTS `calendario`;
CREATE TABLE calendario (
        idFecha                     INTEGER PRIMARY KEY,  -- year*10000+month*100+day
        fecha                 	DATE NOT NULL,
        anio                    INTEGER NOT NULL,
        mes                   	INTEGER NOT NULL, -- 1 to 12
        dia                     INTEGER NOT NULL, -- 1 to 31
        trimestre               INTEGER NOT NULL, -- 1 to 4
        semana                  INTEGER NOT NULL, -- 1 to 52/53
        dia_nombre              VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        mes_nombre              VARCHAR(9) NOT NULL -- 'January', 'February'...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

ALTER TABLE `calendario` ADD UNIQUE(`fecha`);

-- ALTER TABLE venta ADD CONSTRAINT `venta_fk_fecha` FOREIGN KEY (fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE compra ADD CONSTRAINT `compra_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;

/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Calendario.csv' 
INTO TABLE calendario
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;*/