use Universidad_BD
go

--Dar de alta un alumno en el sistema
/*create procedure sp_AltaAlumno 
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

go */
--sp_ModificarAlumno
--Modificar los datos basicos de un alumno: Telefono, email,domicilio o la carrera.
	create procedure sp_ModificarAlumno
	@legajoAlumno int,
	@telefono varchar(20),
	@email varchar (50),
	@domicilio varchar(100),
	@ID_Carrera int 
	as begin 
	if not exists (select 1 from Alumnos where Legajo_Alumno = @legajoAlumno)
	begin
	raiserror ('No existe un alumno con ese numero de legajo', 16,1)
	return
	end

	if exists (select 1 from Personas p 
	inner join Alumnos a on p.ID_Persona = a.ID_Persona
	where p.Email = @email and a.Legajo_Alumno = @legajoAlumno )
	begin
	raiserror ('El email ingresado ya pertenece a otro alumno', 16, 1)
	return
	end

	if not exists (select 1 from Carrera where ID_Carrera = @ID_Carrera)
	begin
	raiserror ('La carrera seleccionada no existe', 16, 1)
	return
	end

	begin transaction 
	begin try 
		update Personas
		set Telefono = @telefono,
		Email = @email,
		Domicilio = @domicilio
		where ID_Persona = 
		(select ID_Persona from Alumnos where Legajo_Alumno = @legajoAlumno)

		update Alumnos 
		set ID_Carrera = @ID_Carrera
		where Legajo_Alumno = @legajoAlumno

	commit transaction 
	print 'Alumno modificado correctamente!'
	end try

	begin catch
	rollback transaction 
	raiserror ('Ocurrio un error al modificar al alumnos',16,1)
	end catch 
	end 
	go

	exec sp_ModificarAlumno 1,'114585788','gonzdle2@gamil.com','Beltran al 245',3
	select * from vw_AlumnosCarrera

--sp_BuscarAlumnoApellido
--Se busca un alumno por su apellido 
	alter procedure sp_BuscarAlumnoApellido 
	@Apellido varchar(50)
	as begin 

	if @Apellido is null or trim(@Apellido) = ''
	begin 
	raiserror ('Debe ingresar un apellido para realizar la busqueda',16,1)
	return
	end

	select 
        a.Legajo_Alumno,
        p.DNI,
        p.Apellido,
        p.Nombre,
        p.Email,
        p.Telefono,
        c.Nombre as Carrera
    from Alumnos a
    inner join Personas p on a.ID_Persona = p.ID_Persona
    left join Carrera c on a.ID_Carrera = c.ID_Carrera
    where p.Apellido like '%' + @Apellido + '%'
    order by p.Apellido, p.Nombre;
end
go

exec sp_BuscarAlumnoApellido 'Vicente';
exec sp_BuscarAlumnoApellido '';
go

--Permite dar de baja un Alumno
create procedure sp_BajaAlumno
    @Legajo_Alumno int
as
begin

    if not exists (select 1 from Alumnos where Legajo_Alumno = @Legajo_Alumno)
    begin
        raiserror('El alumno no existe.', 16, 1);
        return;
    end

    update Alumnos set Estado = 0 where Legajo_Alumno = @Legajo_Alumno;

    print 'Alumno dado de baja correctamente.';
end
go

select * from vw_AlumnosCarrera

--sp_InscribirAlumnoMateria
--sp_RegistrarAsistencia
--sp_CargarNota
--sp_RegistrarVacaciones
--sp_GenerarLiquidacion
