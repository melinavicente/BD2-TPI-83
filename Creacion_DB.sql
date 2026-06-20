Create database Universidad_BD
go 

Use Universidad_BD 
go

Create table Institucion (
    ID_Institucion int identity (1,1) primary key,
    Nombre varchar(50) not null,
    Telefono varchar(20),
    Email varchar(50),
    Domicilio varchar(100)
)

CREATE TABLE Personas (
    ID_Persona INT IDENTITY (1,1) PRIMARY KEY,
    DNI VARCHAR(15) UNIQUE NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Telefono VARCHAR(20), 
    Email VARCHAR(50) UNIQUE NOT NULL,
    Domicilio VARCHAR(100),
    Fecha_Nacimiento DATE
)

CREATE TABLE Departamento (
    ID_Depto INT IDENTITY (1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(50) UNIQUE,
    ID_Institucion INT,
    FOREIGN KEY (ID_Institucion) REFERENCES Institucion(ID_Institucion),
) 

Create table Carrera (
    ID_Carrera int identity (1,1) primary key,
    Nombre varchar(100) not null,
    Cantidad_Materias int not null,
    ID_Depto int,
    FOREIGN KEY (ID_Depto) REFERENCES Departamento(ID_Depto)
)

Create table Alumnos (
    ID_Alumno INT IDENTITY (1,1) PRIMARY KEY,
    ID_Persona INT UNIQUE NOT NULL,
    FOREIGN KEY (ID_Persona) REFERENCES Personas(ID_Persona)
)

Create table Alumnos_Carrera (
    Legajo_Alumno INT IDENTITY (1,1) PRIMARY KEY,
    ID_Alumno INT NOT NULL,
    ID_Carrera INT,
    Estado bit,
    FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Docentes (
    ID_Docente INT IDENTITY (1,1) PRIMARY KEY,
    ID_Persona INT UNIQUE NOT NULL,
    Sueldo DECIMAL(18,2) NOT NULL,
    ID_Carrera INT,
    FOREIGN KEY (ID_Persona) REFERENCES Personas(ID_Persona),
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Materia (
    ID_Materia int identity (1,1) primary key,
    Nombre_Materia varchar(100) NOT NULL,
    Horas_Semanales int NOT NULL,
    ID_Carrera int,
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

Create table Director (
    ID_Director INT IDENTITY (1,1) PRIMARY KEY,
    ID_Docente INT UNIQUE NOT NULL,
    ID_Depto int,
    Matricula VARCHAR(20) NOT NULL,
    Sueldo_Director DECIMAL(18,2),
    FOREIGN KEY (ID_Docente) REFERENCES Docentes(ID_Docente),
    Foreign key (ID_Depto) references Departamento(ID_Depto)
)

Create table Catedra (
    ID_Catedra int identity (1,1) primary key,
    ID_Materia int,
    ID_Docente int,
    Turno varchar(20) NOT NULL,
    Año_Lectivo int NOT NULL,
    Cupo_Maximo INT NOT NULL DEFAULT 2,
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
    FOREIGN KEY (Legajo_Alumno) REFERENCES Alumnos_Carrera(Legajo_Alumno)
)

Create table Inscripcion (
    ID_Inscripcion int identity (1,1) primary key,
    ID_Catedra int,
    Legajo_Alumno int,
    Fecha_Inscripcion DATE,
    Ciclo_Lectivo int,
    FOREIGN KEY (ID_Catedra) REFERENCES Catedra(ID_Catedra),
    FOREIGN KEY (Legajo_Alumno) REFERENCES Alumnos_Carrera(Legajo_Alumno)
)

CREATE TABLE Asistencias (
    ID_Asistencia INT IDENTITY (1,1) PRIMARY KEY,
    ID_Catedra INT,
    Legajo_Alumno INT,
    Fecha DATE NOT NULL,
    Estado BIT NOT NULL,
    FOREIGN KEY (ID_Catedra) REFERENCES Catedra(ID_Catedra),
    FOREIGN KEY (Legajo_Alumno) REFERENCES Alumnos_Carrera(Legajo_Alumno)
)

CREATE TABLE Liquidacion_Sueldos (
    ID_Liquidacion INT IDENTITY (1,1) PRIMARY KEY,
    ID_Docente INT,
    Periodo DATE NOT NULL,
    Monto_Neto DECIMAL(18,2) NOT NULL,
    Fecha_Calculo DATE,
    Fecha_Pago DATE,
    ID_Director INT,
    FOREIGN KEY (ID_Docente) REFERENCES Docentes(ID_Docente),
    FOREIGN KEY (ID_Director) REFERENCES Director(ID_Director)
)

CREATE TABLE Vacaciones_Docentes (
    ID_Vacaciones INT IDENTITY (1,1) PRIMARY KEY,
    ID_Docente INT,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE NOT NULL,
    Año_Correspondiente DATE,
    FOREIGN KEY (ID_Docente) REFERENCES Docentes(ID_Docente)
)
