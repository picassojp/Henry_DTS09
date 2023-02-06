-- se elimina la base de datos anterior
DROP DATABASE henry;
-- se crea la nueva base
CREATE DATABASE henry;

-- se selecciona la base de datos con la cual se va a trabajar
USE henry;

/* comentario 
multilinea */

-- se crean las tablas:

create table carrera (
	-- AUTO_INCREMENT PARA QUE AGREGUE LOS VALORES AUTOMATICAMENTE Y SIN REPETIR
    idCarrera int NOT NULL AUTO_INCREMENT,
    -- VARCHAR PERMITE DEFINIR LA CANTIDAD DE CARACTERES NECESARIOS PARA LOS DATOS DE ESE ATRIBUTO. 50 CARACTERES EN ESTE CASO
    nombre varchar(50) NOT NULL,
    PRIMARY KEY (idCarrera)
    );
    
create table instructor (
	idInstructor int NOT NULL AUTO_INCREMENT,
    -- cedula_identidad int NOT NULL,
    cedulaIdentidad VARCHAR(30) NOT NULL,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaIncorporacion DATE,
    primary key (idInstructor)
    );
    
CREATE TABLE cohorte (
	idCohorte int NOT NULL AUTO_INCREMENT,
    codigo VARCHAR(30) NOT NULL,
    idCarrera int NOT NULL,
    fechaInicio DATE,
    fechaFinalizacion DATE,
    idInstructor int NOT NULL,
    PRIMARY KEY (idCohorte),
    FOREIGN KEY (idCarrera) references carrera (idCarrera),
    FOREIGN KEY (idInstructor) references instructor (idInstructor)
    );
    
create table alumno (
	idAlumno int NOT NULL AUTO_INCREMENT,
    cedulaIdentidad VARCHAR(30) NOT NULL,
    nombre varchar(30) NOT NULL,
    apellido varchar(30) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaIngreso DATE,
    idCarrera int,
    idCohorte int,
    PRIMARY KEY (idAlumno),
    FOREIGN KEY (idCohorte) REFERENCES cohorte (idCohorte)
    );

SELECT *
FROM Alumno
