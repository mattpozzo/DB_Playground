
CREATE DATABASE DevAgenci

USE DevAgenci


------------------------------- CREACIÓN DE TABLAS -------------------------------

BEGIN TRY
BEGIN TRAN
CREATE TABLE Pais (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre	VARCHAR(100) NOT NULL
)

CREATE TABLE Provincia (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre	VARCHAR(100) NOT NULL,
	ID_Pais	INT CONSTRAINT FK_Pais1 FOREIGN KEY REFERENCES Pais(ID) NOT NULL
)

CREATE TABLE Transporte (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Tipo	VARCHAR(50) NOT NULL	-- Auto, micro, tren, avión
)

CREATE TABLE Genero (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Tipo	VARCHAR(10) NOT NULL	-- M, F, otro, etc.
)

CREATE TABLE Tipo_Documento (
	ID				INT PRIMARY KEY IDENTITY(1,1),
	Denominacion	VARCHAR(50) NOT NULL,	-- DNI, LE, Pasaporte, etc.
	ID_Pais			INT CONSTRAINT FK_Pais2 FOREIGN KEY REFERENCES Pais(ID) NULL
)

CREATE TABLE Tipo_Contacto (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Tipo	VARCHAR(50) NOT NULL	-- Teléfono,E-mail,etc.
)

CREATE TABLE Tipo_Persona (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Tipo	VARCHAR(50) NOT NULL	-- Pasajero, cliente, vendedor
)
/*
CREATE TABLE Operacion (
	ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Tipo	VARCHAR(20) NOT NULL	-- Inserción, modificación, eliminación
)
*/
CREATE TABLE Destino(
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(100) NOT NULL,
--	ID_Transporte	INT CONSTRAINT FK_Transporte1 FOREIGN KEY REFERENCES Transporte(ID) NOT NULL,
	ID_Provincia	INT CONSTRAINT FK_Provincia1 FOREIGN KEY REFERENCES Provincia(ID) NOT NULL
)

CREATE TABLE Oficina (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(100) NOT NULL,
--	Direccion		VARCHAR(200) NOT NULL,
	ID_Provincia	INT CONSTRAINT FK_Provincia2 FOREIGN KEY REFERENCES Provincia(ID) NOT NULL
)

CREATE TABLE Persona (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Apellido		VARCHAR(50) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	ID_Tipo_Per		INT CONSTRAINT FK_Tipo_Per1 FOREIGN KEY REFERENCES Tipo_Persona(ID) NOT NULL,
	ID_Tipo_Doc		INT CONSTRAINT FK_Tipo_Doc1 FOREIGN KEY REFERENCES Tipo_Documento(ID) NOT NULL,		-- tiene nacionalidad implícita (ver tabla Tipo_Doc)
	Nro_Doc			VARCHAR(30) NOT NULL,
	Fecha_Nac		DATE NOT NULL,
	ID_Genero		INT CONSTRAINT FK_Genero1 FOREIGN KEY REFERENCES Genero(ID) NOT NULL,
	Pais_Res		INT CONSTRAINT FK_Pais3 FOREIGN KEY REFERENCES Pais(ID) NOT NULL,
	Direccion		VARCHAR(200) NULL
)

CREATE TABLE Contacto (
	Contacto			VARCHAR(100) NOT NULL,
	ID_Persona			INT CONSTRAINT FK_Persona1 FOREIGN KEY REFERENCES Persona(ID) NOT NULL,
	ID_Tipo_Contacto	INT CONSTRAINT FK_Tipo_Contacto1 FOREIGN KEY REFERENCES Tipo_Contacto(ID) NOT NULL,
	ID					INT IDENTITY(1,1) NOT NULL,
	CONSTRAINT PK_Contacto PRIMARY KEY CLUSTERED (ID_Persona,ID_Tipo_Contacto)
)

CREATE TABLE Cliente (
	Mail		VARCHAR(100) PRIMARY KEY NOT NULL,
	Clave		VARCHAR(30) NOT NULL,
	ID_Cliente	INT UNIQUE CONSTRAINT FK_Persona2 FOREIGN KEY REFERENCES Persona(ID) NOT NULL
)

CREATE TABLE Vendedor (
	ID_Vendedor	INT PRIMARY KEY CONSTRAINT FK_Persona3 FOREIGN KEY REFERENCES Persona(ID) NOT NULL,
	CUIL		VARCHAR(30) NOT NULL,
	ID_Oficina	INT CONSTRAINT FK_Oficina1 FOREIGN KEY REFERENCES Oficina(ID) NOT NULL
)

