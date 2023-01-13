
--PRACTICA 1 (CLASE 7)

/* 1)
Indicar cuántos cursos y carreras tiene el área de Data. Renombrar la nueva columna como cant_asignaturas.
Keywords: Tipo, Area, Asignaturas.*/

SELECT *
FROM Area --El AreaId de Data es 5

SELECT *
FROM Asignaturas

SELECT Tipo, COUNT(Area) AS cant_asignaturas
FROM Asignaturas
WHERE Area = 5
GROUP BY Tipo;


/* 2) 
Se requiere saber cual es el nombre, el documento de identidad y el teléfono de los estudiantes que son profesionales en agronomía 
y que nacieron entre el año 1970 y el año 2000. Keywords: Estudiantes, Profesión, Fecha de Nacimiento.*/

SELECT * FROM Estudiantes;

SELECT * FROM Profesiones
WHERE Profesiones LIKE '%Agro%';

--Opción 1
--Se realiza un subquery para utilizar datos de otra tabla 'Profesiones
SELECT Nombre, Documento, Telefono
FROM Estudiantes
WHERE Profesion IN
	(SELECT ProfesionesID
	FROM Profesiones
	WHERE ProfesionesID = 6)
AND [Fecha de Nacimiento] BETWEEN '1970-01-01' AND '2000-12-31';

--Opción 2
--Simplemente se usa el WHERE porque previamente ya buscamos cuál era la 'ProfesionID'
SELECT Nombre, Documento, Telefono
FROM Estudiantes
WHERE Profesion = 6 
AND [Fecha de Nacimiento] BETWEEN '1970-01-01' AND '2000-12-31';


/* 3)
Se requiere un listado de los docentes que ingresaron en el año 2021 y concatenar los campos nombre y apellido.
El resultado debe utilizar un separador: guión (-). Ejemplo: Elba-Jimenez. Renombrar la nueva columna como Nombres_Apellidos.
Los resultados de la nueva columna deben estar en mayúsculas. Keywords: Staff, Fecha Ingreso, Nombre, Apellido.*/

--Opción 1
SELECT UPPER(CONCAT(Nombre, '-', Apellido)) AS Nombres_Apellidos
FROM Staff
WHERE [Fecha Ingreso] BETWEEN '2021-01-01' AND '2021-12-31';

--Opción 2
SELECT UPPER(CONCAT(Nombre, '-', Apellido)) AS Nombres_Apellidos
FROM Staff
WHERE YEAR([Fecha Ingreso]) = 2021;


/* 4)
Indicar la cantidad de encargados de docentes y de tutores. Renombrar la columna como CantEncargados.
Quitar la palabra ”Encargado ”en cada uno de los registros. Renombrar la columna como NuevoTipo. Keywords: Encargado, tipo, Encargado_ID.*/

SELECT * FROM Encargado;

SELECT 
	REPLACE(Tipo, 'Encargado ', '') AS NuevoTipo,
	COUNT(*) AS CantEncargados
FROM Encargado
GROUP BY Tipo;


/* 5)
Indicar cuál es el precio promedio de las carreras y los cursos por jornada. Renombrar la nueva columna como Promedio.
Ordenar los promedios de Mayor a menor Keywords: Tipo, Jornada, Asignaturas.*/

SELECT * FROM Asignaturas;

SELECT Tipo, Jornada, AVG(Costo) AS Promedio
FROM Asignaturas
GROUP BY Tipo, Jornada
ORDER BY Promedio DESC;


/* 6)
Se requiere calcular la edad de los estudiantes en una nueva columna. Renombrar a la nueva columna Edad. Filtrar solo los que son mayores de 18 años. 
Ordenar de Menor a Mayor Keywords: Fecha de Nacimiento, Estudiantes.*/

SELECT * FROM Estudiantes;

SELECT Nombre, Apellido, YEAR([Fecha Ingreso])-YEAR([Fecha de Nacimiento]) AS Edad
FROM Estudiantes
WHERE YEAR([Fecha Ingreso])-YEAR([Fecha de Nacimiento]) >18
ORDER BY Edad;


/* 7)
Se requiere saber el Nombre,el correo, la camada y la fecha de ingreso de personas del staff que contienen correo .edu y su DocenteID 
se mayor o igual que 100 Keywords: Staff, correo, DocentesID.*/

SELECT * FROM Staff;

SELECT Nombre, Correo, Camada, [Fecha Ingreso]
FROM Staff
WHERE RIGHT(Correo, 4) = '.edu'
AND DocentesID >= 100;
	

/* 8)
Se requiere conocer el documento, el domicilio, el código postal y el nombre de los primeros estudiantes que se registraron en la plataforma. 
Keywords: Documento, Estudiantes, Fecha Ingreso.*/

SELECT * FROM Estudiantes;

SELECT Nombre, Documento, Domicilio, [Codigo Postal], [Fecha Ingreso]
FROM Estudiantes
ORDER BY [Fecha Ingreso];


/* 9)
Indicar el nombre, apellido y documento de identidad de los docentes y tutores que tienen asignaturas “UX” . 
Keywords: Staff, Asignaturas, Nombre, Apellido.*/

SELECT * FROM Staff;

SELECT * FROM Asignaturas;

SELECT Nombre, Apellido, Documento
FROM Staff
WHERE Asignatura IN
	(SELECT Area
	FROM Asignaturas
	WHERE Nombre LIKE '%UX%')


/* 10)
Se desea calcular el 25% de aumento para las asignaturas del área de marketing de la jornada mañana se deben traer todos los campos, 
mas el de los cálculos correspondientes el porcentaje y el Nuevo costo debe estar en decimal con 3 digitos. 
Renombrar el calculo del porcentaje con el nombre porcentaje y la suma del costo mas el porcentaje por NuevoCosto.
Keywords: Asignaturas, Costo, Área, Jornada, Nombre.*/

SELECT AsignaturasID, 
	   Nombre, 
	   Tipo, 
	   Jornada, 
	   Costo, 
	   Area,
	   Costo*0.25 AS Porcentaje,
	   CAST(ROUND((Costo+(Costo*0.25)), 3) AS DECIMAL(20,3))AS NuevoCosto
FROM Asignaturas
WHERE Nombre LIKE '%Marketing%'
AND Jornada = 'Manana'
