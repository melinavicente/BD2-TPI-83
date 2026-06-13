USE Universidad_BD
GO

-- =============================================
-- INSTITUCION
-- =============================================
INSERT INTO Institucion (Nombre, Telefono, Email, Domicilio) VALUES
('Universidad Nacional del Sur',    '0291-4595101', 'info@uns.edu.ar',  'Av. Alem 1253, Bahia Blanca'),
('Universidad de Buenos Aires',     '011-5285-0000', 'info@uba.ar',     'Av. Figueroa Alcorta 2263, Buenos Aires'),
('Universidad Tecnologica Nacional','011-4867-7500', 'info@utn.edu.ar', 'Medrano 951, Buenos Aires');
GO

-- =============================================
-- PERSONAS  (12 personas: 6 alumnos + 6 docentes)
-- =============================================
INSERT INTO Personas (DNI, Nombre, Apellido, Telefono, Email, Domicilio, Fecha_Nacimiento) VALUES
-- Alumnos (ID_Persona 1-6)
('30111222', 'Carlos',    'Gomez',     '0291-4123456', 'cgomez@mail.com',     'Colon 450, Bahia Blanca',         '1990-03-15'),
('31222333', 'Lucia',     'Fernandez', '0291-4234567', 'lfernandez@mail.com', 'Brown 820, Bahia Blanca',         '1992-07-22'),
('32333444', 'Martin',    'Lopez',     '011-4567890',  'mlopez@mail.com',     'Corrientes 1500, Buenos Aires',   '1988-11-05'),
('33444555', 'Sofia',     'Perez',     '011-4678901',  'sperez@mail.com',     'Lavalle 300, Buenos Aires',       '1995-01-30'),
('34555666', 'Diego',     'Ramirez',   '0291-4345678', 'dramirez@mail.com',   'Zelaarrayon 200, Bahia Blanca',   '1985-06-18'),
('35666777', 'Valentina', 'Torres',    '011-4789012',  'vtorres@mail.com',    'Rivadavia 900, Buenos Aires',     '1993-09-12'),
-- Docentes (ID_Persona 7-12)
('36777888', 'Andres',    'Morales',   '0291-4456789', 'amorales@mail.com',   'Darregueira 100, Bahia Blanca',   '1980-04-25'),
('37888999', 'Florencia', 'Sanchez',   '011-4890123',  'fsanchez@mail.com',   'Tucuman 600, Buenos Aires',       '1987-12-03'),
('38999000', 'Nicolas',   'Herrera',   '0291-4567890', 'nherrera@mail.com',   'Chiclana 750, Bahia Blanca',      '1979-02-14'),
('39000111', 'Camila',    'Diaz',      '011-4901234',  'cdiaz@mail.com',      'Callao 200, Buenos Aires',        '1983-08-07'),
('40111333', 'Pablo',     'Ruiz',      '0291-4678901', 'pruiz@mail.com',      'Rodriguez 320, Bahia Blanca',     '1976-05-19'),
('41222444', 'Natalia',   'Vargas',    '011-5012345',  'nvargas@mail.com',    'Santa Fe 1100, Buenos Aires',     '1981-10-28');
GO

-- =============================================
-- DEPARTAMENTO
-- =============================================
INSERT INTO Departamento (Nombre, Telefono, Email, ID_Institucion) VALUES
('Departamento de Ciencias de la Computacion', '0291-4595110', 'dcca@uns.edu.ar',      1),
('Departamento de Ingenieria Electrica',        '0291-4595120', 'die@uns.edu.ar',       1),
('Departamento de Sistemas',                    '011-5285-0100','dsistemas@uba.ar',     2);
GO

-- =============================================
-- CARRERA
-- =============================================
INSERT INTO Carrera (Nombre, Cantidad_Materias, ID_Depto) VALUES
('Licenciatura en Ciencias de la Computacion', 35, 1),
('Ingenieria Electrica',                        40, 2),
('Ingenieria en Sistemas de Informacion',       38, 3);
GO

