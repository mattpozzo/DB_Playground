CREATE DATABASE SangreTest

USE SangreTest

CREATE TABLE Grupo (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(11) NOT NULL
)

CREATE TABLE Enfermedad (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Denominacion	VARCHAR(50) NOT NULL
)

CREATE TABLE Paciente (
	ID				INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	Apellido		VARCHAR(50) NOT NULL,
	DNI				VARCHAR(10) NOT NULL,
	ID_Grupo		INT CONSTRAINT FK_ID_Grupo1 FOREIGN KEY REFERENCES Grupo(ID) NOT NULL,
	ID_Enfermedad	INT CONSTRAINT FK_ID_Enfermedad1 FOREIGN KEY REFERENCES Enfermedad(ID) NOT NULL
)

CREATE TABLE Donante (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(50) NOT NULL,
	Apellido	VARCHAR(50) NOT NULL,
	DNI			VARCHAR(10) NOT NULL,
	ID_Grupo	INT CONSTRAINT FK_ID_Grupo2 FOREIGN KEY REFERENCES Grupo(ID) NOT NULL,
	Reporte		VARCHAR(500) NOT NULL,
	Direccion	VARCHAR(100) NOT NULL,
	NumContacto	VARCHAR(20) NOT NULL
)

CREATE TABLE Banco (
	ID			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Nombre		VARCHAR(100) NOT NULL,
	Direccion	VARCHAR(100) NOT NULL,
	NumContacto	VARCHAR(20) NOT NULL,
	ID_Donante	INT CONSTRAINT FK_ID_Donante1 FOREIGN KEY REFERENCES Donante(ID) NOT NULL
)
