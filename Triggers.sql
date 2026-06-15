--Al modificar la carrera de un alumno, se dan de baja las materias relacionadas a la carrera anterior
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
--trg_NoDuplicarInscripcion
--trg_ControlVacaciones
--trg_ActualizarCantidadMaterias
--trg_RegistrarFechaLiquidacion
--trg_ControlCupoMateria
--trg_EvitarEliminarMateriaConInscriptos
