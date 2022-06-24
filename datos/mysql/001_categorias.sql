/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *                                   TABLA                                    *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
CREATE TABLE IF NOT EXISTS categorias (
    codigo SMALLINT(5) UNSIGNED NOT NULL,
    descripcion VARCHAR(40) NOT NULL,
    estado TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en DATETIME NULL DEFAULT NULL
)
ENGINE=InnoDB
DEFAULT CHARACTER SET = 'latin1'
DEFAULT COLLATE = 'latin1_swedish_ci';

ALTER TABLE categorias
    ADD CONSTRAINT pk_categorias_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_categorias_descripcion
        UNIQUE KEY (descripcion),
    ADD CONSTRAINT ck_categorias_codigo
        CHECK (codigo BETWEEN 1 AND 65535),
    ADD CONSTRAINT ck_categorias_descripcion
        CHECK (descripcion <> ''),
    ADD CONSTRAINT ck_categorias_estado
        CHECK (estado IN (0, 1));

ALTER TABLE categorias
    CHANGE COLUMN codigo
        codigo SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *                         PROCEDIMIENTOS ALMACENADOS                         *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

--
-- INICIO: CATEGORIAS
--

/* -------------------------------------------------------------------------- *
 * FN para averiguar si existe un código en la tabla 'categorias'.            *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS fn_categorias_codigo_existe $$

CREATE FUNCTION fn_categorias_codigo_existe(p_codigo SMALLINT(5) UNSIGNED)
       RETURNS TINYINT(3) UNSIGNED
BEGIN
    DECLARE v_filas TINYINT(3) UNSIGNED DEFAULT 0;

    SELECT
        COUNT(*)
    FROM
        categorias
    WHERE
        codigo = p_codigo
    INTO
        v_filas;

    RETURN v_filas;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * FN para averiguar si existe una descripción en la tabla de 'categorias'.   *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS fn_categorias_descripcion_existe $$

CREATE FUNCTION fn_categorias_descripcion_existe(p_descripcion VARCHAR(40))
       RETURNS TINYINT(3) UNSIGNED
BEGIN
    DECLARE v_filas TINYINT(3) UNSIGNED DEFAULT 0;

    SELECT
        COUNT(*)
    FROM
        categorias
    WHERE
        UPPER(descripcion) LIKE UPPER(p_descripcion)
    INTO
        v_filas;

    RETURN v_filas;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para obtener registros por código de la tabla 'categorias'.             *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_obtener_por_codigo $$

CREATE PROCEDURE sp_categorias_obtener_por_codigo(
    IN p_codigo SMALLINT(5) UNSIGNED)
BEGIN
    SELECT
        codigo,
        descripcion
    FROM
        categorias
    WHERE
        codigo = p_codigo
    ORDER BY
        descripcion;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para obtener registros por descripción de la tabla 'categorias'.        *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_obtener_por_descripcion $$

CREATE PROCEDURE sp_categorias_obtener_por_descripcion(
    IN p_descripcion VARCHAR(40))
BEGIN
    SELECT
        codigo,
        descripcion
    FROM
        categorias
    WHERE
        TRIM(UPPER(descripcion)) LIKE TRIM(UPPER(p_descripcion))
    ORDER BY
        descripcion;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para obtener registros de la tabla 'categorias'.                        *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_listado $$

CREATE PROCEDURE sp_categorias_listado(IN p_texto VARCHAR(100))
BEGIN
    SELECT
        codigo,
        descripcion
    FROM
        categorias
    WHERE
        estado != 0
        AND UPPER(CONCAT(TRIM(CAST(codigo AS CHAR)), TRIM(descripcion)))
            LIKE CONCAT('%', TRIM(UPPER(p_texto)), '%');
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para guardar un registro en la tabla 'categorias'.                      *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_guardar $$

CREATE PROCEDURE sp_categorias_guardar(
    IN p_opcion TINYINT(3) UNSIGNED,
    IN p_codigo SMALLINT(5) UNSIGNED,
    IN p_descripcion VARCHAR(40))
BEGIN
    DECLARE v_codigo SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE v_descripcion VARCHAR(40);
    DECLARE v_estado TINYINT(3) UNSIGNED DEFAULT 0;

    -- inicio { validaciones }
    IF p_descripcion IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '|Descripción: No puede ser nula.|';
    END IF;

    IF p_descripcion = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '|Descripción: No puede quedar en blanco.|';
    END IF;
    -- fin { validaciones }

    IF p_opcion = 1 THEN    -- nuevo registro.
        IF (SELECT fn_categorias_descripcion_existe(p_descripcion)) THEN
            SELECT
                codigo,
                estado
            FROM
                categorias
            WHERE
                UPPER(descripcion) LIKE UPPER(p_descripcion)
            INTO
                v_codigo,
                v_estado;

            IF v_estado = 0 THEN
                CALL sp_categorias_restaurar(v_codigo);
            ELSE
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = '|Descripción: Ya existe.|';
            END IF;
        ELSE
            INSERT INTO categorias (descripcion) VALUES (p_descripcion);
        END IF;
    ELSE                    -- actualizar registro.
        -- inicio { validar: codigo }
        IF p_codigo IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '|Código: No puede ser nulo.|';
        END IF;

        IF p_codigo <= 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '|Código: Debe ser mayor que cero.|';
        END IF;

        IF NOT (SELECT fn_categorias_codigo_existe(p_codigo)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '|Código: No existe.|';
        END IF;

        IF EXISTS(SELECT * FROM productos WHERE categoria = p_codigo) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '|Código: Con referencias asociadas.|';
        END IF;
        -- fin { validar: codigo }

        -- inicio { validar: descripcion }
        IF EXISTS(SELECT * FROM categorias WHERE codigo <> p_codigo
                AND UPPER(descripcion) LIKE UPPER(p_descripcion)) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '|Descripción: Ya existe.|';
        END IF;
        -- fin { validar: descripcion }

        SELECT
            descripcion
        FROM
            categorias
        WHERE
            codigo = p_codigo
        INTO
            v_descripcion;

        IF UPPER(v_descripcion) <> UPPER(p_descripcion) THEN
            UPDATE
                categorias
            SET
                descripcion = p_descripcion,
                actualizado_en = CURRENT_TIMESTAMP
            WHERE
                codigo = p_codigo;
        END IF;
    END IF;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para eliminar filas de la tabla 'categorias'.                           *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_eliminar $$

CREATE PROCEDURE sp_categorias_eliminar(IN p_codigo SMALLINT(5) UNSIGNED)
BEGIN
    -- inicio { validar: codigo }
    IF NOT (SELECT fn_categorias_codigo_existe(p_codigo)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '|Código: No existe.|';
    END IF;
    -- fin { validar: codigo }

    UPDATE
        categorias
    SET
        estado = 0,
        actualizado_en = CURRENT_TIMESTAMP
    WHERE
        codigo = p_codigo;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * SP para restaurar filas de la tabla 'categorias'.                          *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_categorias_restaurar $$

CREATE PROCEDURE sp_categorias_restaurar(IN p_codigo SMALLINT(5) UNSIGNED)
BEGIN
    DECLARE v_estado TINYINT(3) UNSIGNED DEFAULT 0;

    -- inicio { validar: codigo }
    IF NOT (SELECT fn_categorias_codigo_existe(p_codigo)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '|Código: No existe.|';
    END IF;
    -- fin { validar: codigo }

    SELECT
        estado
    FROM
        categorias
    WHERE
        codigo = p_codigo
    INTO
        v_estado;

    IF v_estado = 0 THEN
        UPDATE
            categorias
        SET
            estado = 1,
            actualizado_en = CURRENT_TIMESTAMP
        WHERE
            codigo = p_codigo;
    END IF;
END $$

DELIMITER ;

--
-- FIN: CATEGORIAS
--
