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

if not exists (select 1 from Carrera where ID_Carrera = @ID_Carrera)
begin
raiserror ('No existe la carrera seleccionada.', 16, 1)
return
end

begin try 
	begin transaction 
	insert into Personas (DNI, Nombre, Apellido, Telefono, Email, Domicilio, Fecha_Nacimiento)
	values (@DNI, @Nombre, @Apellido, @Telefono, @Email, @Domicilio, @Fecha_Nacimiento)

	declare @nuevo_id_persona int;
	set @nuevo_id_persona = SCOPE_IDENTITY()

	insert into Alumnos (ID_Persona)
	values (@nuevo_id_persona)

	declare @nuevo_id_alumno int;
	set @nuevo_id_alumno = SCOPE_IDENTITY()

	insert into Alumnos_Carrera (ID_Alumno, ID_Carrera, Estado)
	values (@nuevo_id_alumno, @ID_Carrera, 1)

	commit transaction 
	print 'Alumno dado de alta exitosamente!'
	end try 
	begin catch 
	rollback transaction 
	raiserror ('Error al dar de alta el alumno', 16, 1)
	end catch 
	end 
	go

EXEC sp_AltaAlumno '45123456','Melina','Vicente','0291-4111222','melvicente@mail.com','Femidem 2456','2003-08-03',2;
EXEC sp_AltaAlumno '46123456','Melisa','Visente','0291-154545','melvicente@hotmail.com','Beltran 2456','2003-08-03',1;
EXEC sp_AltaAlumno '84545454','Gaston','Perez','0271-154545','perez@hotmail.com','Groussac 2456','2003-08-03',3;
EXEC sp_AltaAlumno '12345678','Rocio','Santini','618199595','vrs@hotmail.com','asasas 2456','2005-08-03',1;

go 

select * from vw_AlumnosCarrera
go
select * from Carrera
go 
--sp_ModificarPersona
--Modificar los datos basicos de un alumno: Telefono, email,domicilio o la carrera.
	create procedure sp_ModificarPersona
	@ID_Persona int,
	@telefono varchar(20),
	@email varchar (50),
	@domicilio varchar(100)
	as begin 
	if not exists (select 1 from Personas where ID_Persona = @ID_Persona)
	begin
	raiserror ('No existe una persona con ese ID', 16,1)
	return
	end

    IF EXISTS (SELECT 1 FROM Personas WHERE Email = @Email AND ID_Persona <> @ID_Persona)
    BEGIN
        RAISERROR('El email ingresado ya pertenece a otra persona registrada.', 16, 1);
        RETURN;
    END

	begin transaction 
	begin try 
		update Personas
		set Telefono = @telefono,
		Email = @email,
		Domicilio = @domicilio
		where ID_Persona = @ID_Persona

	commit transaction 
	print 'Datos personales actualizados correctamente!'
	end try

	begin catch
	rollback transaction 
	raiserror ('Ocurrio un error al modificar la persona',16,1)
	end catch 
	end 
	go

    EXEC sp_ModificarPersona 7, '0271-4999888', 'morales_nuevo@mail.com', 'Colon 999, Bahia Blanca';
	select * from Personas
    select * from Docentes

	go
--sp_BuscarAlumnoApellido
--Se busca un alumno por su apellido 
	create procedure sp_BuscarAlumnoApellido 
	@Apellido varchar(50)
	as begin 

	if @Apellido is null or trim(@Apellido) = ''
	begin 
	raiserror ('Debe ingresar un apellido para realizar la busqueda',16,1)
	return
	end

	select 
        ac.Legajo_Alumno,
        p.DNI,
        p.Apellido,
        p.Nombre,
        p.Email,
        p.Telefono,
        c.Nombre as Carrera,
		CASE WHEN ac.Estado = 1 THEN 'Activo' ELSE 'Baja' END AS Estado
    from Alumnos_Carrera ac
	inner join Alumnos a on ac.ID_Alumno = a.ID_Alumno
    inner join Personas p on a.ID_Persona = p.ID_Persona
    left join Carrera c on ac.ID_Carrera = c.ID_Carrera
    where p.Apellido like '%' + @Apellido + '%'
    order by p.Apellido, p.Nombre;
