Create database Universidad_BD
go 

Use Universidad_BD 
go

Create table Institucion (
    ID_Institucion int identity (1,1) primary key,
    Nombre varchar(50) not null,
    Telefono varchar(20),
    Email varchar(50)
)

Create table Director (
    ID_Director int identity (1,1) primary key,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    DNI varchar(15) not null,
    Sueldo decimal(18,2),
    Materia varchar(50)
)

Create table Departamento (
    ID_Depto int identity (1,1) primary key,
    Nombre varchar(100) not null,
    Telefono varchar(20),
    Email varchar(50),
    ID_Director int,
    ID_Institucion int,
    FOREIGN KEY (ID_Director) REFERENCES Director(ID_Director),
    FOREIGN KEY (ID_Institucion) REFERENCES Institucion(ID_Institucion) 
)

Create table Carrera (
    ID_Carrera int identity (1,1) primary key,
    Nombre varchar(100) not null,
    Cantidad_Materias int not null,
    ID_Depto int,
    FOREIGN KEY (ID_Depto) REFERENCES Departamento(ID_Depto)
)

Create table Alumnos (
    Legajo_Alumno int identity (1,1) primary key,
    DNI varchar(15) not null,
    Nombre varchar(50) NOT NULL,
    Apellido varchar(50) NOT NULL,
    Telefono varchar(20), 
    Email varchar(50) NOT NULL,
    Domicilio varchar(100),
    Fecha_Nacimiento DATE,
    ID_Carrera int,
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)