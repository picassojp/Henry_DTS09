use henry;
SELECT *
FROM alumno a
-- JOIN cohorte c ON(a.idCohorte = c.idCohorte);
-- LEFT JOIN cohorte c ON(a.idCohorte = c.idCohorte);
RIGHT JOIN cohorte c ON(a.idCohorte = c.idCohorte);

SELECT *
FROM cohorte c
LEFT JOIN alumno a ON(a.idCohorte = c.idCohorte);
-- Full Join
SELECT *
FROM cohorte c
LEFT JOIN alumno a ON(a.idCohorte = c.idCohorte)
UNION
SELECT *
FROM cohorte c
RIGHT JOIN alumno a ON(a.idCohorte = c.idCohorte);

-- Cohortes sin alumnos
SELECT *
FROM cohorte c
LEFT JOIN alumno a ON(a.idCohorte = c.idCohorte)
WHERE a.idAlumno is null;

use henry_m3;

-- Clientes que no compraron
SELECT *
FROM cliente c
LEFT JOIN venta v ON(c.IdCliente = v.IdCliente)
WHERE v.IdCliente IS NULL;

Select count(*)
from venta;