end
go

exec sp_BuscarAlumnoApellido 'Gomez';
exec sp_BuscarAlumnoApellido '';
go

--Permite dar de baja un Alumno
create procedure sp_BajaAlumno
    @Legajo_Alumno int
as
begin

    if not exists (select 1 from Alumnos_Carrera where Legajo_Alumno = @Legajo_Alumno)
    begin
        raiserror('El alumno no existe.', 16, 1);
        return;
    end

	if exists (select 1 from Alumnos_Carrera where Legajo_Alumno = @Legajo_Alumno and estado = 0)
	begin 
	raiserror('El alumno ya se encuentra dado de baja', 16, 1)
	return
	end

    update Alumnos_Carrera set Estado = 0 where Legajo_Alumno = @Legajo_Alumno;

    print 'Alumno dado de baja correctamente.';
end
go

select * from vw_AlumnosCarrera
go

exec sp_BajaAlumno 9
go

--sp_RegistrarAsistencia
create procedure sp_registrarasistencia
    @legajo_alumno int,
    @id_catedra int,
    @fecha date,
    @estado bit
as
begin
    if not exists (select 1 from alumnos_carrera where legajo_alumno = @legajo_alumno and estado = 1)
    begin
        raiserror('el alumno no existe o no se encuentra activo.', 16, 1);
        return;
    end

    if not exists (select 1 from catedra where id_catedra = @id_catedra)
    begin
        raiserror('la catedra no existe.', 16, 1);
        return;
    end

    if not exists (select 1 from inscripcion where legajo_alumno = @legajo_alumno and id_catedra = @id_catedra)
    begin
        raiserror('el alumno no esta inscripto en esa catedra.', 16, 1);
        return;
    end

    if exists (select 1 from asistencias where legajo_alumno = @legajo_alumno
    and id_catedra = @id_catedra and fecha= @fecha)
    begin
        raiserror('ya existe un registro de asistencia para ese alumno en esa fecha y catedra.', 16, 1);
        return;
    end

    insert into asistencias (id_catedra, legajo_alumno, fecha, estado)
    values (@id_catedra, @legajo_alumno, @fecha, @estado);

    print 'asistencia registrada correctamente.';
end
go
	select * from vw_AsistenciaMateria
	select * from Catedra
 exec sp_registrarasistencia 1, 1, '2025-04-07', 1;
 exec sp_registrarasistencia 2, 2, '2025-04-07', 0;
go

select * from Materia
go
--sp_CargarNota
create procedure sp_carganota
    @legajo_alumno int,
    @id_materia int,
    @calificacion decimal(4,2),
    @fecha_calificacion date
as
begin
    if not exists (select 1 from alumnos_carrera where legajo_alumno = @legajo_alumno and estado = 1)
    begin
        raiserror('el alumno no existe o no se encuentra activo.', 16, 1);
        return;
    end

    if not exists (select 1 from materia where id_materia = @id_materia)
    begin
        raiserror('la materia no existe.', 16, 1);
        return;
    end

    if @calificacion < 0 or @calificacion > 10
    begin
        raiserror('la calificacion debe estar entre 0 y 10.', 16, 1);
        return;
    end

        insert into calificaciones (id_materia, legajo_alumno, calificacion, fecha_calificacion)
        values (@id_materia, @legajo_alumno, @calificacion, @fecha_calificacion);
    end
        print 'nota cargada correctamente.';
go

exec sp_carganota 1, 2, 8, '2025-07-15';
select * from vw_PromedioAlumno
select * from Calificaciones
go

--Registrar vacaciones docentes
create procedure sp_registrarvacaciones
    @id_docente int,
    @fecha_inicio date,
    @fecha_fin date,
    @año_correspondiente date
