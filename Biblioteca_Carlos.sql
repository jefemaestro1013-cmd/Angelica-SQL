-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 09-03-2026 a las 16:36:38
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaautores` ()   BEGIN
    -- Selecciona el ID y el nombre completo de los autores
    SELECT aut_codigo, aut_nombre, aut_apellido 
    FROM tbl_autor
    ORDER BY aut_apellido ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoautor` (IN `p_aut_codigo` INT)   BEGIN
    -- Busca el tipo de autor basado en su código único
    SELECT aut_codigo, aut_nombre, aut_tipo 
    FROM tbl_autor 
    WHERE aut_codigo = p_aut_codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_libro` (IN `p_titulo` VARCHAR(100), IN `p_isbn` VARCHAR(20), IN `p_editorial` VARCHAR(45), IN `p_paginas` INT, IN `p_autor_id` INT)   BEGIN
    -- Inserta los datos recibidos en la tabla de libros
    INSERT INTO tbl_libro (lib_titulo, lib_isbn, lib_editorial, lib_paginas, fk_autor)
    VALUES (p_titulo, p_isbn, p_editorial, p_paginas, p_autor_id);
    
    -- Mensaje de confirmación
    SELECT 'Libro insertado correctamente' AS Mensaje;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ActualizarContacto` (IN `p_num` INT, IN `p_nuevaDir` VARCHAR(255), IN `p_nuevoTel` VARCHAR(10))   BEGIN
    UPDATE tbl_socio 
    SET soc_direccion = p_nuevaDir, soc_telefono = p_nuevoTel
    WHERE soc_numero = p_num;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuscarLibro` (IN `p_titulo` VARCHAR(255))   BEGIN
    SELECT * FROM tbl_libro WHERE lib_titulo LIKE CONCAT('%', p_titulo, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EliminarLibro` (IN `p_isbn` BIGINT)   BEGIN
    DELETE FROM tbl_libro WHERE lib_isbn = p_isbn;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_InsertarSocio` (IN `p_num` INT, IN `p_nom` VARCHAR(45), IN `p_ape` VARCHAR(45), IN `p_dir` VARCHAR(255), IN `p_tel` VARCHAR(10))   BEGIN
    INSERT INTO tbl_socio (soc_numero, soc_nombre, soc_apellido, soc_direccion, soc_telefono)
    VALUES (p_num, p_nom, p_ape, p_dir, p_tel);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_LibrosEnPrestamo` ()   BEGIN
    SELECT l.lib_titulo, s.soc_nombre, p.pres_fechaPrestamo
    FROM tbl_libro l
    INNER JOIN tbl_prestamo p ON l.lib_isbn = p.lib_copiaISBN
    INNER JOIN tbl_socio s ON p.soc_copiaNumero = s.soc_numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ListarSociosYPrestamos` ()   BEGIN
    SELECT s.*, p.pres_id, p.pres_fechaPrestamo
    FROM tbl_socio s
    LEFT JOIN tbl_prestamo p ON s.soc_numero = p.soc_copiaNumero;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_DiasPrestado` (`p_idlibro` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE v_dias INT;
    SELECT DATEDIFF(pres_fechaDevolucion, pres_fechaPrestamo) INTO v_dias
    FROM tbl_prestamo 
    WHERE lib_copiaISBN = p_idlibro 
    LIMIT 1;
    RETURN v_dias;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_TotalSocios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total FROM tbl_socio;
    RETURN v_total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_autor`
--

CREATE TABLE `audi_autor` (
  `id_audi` int(11) NOT NULL,
  `autor_id` int(11) DEFAULT NULL,
  `apellido_anterior` varchar(45) DEFAULT NULL,
  `apellido_nuevo` varchar(45) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `accion` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_autor`
--

INSERT INTO `audi_autor` (`id_audi`, `autor_id`, `apellido_anterior`, `apellido_nuevo`, `fecha`, `usuario`, `accion`) VALUES
(1, 765, 'López', 'Lopez Gomez', '2026-03-09 10:26:33', 'root@localhost', 'Actualizacion');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_libro`
--

CREATE TABLE `audi_libro` (
  `id_audi` int(11) NOT NULL,
  `lib_codigo_audi` int(11) DEFAULT NULL,
  `titulo_anterior` varchar(100) DEFAULT NULL,
  `titulo_nuevo` varchar(100) DEFAULT NULL,
  `autor_anterior` int(11) DEFAULT NULL,
  `autor_nuevo` int(11) DEFAULT NULL,
  `audi_fecha` datetime DEFAULT NULL,
  `audi_usuario` varchar(50) DEFAULT NULL,
  `audi_accion` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(11) NOT NULL,
  `socNumero_audi` int(11) DEFAULT NULL,
  `socNombre_anterior` varchar(45) DEFAULT NULL,
  `socApellido_anterior` varchar(45) DEFAULT NULL,
  `socDireccion_anterior` varchar(255) DEFAULT NULL,
  `socTelefono_anterior` varchar(10) DEFAULT NULL,
  `socNombre_nuevo` varchar(45) DEFAULT NULL,
  `socApellido_nuevo` varchar(45) DEFAULT NULL,
  `socDireccion_nuevo` varchar(255) DEFAULT NULL,
  `socTelefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(50) DEFAULT NULL,
  `audi_accion` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_socio`
--

INSERT INTO `audi_socio` (`id_audi`, `socNumero_audi`, `socNombre_anterior`, `socApellido_anterior`, `socDireccion_anterior`, `socTelefono_anterior`, `socNombre_nuevo`, `socApellido_nuevo`, `socDireccion_nuevo`, `socTelefono_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 1234567, 'yefer', 'y', 'actual 13', 'act800', 'yefer', 'y', 'Calle 72 # 2', '2928088', '2026-03-05 07:26:17', 'root@localhost', 'Actualización');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_autor`
--

CREATE TABLE `tbl_autor` (
  `aut_codigo` int(11) NOT NULL,
  `aut_apellido` varchar(45) DEFAULT NULL,
  `aut_nacimiento` date DEFAULT NULL,
  `aut_muerte` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_autor`
