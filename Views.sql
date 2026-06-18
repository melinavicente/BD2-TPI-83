Use Universidad_BD 
GO

--vw_AlumnosCarrera
--Muestra el listado de alumnos con sus datos personales y la carrera en la que estan inscriptos.

create view vw_AlumnosCarrera as
select
    ac.Legajo_Alumno,
    p.DNI,
    p.Apellido,
    p.Nombre,
    p.Email,
    p.Telefono,
    c.Nombre  as Carrera,
    case when ac.Estado = 1 then 'Activo' else 'Baja' end as Estado
from Alumnos_Carrera ac
inner join Alumnos a on ac.ID_Alumno = a.ID_Alumno
inner join Personas p on a.ID_Persona = p.ID_Persona
left join Carrera c on ac.ID_Carrera = c.ID_Carrera;
go

select * from vw_AlumnosCarrera 

--vw_AlumnosMateria
--Muestra el listado de alumnos con sus datos personales y las materias que estan cursando
go
create view vw_AlumnosMateria as
select
    ac.Legajo_Alumno,
    p.DNI,
    p.Apellido,
    p.Nombre,
    m.Nombre_Materia as Materia,
    c.ID_Catedra,
    case when ac.Estado = 1 then 'Activo' else 'Baja' end as Estado
from Alumnos_Carrera ac
inner join Alumnos a on ac.ID_Alumno = a.ID_Alumno
inner join Personas p on a.ID_Persona = p.ID_Persona
inner join Inscripcion i on ac.Legajo_Alumno = i.Legajo_Alumno
inner join Catedra c on i.ID_Catedra = c.ID_Catedra
inner join Materia m on c.ID_Materia = m.ID_Materia
go

select * from vw_AlumnosMateria 
go

--vw_PromedioAlumno
-- Muestra el promedio histórico de calificaciones de cada alumno.

create view vw_PromedioAlumno as
select
    ac.Legajo_Alumno,
    p.Apellido,
    p.Nombre,
    isnull(ROUND(AVG(cal.Calificacion), 2), 0) as PromedioGeneral,
    count(cal.ID_Nota) as CantidadExamenes
from Alumnos_Carrera ac
inner join Alumnos a on ac.ID_Alumno = a.ID_Alumno
inner join Personas p on a.ID_Persona = p.ID_Persona
left join Calificaciones cal on ac.Legajo_Alumno = cal.Legajo_Alumno
group by ac.Legajo_Alumno, p.Apellido, p.Nombre;
go

select * from vw_PromedioAlumno

go

--vw_RankingCarrera
-- Muestra un ranking de carreras basado en la cantidad de alumnos activos inscriptos.
create view vw_RankingCarrera as
select 
    c.ID_Carrera,
    c.Nombre as Carrera,
    count (a.Legajo_Alumno) as TotalAlumnos
from Carrera c
left join Alumnos_Carrera a on c.ID_Carrera = a.ID_Carrera and a.Estado = 1
group by c.ID_Carrera, c.Nombre
go

select * from vw_RankingCarrera
go

--vw_AsistenciaMateria
-- Calcula el porcentaje de asistencia de los alumnos en cada cátedra/materia.

create view vw_AsistenciaMateria as
select 
    ac.Legajo_Alumno,
    p.Apellido,
    p.Nombre as Alumno,
    m.Nombre_Materia as Materia,
    c.Turno,
    count (asis.ID_Asistencia) as ClasesTotales,
    sum (case when asis.Estado = 1 then 1 else 0 end) as ClasesPresentes,
    round ((sum(case when asis.Estado = 1 then 1.0 else 0.0 end) / count (asis.ID_Asistencia)) * 100, 1)
    as PorcentajeAsistencia
from Asistencias asis
inner join Alumnos_Carrera ac on asis.Legajo_Alumno = ac.Legajo_Alumno
inner join Alumnos a on ac.ID_Alumno = a.ID_Alumno
inner join Personas p on a.ID_Persona = p.ID_Persona
inner join Catedra c on asis.ID_Catedra = c.ID_Catedra
inner join Materia m on c.ID_Materia = m.ID_Materia
group by ac.Legajo_Alumno, p.Apellido, p.Nombre, m.Nombre_Materia, c.Turno
go

select * from vw_AsistenciaMateria order by Apellido, Materia;

go

--vw_DocentesMaterias
--Muestra el listado de docentes con sus datos personales, 
--la carrera en la que ejerce y su materia correspondiente

create view vw_DocentesMaterias as
select 
    d.ID_Docente,
    p.DNI,
    p.Apellido,
    p.Nombre,
    p.Email,
    c.Nombre AS Carrera,
    m.Nombre_Materia AS Materia,
    ct.Turno,
    ct.Año_Lectivo
from Docentes d 
inner join Personas p on d.ID_Persona = p.ID_Persona
inner join Catedra ct on d.ID_Docente = ct.ID_Docente
inner join Materia m on ct.ID_Materia = m.ID_Materia
inner join Carrera c on d.ID_Carrera = c.ID_Carrera;
go 

select * from vw_DocentesMaterias

go
--vw_LiquidacionDocente
--Muestra el listado de la liquidación del sueldo de los docentes

create view vw_LiquidacionDocente as
select
    d.ID_Docente,
    p.DNI,
    p.Apellido,
    p.Nombre,
    l.Periodo,
    d.Sueldo as SueldoBruto,
    l.Monto_Neto as SueldoNeto,
    l.Fecha_Pago as FechaCobro
from Docentes d
inner join Personas p on d.ID_Persona = p.ID_Persona
inner join Liquidacion_Sueldos l on d.ID_Docente = l.ID_Docente;
go

select * from vw_LiquidacionDocente

go
--vw_VacacionesDocentes
--Muestra el listado de los docentes con sus respectivas vacaciones

create view vw_VacacionesDocentes as
select
    d.ID_Docente,
    p.DNI,
    p.Apellido,
    p.Nombre,
    v.Fecha_Inicio as InicioVacaciones,
    v.Fecha_Fin as FinVacaciones,
    v.Año_Correspondiente as Año
from Docentes d
inner join Personas p on d.ID_Persona = p.ID_Persona
inner join Vacaciones_Docentes v on d.ID_Docente = v.ID_Docente;
go

select * from vw_VacacionesDocentes

go

--vw_EstadisticaCarreras
--Muestra el listado de las carreras ordenadas por la cantidad de alumnos que tiene cada uno
 

create view vw_EstadisticaCarreras as
select
    c.ID_Carrera,
    c.Nombre as Carrera,
    COUNT(ac.Legajo_Alumno) as TotalAlumnos,
    SUM(CASE WHEN ac.Estado = 1 THEN 1 ELSE 0 END) as AlumnosActivos,
    SUM(CASE WHEN ac.Estado = 0 THEN 1 ELSE 0 END) as AlumnosBaja
from Carrera c
left join Alumnos_Carrera ac on c.ID_Carrera = ac.ID_Carrera
group by c.ID_Carrera, c.Nombre;
go

select * from vw_EstadisticaCarreras
order by AlumnosActivos desc;