CREATE TABLE Viaje (
	ID						INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_Pasajero				INT CONSTRAINT FK_Persona4 FOREIGN KEY REFERENCES Persona(ID) NOT NULL,
	ID_Cliente				INT CONSTRAINT FK_Cliente1 FOREIGN KEY REFERENCES Cliente(ID_Cliente) NOT NULL,
	Fecha_Venta				DATE NOT NULL,
	Fecha_Viaje				DATE NOT NULL,
	ID_Vendedor				INT CONSTRAINT FK_Vendedor1 FOREIGN KEY REFERENCES Vendedor(ID_Vendedor) NOT NULL,
	ID_Origen				INT CONSTRAINT FK_Destino3 FOREIGN KEY REFERENCES Destino(ID) NOT NULL,
	ID_Destino				INT CONSTRAINT FK_Destino4 FOREIGN KEY REFERENCES Destino(ID) NOT NULL,
	Monto					MONEY NOT NULL,
	Descuento_Aplicado		FLOAT NOT NULL,
	ID_Transporte			INT CONSTRAINT FK_Transporte1 FOREIGN KEY REFERENCES Transporte(ID) NOT NULL,
	Codigo_Grupo			VARCHAR(17) NULL,
	Codigo_Pasaje			VARCHAR(16) UNIQUE NULL,
	ID_Vendedor_Baja		INT CONSTRAINT FK_Vendedor2 FOREIGN KEY REFERENCES Vendedor(ID_Vendedor) NULL,
	Fecha_Baja				DATE NULL,
	Motivo_Baja				VARCHAR(500) NULL
)

CREATE TABLE Bitacora_Personas (		-- No usa FK porque en una aplicación real estaría almacenada externamente (acá esta tabla es casi simbólica, no se implementa así irl)
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Persona		VARCHAR(100) NOT NULL,
	Operacion	VARCHAR(20) NOT NULL,
	Fecha		DATETIME NOT NULL
)

COMMIT TRAN
END TRY
BEGIN CATCH
PRINT 'ERROR'
ROLLBACK TRAN
END CATCH


------------------------------- INSERT BÁSICOS NO-ALEATORIOS -------------------------------

INSERT INTO Transporte VALUES ('Auto'),('Micro'),('Tren'),('Avión');

INSERT INTO Genero VALUES ('Masculino'),('Femenino'),('No binario'),('NC');

INSERT INTO Tipo_Contacto VALUES ('E-mail'),('Teléfono 1'),('Teléfono 2'),('Teléfono 3');

INSERT INTO Tipo_Persona VALUES ('Vendedor'),('Cliente'),('Pasajero');

INSERT INTO Pais VALUES ('Argentina'),('Uruguay'),('Chile'),('Ecuador');
GO


------------------------------- SP RANDOMIZADORES -------------------------------
-- Devuelven valores numéricos o de fecha aleatorios

-- Random ID País
CREATE PROCEDURE randIDPais @idPais INT OUTPUT
AS
SELECT @idPais = (SELECT TOP 1 ID FROM Pais ORDER BY NEWID());
GO

-- Random ID Provincia
CREATE PROCEDURE randIDProvincia @idProvincia INT OUTPUT
AS
SELECT @idProvincia = (SELECT TOP 1 ID FROM Provincia ORDER BY NEWID());
GO

-- Random ID Tipo_Persona
CREATE PROCEDURE randIDTPersona @idTPersona INT OUTPUT
AS
SELECT @idTPersona = (SELECT TOP 1 ID FROM Tipo_Persona ORDER BY NEWID());
GO

-- Random ID Tipo_Documento
CREATE PROCEDURE randIDTDocumento @idTDocumento INT OUTPUT
AS
SELECT @idTDocumento = (SELECT TOP 1 ID FROM Tipo_Documento ORDER BY NEWID());
GO

-- Random ID Género
CREATE PROCEDURE randIDGenero @idGenero INT OUTPUT
AS
SELECT @idGenero = (SELECT TOP 1 ID FROM Genero ORDER BY NEWID());
GO

-- Random ID Persona
CREATE PROCEDURE randIDPersona @idPersona INT OUTPUT
AS
SELECT @idPersona = (SELECT TOP 1 ID FROM Persona ORDER BY NEWID());
GO

-- Random ID Cliente
CREATE PROCEDURE randIDCliente @idCliente INT OUTPUT
AS
SELECT @idCliente = (SELECT TOP 1 ID_Cliente FROM Cliente ORDER BY NEWID());
GO

-- Random ID Vendedor
CREATE PROCEDURE randIDVendedor @idVendedor INT OUTPUT
AS
SELECT @idVendedor = (SELECT TOP 1 ID_Vendedor FROM Vendedor ORDER BY NEWID());
GO