as
begin
    if not exists (select 1 from docentes where id_docente = @id_docente)
    begin
        raiserror('el docente no existe.', 16, 1);
        return;
    end

    if @fecha_inicio >= @fecha_fin
    begin
        raiserror('la fecha de inicio debe ser anterior a la fecha de fin.', 16, 1);
        return;
    end

    if exists (select 1 from vacaciones_docentes where id_docente = @id_docente
    and @fecha_inicio <= fecha_fin and @fecha_fin >= fecha_inicio)
    begin
        raiserror('el periodo indicado se mezcla con vacaciones ya registradas para este docente.', 16, 1);
        return;
    end
    insert into vacaciones_docentes (id_docente, fecha_inicio, fecha_fin, año_correspondiente)
    values (@id_docente, @fecha_inicio, @fecha_fin, @año_correspondiente);

    print 'vacaciones registradas correctamente.';
end
go

exec sp_registrarvacaciones 1, '2025-01-06', '2025-01-24', '2025-01-01';
select * from vw_VacacionesDocentes
go


--sp_ModificarCarrera_Alumno
create procedure sp_ModificarCarrera_Alumno
@legajo int,
@id_Carrera int
as begin

if not exists (select 1 from Alumnos_Carrera where Legajo_Alumno = @legajo and estado = 1)
begin
raiserror ('el alumno no existe o no se encuentra activo', 16, 1)
return 
end
if not exists (select 1 from Carrera where ID_Carrera = @id_Carrera)
begin
raiserror ('La carrera seleccionada no existe',16,1)
return
end

if exists (select 1 from Alumnos_Carrera where Legajo_Alumno = @legajo and ID_Carrera = @id_Carrera)
begin
raiserror ('El alumno ya se encuentra inscripto en esa carrera',16,1)
return
end

update Alumnos_Carrera
set ID_Carrera = @id_Carrera
where Legajo_Alumno = @legajo

print 'Carrera del alumno actualizada correctamente'
end
go

exec sp_ModificarCarrera_Alumno 10,2
select * from vw_AlumnosCarrera

select * from Materia
go
--sp_AnotarAlumnoMateria
--Anotar a un alumno a una materia segun la carrera seleccionada

create procedure sp_AnotarAlumnoMateria
@legajo int,
@id_Catedra int,
@fecha_Inscripcion date,
@Ciclo_Lectivo int
as begin

    if not exists (select 1 from Alumnos_Carrera where Legajo_Alumno = @legajo and estado = 1)
    begin
        raiserror ('el alumno no existe o no se encuentra activo', 16, 1)
    return 
    end

    if not exists (select 1 from Catedra where ID_Catedra = @id_Catedra)
    begin
        raiserror ('La catedra seleccionada no existe',16,1)
    return
    end

    if exists (select 1 from Inscripcion where Legajo_Alumno = @legajo and ID_Catedra = @id_Catedra)
    begin
        raiserror ('El alumno ya se encuentra inscripto en esa catedra',16,1)
    return
    end

    if not exists (select 1 from Alumnos_Carrera ac 
        inner join Catedra c on c.ID_Catedra = @id_Catedra
        inner join Materia m on c.ID_Materia = m.ID_Materia
        where ac.Legajo_Alumno = @legajo and ac.ID_Carrera = m.ID_Carrera
    )
    begin
        raiserror('La materia no pertenece a la carrera del alumno.',16,1);
    return;
    end

insert into Inscripcion (ID_Catedra, Legajo_Alumno,Fecha_Inscripcion,Ciclo_Lectivo)
values(@id_Catedra, @legajo, @Fecha_Inscripcion, @Ciclo_Lectivo);

    print 'Inscripción realizada correctamente.';

end
go

exec sp_AnotarAlumnoMateria 8,1,'2024-11-18', 2025

select * from vw_AlumnosMateria