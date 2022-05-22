CREATE DATABASE HospitalProj

USE HospitalProj

CREATE TABLE Medico (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	Apellido		VARCHAR(50) NOT NULL,
	DNI				VARCHAR(10) NOT NULL,
	CONSTRAINT UC_Medico1 UNIQUE(DNI)
)

CREATE TABLE Departamento (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Jefe		INT CONSTRAINT FK_ID_Medico1 FOREIGN KEY REFERENCES Medico(ID) NOT NULL,
	CONSTRAINT UC_Departamento1 UNIQUE(Nombre)
)

CREATE TABLE Afiliacion (
	Medico			INT NOT NULL,
	Departamento	INT NOT NULL,
	Afiliado		BIT NOT NULL,
	PRIMARY KEY (Medico,Departamento),
	CONSTRAINT FK_ID_Medico2 FOREIGN KEY (Medico) REFERENCES Medico(ID),
	CONSTRAINT FK_ID_Departamento1 FOREIGN KEY (Departamento) REFERENCES Departamento(ID)
)

CREATE TABLE Procedimiento (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre	VARCHAR(100) NOT NULL,
	Costo	MONEY
)

CREATE TABLE Capacitacion (
	Medico			INT NOT NULL,
	Procedimiento	INT NOT NULL,
	FechaAlta		DATE NOT NULL,
	FechaBaja		DATE,
	PRIMARY KEY (Medico,Procedimiento),
	CONSTRAINT FK_ID_Medico3 FOREIGN KEY (Medico) REFERENCES Medico(ID),
	CONSTRAINT FK_ID_Procedimiento1 FOREIGN KEY (Procedimiento) REFERENCES Procedimiento(ID)
)

CREATE TABLE Paciente (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Apellido	VARCHAR(50) NOT NULL,
	DNI			VARCHAR(10) NOT NULL,
	Direccion	VARCHAR(100),
	Telefono	VARCHAR(20),
	Credencial	VARCHAR(20),
	PrimerCheck	INT CONSTRAINT FK_ID_Medico4 FOREIGN KEY REFERENCES Medico(ID)
)

CREATE TABLE Enfermero (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Apellido	VARCHAR(50) NOT NULL,
	DNI			VARCHAR(10) NOT NULL,
	Puesto		VARCHAR(50) NOT NULL,	-- Esto debería tener su propia tabla Puesto, y este campo ser una FK
	Registrado	BIT NOT NULL
)

CREATE TABLE Bloque (
	ID			INT UNIQUE IDENTITY(1,1) NOT NULL,
	PisoBloque	VARCHAR(2) NOT NULL,	
	CodBloque	VARCHAR(10) NOT NULL,
	PRIMARY KEY (PisoBloque,CodBloque)
)

CREATE TABLE TipoSala (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(50) NOT NULL
)

CREATE TABLE Sala (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(50) NOT NULL,
	TipoSala		INT CONSTRAINT FK_ID_TipoSala1 FOREIGN KEY REFERENCES TipoSala(ID) NOT NULL,
	Bloque			INT CONSTRAINT FK_ID_Bloque1 FOREIGN KEY REFERENCES Bloque(ID) NOT NULL,
	Disponible		BIT NOT NULL
)

CREATE TABLE Turno (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Paciente	INT CONSTRAINT FK_ID_Paciente1 FOREIGN KEY REFERENCES Paciente(ID) NOT NULL,
	Enfermero	INT CONSTRAINT FK_ID_Enfermero1 FOREIGN KEY REFERENCES Enfermero(ID),
	Medico		INT CONSTRAINT FK_ID_Medico5 FOREIGN KEY REFERENCES Medico(ID) NOT NULL,
	Comienzo	DATETIME NOT NULL,
	Final		DATETIME,
	Sala		INT CONSTRAINT FK_ID_Sala1 FOREIGN KEY REFERENCES Sala(ID) NOT NULL
)

