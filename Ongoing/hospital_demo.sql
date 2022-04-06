CREATE DATABASE HospitalTest

USE HospitalTest

CREATE TABLE Sala (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(20) NOT NULL
)

CREATE TABLE TipoPersona (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(20) NOT NULL
)

CREATE TABLE Especialidad (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(50) NOT NULL
)

CREATE TABLE Medico (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	Apellido		VARCHAR(50) NOT NULL,
	DNI				VARCHAR(10) NOT NULL,
	FechaNac		DATE,
	ID_Especialidad	INT CONSTRAINT FK_ID_Especialidad1 FOREIGN KEY REFERENCES Especialidad(ID),
	CONSTRAINT UC_Medico UNIQUE(DNI)
)

CREATE TABLE Paciente (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Apellido	VARCHAR(50) NOT NULL,
	DNI			VARCHAR(10) NOT NULL,
	FechaNac	DATE NOT NULL,
	CONSTRAINT UC_Persona UNIQUE(DNI)
)

CREATE TABLE Enfermero (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Apellido	VARCHAR(50) NOT NULL,
	DNI			VARCHAR(10) NOT NULL,
	FechaNac	DATE,
	CONSTRAINT UC_Enfermero UNIQUE(DNI)
)

CREATE TABLE Ingreso (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_Paciente		INT CONSTRAINT FK_ID_Paciente1 FOREIGN KEY REFERENCES Paciente(ID) NOT NULL,
	Hora_Ingreso	DATETIME NOT NULL,
	Hora_Egreso		DATETIME,
	ID_Sala			INT CONSTRAINT FK_ID_Sala1 FOREIGN KEY REFERENCES Sala(ID) NOT NULL
)

CREATE TABLE Horario (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_MedEnf		INT NOT NULL,
	ID_TipoPersona	INT CONSTRAINT FK_ID__TipoPersona1 REFERENCES TipoPersona (ID) NOT NULL,
	DiaLab			VARCHAR(7),		-- puede ser uno, algunos o todos en un string de chars ordenados: LMXJVSD
	HoraIn			TIME NOT NULL,
	HoraOut			TIME NOT NULL
	CONSTRAINT FK_ID_Medico1 FOREIGN KEY (ID_MedEnf) REFERENCES Medico(ID),
	CONSTRAINT FK_ID_Enfermero1 FOREIGN KEY (ID_MedEnf) REFERENCES Enfermero(ID)
)

CREATE TABLE Atencion (		-- Muestra qué médico/s y/o enfermero/s se encargaron de cada ingreso (ID_Ingreso repetido, cada fila con un ID_Medico o ID_Enfermero distinto, VER QUE SE PUEDE HACER QUE ESA FK TENGA MULTIPLES REFERENCIAS https://stackoverflow.com/questions/50416627/how-can-same-foreign-key-have-multiple-references-in-sql)
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_Ingreso		INT CONSTRAINT FK_ID_Ingreso1 REFERENCES Ingreso(ID) NOT NULL,
	ID_MedEnf		INT NOT NULL,
	ID_TipoPersona	INT CONSTRAINT FK_ID_TipoPersona2 REFERENCES TipoPersona(ID) NOT NULL,
	CONSTRAINT FK_ID_Medico2 FOREIGN KEY (ID_MedEnf) REFERENCES Medico(ID),
	CONSTRAINT FK_ID_Enfermero2 FOREIGN KEY (ID_MedEnf) REFERENCES Enfermero(ID)
)

CREATE TABLE EstadoTratamiento (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(20) NOT NULL
)

CREATE TABLE Tratamiento (		-- Procesos a largo plazo, con seguimiento de un solo médico
	ID						INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_Paciente				INT CONSTRAINT FK_ID_Paciente2 FOREIGN KEY REFERENCES Paciente(ID) NOT NULL,
	ID_Medico				INT CONSTRAINT FK_ID_Medico3 FOREIGN KEY REFERENCES Medico(ID) NOT NULL,
	Descripcion				VARCHAR(500) NOT NULL,
	ID_EstadoTratamiento	INT CONSTRAINT FK_ID_EstadoTratamiento1 FOREIGN KEY REFERENCES EstadoTratamiento(ID) NOT NULL,
	Fecha_Inicio			DATE NOT NULL,
	Fecha_Final				DATE
)

