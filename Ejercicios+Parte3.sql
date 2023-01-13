
--PRACTICA FINAL (CLASE 9)

--PARTE 1: INDICADORES PARA NIVEL OPERATIVO

/* 1) Análisis de docentes por camada/ comisión: 
Número de documento de identidad, nombre del docente y camada, para identificar la camada mayor y la menor según el número de la  camada. 
Número de documento de identidad, nombre de docente y camada para identificar la camada con fecha de ingreso, mayo 2021. Agregar un campo 
indicador que informe cuáles son los registros ”mayor o menor” y los que son “mayo 2021” y ordenar el listado de menor a mayor por camada.*/

SELECT Documento, 
	   CONCAT(Nombre,' ', Apellido) AS NombreCompleto, 
	   Camada, 
	   'Menor' AS Marca,
	   [Fecha Ingreso] 
FROM Staff
WHERE Camada = (SELECT MIN(Camada) FROM Staff)
UNION
SELECT Documento, 
	   CONCAT(Nombre,' ', Apellido), 
	   Camada, 
	   'Mayor' AS Marca,
	   [Fecha Ingreso]  
FROM Staff
WHERE Camada = (SELECT MAX(Camada) FROM Staff)
UNION
SELECT
	Documento,
	CONCAT(Nombre,' ', Apellido) AS NombreCompleto,
	Camada,
	'Mayo 2021' AS Marca,
	[Fecha Ingreso]
FROM Staff
WHERE [Fecha Ingreso] BETWEEN '2021-05-01' AND '2021-05-31'
ORDER BY Camada;


--OTRA OPCION
/*
SELECT t1.Documento, 
	   t1.Nombre, 
	   t1.Camada, 
	   'Mayor' AS Indice
FROM Staff AS t1 
WHERE t1.Camada = (SELECT MAX(t1.Camada) FROM Staff AS t1)
UNION
SELECT t1.Documento, 
	   t1.Nombre, 
	   t1.Camada, 
	   'Menor' AS Indice
FROM Staff AS t1
WHERE t1.Camada = (SELECT MIN(t1.Camada) FROM Staff AS t1)
UNION
SELECT t1.Documento, 
       t1.Nombre, 
	   t1.Camada, 
	   'Mayo 2021' as Indice
FROM Staff AS t1 
WHERE YEAR(t1.[Fecha Ingreso]) = 2021 AND MONTH(t1.[Fecha Ingreso])=05  /*t1.[Fecha Ingreso]>='2021-05-01' AND t1.[Fecha Ingreso]<='2021-05-30'*/
ORDER BY Camada;
*/

/* 2) Análisis diario de estudiantes: 
Por medio de la fecha de ingreso de los estudiantes identificar: cantidad total de estudiantes. Mostrar los periodos de tiempo separados 
por año, mes y día, y presentar la información ordenada por la fecha que más ingresaron estudiantes.*/

SELECT YEAR([Fecha Ingreso]) AS Anio,
	   MONTH([Fecha Ingreso]) AS Mes,
	   DAY([Fecha Ingreso]) AS Dia,
	   COUNT(EstudiantesID) AS CantEstudiantes   
FROM Estudiantes
GROUP BY [Fecha Ingreso]
ORDER BY  COUNT(EstudiantesID) DESC;


/* 3) Análisis de encargados con más docentes a cargo: 
Identificar el top 10 de los encargados que tiene más docentes a cargo, filtrar solo los que tienen a cargo docentes. Ordenar de mayor 
a menor para poder tener el listado correctamente. */

SELECT TOP (10) 
	   t1.Encargado_ID, 
       t1.Nombre, 
	   t1.Apellido, 
	   COUNT(t2.DocentesID) AS CantDocentes
FROM Encargado AS t1
INNER JOIN Staff AS t2
ON t1.Encargado_ID = t2.Encargado
WHERE t1.Tipo LIKE '%Encargado Docentes%'
GROUP BY t1.Encargado_ID, t1.Nombre, t1.Apellido
ORDER BY CantDocentes DESC;


/* 4) Análisis de profesiones con más estudiantes: 
Identificar la profesión y la cantidad de estudiantes que ejercen, mostrar el listado solo de las profesiones que tienen más de 5 estudiantes.
Ordenar de mayor a menor por la profesión que tenga más estudiantes.*/

SELECT t1.Profesiones,
	   COUNT(t2.EstudiantesID) AS CantEstudiantes
FROM Profesiones AS t1
INNER JOIN Estudiantes AS t2 
ON t1.ProfesionesID = t2.Profesion
GROUP BY t1.Profesiones 
HAVING COUNT(t2.EstudiantesID) > 5 
ORDER BY CantEstudiantes DESC;

/* NOTA: La función WHERE se utiliza para filtrar registros individuales pero la función HAVING filtra por grupo de registros.*/


/* 5) Análisis de estudiantes por área de educación: 
Identificar: nombre del área, si la asignatura es carrera o curso , a qué jornada pertenece, cantidad de estudiantes y monto total del costo
de la asignatura. Ordenar el informe de mayor a menor por monto de costos total, tener en cuenta los docentes que no tienen asignaturas ni 
estudiantes asignados, también sumarlos.*/

SELECT t1.Nombre AS Area, 
	   t2.Tipo, 
	   t2.Jornada, 
	   COUNT(t4.EstudiantesID) AS CantEstudiantes,
	   SUM(t2.Costo) AS CostoTotal