CREATE TABLE Medicacion (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Fabricante	VARCHAR(50) NOT NULL,	-- Esto debería tener su propia tabla Fabricante, y este campo ser una FK
	Descripcion	VARCHAR(500) NOT NULL
)

CREATE TABLE Receta (
	ID			INT IDENTITY(1,1) NOT NULL,
	Medico		INT CONSTRAINT FK_ID_Medico6 FOREIGN KEY REFERENCES Medico(ID) NOT NULL,
	Paciente	INT CONSTRAINT FK_ID_Paciente2 FOREIGN KEY REFERENCES Paciente(ID) NOT NULL,
	Medicacion	INT CONSTRAINT FK_ID_Medicacion1 FOREIGN KEY REFERENCES Medicacion(ID) NOT NULL,
	Turno		INT CONSTRAINT FK_ID_Turno1 FOREIGN KEY REFERENCES Turno(ID) NOT NULL,
	Dosis		VARCHAR(50) NOT NULL,
	PRIMARY KEY (Medico,Paciente,Medicacion,Turno)
)

CREATE TABLE Llamada (
	ID			INT IDENTITY(1,1) NOT NULL,
	Enfermero	INT CONSTRAINT FK_ID_Enfermero2 FOREIGN KEY REFERENCES Enfermero(ID) NOT NULL,
	Bloque		INT CONSTRAINT FK_ID_Bloque2 FOREIGN KEY REFERENCES Bloque(ID) NOT NULL,
	Comienzo	DATETIME NOT NULL,
	Final		DATETIME NOT NULL,
	PRIMARY KEY (Enfermero,Bloque,Comienzo,Final)
)

CREATE TABLE Admision (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Paciente	INT CONSTRAINT FK_ID_Paciente3 FOREIGN KEY REFERENCES Paciente(ID) NOT NULL,
	Sala		INT CONSTRAINT FK_ID_Sala2 FOREIGN KEY REFERENCES Sala(ID) NOT NULL,
	Comienzo	DATETIME NOT NULL,
	Final		DATETIME
)

CREATE TABLE Intervencion (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Procedimiento	INT CONSTRAINT FK_ID_Procedimiento2 FOREIGN KEY REFERENCES Procedimiento(ID) NOT NULL,
	Admision		INT CONSTRAINT FK_ID_Admision1 FOREIGN KEY REFERENCES Admision(ID) NOT NULL,
	Fecha			DATE NOT NULL,
	Medico			INT CONSTRAINT FK_ID_Medico7 FOREIGN KEY REFERENCES Medico(ID) NOT NULL,
	Enfermero		INT CONSTRAINT FK_ID_Enfermero3 FOREIGN KEY REFERENCES Enfermero(ID),
)

GO

----------------------SP RANDOMIZADORES----------------------

-- Random DNI entre 4.000.000 y 42.000.000
CREATE PROCEDURE randDNI @dni VARCHAR(8) OUTPUT
AS
SET @dni = CAST(CAST((38000000*RAND()+4000000) AS DEC(8,0)) AS VARCHAR(10))
GO
--test
DECLARE @dni VARCHAR(8);
EXEC randDNI @dni OUTPUT;
PRINT @dni
GO

-- Random ID Médico
CREATE PROCEDURE randIDMedico @idMedico INT OUTPUT
AS
SET @idMedico = (SELECT TOP 1 ID FROM Medico ORDER BY NEWID());
GO
--test
DECLARE @idMedico INT;
EXEC randIDMedico @idMedico OUTPUT;
PRINT @idMedico
GO

-- Random ID Departamento
CREATE PROCEDURE randIDDepartamento @idDepartamento INT OUTPUT
AS
SET @idDepartamento = (SELECT TOP 1 ID FROM Departamento ORDER BY NEWID())
GO

-- Random ID Procedimiento
CREATE PROCEDURE randIDProcedimiento @idProcedimiento INT OUTPUT
AS
SET @idProcedimiento = (SELECT TOP 1 ID FROM Procedimiento ORDER BY NEWID())
GO