--

INSERT INTO `tbl_autor` (`aut_codigo`, `aut_apellido`, `aut_nacimiento`, `aut_muerte`) VALUES
(98, 'Smith', '1974-12-21', '2018-07-21'),
(123, 'Taylor', '1980-04-15', NULL),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', NULL),
(432, 'Miller', '1981-10-26', NULL),
(456, 'García', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', NULL),
(765, 'Lopez Gomez', '1976-07-08', '2020-01-01'),
(789, 'Rodríguez', '1985-12-10', NULL),
(890, 'Brown', '1982-11-17', NULL),
(901, 'Soto', '1979-05-13', '2015-11-05');

--
-- Disparadores `tbl_autor`
--
DELIMITER $$
CREATE TRIGGER `autor_after_delete` AFTER DELETE ON `tbl_autor` FOR EACH ROW BEGIN
    INSERT INTO audi_autor
    (autor_id, apellido_anterior, fecha, usuario, accion)
    VALUES
    (OLD.aut_codigo, OLD.aut_apellido, NOW(), CURRENT_USER(), 'Eliminacion');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `autor_before_update` BEFORE UPDATE ON `tbl_autor` FOR EACH ROW BEGIN
    INSERT INTO audi_autor
    (autor_id, apellido_anterior, apellido_nuevo, fecha, usuario, accion)
    VALUES
    (OLD.aut_codigo, OLD.aut_apellido, NEW.aut_apellido, NOW(), CURRENT_USER(), 'Actualizacion');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_libro`
--

CREATE TABLE `tbl_libro` (
  `lib_isbn` bigint(20) NOT NULL,
  `lib_titulo` varchar(255) DEFAULT NULL,
  `lib_genero` varchar(20) DEFAULT NULL,
  `lib_numeroPaginas` int(11) DEFAULT NULL,
  `lib_diasPrestamo` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_libro`
--

INSERT INTO `tbl_libro` (`lib_isbn`, `lib_titulo`, `lib_genero`, `lib_numeroPaginas`, `lib_diasPrestamo`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 3),
(2718281828, 'El Bosque de los Suspiros', 'novela', 397, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 3),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 3);