-- Random ID Pasajero
CREATE PROCEDURE randIDPasajero @idPasajero INT OUTPUT
AS
SELECT @idPasajero = (SELECT TOP 1 ID FROM Persona WHERE ID_Tipo_Per = 3 ORDER BY NEWID())
GO

-- Random ID Tipo_Contacto
CREATE PROCEDURE randIDTContacto @idTContacto INT OUTPUT
AS
SELECT @idTContacto = (SELECT TOP 1 ID FROM Tipo_Contacto ORDER BY NEWID());
GO

-- Random ID Oficina
CREATE PROCEDURE randIDOficina @idOficina INT OUTPUT
AS
SELECT @idOficina = (SELECT TOP 1 ID FROM Oficina ORDER BY NEWID());
GO

-- Random ID Destino
CREATE PROCEDURE randIDDestino @idDestino INT OUTPUT
AS
SELECT @idDestino = (SELECT TOP 1 ID FROM Destino ORDER BY NEWID());
GO

-- Random ID Transporte
CREATE PROCEDURE randIDTransporte @idTransporte INT OUTPUT
AS
SELECT @idTransporte = (SELECT TOP 1 ID FROM Transporte ORDER BY NEWID());
GO

-- Random DNI entre 33.000.000 y 43.000.000
CREATE PROCEDURE randDNI @dni VARCHAR(8) OUTPUT
AS
SET @dni = CAST(CAST((33000000*RAND()+10000000) AS DEC(8,0)) AS VARCHAR(10))
GO

-- Random Fecha de Nacimiento entre 30/10/1951 y ~30/10/2003
CREATE PROCEDURE randFNac @fNac DATE OUTPUT
AS
SET @fNac = DATEADD(DAY,ROUND(52*365*RAND(),0),'1951-10-30')	--asumo personas de entre 18 y 70 años al día de hoy
GO

-- Random Fecha de Venta entre 01/01/2019 y ~01/01/2021
CREATE PROCEDURE randFVenta @fVenta DATE OUTPUT
AS
SET @fVenta = DATEADD(DAY,ROUND(2*365*RAND(),0),'2019-01-01')
GO

-- Random Fecha de Viaje entre 01/01/2020 y ~01/01/2022
CREATE PROCEDURE randFViaje @fViaje DATE OUTPUT
AS
SET @fViaje = DATEADD(DAY,ROUND(2*365*RAND(),0),'2020-01-01')
GO

-- Random monto entre $10.000 y $200.000
CREATE PROCEDURE randMonto @monto MONEY OUTPUT
AS
SET @monto = 190000*RAND()+10000
GO


------------------------------- FUNCIONES Y SP DE INSERCIÓN -------------------------------

-- Generación de Codigo_Grupo para Viaje
CREATE FUNCTION genCodGrup (@idTran INT)
RETURNS VARCHAR(17) AS
BEGIN
	DECLARE @init CHAR(1)
	DECLARE @antCod VARCHAR(17)
	DECLARE @cod VARCHAR(17)
	DECLARE @size INT
	SET @init = (SELECT CASE @idTran	-- elige una letra inicial basada en el transporte que se usará
		WHEN 1 THEN 'A'
		WHEN 2 THEN 'M'
		WHEN 3 THEN 'T'
		WHEN 4 THEN 'V'
		END)
	SET @antCod = (SELECT TOP 1 Codigo_Grupo FROM Viaje WHERE Codigo_Grupo LIKE @init+'%' ORDER BY Codigo_Grupo DESC)	-- almacena el último código de grupo que comience con @init
	IF @antCod IS NULL
		SET @cod = @init+'0000000000000000'		-- si no existe ningún código de grupo que comience con @init, crea el primero (@cod es el parámetro de salida)
	ELSE
	BEGIN
		SET @antCod = CAST(RIGHT(@antCod,16) AS BIGINT)
		SET @antCod = CAST((@antCod + 1) AS VARCHAR(17))	-- incrementa en 1 el valor numérico del código de grupo almacenado
		SET @size = LEN(@antCod)
		DECLARE @count INT = 0;
		WHILE @count < 16-@size
			BEGIN
			SET @cod = CONCAT(@cod,'0');	-- inserta la cantidad de ceros necesarios entre la letra inicial y el valor numérico no-nulo (i.e. @antCod)
			SET @count = @count + 1;
			END
		SET @cod = CONCAT(@init,@cod,@antCod);		-- crea el nuevo código de grupo
	END
	RETURN @cod
END
GO

--test
PRINT dbo.genCodGrup(3)
GO

