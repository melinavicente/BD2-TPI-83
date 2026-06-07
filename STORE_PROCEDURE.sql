use Universidad_BD
go

--Dar de alta un alumno en el sistema
create procedure sp_AltaAlumno 
@dni varchar(15),
@nombre varchar (50),
@apellido varchar (50),
@telefono varchar(20),
@email varchar (50),
@domicilio varchar(100),
@fecha_Nacimiento DATE,
@ID_Carrera int 
as
begin 

if exists (select 1 from Personas where DNI=@dni)
begin 
raiserror ('Ya existe una persona con ese dni registrado', 16, 1)
return
end 

if exists (select 1 from Personas where Email = @email)
begin 
raiserror ('Ya existe una persona con ese email registrado', 16, 1)
end 

begin try 
	begin transaction 
	insert into Personas (DNI, Nombre, Apellido, Telefono, Email, Domicilio, Fecha_Nacimiento)
	values (@DNI, @Nombre, @Apellido, @Telefono, @Email, @Domicilio, @Fecha_Nacimiento)

	declare @nuevo_id_persona int;
	set @nuevo_id_persona = SCOPE_IDENTITY()

	insert into Alumnos (ID_Persona, ID_Carrera)
	values (@nuevo_id_persona, @ID_Carrera)

	commit transaction 
	print 'Alumno dado de alta exitosamente!'
	end try 
	begin catch 
	rollback transaction 
	raiserror ('Error al dar de alta el alumno', 16, 1)
	end catch 
	end 
	go

	exec sp_AltaAlumno
	@DNI= '45123456',
    @Nombre= 'Melina',
    @Apellido= 'Vicente',
    @Telefono= '0291-4111222',
    @Email= 'melvicente@123.com',
    @Domicilio= 'Femidem al 2456',
    @Fecha_Nacimiento='2003-08-03',
    @ID_Carrera= 1;

select * from vw_AlumnosCarrera


--sp_ModificarAlumno
--sp_BajaAlumno
--sp_BuscarAlumnoApellido
--sp_InscribirAlumnoMateria
--sp_RegistrarAsistencia
--sp_CargarNota
--sp_RegistrarVacaciones
--sp_GenerarLiquidacion
