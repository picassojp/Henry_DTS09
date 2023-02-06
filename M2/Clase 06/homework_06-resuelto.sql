USE henry;

-- 2.	No se sabe con certeza el lanzamiento de las cohortes N° 1245 y N° 1246, se solicita que las elimine de la tabla.<br>
DELETE 
FROM cohorte
WHERE idCohorte = 1245  OR idCohorte = 1246;

SELECT *
FROM cohorte;

-- 3.	Se ha decidido retrasar el comienzo de la cohorte N°1243, por lo que la nueva fecha de inicio será el 16/05. Se le solicita modificar la fecha de inicio de esos alumnos.<br>
UPDATE cohorte
SET fechaInicio = '2022-05-16'
WHERE idCohorte = 1243;

SELECT *
FROM cohorte;

-- 4.	El alumno N° 165 solicito el cambio de su Apellido por “Ramirez”. <br>
SELECT *
FROM alumno
WHERE idAlumno = 165;

UPDATE alumno
SET apellido = 'Ramirez'
WHERE idAlumno = 165;

-- 5.	El área de Learning le solicita un listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso.<br>
SELECT fechaIngreso
FROM alumno
WHERE idCohorte = 1243;

-- 6.	Como parte de un programa de actualización, el área de People le solicita un listado de los instructores que dictan la carrera de Full Stack Developer.<br>
SELECT *
FROM instructor;

-- 1° alternativa
SELECT *
FROM cohorte c -- implicitamente toma el espacio como un "AS"
JOIN instructor i
ON c.idInstructor = i.idInstructor
WHERE idCarrera = 1;

-- 2° alternativa (SIN JOIN)
SELECT *
FROM instructor
WHERE idInstructor IN (SELECT DISTINCT idInstructor FROM cohorte WHERE idCarrera = 1);

-- 7. Se desea saber que alumnos formaron parte de la cohorte N° 1235. Elabore un listado.<br>
SELECT *
FROM alumno
WHERE idCohorte = 1235;

-- 8. Del listado anterior se desea saber quienes ingresaron en el año 2019.<br>
-- creando una tabla temporal
CREATE TEMPORARY TABLE cohorte1235
AS
SELECT *
FROM alumno
WHERE idCohorte = 1235;

SELECT *
FROM cohorte1235
WHERE YEAR(fechaIngreso) = 2019;

-- 9. La siguiente consulta permite acceder a datos de otras tablas y devolver un listado con la carrera a la cual pertenece cada alumno:
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera;

/* Coneste la siguientes interrogantes:
  a. ¿Que campos permiten que se puedan acceder al nombre de la carrera? los campos que corresponden a PKs
  b. ¿Que tipo de relación existe entre el nombre la tabla cohortes y alumnos?
  c. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando LIKE y NOT LIKE?, ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por que? */

-- forma correcta
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.nombre LIKE 'Full Stack Developer';

-- forma incorrecta (ya que puede devolver alumnos de otras carreras si llegasen a existir más de 2)
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.nombre NOT LIKE 'Data Science';

  
  /* d. ¿Proponga dos opciones para filtrar el listado solo por los alumnos que pertenecen a 'Full Stack Developer', utilizando " = " y " != "?  ¿Cual de las dos opciones es la manera correcta de hacerlo?, ¿Por que? */

-- 1° opción
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.nombre = 'Full Stack Developer';

-- 2° opción
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.nombre != 'Data Science';
  
  /* e. ¿Como emplearía el filtrado utilizando el campo idCarrera? */
-- 1° opción
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.idCarrera = 1;

-- 2° opción
SELECT a.nombre, apellido, fechaNacimiento, cr.nombre
FROM alumno a
INNER JOIN cohorte c
ON a.idCohorte=c.idCohorte
INNER JOIN carrera cr
ON c.idCarrera = cr.idCarrera
WHERE cr.idCarrera != 2;