-- Generación de Codigo_Pasaje para Viaje
CREATE FUNCTION genCodPas(@id BIGINT)
RETURNS VARCHAR(16) AS
BEGIN
	SET @id = CAST(@id AS VARCHAR(16));
	DECLARE @size INT = LEN(@id);
	DECLARE @cod VARCHAR(16);
	DECLARE @count INT = 0;
	WHILE @count < 16-@size
		BEGIN
		SET @cod = CONCAT(@cod,'0');	-- inserta la cantidad de ceros necesarios antes del valor numérico no-nulo (i.e. @id)
		SET @count = @count + 1;
		END
	SET @cod = CONCAT(@cod,@id);	-- crea el nuevo código de pasaje (no se repite ya que @id es único; en caso de que se repita, se arroja un error debido al keyword UNIQUE con el que se define el campo Codigo_Pasaje)
	RETURN @cod
END
GO

--test
PRINT dbo.genCodPas(1)
PRINT dbo.genCodPas(123)
PRINT dbo.genCodPas(12345)
PRINT dbo.genCodPas(10000000)
PRINT dbo.genCodPas(9999999999999999)
GO

-- Insert masivo Provincia
CREATE PROCEDURE insertProv @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idPais INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Provincia);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDPais @idPais OUTPUT
		INSERT INTO Provincia VALUES ('Provincia ' + CAST((@count+@suffix) AS VARCHAR(10)),@idPais)
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
EXEC insertProv 2
SELECT * FROM Provincia
GO

-- Insert masivo Tipo_Documento
CREATE PROCEDURE insertTipoDoc @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idPais INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Tipo_Documento);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDPais @idPais OUTPUT
		INSERT INTO Tipo_Documento VALUES ('Documento ' + CAST((@count+@suffix) AS VARCHAR(10)),@idPais)
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
EXEC insertTipoDoc 1
SELECT * FROM Tipo_Documento
GO

-- Insert masivo Destino
CREATE PROCEDURE insertDestino @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idProv INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Destino);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDProvincia @idProv OUTPUT
		INSERT INTO Destino VALUES ('Destino ' + CAST((@count+@suffix) AS VARCHAR(10)),@idProv)
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
EXEC insertDestino 10
SELECT * FROM Destino
GO

-- Insert masivo Oficina
CREATE PROCEDURE insertOficina @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idProv INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Oficina);
	IF @suffix IS NULL SET @suffix = 0;
	WHILE @count < @cant
	BEGIN
		EXEC randIDProvincia @idProv OUTPUT
		INSERT INTO Oficina VALUES ('Oficina ' + CAST((@count+@suffix) AS VARCHAR(10)),@idProv)
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
EXEC insertOficina 10
SELECT * FROM Oficina
GO

-- Insert masivo Persona
CREATE PROCEDURE insertPersona @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idTPersona INT;
	DECLARE @idTDocumento INT;
	DECLARE @dni VARCHAR(8);
	DECLARE @fNac DATE;
	DECLARE @idGenero INT;
	DECLARE @idPais INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Persona);
	IF @suffix IS NULL SET @suffix = 0;
	DECLARE @cuil VARCHAR(11);
	DECLARE @idOficina INT;
	WHILE @count < @cant
	BEGIN
		EXEC randIDTPersona @idTPersona OUTPUT
		EXEC randIDTDocumento @idTDocumento OUTPUT
		EXEC randDNI @dni OUTPUT
		EXEC randFNac @fNac OUTPUT
		EXEC randIDGenero @idGenero OUTPUT
		EXEC randIDPais @idPais OUTPUT
		INSERT INTO Persona VALUES (
			'Apellido ' + CAST((@count+@suffix) AS VARCHAR(10)),
			'Nombre ' + CAST((@count+@suffix) AS VARCHAR(10)),
			@idTPersona,
			@idTDocumento,
			@dni,
			@fNac,
			@idGenero,
			@idPais,
			'Dirección ' + CAST((@count+@suffix) AS VARCHAR(10)))
		IF @idTPersona = 1 --vend
		BEGIN
			SET @cuil = '20'+@dni+'8'	-- existe todo un algoritmo para calcular el CUIL correctamente; implementar a futuro
			EXEC randIDOficina @idOficina OUTPUT
			INSERT INTO Vendedor VALUES (
				(SELECT MAX(ID) FROM Persona),
				@cuil,
				@idOficina)
		END
		ELSE IF @idTPersona = 2 --cli
		BEGIN
			INSERT INTO Cliente VALUES (
				'Mail ' + CAST((@count+@suffix) AS VARCHAR(10)),
				'Clave ' + CAST((@count+@suffix) AS VARCHAR(10)),
				(SELECT MAX(ID) FROM Persona))
		END
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
EXEC insertPersona 100
SELECT * FROM Persona
SELECT * FROM Vendedor
SELECT * FROM Cliente
GO

