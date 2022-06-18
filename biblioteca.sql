-- Creación de base de datos
CREATE DATABASE biblioteca;

-- Ingreso a la base de datos biblioteca
\c biblioteca

-- Creación de Tabla Libro
CREATE TABLE libro(
    isbn VARCHAR(15) PRIMARY KEY,
    titulo VARCHAR (255),
    num_paginas INT
);

-- Creación de Tabla socio
CREATE TABLE socio(
    rut VARCHAR(13) PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(255) UNIQUE,
    telefono VARCHAR(12) UNIQUE
);

-- Creación de Tabla prestamo
CREATE TABLE prestamo(
    id_prestamo SERIAL PRIMARY KEY,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    isbn_libro VARCHAR(15),
    rut_socio VARCHAR(13),
    FOREIGN KEY (isbn_libro) REFERENCES libro(isbn),
    FOREIGN KEY (rut_socio) REFERENCES socio(rut)
);

-- Creación de Tabla autor
CREATE TABLE autor(
    id SMALLINT PRIMARY KEY,
    nombre_autor VARCHAR (50),
    apellido_autor VARCHAR (50),
    fecha_nacimiento VARCHAR(10),
    fecha_muerte VARCHAR(10)
);

-- Creación de Tabla tipo_autor
CREATE TABLE tipo_autor(
    id_autor_libro SMALLINT PRIMARY KEY,
    tipo VARCHAR(25)
);

-- Creación de Tabla autor_libro
CREATE TABLE autor_libro(
    isbn_libro VARCHAR(15),
    id_autor INT,
    id_tipo_autor SMALLINT,
    PRIMARY KEY (isbn_libro, id_autor),
    FOREIGN KEY (isbn_libro) REFERENCES libro(isbn),
    FOREIGN KEY (id_autor) REFERENCES autor(id),
    FOREIGN KEY (id_tipo_autor) REFERENCES tipo_autor(id_autor_libro)
);

-- Insertando datos de tabla socio
INSERT INTO socio(rut, nombre, apellido, direccion, telefono) VALUES ('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', '911111111');
INSERT INTO socio(rut, nombre, apellido, direccion, telefono) VALUES ('2222222-2', 'ANA', 'PÉREZ', 'PASAJE 2, SANTIAGO', '922222222');
INSERT INTO socio(rut, nombre, apellido, direccion, telefono) VALUES ('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', '933333333');
INSERT INTO socio(rut, nombre, apellido, direccion, telefono) VALUES ('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', '944444444');
INSERT INTO socio(rut, nombre, apellido, direccion, telefono) VALUES ('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', '955555555');

-- Insertando datos de tabla libro
INSERT INTO libro(isbn, titulo, num_paginas) VALUES('111-1111111-111', 'CUENTOS DE TERROR','344');
INSERT INTO libro(isbn, titulo, num_paginas) VALUES('222-2222222-222', 'POESÍAS CONTEMPORANEAS', '167');
INSERT INTO libro(isbn, titulo, num_paginas) VALUES('333-3333333-333', 'HISTORIA DE ASIA', '511');
INSERT INTO libro(isbn, titulo, num_paginas) VALUES('444-4444444-444', 'MANUAL DE MECANICA', '298');

-- Insertando datos de tabla autor
INSERT INTO autor (id, nombre_autor, apellido_autor, fecha_nacimiento, fecha_muerte) VALUES ('3', 'JOSE', 'SALGADO', '1968', '2020');
INSERT INTO autor (id, nombre_autor, apellido_autor, fecha_nacimiento, fecha_muerte) VALUES ('4', 'ANA', 'SALGADO', '1972', ' ');
INSERT INTO autor (id, nombre_autor, apellido_autor, fecha_nacimiento, fecha_muerte) VALUES ('1', 'ANDRES','ULLOA','1982', ' ');
INSERT INTO autor (id, nombre_autor, apellido_autor, fecha_nacimiento, fecha_muerte) VALUES ('2', 'SERGIO', 'MARDONES', '1950', '2012');
INSERT INTO autor (id, nombre_autor, apellido_autor, fecha_nacimiento, fecha_muerte) VALUES ('5', 'MARTIN', 'PORTA', '1976', ' ');

-- Insertando datos de tabla tipo_autor
INSERT INTO tipo_autor (id_autor_libro, tipo) VALUES ('1', 'PRINCIPAL');
INSERT INTO tipo_autor (id_autor_libro, tipo) VALUES ('2', 'COAUTOR');

-- Insertando datos de tabla autor_libro
INSERT INTO autor_libro (isbn_libro, id_autor, id_tipo_autor) VALUES ('111-1111111-111', '4', '2');
INSERT INTO autor_libro (isbn_libro, id_autor, id_tipo_autor) VALUES ('222-2222222-222', '1', '1');
INSERT INTO autor_libro (isbn_libro, id_autor, id_tipo_autor) VALUES ('333-3333333-333', '2','1');
INSERT INTO autor_libro (isbn_libro, id_autor, id_tipo_autor) VALUES ('444-4444444-444', '5', '1');
INSERT INTO autor_libro (isbn_libro, id_autor, id_tipo_autor) VALUES ('111-1111111-111', '3', '1');

-- Insertando datos de tabla prestamo
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('20-01-2020', '27-01-2020', '111-1111111-111', '1111111-1');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('20-01-2020', '30-01-2020', '222-2222222-222', '5555555-5');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('22-01-2020', '30-01-2020', '333-3333333-333', '3333333-3');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('23-01-2020', '30-01-2020', '444-4444444-444', '4444444-4');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('27-01-2020', '04-02-2020', '111-1111111-111', '2222222-2');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('31-01-2020', '12-02-2020', '333-3333333-333', '1111111-1');
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, isbn_libro, rut_socio) VALUES ('31-01-2020', '12-02-2020', '222-2222222-222', '3333333-3');

-- Consultas
--> Mostrar todos los libros que posean menos de 300 páginas.
SELECT titulo, num_paginas FROM libro WHERE num_paginas < 300;

--> Mostrar todos los autores que hayan nacido después del 01-01-1970
SELECT nombre_autor, fecha_nacimiento FROM autor WHERE fecha_nacimiento >='1970';

--> ¿Cuál es el libro más solicitado?
SELECT COUNT(p.isbn_libro), l.titulo 
FROM prestamo p
INNER JOIN libro l ON p.isbn_libro = l.isbn
GROUP by l.titulo
ORDER BY COUNT(p.isbn_libro) DESC, l.titulo;

--> Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.
SELECT p.id_prestamo, s.nombre, s.apellido, s.rut, ((p.fecha_devolucion - p.fecha_prestamo) - 7) dias_de_atraso,(((p.fecha_devolucion - p.fecha_prestamo) - 7) *100) multa 
FROM prestamo p
INNER JOIN socio s ON p.rut_socio = s.rut 
WHERE (p.fecha_devolucion - p.fecha_prestamo) > 7;