-- Random Fecha de Alta de Capacitación entre 01/01/2020 y ~01/01/2022
CREATE PROCEDURE randFAlta @fAlta DATE OUTPUT
AS
SET @fAlta = DATEADD(DAY,ROUND(2*365*RAND(),0),'2020-01-01')
GO

-- Random Fecha de Baja de Capacitación entre 01/01/2021 y ~01/01/2023
CREATE PROCEDURE randFBaja @fBaja DATE OUTPUT
AS
SET @fBaja = DATEADD(DAY,ROUND(2*365*RAND(),0),'2021-01-01')
GO

-- Random Telefono entre 1100000000 y 1199999999
CREATE PROCEDURE randTelefono @telefono VARCHAR(10) OUTPUT
AS
SET @telefono = CAST(CAST(ROUND(RAND()*99999999,0)+1100000000 AS INT) AS VARCHAR(10))
GO
--test
DECLARE @telefono VARCHAR(10)
EXEC randTelefono @telefono OUTPUT
PRINT @telefono
GO

-- Random Credencial entre 20 ceros y 20 nueves
CREATE PROCEDURE randCredencial @credencial VARCHAR(20) OUTPUT
AS
SET @credencial = ''
DECLARE @count INT = 0
WHILE @count<20
BEGIN
	SET @credencial = @credencial + CAST(ROUND(RAND()*9,0) AS VARCHAR(1))
	SET @count = @count + 1
END
GO
--test
DECLARE @credencial VARCHAR(20)
EXEC randCredencial @credencial OUTPUT
PRINT @credencial
GO

-- Random ID Tipo Sala
CREATE PROCEDURE randIDTipoSala @idTipoSala INT OUTPUT
AS
SET @idTipoSala = (SELECT TOP 1 ID FROM TipoSala ORDER BY NEWID())
GO

-- Random ID Bloque
CREATE PROCEDURE randIDBloque @idBloque INT OUTPUT
AS
SET @idBloque = (SELECT TOP 1 ID FROM Bloque ORDER BY NEWID())
GO

-- Random ID Sala
CREATE PROCEDURE randIDSala @idSala INT OUTPUT
AS
SET @idSala = (SELECT TOP 1 ID FROM Sala ORDER BY NEWID())
GO

-- Random ID Paciente
CREATE PROCEDURE randIDPaciente @idPaciente INT OUTPUT
AS
SET @idPaciente = (SELECT TOP 1 ID FROM Paciente ORDER BY NEWID())
GO

-- Random ID Enfermero (registrado)
CREATE PROCEDURE randIDEnfermero @idEnfermero INT OUTPUT
AS
SET @idEnfermero = (SELECT TOP 1 ID FROM Enfermero WHERE Registrado = 1 ORDER BY NEWID())
GO

-- Random Fecha Evento (Turno, Admision, Llamada, Intervención), un año desde input
CREATE PROCEDURE randFecha @fecha DATETIME OUTPUT
AS
DECLARE @to DATETIME = DATEADD(YEAR, 1, @fecha)
DECLARE @sec INT = DATEDIFF(SECOND, @fecha, @to)
DECLARE @random INT = ROUND(((@sec-1) * RAND()), 0)
SET @fecha = (SELECT DATEADD(SECOND, @random, @fecha))
GO
--test
DECLARE @fecha DATETIME = '2021-01-01 00:00:00'
EXEC randFecha @fecha OUTPUT
PRINT @fecha
GO

-- Random ID Medicacion
CREATE PROCEDURE randIDMedicacion @idMedicacion INT OUTPUT
AS
SET @idMedicacion = (SELECT TOP 1 ID FROM Medicacion ORDER BY NEWID())
GO

-- Random ID Turno
CREATE PROCEDURE randIDTurno @idTurno INT OUTPUT
AS
SET @idTurno = (SELECT TOP 1 ID FROM Turno ORDER BY NEWID())
GO

