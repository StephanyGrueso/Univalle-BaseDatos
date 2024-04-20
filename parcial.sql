-- DANI ESTIVEN ESTACIO TORRES

CREATE TABLE SalasDeSistemas (
    ID_Sala INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    NombreSala VARCHAR(100) UNIQUE,
    CantidadExtintores INT UNSIGNED
);

CREATE TABLE Proveedores (
    ID_Proveedor INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    NombreProveedor VARCHAR(100) UNIQUE,
    Telefono VARCHAR(15) UNIQUE,
    CorreoElectronico VARCHAR(100) UNIQUE
);

CREATE TABLE Extintores (
    ID_Extintor INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ID_Sala INT UNSIGNED,
    ClaseExtintor VARCHAR(50),
    Capacidad INT UNSIGNED,
    FechaFabricacion DATE,
    FechaUltimaInspeccion DATE,
    FechaProximaInspeccion DATE,
    FechaUltimaRecarga DATE,
    FechaProximaRecarga DATE,
    Estado VARCHAR(50),
    ID_Proveedor INT UNSIGNED,
    FOREIGN KEY (ID_Sala) REFERENCES SalasDeSistemas(ID_Sala),
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor)
);

CREATE TABLE Inspecciones (
    ID_Inspeccion INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ID_Extintor INT UNSIGNED,
    FechaInspeccion DATE,
    FOREIGN KEY (ID_Extintor) REFERENCES Extintores(ID_Extintor)
);

CREATE TABLE Recargas (
    ID_Recarga INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ID_Extintor INT UNSIGNED,
    FechaRecarga DATE,
    ID_Proveedor INT UNSIGNED,
    FOREIGN KEY (ID_Extintor) REFERENCES Extintores(ID_Extintor),
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor)
);

CREATE TABLE HistorialMantenimiento (
    ID_Mantenimiento INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ID_Extintor INT UNSIGNED,
    FechaMantenimiento DATE,
    Costo DECIMAL(10,2),
    FOREIGN KEY (ID_Extintor) REFERENCES Extintores(ID_Extintor)
);

-- Insertar datos en la tabla SalasDeSistemas
INSERT INTO SalasDeSistemas (NombreSala, CantidadExtintores) VALUES ('Sala 1', 2);
INSERT INTO SalasDeSistemas (NombreSala, CantidadExtintores) VALUES ('Sala 2', 3);
INSERT INTO SalasDeSistemas (NombreSala, CantidadExtintores) VALUES ('Sala 3', 1);

-- Insertar datos en la tabla Proveedores
INSERT INTO Proveedores (NombreProveedor, Telefono, CorreoElectronico) VALUES ('Proveedor A', '1234567890', 'proveedora@example.com');
INSERT INTO Proveedores (NombreProveedor, Telefono, CorreoElectronico) VALUES ('Proveedor B', '9876543210', 'proveedorb@example.com');
INSERT INTO Proveedores (NombreProveedor, Telefono, CorreoElectronico) VALUES ('Proveedor C', '1112223333', 'proveedorc@example.com');

-- Insertar datos en la tabla Extintores
INSERT INTO Extintores (ID_Sala, ClaseExtintor, Capacidad, FechaFabricacion, FechaUltimaInspeccion, FechaProximaInspeccion, FechaUltimaRecarga, FechaProximaRecarga, Estado, ID_Proveedor) VALUES (4, 'Clase A', 10, '2023-01-01', '2023-02-01', '2023-07-01', '2023-01-01', '2023-07-01', 'En uso', 8);
INSERT INTO Extintores (ID_Sala, ClaseExtintor, Capacidad, FechaFabricacion, FechaUltimaInspeccion, FechaProximaInspeccion, FechaUltimaRecarga, FechaProximaRecarga, Estado, ID_Proveedor) VALUES (5, 'Clase B', 5, '2023-02-01', '2023-03-01', '2023-08-01', '2023-02-01', '2023-08-01', 'En uso', 9);
INSERT INTO Extintores (ID_Sala, ClaseExtintor, Capacidad, FechaFabricacion, FechaUltimaInspeccion, FechaProximaInspeccion, FechaUltimaRecarga, FechaProximaRecarga, Estado, ID_Proveedor) VALUES (6, 'Clase C', 8, '2023-03-01', '2023-04-01', '2023-09-01', '2023-03-01', '2023-09-01', 'En mantenimiento', 10);

