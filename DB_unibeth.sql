create database uni;

-- Creación de tabla 'categorias' para clasificar a las personas (ej. Estudiante, Docente)
CREATE TABLE categorias (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    CHECK (LENGTH(nombre_categoria) > 0)
);

-- Creación de tabla 'personas' para almacenar información de estudiantes, docentes, etc.
CREATE TABLE personas (
    persona_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    categoria_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (LENGTH(nombre) > 0),
    CHECK (LENGTH(apellido) > 0)
);

-- Relación entre personas y categorías para manejar múltiples categorías por persona
CREATE TABLE persona_categorias (
    persona_id INT,
    categoria_id INT,
    FOREIGN KEY (persona_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (persona_id, categoria_id)
);

-- Creación de tabla 'privilegios' para definir los diferentes privilegios del sistema
CREATE TABLE privilegios (
    privilegio_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_privilegio VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    CHECK (LENGTH(nombre_privilegio) > 0)
);

-- Relación entre categorías y privilegios (muchos a muchos)
CREATE TABLE categoria_privilegios (
    categoria_id INT,
    privilegio_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (privilegio_id) REFERENCES privilegios(privilegio_id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (categoria_id, privilegio_id)
);

-- Relación entre personas y privilegios (muchos a muchos)
CREATE TABLE personas_privilegios (
    persona_id INT,
    privilegio_id INT,
    FOREIGN KEY (persona_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (privilegio_id) REFERENCES privilegios(privilegio_id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (persona_id, privilegio_id)
);

-- Creación de la tabla 'Materias' para almacenar asignaturas
CREATE TABLE materias (
    materia_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    CHECK (LENGTH(nombre) > 0)
);

-- Creación de la tabla 'Semestres' para definir los semestres académicos
CREATE TABLE semestres (
    semestre_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(10) NOT NULL UNIQUE,
    CHECK (LENGTH(nombre) > 0)
);

-- Creación de la tabla 'Sucursales' para definir las sedes de la institución
CREATE TABLE sucursales (
    sucursal_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    CHECK (LENGTH(nombre) > 0),
    CHECK (LENGTH(direccion) > 0)
);

-- Creación de la tabla 'Aulas' para almacenar información de aulas dentro de una sucursal
CREATE TABLE aulas (
    aula_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    sucursal_id INT NOT NULL,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(sucursal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (capacidad > 0),
    CHECK (LENGTH(nombre) > 0)
);

-- Creación de tabla 'DiasHorario' para definir los días de la semana
CREATE TABLE dias_horario (
    dia_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_dia VARCHAR(10) NOT NULL UNIQUE,
    CHECK (LENGTH(nombre_dia) > 0)
);

-- Creación de tabla 'HorariosTurnos' para definir los turnos horarios (mañana, tarde, etc.)
CREATE TABLE horarios_turnos (
    turno_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_horario VARCHAR(50) NOT NULL,
    hora_inicial TIME NOT NULL,
    hora_final TIME NOT NULL,
    CHECK (hora_inicial < hora_final)
);

-- Creación de tabla 'Horarios' para definir los horarios de clases
CREATE TABLE horarios (
    horario_id INT AUTO_INCREMENT PRIMARY KEY,
    dia_id INT NOT NULL,
    turno_id INT NOT NULL,
    FOREIGN KEY (dia_id) REFERENCES dias_horario(dia_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (turno_id) REFERENCES horarios_turnos(turno_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de tabla 'MetodosPagos' para definir los métodos de pago
CREATE TABLE metodos_pagos (
    metodo_id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_metodo VARCHAR(50) NOT NULL,
    CHECK (LENGTH(tipo_metodo) > 0)
);

-- Creación de tabla 'Pagos' para gestionar los pagos realizados por los estudiantes
CREATE TABLE pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha DATE NOT NULL,
    metodo_pago_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pagos(metodo_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (monto > 0)
);

-- Creación de tabla 'Asignaciones' para asignar cursos a los docentes
CREATE TABLE asignaciones (
    asignacion_id INT AUTO_INCREMENT PRIMARY KEY,
    docente_id INT NOT NULL,
    materia_id INT NOT NULL,
    semestre_id INT NOT NULL,
    aula_id INT NOT NULL,
    horario_id INT NOT NULL,
    FOREIGN KEY (docente_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (materia_id) REFERENCES materias(materia_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (semestre_id) REFERENCES semestres(semestre_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (aula_id) REFERENCES aulas(aula_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (horario_id) REFERENCES horarios(horario_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de tabla 'Inscripciones' para gestionar las inscripciones de estudiantes a las materias
CREATE TABLE inscripciones (
    inscripcion_id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    asignacion_id INT NOT NULL,
    pago_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (asignacion_id) REFERENCES asignaciones(asignacion_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pago_id) REFERENCES pagos(pago_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de la tabla 'bitacora' para registrar eventos importantes dentro del sistema
CREATE TABLE bitacora (
    bitacora_id INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(100) NOT NULL,
    accion VARCHAR(50) NOT NULL,
    persona_id INT NOT NULL,
    datos_anteriores TEXT,
    datos_nuevos TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_id) REFERENCES personas(persona_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de la tabla 'bitacora' para registrar eventos importantes dentro del sistema en categorías
CREATE TABLE bitacora_categorias (
    bitacora_id INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(50) NOT NULL, -- Tipo de acción: INSERT, UPDATE, DELETE
    categoria_id INT, -- ID de la categoría afectada
    nombre_categoria VARCHAR(50), -- Nombre de la categoría afectada
    descripcion TEXT, -- Descripción de la categoría
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de la acción
    datos_anteriores TEXT, -- Datos anteriores en caso de UPDATE o DELETE
    usuario_id INT, -- Usuario que realizó la acción
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id) ON DELETE SET NULL
);


-- Trigger para registrar inserciones en la tabla 'personas' en la bitácora
DELIMITER $$


CREATE TRIGGER trigger_bitacora_insert_persona
AFTER INSERT ON personas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tabla_afectada, accion, persona_id, datos_nuevos, fecha)
    VALUES ('personas',
    'INSERT', NEW.persona_id, 
    CONCAT('Nombre: ', NEW.nombre, ', Apellido: ', NEW.apellido, ', Email: ', NEW.email), 
    CURRENT_TIMESTAMP);
END;

-- Trigger para registrar eliminaciones en la tabla 'personas' en la bitácora
CREATE TRIGGER trigger_bitacora_delete_persona
AFTER DELETE ON personas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tabla_afectada, accion, persona_id, datos_anteriores, fecha)
    VALUES ('personas', 'DELETE', OLD.persona_id, 
            CONCAT('Nombre: ', OLD.nombre, ', Apellido: ', OLD.apellido, ', Email: ', OLD.email), 
            CURRENT_TIMESTAMP);
END;

CREATE TRIGGER trigger_bitacora_insert_pago
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tabla_afectada, accion, persona_id, datos_nuevos, fecha)
    VALUES ('pagos', 'INSERT', NEW.persona_id, CONCAT('Monto: ', NEW.monto, ', Fecha: ', NEW.fecha, ', Método: ', NEW.metodo_pago_id), CURRENT_TIMESTAMP);
END$$

DELIMITER ;

-- Trigger para registrar eliminaciones en la tabla 'categoria' en la bitácora

DELIMITER $$

CREATE TRIGGER trigger_bitacora_insert_categoria
AFTER INSERT ON categorias
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_categorias (accion, categoria_id, nombre_categoria, descripcion, usuario_id)
    VALUES ('INSERT', NEW.categoria_id, NEW.nombre_categoria, NEW.descripcion, @current_user_id);
END$$

DELIMITER ;

-- insertar valores tabla categorias--
select * from categorias;

INSERT INTO categorias (nombre_categoria, descripcion)
VALUES ('Estudiante', 'Personas que están inscritas en el sistema como estudiantes');

-- insertar valores tabla personas--

INSERT INTO personas (nombre, apellido, email, categoria_id)
VALUES ('Juan', 'Pérez', 'juan.perez@example.com', 1);

select * from bitacora_categorias;

-- procedimientos almacenados--

-- PROCEDIMIENTOS LLAMAR PERSONA--
DELIMITER $$
CREATE PROCEDURE obtener_personas()
BEGIN
    SELECT * FROM personas;
END$$

DELIMITER ;

-- LLAMAR TODAS LAS FILAS TABLA PERSONA--
CALL obtener_personas();

-- PROCEDIMIENTO OBTENER PERSONA POR ID--

DELIMITER $$
CREATE PROCEDURE obtener_persona_por_id(IN p_id INT)
BEGIN
    SELECT * FROM personas WHERE persona_id = p_id;
END$$
DELIMITER ;

-- LLAMAR PROCEDIMIENTO OBTENER PERSONA POR ID--
CALL obtener_persona_por_id(1);

-- VISTAS--

-- Vista Simple de Personas y Categorías--
CREATE VIEW vista_personas_categorias AS
SELECT p.persona_id, CONCAT(p.nombre, ' ', p.apellido) AS nombre_completo, c.nombre_categoria
FROM personas p
JOIN categorias c ON p.categoria_id = c.categoria_id;

-- Llamar vista persona y categorias--
SELECT * FROM vista_personas_categorias;

-- Vista con Filtros estudiantes--
CREATE VIEW vista_estudiantes AS
SELECT p.persona_id, p.nombre, p.apellido, p.email
FROM personas p
JOIN categorias c ON p.categoria_id = c.categoria_id
WHERE c.nombre_categoria = 'Estudiante';

-- llamar vista filtro estudiante--
SELECT * FROM vista_estudiantes;

select * from metodos_pagos;





