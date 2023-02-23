USE henry;

-- 1. ¿Cuantas carreas tiene Henry?
SELECT count(idCarrera) AS cantidad_carreras
FROM carrera;

-- 2. ¿Cuantos alumnos hay en total?
SELECT DISTINCT count(*) AS cantidad_alumnos
FROM alumno;

-- 3. ¿Cuantos alumnos tiene cada cohorte?
SELECT idCohorte, count(*) as cantidad_alumnos
FROM alumno
GROUP BY idCohorte;

-- 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron,
-- con nombre y apellido en un solo campo.
-- SELECT concat_ws('-','Hola','Mundo');
SELECT concat(nombre, ' ', apellido) AS nombre_apellido, fechaIngreso
FROM alumno
ORDER BY fechaIngreso DESC;

-- 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?
SELECT concat(nombre, ' ', apellido) AS nombre_apellido
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;

-- 6. ¿En que fecha ingreso?
SELECT fechaIngreso
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;

-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
SELECT concat(nombre, ' ', apellido) AS nombre_apellido
FROM alumno
ORDER BY fechaIngreso DESC
LIMIT 1;

-- 8. La función YEAR le permite extraer el año de un campo date,
-- utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.
SELECT year(fechaIngreso) AS año_ingreso, count(*) AS cantidad_alumnos
FROM alumno
GROUP BY año_ingreso
ORDER BY 1;

-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
SELECT year(fechaIngreso) AS año, weekofyear(fechaIngreso) AS semana, count(*) AS cantidad_alumnos
FROM alumno
GROUP BY año, semana
ORDER BY 1,2;

-- 10. ¿En que años ingresaron más de 20 alumnos?
SELECT year(fechaIngreso) AS año_ingreso, count(*) AS cantidad_alumnos
FROM alumno
GROUP BY año_ingreso
HAVING cantidad_alumnos > 20
ORDER BY 1;

-- 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE().
-- ¿Podría utilizarlas para saber cual es la edad de los instructores?.
-- ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().
SELECT concat(nombre, ' ', apellido) AS nombre_apellido, timestampdiff(YEAR, fechaNacimiento, curdate()) as edad,
date_add(fechaNacimiento, interval timestampdiff(YEAR, fechaNacimiento, curdate()) year) AS verificacion, fechaNacimiento
FROM instructor
ORDER BY 1;

-- 12. Cálcula:<br>
            -- La edad de cada alumno.<br>
            -- La edad promedio de los alumnos de henry.<br>
            -- La edad promedio de los alumnos de cada cohorte.<br>

SELECT idAlumno, concat(nombre, ' ', apellido) AS nombre_apellido, fechaNacimiento,
	timestampdiff(YEAR, fechaNacimiento, curdate()) as edad
FROM alumno
ORDER BY edad DESC;

SELECT avg(timestampdiff(YEAR, fechaNacimiento, curdate())) as edad_promedio
FROM alumno;

UPDATE alumno
SET fechaNacimiento = '2002-01-02'
WHERE idAlumno = 127;

SELECT idCohorte, avg(timestampdiff(YEAR, fechaNacimiento, curdate())) as edad_promedio
FROM alumno
GROUP BY idCohorte;

-- 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.
SELECT idAlumno, concat(nombre, ' ', apellido) AS nombre_apellido
FROM alumno
WHERE timestampdiff(YEAR, fechaNacimiento, curdate()) >
	(SELECT avg(timestampdiff(YEAR, fechaNacimiento, curdate())) as edad_promedio
	FROM alumno);