-- Random ID Admision
CREATE PROCEDURE randIDAdmision @idAdmision INT OUTPUT
AS
SET @idAdmision = (SELECT TOP 1 ID FROM Admision ORDER BY NEWID())
GO

-----------------------SP DE INSERCIÓN-----------------------

-- Insert masivo Medico
CREATE PROCEDURE insertMedico @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @dni VARCHAR(8);
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Medico);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randDNI @dni OUTPUT
		INSERT INTO Medico VALUES (
			'Nombre' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Apellido' + CAST((@count+@suffix) AS VARCHAR(10)),
			@dni)
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertMedico 5
SELECT * FROM Medico
GO

-- Insert masivo Departamento
CREATE PROCEDURE insertDepartamento @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idMedico INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Departamento);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDMedico @idMedico OUTPUT
		INSERT INTO Departamento VALUES (
			'Departamento' + CAST((@count+@suffix) AS VARCHAR(10)),
			@idMedico)
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertDepartamento 5;
SELECT * FROM Departamento
GO

-- Insert masivo Afiliacion
CREATE PROCEDURE insertAfiliacion @cant INT	-- VA AL CATCH PADRE CUANDO SE ACTIVA EL CATCH HIJO: CORREGIR
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idMedico INT;
	DECLARE @idDepartamento INT;
	WHILE @count < @cant
	BEGIN
		EXEC randIDMedico @idMedico OUTPUT
		EXEC randIDDepartamento @idDepartamento OUTPUT
		BEGIN TRY
			INSERT INTO Afiliacion VALUES (
				@idMedico,
				@idDepartamento,
				ROUND(RAND(),0))
		END TRY
		BEGIN CATCH
			PRINT 'PAIR IDMEDICO='+@idMedico+' / IDDEPARTAMENTO='+@idDepartamento+' ALREADY IN TABLE'
		END CATCH
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertAfiliacion 10
SELECT * FROM Afiliacion
GO

-- Insert masivo Procedimiento
CREATE PROCEDURE insertProcedimiento @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Procedimiento);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		INSERT INTO Procedimiento VALUES (
			'Procedimiento' + CAST((@count+@suffix) AS VARCHAR(10)),
			CAST((99000*RAND()+1000) AS MONEY))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertProcedimiento 10
SELECT * FROM Procedimiento
GO

-- Insert masivo Capacitacion
CREATE PROCEDURE insertCapacitacion @cant INT	-- VA AL CATCH PADRE CUANDO SE ACTIVA EL CATCH HIJO: CORREGIR
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idMedico INT;
	DECLARE @idProcedimiento INT;
	DECLARE @fAlta DATE;
	DECLARE @fBaja DATE;
	WHILE @count < @cant
	BEGIN
		EXEC randIDMedico @idMedico OUTPUT
		EXEC randIDProcedimiento @idProcedimiento OUTPUT
		EXEC randFAlta @fAlta OUTPUT
		EXEC randFBaja @fBaja OUTPUT
		BEGIN TRY
			INSERT INTO Capacitacion VALUES (
				@idMedico,
				@idProcedimiento,
				@fAlta,
				@fBaja)
		END TRY
		BEGIN CATCH
			PRINT 'PAIR IDMEDICO='+@idMedico+' / IDPROCEDIMIENTO='+@idProcedimiento+' ALREADY IN TABLE'
		END CATCH
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertCapacitacion 10
SELECT * FROM Capacitacion
GO

-- Insert masivo Paciente
CREATE PROCEDURE insertPaciente @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @dni VARCHAR(10);
	DECLARE @telefono VARCHAR(20);
	DECLARE @credencial VARCHAR(20);
	DECLARE @idMedico INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Paciente);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randDNI @dni OUTPUT
		EXEC randTelefono @telefono OUTPUT
		EXEC randCredencial @credencial OUTPUT
		EXEC randIDMedico @idMedico OUTPUT
		INSERT INTO Paciente VALUES (
			'Nombre' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Apellido' + CAST((@count+@suffix) AS VARCHAR(10)),
			@dni,
			'Direccion' + CAST((@count+@suffix) AS VARCHAR(10)),
			@telefono,
			@credencial,
			@idMedico)
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertPaciente 20
SELECT * FROM Paciente
GO

