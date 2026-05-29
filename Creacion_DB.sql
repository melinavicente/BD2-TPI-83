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
    DNI varchar(15) unique not null,
    Sueldo decimal(18,2),
    Materia varchar(50)
)

Create table Departamento (
    ID_Depto int identity (1,1) primary key,
    Nombre varchar(100) not null,
    Telefono varchar(20),
    Email varchar(50) unique,
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
    DNI varchar(15) unique not null,
    Nombre varchar(50) NOT NULL,
    Apellido varchar(50) NOT NULL,
    Telefono varchar(20), 
    Email varchar(50) unique NOT NULL,
    Domicilio varchar(100),
    Fecha_Nacimiento DATE,
    ID_Carrera int,
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Materia (
    ID_Materia int identity (1,1) primary key,
    Nombre_Materia varchar(100) NOT NULL,
    Horas_Semanales int NOT NULL,
    ID_Carrera int,
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Docentes (
    ID_Docente int identity (1,1) primary key,
    Nombre varchar(50) NOT NULL,
    Apellido varchar(50) NOT NULL,
    Telefono varchar(20), 
    Email varchar(50) unique NOT NULL,
    Sueldo decimal(18,2) NOT NULL,
    ID_Carrera int,
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Catedra (
    ID_Catedra int identity (1,1) primary key,
    ID_Materia int,
    ID_Docente int,
    Turno varchar(20) NOT NULL,
    Año_Lectivo int NOT NULL,
    FOREIGN KEY (ID_Materia) REFERENCES Materia(ID_Materia),
    FOREIGN KEY (ID_Docente) REFERENCES Docentes(ID_Docente)
)

Create table Calificaciones (
    ID_Nota int identity (1,1) primary key,
    ID_Materia int,
    Legajo_Alumno int,
    Calificacion decimal(4,2),
    Fecha_Calificacion DATE,
    FOREIGN KEY (ID_Materia) REFERENCES Materia(ID_Materia),
    FOREIGN KEY (Legajo_Alumno) REFERENCES Alumnos(Legajo_Alumno)
)



Create table Inscripcion (
    ID_Inscripcion int identity (1,1) primary key,
    ID_Catedra int,
    Legajo_Alumno int,
    Estado bit,
    Fecha_Inscripcion DATE,
    Ciclo_Lectivo int,
    FOREIGN KEY (ID_Catedra) REFERENCES Catedra(ID_Catedra),
    FOREIGN KEY (Legajo_Alumno) REFERENCES Alumnos(Legajo_Alumno)
)