-- Insertar datos en la tabla Inspecciones
INSERT INTO Inspecciones (ID_Extintor, FechaInspeccion) VALUES (6, '2023-02-15');
INSERT INTO Inspecciones (ID_Extintor, FechaInspeccion) VALUES (7, '2023-03-20');
INSERT INTO Inspecciones (ID_Extintor, FechaInspeccion) VALUES (8, '2023-04-25');

-- Insertar datos en la tabla Recargas
INSERT INTO Recargas (ID_Extintor, FechaRecarga, ID_Proveedor) VALUES (6, '2023-01-15', 8);
INSERT INTO Recargas (ID_Extintor, FechaRecarga, ID_Proveedor) VALUES (7, '2023-02-20', 10);
INSERT INTO Recargas (ID_Extintor, FechaRecarga, ID_Proveedor) VALUES (8, '2023-03-25', 9);

-- Insertar datos en la tabla HistorialMantenimiento
INSERT INTO HistorialMantenimiento (ID_Extintor, FechaMantenimiento, Costo) VALUES (7, '2023-01-05', 50.00);
INSERT INTO HistorialMantenimiento (ID_Extintor, FechaMantenimiento, Costo) VALUES (6, '2023-02-10', 75.00);
INSERT INTO HistorialMantenimiento (ID_Extintor, FechaMantenimiento, Costo) VALUES (8, '2023-03-15', 100.00);

SELECT NombreSala, CantidadExtintores
FROM SalasDeSistemas;

SELECT COUNT(ID_Proveedor) AS TotalProveedores
FROM Proveedores;

SELECT MAX(ID_Proveedor) AS MaxIDProveedor
FROM Proveedores;

SELECT SalasDeSistemas.NombreSala, Extintores.ClaseExtintor, Extintores.Estado
FROM Extintores
JOIN SalasDeSistemas ON Extintores.ID_Sala = SalasDeSistemas.ID_Sala;

SELECT ID_Extintor, COUNT(ID_Inspeccion) AS TotalInspecciones
FROM Inspecciones
GROUP BY ID_Extintor;

SELECT ID_Extintor, SUM(Costo) AS CostoTotalMantenimiento
FROM HistorialMantenimiento
GROUP BY ID_Extintor;

SELECT SalasDeSistemas.NombreSala, Proveedores.NombreProveedor, Recargas.FechaRecarga
FROM Extintores
JOIN SalasDeSistemas ON Extintores.ID_Sala = SalasDeSistemas.ID_Sala
JOIN Recargas ON Extintores.ID_Extintor = Recargas.ID_Extintor
JOIN Proveedores ON Recargas.ID_Proveedor = Proveedores.ID_Proveedor;

SELECT ID_Extintor
FROM Extintores
WHERE Estado = 'En uso' AND DATEDIFF(FechaProximaRecarga, CURRENT_DATE()) <= 7;

CREATE VIEW vw_extintores AS
SELECT e.ID_Extintor, e.ClaseExtintor, e.Capacidad, e.Estado, s.NombreSala AS Sala, p.NombreProveedor AS Proveedor
FROM Extintores e
JOIN SalasDeSistemas s ON e.ID_Sala = s.ID_Sala
JOIN Proveedores p ON e.ID_Proveedor = p.ID_Proveedor;

CREATE VIEW vw_recargas_proveedor AS
SELECT 
    r.ID_Extintor, 
    r.FechaRecarga, 
    ultima_recarga.FechaUltimaRecarga AS UltimaFechaRecarga,
    p.NombreProveedor AS Proveedor
FROM Recargas r
JOIN Proveedores p ON r.ID_Proveedor = p.ID_Proveedor
LEFT JOIN (
    SELECT ID_Extintor, MAX(FechaRecarga) AS FechaUltimaRecarga
    FROM Recargas
    GROUP BY ID_Extintor
) AS ultima_recarga ON r.ID_Extintor = ultima_recarga.ID_Extintor;