--
-- Disparadores `tbl_libro`
--
DELIMITER $$
CREATE TRIGGER `libro_after_delete` AFTER DELETE ON `tbl_libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (lib_codigo_audi, titulo_anterior, audi_fecha, audi_usuario, audi_accion)
    VALUES (OLD.tbl.libro, OLD.lib_titulo, NOW(), CURRENT_USER(), 'Eliminación');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_after_insert` AFTER INSERT ON `tbl_libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (lib_codigo_audi, titulo_nuevo, audi_fecha, audi_usuario, audi_accion)
    VALUES (NEW.tbl.libro, NEW.lib_titulo, NOW(), CURRENT_USER(), 'Inserción');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_before_update` BEFORE UPDATE ON `tbl_libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (lib_codigo_audi, titulo_anterior, titulo_nuevo, audi_fecha, audi_usuario, audi_accion)
    VALUES (OLD.tbl.libro, OLD.lib_titulo, NEW.lib_titulo, NOW(), CURRENT_USER(), 'Actualización');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_prestamo`
--

CREATE TABLE `tbl_prestamo` (
  `pres_id` varchar(20) NOT NULL,
  `pres_fechaPrestamo` date DEFAULT NULL,
  `pres_fechaDevolucion` date DEFAULT NULL,
  `soc_copiaNumero` int(11) DEFAULT NULL,
  `lib_copiaISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_prestamo`
--

INSERT INTO `tbl_prestamo` (`pres_id`, `pres_fechaPrestamo`, `pres_fechaDevolucion`, `soc_copiaNumero`, `lib_copiaISBN`) VALUES
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_socio`
--

CREATE TABLE `tbl_socio` (
  `soc_numero` int(11) NOT NULL,
  `soc_nombre` varchar(45) DEFAULT NULL,
  `soc_apellido` varchar(45) DEFAULT NULL,
  `soc_direccion` varchar(255) DEFAULT NULL,
  `soc_telefono` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_socio`
--

INSERT INTO `tbl_socio` (`soc_numero`, `soc_nombre`, `soc_apellido`, `soc_direccion`, `soc_telefono`) VALUES
(1, 'Ana', 'Ruiz', 'Nueva Dir 123', '3001112233'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '212345678'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '301234567'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '111234567'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '491234567'),
(12, 'Sofía', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678'),
(13, 'Carlos', 'Ruiz', 'Calle Falsa 123', '3009998877'),
(15, 'Pedro', 'Picapiedra', 'Calle Rocosa 1', '3001234567'),
(1234567, 'yefer', 'y', 'Calle 72 # 2', '2928088');

--
-- Disparadores `tbl_socio`
--
DELIMITER $$
CREATE TRIGGER `socio_after_delete` AFTER DELETE ON `tbl_socio` FOR EACH ROW BEGIN
    INSERT INTO audi_socio (
        socNumero_audi, 
        socNombre_anterior, 
        socApellido_anterior, 
        socDireccion_anterior, 
        socTelefono_anterior,
        audi_fechaModificacion, 
        audi_usuario, 
        audi_accion
    ) 
    VALUES (
        OLD.soc_numero, 
        OLD.soc_nombre, 
        OLD.soc_apellido, 
        OLD.soc_direccion, 
        OLD.soc_telefono,
        NOW(), 
        CURRENT_USER(), 
        'Eliminación'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socio_before_update` BEFORE UPDATE ON `tbl_socio` FOR EACH ROW BEGIN
       INSERT INTO audi_socio (
           socnumero_audi,
           socNombre_anterior, socApellido_anterior, socDireccion_anterior, socTelefono_anterior,
        socNombre_nuevo, socApellido_nuevo, socDireccion_nuevo, socTelefono_nuevo,
        audi_fechaModificacion, audi_usuario, audi_accion
    ) 
    VALUES (
        NEW.soc_numero, 
        OLD.soc_nombre, OLD.soc_apellido, OLD.soc_direccion, OLD.soc_telefono,
        NEW.soc_nombre, NEW.soc_apellido, NEW.soc_direccion, NEW.soc_telefono,
        NOW(), CURRENT_USER(), 'Actualización'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipoautores`
--

CREATE TABLE `tbl_tipoautores` (
  `copiaISBN` bigint(20) NOT NULL,
  `copiaAutor` int(11) NOT NULL,
  `tipoAutor` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipoautores`
--

INSERT INTO `tbl_tipoautores` (`copiaISBN`, `copiaAutor`, `tipoAutor`) VALUES
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(1357924680, 123, 'Traductor'),
(2468135790, 234, 'Autor'),
(2718281828, 789, 'Traductor'),
(3141592653, 901, 'Autor'),
(5555555555, 678, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 234, 'Autor'),
(8888888888, 345, 'Coautor'),
(9517530862, 432, 'Traductor'),
(9517530862, 890, 'Autor'),
(9876543210, 567, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_prestamos_libros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_prestamos_libros` (
`pres_id` varchar(20)
,`lib_titulo` varchar(255)
,`lib_genero` varchar(20)
,`pres_fechaPrestamo` date
,`pres_fechaDevolucion` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_reporte_libros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_reporte_libros` (
`lib_isbn` bigint(20)
,`lib_titulo` varchar(255)
,`lib_genero` varchar(20)
,`lib_numeroPaginas` int(11)
,`lib_diasPrestamo` tinyint(4)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_prestamos_libros`
--
DROP TABLE IF EXISTS `vista_prestamos_libros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prestamos_libros`  AS SELECT `p`.`pres_id` AS `pres_id`, `l`.`lib_titulo` AS `lib_titulo`, `l`.`lib_genero` AS `lib_genero`, `p`.`pres_fechaPrestamo` AS `pres_fechaPrestamo`, `p`.`pres_fechaDevolucion` AS `pres_fechaDevolucion` FROM (`tbl_prestamo` `p` join `tbl_libro` `l` on(`p`.`lib_copiaISBN` = `l`.`lib_isbn`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_reporte_libros`
--
DROP TABLE IF EXISTS `vista_reporte_libros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_reporte_libros`  AS SELECT `tbl_libro`.`lib_isbn` AS `lib_isbn`, `tbl_libro`.`lib_titulo` AS `lib_titulo`, `tbl_libro`.`lib_genero` AS `lib_genero`, `tbl_libro`.`lib_numeroPaginas` AS `lib_numeroPaginas`, `tbl_libro`.`lib_diasPrestamo` AS `lib_diasPrestamo` FROM `tbl_libro` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `tbl_autor`
--
ALTER TABLE `tbl_autor`
  ADD PRIMARY KEY (`aut_codigo`);

--
-- Indices de la tabla `tbl_libro`
--
ALTER TABLE `tbl_libro`
  ADD PRIMARY KEY (`lib_isbn`),
  ADD KEY `idx_lib_titulo` (`lib_titulo`);

--
-- Indices de la tabla `tbl_prestamo`
--
ALTER TABLE `tbl_prestamo`
  ADD PRIMARY KEY (`pres_id`),
  ADD KEY `fk_prestamo_socio` (`soc_copiaNumero`),
  ADD KEY `fk_prestamo_libro` (`lib_copiaISBN`);

--
-- Indices de la tabla `tbl_socio`
--
ALTER TABLE `tbl_socio`
  ADD PRIMARY KEY (`soc_numero`);

--
-- Indices de la tabla `tbl_tipoautores`
--
ALTER TABLE `tbl_tipoautores`
  ADD PRIMARY KEY (`copiaISBN`,`copiaAutor`),
  ADD KEY `fk_tipoautores_autor` (`copiaAutor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  MODIFY `id_audi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  MODIFY `id_audi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_prestamo`
--
ALTER TABLE `tbl_prestamo`
  ADD CONSTRAINT `fk_prestamo_libro` FOREIGN KEY (`lib_copiaISBN`) REFERENCES `tbl_libro` (`lib_isbn`),
  ADD CONSTRAINT `fk_prestamo_socio` FOREIGN KEY (`soc_copiaNumero`) REFERENCES `tbl_socio` (`soc_numero`);

--
-- Filtros para la tabla `tbl_tipoautores`
--
ALTER TABLE `tbl_tipoautores`
  ADD CONSTRAINT `fk_tipoautores_autor` FOREIGN KEY (`copiaAutor`) REFERENCES `tbl_autor` (`aut_codigo`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tipoautores_libro` FOREIGN KEY (`copiaISBN`) REFERENCES `tbl_libro` (`lib_isbn`) ON DELETE CASCADE;

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `eliminar_prestamos` ON SCHEDULE EVERY 1 DAY STARTS '2026-03-10 00:00:00' ENDS '2026-12-31 23:59:59' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM tbl_prestamo
    WHERE pres_fechaDevolucion < CURDATE();
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