FROM Area AS t1
INNER JOIN Asignaturas AS t2
ON t1.AreaID = t2.Area
INNER JOIN Staff AS t3
ON t3.Asignatura = t2.AsignaturasID
INNER JOIN Estudiantes AS t4
ON t3.DocentesID = t4.Docente
GROUP BY t1.Nombre, t2.Tipo, t2.Jornada
ORDER BY CostoTotal DESC;


--PARTE 2: INDICADORES PARA NIVEL TACTICO

/* 1) Análisis mensual de estudiantes por área: 
Identificar para cada área: el año y el mes (concatenados en formato YYYYMM), cantidad de estudiantes y monto total de las asignaturas. 
Ordenar por mes del más actual al más antiguo y por cantidad de clientes de mayor a menor.*/

SELECT t4.Nombre,
	   CONCAT(YEAR(t1.[Fecha Ingreso]),'-', MONTH(t1.[Fecha Ingreso])) AS FechaIngreso,
	   COUNT(t1.EstudiantesID) AS CantEstudiantes,
	   SUM(t3.Costo) AS Total
FROM Estudiantes AS t1
INNER JOIN Staff AS t2 
ON t1.Docente = t2.DocentesID
INNER JOIN Asignaturas AS t3 
ON t2.Asignatura = t3.AsignaturasID
INNER JOIN Area AS t4 
ON t3.Area = t4.AreaID
GROUP BY T4.Nombre, CONCAT(YEAR(t1.[Fecha Ingreso]),'-', MONTH(t1.[Fecha Ingreso]))
ORDER BY FechaIngreso DESC, CantEstudiantes DESC;


/* 2) Análisis encargado tutores jornada noche: 
Identificar el nombre del encargado, el documento de identidad, el número de la camada (solo el número) y la fecha de ingreso del tutor. 
Ordenar por camada de forma mayor a menor.*/

SELECT t1.Nombre, 
	   t1.Documento, 
	   RIGHT(t2.Camada, 5) AS Comision, 
	   t2.[Fecha Ingreso]
FROM Encargado AS t1
INNER JOIN Staff AS t2
ON t1.Encargado_ID = t2.Encargado
INNER JOIN Asignaturas AS t3
ON t3.AsignaturasID = t2.Asignatura
WHERE t1.Tipo LIKE '%Encargado Tutores%' AND t3.Jornada LIKE '%Noche%'
ORDER BY Comision DESC;


/* 3) Análisis asignaturas sin docentes o tutores: 
Identificar el tipo de asignatura, la jornada, la cantidad de áreas únicas y la cantidad total de asignaturas que no tienen asignadas 
docentes o tutores. Ordenar por tipo de forma descendente.*/

SELECT t1.Nombre,
	   t1.Tipo,
	   t1.Jornada,
	   t1.Area
FROM Asignaturas AS t1
LEFT JOIN Staff AS t2
ON t1.AsignaturasID = t2.Asignatura
WHERE t2.Asignatura IS NULL
ORDER BY t1.Tipo DESC;


/* 4) Análisis asignaturas mayor al promedio: 
Identificar el nombre de la asignatura, el costo de la asignatura y el promedio del costo de las asignaturas por área. Una vez obtenido 
el dato, del promedio se debe visualizar solo las carreras que se encuentran por encima del promedio.*/

SELECT t1.Nombre, 
	   t1.Costo, 
	   t2.CostoPromedio 
FROM Asignaturas AS t1,
	(SELECT a.Nombre AS NombreAsignatura,
	        b.Nombre AS NombreArea,
			AVG(a.Costo) AS CostoPromedio
	 FROM Asignaturas AS a
	 INNER JOIN Area AS b
	 ON a.Area = b.AreaID
	 GROUP BY a.Nombre, b.Nombre) AS t2
WHERE t1.Nombre = t2.NombreAsignatura AND t1.Costo > t2.CostoPromedio


/* 5) Análisis aumento de salario docente: 
Identificar el nombre, documento de identidad, el área, la asignatura y el aumento del salario del docente, este último calcularlo 
sacándole un porcentaje al costo de la asignatura, todas las áreas tienen un porcentaje distinto, Marketing-17%, Diseño-20%, 
Programación-23%, Producto-13%, Data-15%, Herramientas 8%.*/

SELECT CONCAT(t1.Nombre,' ', t1.Apellido) AS [Nombres Completos], 
	   t1.Documento, 
	   t2.Nombre AS Asignatura,
	   t2.Costo,
	   t3.Nombre AS Area,

	   CASE WHEN t3.Nombre LIKE 'Marketing%' THEN (t2.Costo*0.17) 
	   WHEN t3.Nombre LIKE 'Diseno%' THEN (t2.Costo*0.20) 
	   WHEN t3.Nombre LIKE 'Programacion%' THEN (t2.Costo*0.23) 
       WHEN t3.Nombre LIKE 'Producto%' THEN (t2.Costo*0.13) 
	   WHEN t3.Nombre LIKE 'Data%' THEN (t2.Costo*0.15)
	   WHEN t3.Nombre LIKE 'Herramientas%' THEN (t2.Costo*0.08)
       END AS AumentoSalario  

FROM Staff AS t1
INNER JOIN Asignaturas AS t2
ON t1.Asignatura = t2.AsignaturasID
INNER JOIN Area AS t3
ON t2.Area = t3.AreaID