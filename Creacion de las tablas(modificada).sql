----STEPHANY GRUESO MOLINA 
----WALTHER ESTACIO ORDOÑEZ 


-- Creacion de las tablas
CREATE TABLE ubicaciones (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE
);

CREATE TABLE proveedores (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE,
    telefono VARCHAR(15) NULL,
    correo VARCHAR(100) NULL
);

CREATE TABLE tipos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE
);

CREATE TABLE extintores (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    capacidad INT UNSIGNED,
    fechafabricacion DATE,
    VARCHAR(50), 
    idtipo INT UNSIGNED,
    idubicacion INT UNSIGNED,
    idproveedor INT UNSIGNED,
    FOREIGN KEY (idtipo) REFERENCES tipos(id),
    FOREIGN KEY (idubicacion) REFERENCES ubicaciones(id),
    FOREIGN KEY (idproveedor) REFERENCES proveedores(id)
);

CREATE TABLE inspecciones (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    idextintor INT UNSIGNED,
    fecha DATE,
    proximainspeccion DATE,
    FOREIGN KEY (idextintor) REFERENCES extintores(id)
);

CREATE TABLE recargas (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    idextintor INT UNSIGNED,
    fecha DATE,
    proximarecarga DATE,
    FOREIGN KEY (idextintor) REFERENCES extintores(id)
);

-- Consultas SQL

------Cantidad total de extintores por cada ubicacion
SELECT ubicaciones.nombre AS Ubicacion, COUNT(extintores.id) AS Cantidad_Extintores
FROM ubicaciones
LEFT JOIN extintores ON ubicaciones.id = extintores.idubicacion
GROUP BY ubicaciones.nombre;

------Suma de las capacidades de todos los extintores por cada tipo de extintor
SELECT tipos.nombre AS Tipo_Extintor, SUM(extintores.capacidad) AS Suma_Capacidades
FROM tipos
LEFT JOIN extintores ON tipos.id = extintores.idtipo
GROUP BY tipos.nombre;

------Fecha de fabricacion mas reciente de cada tipo de extintor
SELECT tipos.nombre AS Tipo_Extintor, MAX(extintores.fechafabricacion) AS Fecha_Reciente
FROM tipos
LEFT JOIN extintores ON tipos.id = extintores.idtipo
GROUP BY tipos.nombre;

------Numero de inspecciones realizadas en cada extintor
SELECT idextintor, COUNT(*) AS Num_Inspecciones
FROM inspecciones
GROUP BY idextintor;

------Suma de las capacidades de los extintores suministrados por cada proveedor en un rango de fechas
SELECT proveedores.nombre AS Proveedor, SUM(extintores.capacidad) AS Suma_Capacidades
FROM proveedores
LEFT JOIN extintores ON proveedores.id = extintores.idproveedor
WHERE extintores.fechafabricacion BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD'
GROUP BY proveedores.nombre;

------Cantidad de recargas realizadas en extintores de un tipo especifico en ubicaciones que sean salas 
DECLARE tipo_especifico INT; 
SET tipo_especifico = <valor>; 
SELECT COUNT(*) AS Num_Recargas
FROM recargas
INNER JOIN extintores ON recargas.idextintor = extintores.id
INNER JOIN ubicaciones ON extintores.idubicacion = ubicaciones.id
WHERE ubicaciones.nombre LIKE 'sala%'
AND extintores.idtipo = tipo_especifico;

------Numero de recargas realizadas en extintores cuya ultima inspeccion fue hace mas de seis meses 
SELECT COUNT(*) AS Num_Recargas
FROM recargas
INNER JOIN inspecciones ON recargas.idextintor = inspecciones.idextintor
WHERE DATEDIFF(NOW(), inspecciones.fecha) > 180;

------Cantidad de inspecciones realizadas en extintores que tienen al menos dos recargas en el ultimo año
SELECT COUNT(*) AS Num_Inspecciones
FROM inspecciones
INNER JOIN (
    SELECT idextintor
    FROM recargas
    WHERE fecha BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW()
    GROUP BY idextintor
    HAVING COUNT(*) >= 2
) AS recargas_ult_anio ON inspecciones.idextintor = recargas_ult_anio.idextintor;

------Promedio de las capacidades de los extintores que tienen mas de tres recargas en total
SELECT AVG(capacidad) AS Promedio_Capacidades
FROM extintores
INNER JOIN (
    SELECT idextintor
    FROM recargas
    GROUP BY idextintor
    HAVING COUNT(*) > 3
) AS extintores_mas_tres_recargas ON extintores.id = extintores_mas_tres_recargas.idextintor;

------Cantidad de recargas realizadas en extintores cuya fecha de ultima inspeccion esta entre dos fechas específicas
SELECT COUNT(*) AS Num_Recargas
FROM recargas
INNER JOIN inspecciones ON recargas.idextintor = inspecciones.idextintor
WHERE inspecciones.fecha BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD';
