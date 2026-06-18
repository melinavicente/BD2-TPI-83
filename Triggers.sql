--Al modificar la carrera de un alumno, se dan de baja las materias relacionadas a la carrera anterior
use Universidad_BD
go
create trigger trg_BajaInscripcionMateriaCambioCarrera on Alumnos_Carrera
after update
as
begin

    if update(ID_Carrera)
    begin        
        delete i from Inscripcion i
        INNER JOIN Catedra c on i.ID_Catedra = c.ID_Catedra
        INNER JOIN Materia m on c.ID_Materia = m.ID_Materia
        INNER JOIN deleted d on i.Legajo_Alumno = d.Legajo_Alumno
        where m.ID_Carrera = d.ID_Carrera;
    end
end
go

--trg_EvitarNotaInvalida
create trigger trg_EvitarNotaInvalida on Calificaciones
after insert, update 
as
begin

if exists (select 1 from inserted where Calificacion < 0.00 or Calificacion > 10.00)
begin
raiserror ('Error: La calificacion debe ser un valor numerico entre 0 y 10',16,1)
rollback transaction 
return
end
end
go

insert into calificaciones (id_materia, legajo_alumno, calificacion, fecha_calificacion)
values (1, 1, 11.00, '2024-08-01');
go
--trg_NoDuplicarInscripcion
create trigger trg_noduplicarinscripcion
on inscripcion
after insert
as
begin
    if exists (
        select 1
        from inscripcion i
        inner join inserted ins on i.legajo_alumno= ins.legajo_alumno
        and i.id_catedra=ins.id_catedra
        and i.ciclo_lectivo=ins.ciclo_lectivo
        where i.id_inscripcion <> ins.id_inscripcion
    )
    begin
        raiserror('el alumno ya esta inscripto en esa catedra para ese ciclo lectivo.', 16, 1);
        rollback transaction;
        return;
    end
end
go
insert into inscripcion (id_catedra, legajo_alumno, fecha_inscripcion, ciclo_lectivo)
values (1, 1, '2024-03-10', 2024);
insert into inscripcion (id_catedra, legajo_alumno, fecha_inscripcion, ciclo_lectivo)
values (1, 1, '2025-03-01', 2025);
--trg_ControlVacaciones
go
create trigger trg_controlvacaciones
on vacaciones_docentes
after insert, update
as
begin
    if exists (select 1 from vacaciones_docentes v
        inner join inserted i on v.id_docente = i.id_docente where v.id_vacaciones <> i.id_vacaciones
        and v.fecha_inicio <= i.fecha_fin
        and v.fecha_fin >= i.fecha_inicio
    )
    begin
        raiserror('el docente ya tiene vacaciones registradas en ese periodo.', 16, 1);
        rollback transaction;
        return;
    end
end
go

insert into vacaciones_docentes (id_docente, fecha_inicio, fecha_fin, año_correspondiente)
values (1, '2024-01-10', '2024-01-25', '2024-01-01');
--trg_ActualizarCantidadMaterias
go
create trigger trg_actualizarcantidadmaterias
on materia
after insert, delete
as
begin
    update carrera
    set cantidad_materias = (
        select count(*) from materia where id_carrera = carrera.id_carrera
    )
    where id_carrera in (select id_carrera from inserted);

    update carrera
    set cantidad_materias = (
        select count(*) from materia where id_carrera = carrera.id_carrera
    )
    where id_carrera in (select id_carrera from deleted);
end
go

insert into materia (nombre_materia, horas_semanales, id_carrera)
values ('inteligencia artificial', 4, 1);
select id_carrera, nombre, cantidad_materias from carrera;

--trg_RegistrarFechaLiquidacion
--trg_ControlCupoMateria
--trg_EvitarEliminarMateriaConInscriptos