-- =============================================
-- ALUMNOS  (solo ID_Persona, sin ID_Carrera)
-- =============================================
INSERT INTO Alumnos (ID_Persona) VALUES
(1), (2), (3), (4), (5), (6);
GO

-- =============================================
-- ALUMNOS_CARRERA  (relacion alumno <-> carrera)
-- ID_Alumno 1-2 => LCC, 3-4 => Ing. Electrica, 5-6 => Sistemas
-- Estado 1 = activo, 0 = inactivo
-- =============================================
INSERT INTO Alumnos_Carrera (ID_Alumno, ID_Carrera, Estado) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 2, 1),
(4, 2, 1),
(5, 3, 1),
(6, 3, 0);  -- baja logica de ejemplo
GO

-- =============================================
-- DOCENTES
-- =============================================
INSERT INTO Docentes (ID_Persona, Sueldo, ID_Carrera) VALUES
(7,  285000.00, 1),
(8,  310000.00, 1),
(9,  295000.00, 2),
(10, 320000.00, 2),
(11, 275000.00, 3),
(12, 340000.00, 3);
GO

-- =============================================
-- DIRECTOR  (uno por departamento)
-- =============================================
INSERT INTO Director (ID_Docente, ID_Depto, Matricula, Sueldo_Director) VALUES
(1, 1, 'MAT-2018-001', 420000.00),
(3, 2, 'MAT-2019-002', 435000.00),
(5, 3, 'MAT-2020-003', 450000.00);
GO

-- =============================================
-- MATERIA
-- =============================================
INSERT INTO Materia (Nombre_Materia, Horas_Semanales, ID_Carrera) VALUES
('Algoritmos y Estructuras de Datos', 6, 1),
('Base de Datos',                     4, 1),
('Analisis Matematico I',             6, 2),
('Circuitos Electricos',              5, 2),
('Programacion I',                    6, 3),
('Ingenieria de Software',            4, 3);
GO

-- =============================================
-- CATEDRA
-- =============================================
INSERT INTO Catedra (ID_Materia, ID_Docente, Turno, Año_Lectivo) VALUES
(1, 1, 'Manana', 2024),
(2, 2, 'Tarde',  2024),
(3, 3, 'Manana', 2024),
(4, 4, 'Noche',  2024),
(5, 5, 'Tarde',  2024),
(6, 6, 'Manana', 2024);
GO

-- =============================================
-- INSCRIPCION  (sin columna Estado, segun schema)
-- Legajo_Alumno 1-6 corresponde a Alumnos_Carrera
-- =============================================
INSERT INTO Inscripcion (ID_Catedra, Legajo_Alumno, Fecha_Inscripcion, Ciclo_Lectivo) VALUES
(1, 1, '2024-03-01', 2024),
(2, 1, '2024-03-01', 2024),
(1, 2, '2024-03-02', 2024),
(2, 2, '2024-03-02', 2024),
(3, 3, '2024-03-03', 2024),
(4, 3, '2024-03-03', 2024),
(3, 4, '2024-03-04', 2024),
(4, 4, '2024-03-04', 2024),
(5, 5, '2024-03-05', 2024),
(6, 5, '2024-03-05', 2024),
(5, 6, '2024-03-06', 2024),
(6, 6, '2024-03-06', 2024);
GO

-- =============================================
-- CALIFICACIONES
-- =============================================
INSERT INTO Calificaciones (ID_Materia, Legajo_Alumno, Calificacion, Fecha_Calificacion) VALUES
(1, 1, 8.50, '2024-07-15'),
(2, 1, 7.00, '2024-11-20'),
(1, 2, 9.00, '2024-07-15'),
(2, 2, 8.25, '2024-11-20'),
(3, 3, 7.50, '2024-07-10'),
(4, 3, 6.75, '2024-11-18'),
(3, 4, 8.00, '2024-07-10'),
(4, 4, 9.25, '2024-11-18'),
(5, 5, 7.00, '2024-07-12'),
(6, 5, 8.50, '2024-11-22'),
(5, 6, 6.50, '2024-07-12'),
(6, 6, 7.75, '2024-11-22');
GO