-- Insert masivo Enfermero
CREATE PROCEDURE insertEnfermero @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @dni VARCHAR(10);
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Enfermero);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randDNI @dni OUTPUT
		INSERT INTO Enfermero VALUES (
			'Nombre' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Apellido' + CAST((@count+@suffix) AS VARCHAR(10)),
			@dni,
			'Puesto' + CAST((@count+@suffix) AS VARCHAR(10)),
			ROUND(RAND(),0))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertEnfermero 10
SELECT * FROM Enfermero
GO

-- Insert masivo Bloque
CREATE PROCEDURE insertBloque @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Bloque);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		INSERT INTO Bloque VALUES (
			CAST(CAST(ROUND(RAND()*9+1,0) AS INT) AS VARCHAR(2)),
			'Bloque' + CAST((@count+@suffix) AS VARCHAR(10)))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertBloque 5
SELECT * FROM Bloque
GO

-- Insert masivo Tipo Sala
CREATE PROCEDURE insertTipoSala @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM TipoSala);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		INSERT INTO TipoSala VALUES ('Tipo' + CAST((@count+@suffix) AS VARCHAR(10)))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertTipoSala 5
SELECT * FROM TipoSala
GO

CREATE PROCEDURE insertSala @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idTipoSala INT;
	DECLARE @idBloque INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Sala);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDTipoSala @idTipoSala OUTPUT
		EXEC randIDBloque @idBloque OUTPUT
		INSERT INTO Sala VALUES (
			'Sala' + CAST((@count+@suffix) AS VARCHAR(10)),
			@idTipoSala,
			@idBloque,
			ROUND(RAND(),0))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertSala 10
SELECT * FROM Sala
GO

CREATE PROCEDURE insertTurno @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idPaciente INT;
	DECLARE @idEnfermero INT;
	DECLARE @idMedico INT;
	DECLARE @idSala INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Turno);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		DECLARE @fecha DATETIME = '2021-01-01 00:00:00';
		EXEC randIDPaciente @idPaciente OUTPUT
		EXEC randIDEnfermero @idEnfermero OUTPUT
		EXEC randIDMedico @idMedico OUTPUT
		EXEC randFecha @fecha OUTPUT
		EXEC randIDSala @idSala OUTPUT
		INSERT INTO Turno VALUES (
			@idPaciente,
			@idEnfermero,
			@idMedico,
			@fecha,
			DATEADD(MINUTE,ROUND(RAND()*115+5,0),@fecha),
			@idSala)
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertTurno 20
SELECT * FROM Turno
GO

CREATE PROCEDURE insertMedicacion @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Medicacion);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		INSERT INTO Medicacion VALUES (
			'Nombre' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Fabricante' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Descripcion' + CAST((@count+@suffix) AS VARCHAR(10)))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertMedicacion 100
SELECT * FROM Medicacion
GO

CREATE PROCEDURE insertReceta @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idMedico INT;
	DECLARE @idPaciente INT;
	DECLARE @idMedicacion INT;
	DECLARE @idTurno INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Receta);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		BEGIN TRY
		EXEC randIDMedico @idMedico OUTPUT
		EXEC randIDPaciente @idPaciente OUTPUT
		EXEC randIDMedicacion @idMedicacion OUTPUT
		EXEC randIDTurno @idTurno OUTPUT
		INSERT INTO Receta VALUES (
			@idMedico,
			@idPaciente,
			@idMedicacion,
			@idTurno,
			'Dosis' + CAST((@count+@suffix) AS VARCHAR(10)))
		SET @count = @count + 1
		END TRY
		BEGIN CATCH
			PRINT 'GROUP IDMEDICO='+@idMedico+' / IDPACIENTE='+@idPaciente+' / IDMEDICACION='+@idMedicacion+' / IDTURNO='+@idTurno+' ALREADY IN TABLE'
			SET @count = @count + 1
		END CATCH
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertReceta 10
SELECT * FROM Receta ORDER BY ID
GO