-- Insert masivo Contacto
CREATE PROCEDURE insertContacto @cant INT
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @idPersona INT;
	DECLARE @idTContacto INT;
	DECLARE @suffix INT = (SELECT MAX(ID) FROM Contacto);
	IF @suffix IS NULL SET @suffix = 0;
	DECLARE @eCount INT = 0;
	WHILE @count < @cant
	BEGIN
		BEGIN TRY
			EXEC randIDPersona @idPersona OUTPUT
			EXEC randIDTContacto @idTContacto OUTPUT
			INSERT INTO Contacto VALUES ('Contacto ' + CAST((@count+@suffix) AS VARCHAR(10)),@idPersona,@idTContacto)
		END TRY
		BEGIN CATCH
			SET @eCount = @eCount + 1
		END CATCH
		SET @count = @count + 1
	END
	PRINT 'Se lograron insertar '+CAST(@cant-@eCount AS VARCHAR(10))+'/'+CAST(@cant AS VARCHAR(10))+' registros.'
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO

--test
EXEC insertContacto 1000
SELECT * FROM Contacto ORDER BY ID
GO

-- Trigger de inserción para Bitacora_Personas
CREATE TRIGGER trigInsert ON Persona
FOR INSERT
AS
BEGIN
	INSERT INTO Bitacora_Personas
	SELECT Nombre+' '+Apellido,'Inserción',GETDATE() FROM Persona WHERE ID = (SELECT MAX(ID) FROM inserted)
END
GO

-- Trigger de modificación para Bitacora_Personas
CREATE TRIGGER trigUpdate ON Persona
FOR UPDATE
AS
BEGIN
	INSERT INTO Bitacora_Personas
	SELECT Nombre+' '+Apellido,'Modificación',GETDATE() FROM Persona WHERE ID = (SELECT MAX(ID) FROM deleted)
END
GO

-- Trigger de eliminación para Bitacora_Personas
CREATE TRIGGER trigDelete ON Persona
FOR DELETE
AS
BEGIN
	INSERT INTO Bitacora_Personas
	SELECT Nombre+' '+Apellido,'Eliminación',GETDATE() FROM Persona WHERE ID = (SELECT MAX(ID) FROM deleted)
END
GO

-- Función para devolver la tabla de pasajeros que cumplen años dentro del mes en el que está @fechaVenta
CREATE FUNCTION promoTable (@fechaVenta DATE)
RETURNS TABLE AS
RETURN
	SELECT ID, Apellido, Nombre, Fecha_Nac FROM Persona
	WHERE ID_Tipo_Per = 3 AND MONTH(@fechaVenta) = MONTH(Fecha_Nac) AND DATEADD(YEAR,18,Fecha_Nac)<=@fechaVenta;
GO

--test
SELECT * FROM promoTable('2021-01-10')
GO

-- Insert masivo Viaje 
CREATE PROCEDURE insertViajeMass @cant INT, @descuento FLOAT	-- donde @descuento es un número decimal menor a 1 (proporción descontada, no porcentaje)
AS
IF @cant <= 0
	BEGIN
	PRINT 'Ingrese una cantidad mayor a cero.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	DECLARE @count INT = 0;
	DECLARE @randGrupal INT = 0;	-- parámetro que indica si el pasajero insertado pertenece al mismo grupo que el anterior o no
	DECLARE @descuentoAux FLOAT = @descuento;
	DECLARE @idPasajero BIGINT;
	DECLARE @idCliente BIGINT;
	DECLARE @fVenta DATE;
	DECLARE @fViaje DATE;
	DECLARE @idVend BIGINT;
	DECLARE @idOrigen INT;
	DECLARE @idDestino INT;
	DECLARE @monto MONEY;
	DECLARE @montoAux MONEY;
	DECLARE @idTransporte INT;
	DECLARE @codGrupo VARCHAR(17);
	DECLARE @codPasaje VARCHAR(16);
	DECLARE @idMax BIGINT;
	WHILE @count < @cant
	BEGIN
		EXEC randIDPasajero @idPasajero OUTPUT;
		IF @randGrupal < 4
		BEGIN
			EXEC randIDCliente @idCliente OUTPUT;
			EXEC randFVenta @fVenta OUTPUT;
			EXEC randFViaje @fViaje OUTPUT;
			WHILE @fViaje<@fVenta EXEC randFViaje @fViaje OUTPUT;
			EXEC randIDVendedor @idVend OUTPUT;
			EXEC randIDDestino @idOrigen OUTPUT;
			EXEC randIDDestino @idDestino OUTPUT;
			EXEC randMonto @monto OUTPUT;
			SET @montoAux = @monto;
			EXEC randIDTransporte @idTransporte OUTPUT;
		END
		IF @idPasajero IN (SELECT ID FROM promoTable(@fVenta))
			BEGIN
			SET @monto = (1-@descuento)*@monto;
			END
		ELSE
			SET @descuento = 0;
		INSERT INTO Viaje VALUES (@idPasajero,@idCliente,@fVenta,@fViaje,@idVend,@idOrigen,@idDestino,@monto,@descuento,@idTransporte,NULL,NULL,NULL,NULL,NULL)
		SET @idMax = (SELECT MAX(ID) FROM Viaje)
		IF @randGrupal < 4 
			SET @codGrupo = dbo.genCodGrup(@idTransporte);
		SET @codPasaje = dbo.genCodPas(@idMax)
		UPDATE Viaje
			SET Codigo_Grupo = @codGrupo, Codigo_Pasaje = @codPasaje
			WHERE ID = @idMax
		SET @count = @count + 1
		SET @randGrupal = ROUND(3.5*RAND()+1,0)
		SET @descuento = @descuentoAux;
		SET @monto = @montoAux;
	END
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO

