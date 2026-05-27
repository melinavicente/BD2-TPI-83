Create database Universidad_BD
go 

Use Universidad_BD 
go

Create table Alumnos (
	DNI int Identity (1,1) primary key,
	Nombre varchar(50) NOT NULL,
	Apellido varchar(50) NOT NULL,
	Telefono varchar(100), 
	Email varchar (100) NOT NULL,
	Domicilio varchar (200),
	Fecha_Nacimiento DATE
	--FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
)

