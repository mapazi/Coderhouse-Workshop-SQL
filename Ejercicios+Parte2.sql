
--PRACTICA 2 (CLASE 8)

/* 1) Indicar por jornada la cantidad de docentes que dictan y sumar los costos. Esta información sólo se desea visualizar 
para las asignaturas de desarrollo web. El resultado debe contener todos los valores registrados en la primera tabla.
Renombrar la columna del cálculo de la cantidad de docentes como cant_docentes y la columna de la suma de los costos 
como suma_total. Keywords: Asignaturas,Staff, DocentesID, Jornada, Nombre, costo.*/

SELECT t2.Jornada,
	   COUNT(t1.DocentesID) AS cant_docentes, 
	   SUM(t2.Costo) AS sum_total
FROM Staff AS t1
INNER JOIN Asignaturas AS t2
ON t1.Asignatura = t2.AsignaturasID
WHERE t2.Nombre = 'Desarrollo Web'
GROUP BY t2.Jornada;


/* 2) Se requiere saber el id del encargado, el nombre, el apellido y cuántos son los docentes que tiene asignados cada encargado. 
Luego filtrar los encargados que tienen como resultado 0 ya que son los encargados que NO tienen asignado un docente. 
Renombrar el campo de la operación como Cant_Docentes. Keywords: Docentes_id, Encargado, Staff, Nombre, Apellido, Encargado_ID.*/

SELECT t1.Encargado_ID, t1.Nombre, t1.Apellido, COUNT(t2.DocentesID) AS Cant_Docentes
FROM Encargado AS t1
LEFT JOIN Staff AS t2
ON t1.Encargado_ID = t2.Encargado
WHERE t2.Encargado != 0
GROUP BY t1.Encargado_ID, t1.Nombre, t1.Apellido;


/* 3) Se requiere saber todos los datos de asignaturas que no tienen un docente asignado.El modelo de la consulta debe partir 
desde la tabla docentes. Keywords: Staff, Encargado, Asignaturas, costo, Area.*/

SELECT t2.AsignaturasID, t2.Nombre, t2.Tipo, t2.Jornada, t2.Costo, t2.Area
FROM Staff AS t1
RIGHT JOIN Asignaturas AS t2
ON t1.Asignatura = t2.AsignaturasID
WHERE t1.DocentesID IS NULL


/* 4) Se quiere conocer la siguiente información de los docentes. El nombre completo concatenar el nombre y el apellido.
Renombrar NombresCompletos, el documento, hacer un cálculo para conocer los meses de ingreso. Renombrar meses_ingreso, 
el nombre del encargado. Renombrar NombreEncargado, el teléfono del encargado. Renombrar TelefonoEncargado, el nombre del curso o carrera, 
la jornada y el nombre del área. Solo se desean visualizar solo los que llevan más de 3 meses. Ordenar los meses de ingreso de mayor a menor.
Keywords: Encargo,Area,Staff,jornada, fecha ingreso.*/

SELECT CONCAT(t1.Nombre, ' ', t1.Apellido) AS NombresCompletos, 
	   t1.Documento, 
	   DATEDIFF(MONTH,'2020-01-03', t1.[Fecha Ingreso]) AS MesesIngreso,
	   t2.Nombre AS NombreEncargado,
	   t2.Telefono AS TelefonoEncargado,
	   t3.Nombre AS CursoCarrera,
	   t3.Jornada,
	   t4.Nombre AS Area
FROM Staff AS t1
	INNER JOIN Encargado AS t2
	ON t1.Encargado = t2.Encargado_ID
	INNER JOIN Asignaturas AS t3
	ON t1.Asignatura = t3.AsignaturasID
	INNER JOIN Area AS t4
	ON t4.AreaID = t3.Area
	WHERE DATEDIFF(MONTH,'2020-01-03', t1.[Fecha Ingreso]) > 3
ORDER BY t1.[Fecha Ingreso] DESC


/* 5) Se requiere una listado unificado con nombre, apellido, documento y una marca indicando a que base corresponde. 
Renombrar como Marca Keywords: Encargo,Staff,Estudiantes.*/

SELECT t1.Nombre, t1.Apellido, t1.Documento, 'BD Encargados' AS Marca
FROM Encargado AS t1
UNION
SELECT t2.Nombre, t2.Apellido, t2.Documento, 'BD Staff' AS Marca
FROM Staff AS t2
UNION
SELECT t3.Nombre, t3.Apellido, t3.Documento, 'BD Estudiantes' AS Marca
FROM Estudiantes AS t3