--test
DECLARE @desc FLOAT = 0.1;
EXEC insertViajeMass 100,@desc
EXEC insertViajeMass -5,@desc
SELECT * FROM Viaje
GO

-- Insert individual Viaje
CREATE PROCEDURE insertViaje @idPasajero INT, @idCliente INT, @fVenta DATE, @fViaje DATE, @idVendedor INT, @idOrigen INT, @idDestino INT, @monto MONEY, @descuento FLOAT, @idTransporte INT, @codGrupo VARCHAR(17)
AS
IF @idPasajero NOT IN (SELECT ID FROM Persona WHERE ID_Tipo_Per = 3)
	BEGIN
	PRINT 'Ingrese un ID de pasajero válido.'
	RETURN
	END
IF @idCliente NOT IN (SELECT ID_Cliente FROM Cliente)
	BEGIN
	PRINT 'Ingrese un ID de cliente válido.'
	RETURN
	END
IF @idVendedor NOT IN (SELECT ID_Vendedor FROM Vendedor)
	BEGIN
	PRINT 'Ingrese un ID de vendedor válido.'
	RETURN
	END
IF @idOrigen NOT IN (SELECT ID FROM Destino) OR @idDestino NOT IN (SELECT ID FROM Destino)
	BEGIN
	PRINT 'Ingrese ID de origen y destino válidos.'
	RETURN
	END
IF @idTransporte NOT IN (SELECT ID FROM Transporte)
	BEGIN
	PRINT 'Ingrese un ID de transporte válido'
	RETURN
	END
IF @codGrupo IN (SELECT Codigo_Grupo FROM Viaje)
	BEGIN
	PRINT 'Ingrese un código de grupo válido'
	RETURN
	END
IF @monto < 0
	BEGIN
	PRINT 'Ingrese un monto válido.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	IF @idPasajero IN (SELECT ID FROM promoTable(@fVenta))
		SET @monto = (1-@descuento)*@monto;
	ELSE
		SET @descuento = 0
	INSERT INTO Viaje VALUES (@idPasajero,@idCliente,@fVenta,@fViaje,@idVendedor,@idOrigen,@idDestino,@monto,@descuento,@idTransporte,@codGrupo,NULL,NULL,NULL,NULL)
	DECLARE @idMax INT = (SELECT MAX(ID) FROM Viaje)
	DECLARE @codPasaje VARCHAR(17) = dbo.genCodPas(@idMax)
	UPDATE Viaje
		SET Codigo_Pasaje = @codPasaje
		WHERE ID = @idMax
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO

--test (realizar inserts masivos, después ver qué IDs funcionarían bien y mal, y recién ahí probar con los queries de abajo)
DECLARE @idTran INT = 2
DECLARE @codGrupo VARCHAR(17) = dbo.genCodGrup(@idTran)
EXEC insertViaje 3,4,'2020-10-07', '2021-04-01', 2, 4, 5, 100000, 0.1, @idTran, @codGrupo
SELECT * FROM Viaje ORDER BY ID DESC
GO
DECLARE @idTran INT = 2
DECLARE @codGrupo VARCHAR(17) = dbo.genCodGrup(@idTran)
EXEC insertViaje 3,3,'2020-10-07', '2021-04-01', 2, 4, 5, 100000, 0.1, @idTran, @codGrupo
GO

