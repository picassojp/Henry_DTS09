-- Homework
USE henry;

-- 1. ¿Cuantas carreas tiene Henry?
SELECT count(idCarrera) AS cantidad_carreras
FROM carrera;

-- 2. ¿Cuantos alumnos hay en total?
SELECT count(idAlumno) AS cantidad_alumnos
FROM alumno;

-- 3. ¿Cuantos alumnos tiene cada cohorte?
SELECT count(idAlumno) AS cantidad_alumnos, idCohorte AS cohorte
FROM alumno
GROUP BY idCohorte;

-- 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.
SELECT concat(nombre,' ', apellido) AS nombre_completo, fechaIngreso
FROM alumno
ORDER BY fechaIngreso DESC;

-- 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?
SELECT concat(nombre,' ', apellido) AS nombre_completo, fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT MIN(fechaIngreso) FROM alumno);

-- 6. ¿En que fecha ingreso?
SELECT MIN(fechaIngreso) 
FROM alumno;

-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
SELECT concat(nombre,' ', apellido) AS nombre_completo, fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT MAX(fechaIngreso) FROM alumno);

-- 8. La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.
SELECT count(idAlumno) AS 'cantidad ingresantes', YEAR(fechaIngreso) AS 'Año de ingreso'
FROM alumno
GROUP BY YEAR(fechaIngreso)
ORDER BY YEAR(fechaIngreso);

-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
SELECT count(idAlumno) AS 'cantidad ingresantes', YEAR(fechaIngreso) AS 'Año de ingreso', weekofyear(fechaIngreso) AS 'semana de ingreso'
FROM alumno
GROUP BY WEEKOFYEAR(fechaIngreso), YEAR(fechaIngreso)
ORDER BY YEAR(fechaIngreso), WEEKOFYEAR(fechaIngreso);

-- 10. ¿En que años ingresaron más de 20 alumnos?
SELECT count(idAlumno) AS 'cantidad ingresantes', YEAR(fechaIngreso) AS 'Año de ingreso'
FROM alumno
GROUP BY YEAR(fechaIngreso)
HAVING count(idAlumno) >20
ORDER BY YEAR(fechaIngreso);

-- 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().
SELECT *, timestampdiff(year, fechaNacimiento, CURDATE()) AS edad, date_add(fechaNacimiento, INTERVAL timestampdiff(year, fechaNacimiento, CURDATE()) YEAR) AS verificacion_edad
FROM instructor;

/* 12. Cálcula:<br>
            - La edad de cada alumno.<br>*/
SELECT *, timestampdiff(year, fechaNacimiento, CURDATE()) AS edad
FROM alumno;
            -- - La edad promedio de los alumnos de henry.<br>
SELECT round(AVG(timestampdiff(year, fechaNacimiento, CURDATE()))) AS promedio_edad
FROM alumno;
            -- -La edad promedio de los alumnos de cada cohorte.<br>
SELECT idCohorte, round(AVG(timestampdiff(year, fechaNacimiento, CURDATE()))) AS promedio_edad
FROM alumno
GROUP BY idCohorte;
-- parece que la edad promedio de la cohorte 1241 tiene alguna fecha de nacimiento incorrecta. Se revisa:
SELECT *
FROM alumno
WHERE idCohorte = 1241;
-- el alumno con id 127 presenta un error en la fecha de nacimiento, por lo que se modifica el registro
UPDATE alumno
SET fechaNacimiento='2002-01-02'
WHERE idAlumno = 127;
-- se revisa nuevamente la edad promedio de cada cohorte
SELECT idCohorte, round(AVG(timestampdiff(year, fechaNacimiento, CURDATE()))) AS promedio_edad
FROM alumno
GROUP BY idCohorte;

-- 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.
SELECT *, timestampdiff(year, fechaNacimiento, CURDATE()) AS edad
FROM alumno
WHERE timestampdiff(year, fechaNacimiento, CURDATE()) > (SELECT round(AVG(timestampdiff(year, fechaNacimiento, CURDATE()))) AS promedio_edad FROM alumno);