CREATE PROCEDURE insertLlamada @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idEnfermero INT;
	DECLARE @idBloque INT;
	WHILE @count < @cant
	BEGIN
		BEGIN TRY
		DECLARE @fecha DATETIME = '2021-01-01 00:00:00';
		EXEC randIDEnfermero @idEnfermero OUTPUT
		EXEC randIDBloque @idBloque OUTPUT
		EXEC randFecha @fecha OUTPUT
		INSERT INTO Llamada VALUES (
			@idEnfermero,
			@idBloque,
			@fecha,
			DATEADD(SECOND,ROUND(RAND()*110+10,0),@fecha))
		SET @count = @count + 1
		END TRY
		BEGIN CATCH
			PRINT 'GROUP IDENFERMERO='+@idEnfermero+' / IDBLOQUE='+@idBloque+' / COMIENZO='+@fecha+' / FINAL ALREADY IN TABLE'
			SET @count = @count + 1
		END CATCH
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertLlamada 25
SELECT * FROM Llamada
GO

CREATE PROCEDURE insertAdmision @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idPaciente INT;
	DECLARE @idSala INT;
	WHILE @count < @cant
	BEGIN
		DECLARE @fecha DATETIME = '2021-01-01 00:00:00';
		EXEC randIDPaciente @idPaciente OUTPUT
		EXEC randIDSala @idSala OUTPUT
		EXEC randFecha @fecha OUTPUT
		INSERT INTO Admision VALUES (
			@idPaciente,
			@idSala,
			@fecha,
			DATEADD(HOUR,ROUND(RAND()*164+4,0),@fecha))
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertAdmision 15
SELECT * FROM Admision
GO

CREATE PROCEDURE insertIntervencion @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idProcedimiento INT;
	DECLARE @idAdmision INT;
	DECLARE @fecha DATETIME;
	DECLARE @idMedico INT;
	DECLARE @idEnfermero INT;
	WHILE @count < @cant
	BEGIN
		EXEC randIDProcedimiento @idProcedimiento OUTPUT
		EXEC randIDAdmision @idAdmision OUTPUT
		SET @fecha = CAST((SELECT Comienzo FROM Admision WHERE ID = @idAdmision) AS DATE)
		SET @idMedico = (SELECT TOP 1 aux.Medico FROM (SELECT * FROM Capacitacion WHERE Procedimiento = @idProcedimiento) AS aux ORDER BY NEWID())
		EXEC randIDEnfermero @idEnfermero OUTPUT
		INSERT INTO Intervencion VALUES (
			@idProcedimiento,
			@idAdmision,
			@fecha,
			@idMedico,
			@idEnfermero)
		SET @count = @count + 1
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO
--test
EXEC insertIntervencion 15
SELECT * FROM Intervencion ORDER BY Procedimiento
GO
SELECT * FROM Capacitacion ORDER BY Procedimiento
GO

--------------------FUNCIONES PRINCIPALES--------------------

CREATE VIEW noRegistrado AS
	SELECT * FROM Enfermero WHERE Registrado = 0;
GO
--test
SELECT * FROM noRegistrado
GO

CREATE VIEW jefesEnfermeria AS
	SELECT Nombre,Puesto FROM Enfermero WHERE Puesto LIKE '%Jefe%' OR Puesto LIKE '%jefe%';
GO
--test
SELECT * FROM jefesEnfermeria
GO

CREATE VIEW jefesDepartamento AS
	SELECT Departamento.Nombre AS Departamento,Medico.Nombre AS nMedico,Medico.Apellido AS aMedico
	FROM Departamento
	INNER JOIN Medico ON Departamento.Director = Medico.ID
GO
--test
SELECT * FROM jefesDepartamento
GO