-- Cancelación de Viaje individual
CREATE PROCEDURE cancelViaje @codPasaje VARCHAR(16), @idVend INT, @fechaBaja DATE, @motivo VARCHAR(500)
AS
IF @codPasaje NOT IN (SELECT Codigo_Pasaje FROM Viaje) OR @idVend NOT IN (SELECT ID_Vendedor FROM Vendedor)
	BEGIN
	PRINT 'Ingrese valores de entrada válidos.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	UPDATE Viaje
		SET ID_Vendedor_Baja = @idVend, Fecha_Baja = @fechaBaja, Motivo_Baja = @motivo
		WHERE Codigo_Pasaje = @codPasaje
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO

--test
DECLARE @codPasaje VARCHAR(16) = (SELECT Codigo_Pasaje FROM Viaje WHERE ID = (SELECT MAX(ID) FROM Viaje))
SELECT * FROM Viaje WHERE ID = (SELECT MAX(ID) FROM Viaje)
EXEC cancelViaje @codPasaje,6,'2020-10-06','Enfermedad'
SELECT * FROM Viaje WHERE ID = (SELECT MAX(ID) FROM Viaje)
GO

-- Cancelación de Viaje grupal
CREATE PROCEDURE cancelViajeGrupal @codGrupo VARCHAR(17), @idVend INT, @fechaBaja DATE, @motivo VARCHAR(500)
AS
IF @codGrupo NOT IN (SELECT Codigo_Grupo FROM Viaje) OR @idVend NOT IN (SELECT ID_Vendedor FROM Vendedor)
	BEGIN
	PRINT 'Ingrese valores de entrada válidos.'
	RETURN
	END
BEGIN TRY
	BEGIN TRAN
	UPDATE Viaje
		SET ID_Vendedor_Baja = @idVend, Fecha_Baja = @fechaBaja, Motivo_Baja = @motivo
		WHERE Codigo_Grupo = @codGrupo
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'UNKNOWN ERROR'
	ROLLBACK TRAN
END CATCH
GO

--test (hacer insert masivo de Viaje, buscar dónde hay un código de grupo repetido, y probar el query de abajo con ese código)
SELECT * FROM Viaje WHERE Codigo_Grupo = 'M0000000000000007'
EXEC cancelViajeGrupal 'M0000000000000007',6,'2020-10-06','Enfermedad'
SELECT * FROM Viaje WHERE Codigo_Grupo = 'M0000000000000007'
GO


------------------------------- FUNCIONES Y VISTAS PRINCIPALES -------------------------------

-- Devuelve la tabla de ventas individuales (i.e. con código de grupo correspondiente a un único pasajero) realizadas por cada vendedor
CREATE FUNCTION vendIndividual()
RETURNS TABLE AS RETURN(
	SELECT ID_Vendedor,Codigo_Grupo,COUNT(Codigo_Grupo) AS cantVendida
	FROM Viaje
	GROUP BY ID_Vendedor,Codigo_Grupo
	HAVING COUNT(Codigo_Grupo)=1
	ORDER BY ID_Vendedor
)
GO

--test
SELECT * FROM vendIndividual() ORDER BY ID_Vendedor
GO

-- Devuelve la tabla de ventas grupales (i.e. con código de grupo correspondiente a más de un pasajero) realizadas por cada vendedor
CREATE FUNCTION vendGrupal()
RETURNS TABLE AS RETURN(
	SELECT ID_Vendedor,Codigo_Grupo,COUNT(Codigo_Grupo) AS cantVendida
	FROM Viaje
	GROUP BY ID_Vendedor,Codigo_Grupo
	HAVING COUNT(Codigo_Grupo)>1
--	ORDER BY ID_Vendedor
)
GO

--test
SELECT * FROM vendGrupal() ORDER BY ID_Vendedor
GO

-- Vista de cantidad de pasajes individuales y grupales vendidos por cada vendedor
CREATE VIEW vendidosPorVendedor AS
	SELECT ID,Nombre,Apellido,cantIndividuales,SUM(vGrup.cantVendida) AS cantGrupales FROM (
	SELECT Vendedor.ID_Vendedor AS ID, Persona.Nombre AS Nombre, Persona.Apellido AS Apellido, SUM(vInd.cantVendida) AS cantIndividuales
	FROM Vendedor
	INNER JOIN Persona ON Vendedor.ID_Vendedor = Persona.ID
	LEFT JOIN vendIndividual() AS vInd ON Vendedor.ID_Vendedor = vInd.ID_Vendedor
	GROUP BY Vendedor.ID_Vendedor,Persona.Nombre,Persona.Apellido) AS auxTable
	LEFT JOIN vendGrupal() AS vGrup ON auxTable.ID = vGrup.ID_Vendedor
	GROUP BY auxTable.ID,auxTable.Nombre,auxTable.Apellido,auxTable.cantIndividuales
GO

--test
SELECT * FROM vendidosPorVendedor
GO

