Use Universidad_BD 
GO

--vw_AlumnosCarrera
--Muestra el listado de alumnos con sus datos personales y la carrera en la que estan inscriptos.

/*create view vw_AlumnosCarrera as
select 
    a.Legajo_Alumno,
    p.DNI,
    p.Apellido,
    p.Nombre,
    p.Email,
    c.Nombre AS Carrera
from Alumnos a
inner join personas p on a.ID_Persona = p.ID_Persona
inner join Carrera c on a.ID_Carrera = c.ID_Carrera
go

select * from vw_AlumnosCarrera */

--vw_PromedioAlumno
-- Muestra el promedio histórico de calificaciones de cada alumno.

/*alter view vw_PromedioAlumno as
select
    a.Legajo_Alumno,
    p.Apellido,
    p.Nombre,
    ISNULL(ROUND(AVG(c.Calificacion), 2), 0) AS PromedioGeneral,
    COUNT(c.ID_Nota) AS CantidadExamenes
from Alumnos a
inner join Personas p ON a.ID_Persona = p.ID_Persona
inner join Calificaciones c ON a.Legajo_Alumno = c.Legajo_Alumno
group by a.Legajo_Alumno, p.Apellido, p.Nombre;
go

select * from vw_PromedioAlumno */

--vw_RankingCarrera
-- Muestra un ranking de carreras basado en la cantidad de alumnos activos inscriptos.
/*create view vw_RankingCarrera as
select 
    c.ID_Carrera,
    c.Nombre as Carrera,
    count (a.Legajo_Alumno) as TotalAlumnos
from Carrera c
inner join Alumnos a on c.ID_Carrera = a.ID_Carrera
group by c.ID_Carrera, c.Nombre
go

select * from vw_RankingCarrera
*/

--vw_AsistenciaMateria
-- Calcula el porcentaje de asistencia de los alumnos en cada cátedra/materia.

create view vw_AsistenciaMateria as
select 
    a.Legajo_Alumno,
    p.Apellido,
    p.Nombre as Alumno,
    m.Nombre_Materia as Materia,
    c.Turno,
    count (asis.ID_Asistencia) as ClasesTotales,
    sum (case when asis.Estado = 1 then 1 else 0 end) as ClasesPresentes,
    round ((sum(case when asis.Estado = 1 then 1.0 else 0.0 end) / count (asis.ID_Asistencia)) * 100, 1)
    as PorcentajeAsistencia
from Asistencias asis
inner join Alumnos a on asis.Legajo_Alumno = a.Legajo_Alumno
inner join Personas p on a.ID_Persona = p.ID_Persona
inner join Catedra c on asis.ID_Catedra = c.ID_Catedra
inner join Materia m on c.ID_Materia = m.ID_Materia
group by a.Legajo_Alumno, p.Apellido, p.Nombre, m.Nombre_Materia, c.Turno
go

select * from vw_AsistenciaMateria

--vw_DocentesMaterias
--vw_LiquidacionDocente
--vw_VacacionesDocentes
--vw_EstadisticaCarreras