-- =============================================
-- ASISTENCIAS (3 clases por alumno por materia)
-- =============================================
INSERT INTO Asistencias (ID_Catedra, Legajo_Alumno, Fecha, Estado) VALUES
-- Catedra 1 - LCC Manana
(1, 1, '2024-04-01', 1), (1, 1, '2024-04-08', 1), (1, 1, '2024-04-15', 0),
(1, 2, '2024-04-01', 1), (1, 2, '2024-04-08', 0), (1, 2, '2024-04-15', 1),
-- Catedra 2 - LCC Tarde
(2, 1, '2024-04-02', 1), (2, 1, '2024-04-09', 1), (2, 1, '2024-04-16', 1),
(2, 2, '2024-04-02', 0), (2, 2, '2024-04-09', 1), (2, 2, '2024-04-16', 1),
-- Catedra 3 - Electrica Manana
(3, 3, '2024-04-03', 1), (3, 3, '2024-04-10', 1), (3, 3, '2024-04-17', 1),
(3, 4, '2024-04-03', 1), (3, 4, '2024-04-10', 0), (3, 4, '2024-04-17', 1),
-- Catedra 4 - Electrica Noche
(4, 3, '2024-04-04', 0), (4, 3, '2024-04-11', 1), (4, 3, '2024-04-18', 1),
(4, 4, '2024-04-04', 1), (4, 4, '2024-04-11', 1), (4, 4, '2024-04-18', 0),
-- Catedra 5 - Sistemas Tarde
(5, 5, '2024-04-05', 1), (5, 5, '2024-04-12', 1), (5, 5, '2024-04-19', 0),
(5, 6, '2024-04-05', 0), (5, 6, '2024-04-12', 1), (5, 6, '2024-04-19', 1),
-- Catedra 6 - Sistemas Manana
(6, 5, '2024-04-06', 1), (6, 5, '2024-04-13', 0), (6, 5, '2024-04-20', 1),
(6, 6, '2024-04-06', 1), (6, 6, '2024-04-13', 1), (6, 6, '2024-04-20', 0);
GO

-- =============================================
-- LIQUIDACION_SUELDOS (2 meses x 6 docentes)
-- =============================================
INSERT INTO Liquidacion_Sueldos (ID_Docente, Periodo, Monto_Neto, Fecha_Pago, ID_Director) VALUES
(1, '2024-03-01', 235650.00, '2024-03-31', 1),
(2, '2024-03-01', 256300.00, '2024-03-31', 1),
(3, '2024-03-01', 244350.00, '2024-03-31', 2),
(4, '2024-03-01', 265600.00, '2024-03-31', 2),
(5, '2024-03-01', 227750.00, '2024-03-31', 3),
(6, '2024-03-01', 282200.00, '2024-03-31', 3),
(1, '2024-04-01', 235650.00, '2024-04-30', 1),
(2, '2024-04-01', 256300.00, '2024-04-30', 1),
(3, '2024-04-01', 244350.00, '2024-04-30', 2),
(4, '2024-04-01', 265600.00, '2024-04-30', 2),
(5, '2024-04-01', 227750.00, '2024-04-30', 3),
(6, '2024-04-01', 282200.00, '2024-04-30', 3);
GO

-- =============================================
-- VACACIONES_DOCENTES
-- =============================================
INSERT INTO Vacaciones_Docentes (ID_Docente, Fecha_Inicio, Fecha_Fin, Año_Correspondiente) VALUES
(1, '2024-01-02', '2024-01-19', '2024-01-01'),
(2, '2024-01-05', '2024-01-22', '2024-01-01'),
(3, '2024-01-08', '2024-01-25', '2024-01-01'),
(4, '2024-01-10', '2024-01-27', '2024-01-01'),
(5, '2024-01-15', '2024-02-01', '2024-01-01'),
(6, '2024-01-20', '2024-02-06', '2024-01-01');
GO