/*
El query que genera la vista anterior es un quilombo, pero es el mejor que se me ocurrió. Originalmente, la vista anterior era generada por un query más corto:
	CREATE VIEW vendidosPorVendedor AS
		SELECT Vendedor.ID_Vendedor AS ID, Persona.Nombre AS Nombre, Persona.Apellido AS Apellido, SUM(vInd.cantVendida) AS cantIndividuales, SUM(vGrup.cantVendida) AS cantGrupales
		FROM Vendedor
		INNER JOIN Persona ON Vendedor.ID_Vendedor = Persona.ID
		LEFT JOIN vendIndividual() AS vInd ON Vendedor.ID_Vendedor = vInd.ID_Vendedor
		LEFT JOIN vendGrupal() AS vGrup ON vInd.ID_Vendedor = vGrup.ID_Vendedor
		GROUP BY Vendedor.ID_Vendedor,Persona.Nombre,Persona.Apellido;
	GO
Sin embargo, este calculaba mal las sumatorias de pasajes vendidos (a veces individuales, a veces grupales, a veces ambos).
*/

-- Vista de cantidad de pasajes vendidos por cada oficina
CREATE VIEW vendidosPorOficina AS
	SELECT Vendedor.ID_Oficina AS ID, Oficina.Denominacion AS Denominacion, COUNT(Viaje.ID) AS Cantidad_Vendida
	FROM Oficina
	INNER JOIN Vendedor ON Oficina.ID = Vendedor.ID_Oficina
	INNER JOIN Viaje ON Vendedor.ID_Vendedor = Viaje.ID_Vendedor
	GROUP BY Vendedor.ID_Oficina,Oficina.Denominacion
GO

--test
SELECT * FROM vendidosPorOficina
GO

-- Vista de cantidad de pasajes vendidos por cada país (i.e. la sumatoria de las oficinas dentro de un país)
CREATE VIEW vendidosPorPais AS
	SELECT Pais.ID AS ID, Pais.Nombre AS Nombre, COUNT(Viaje.ID) AS Cantidad_Vendida
	FROM Pais
	INNER JOIN Provincia ON Pais.ID = Provincia.ID_Pais
	INNER JOIN Oficina ON Provincia.ID = Oficina.ID_Provincia
	INNER JOIN Vendedor ON Oficina.ID = Vendedor.ID_Oficina
	INNER JOIN Viaje ON Vendedor.ID_Vendedor = Viaje.ID_Vendedor
	GROUP BY Pais.ID,Pais.Nombre
GO

--test
SELECT * FROM vendidosPorPais
GO

-- Vista de facturación total realizada por cada oficina
CREATE VIEW facturacionOficina AS
	SELECT Vendedor.ID_Oficina AS ID, Oficina.Denominacion AS Denominacion, SUM(Viaje.Monto) AS Facturacion
	FROM Oficina
	INNER JOIN Vendedor ON Oficina.ID = Vendedor.ID_Oficina
	INNER JOIN Viaje ON Vendedor.ID_Vendedor = Viaje.ID_Vendedor
	GROUP BY Vendedor.ID_Oficina,Oficina.Denominacion
GO

--test
SELECT * FROM facturacionOficina
GO

-- Vista de facturación total realizada por cada país (i.e. la sumatoria de las oficinas dentro de un país)
CREATE VIEW facturacionPais AS
	SELECT Pais.ID AS ID, Pais.Nombre AS Nombre, SUM(Viaje.Monto) AS Cantidad_Vendida
	FROM Pais
	INNER JOIN Provincia ON Pais.ID = Provincia.ID_Pais
	INNER JOIN Oficina ON Provincia.ID = Oficina.ID_Provincia
	INNER JOIN Vendedor ON Oficina.ID = Vendedor.ID_Oficina
	INNER JOIN Viaje ON Vendedor.ID_Vendedor = Viaje.ID_Vendedor
	GROUP BY Pais.ID,Pais.Nombre
GO

--test
SELECT * FROM facturacionPais
GO

-- Devuelve el total de ingresos "perdidos" por aplicar descuentos entre las fechas @fInicio y @fFin
CREATE FUNCTION descuentoAplicadoTotal(@fInicio DATE,@fFin DATE)
RETURNS MONEY AS
BEGIN
	RETURN(
		SELECT SUM((Monto/(1-Descuento_Aplicado))-Monto) FROM Viaje WHERE Fecha_Venta BETWEEN @fInicio AND @fFin
	)
END
GO


------------------------------- BACK-UP DEL DB -------------------------------

BACKUP DATABASE DevAgenci
TO DISK = 'C:\DevAgenci_POZZO.bak'
WITH FORMAT;
GO
