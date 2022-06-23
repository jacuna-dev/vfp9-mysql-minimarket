**/
* conexion class definition
*
* Copyright (C) 2000-2022 José Acuñjacuna.dev@gmail.comcom>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <https://www.gnu.org/licenses/>.
*/
#INCLUDE 'constantes.h'

DEFINE CLASS conexion AS Custom

    * Propiedades.
    PROTECTED cControlador
    PROTECTED cServidor
    PROTECTED cBaseDatos
    PROTECTED cUsuario
    PROTECTED cClave
    PROTECTED nConexion
    PROTECTED cError

    **/
    * Constructor.
    *
    * @return boolean
    * true si puede crear la instancia y false en caso contrario.
    */
    FUNCTION Init
        WITH THIS
            .cControlador = 'MySQL ODBC 8.0 Unicode Driver'
            .cServidor = '127.0.0.1'
            .cBaseDatos = 'minimarket'
            .cUsuario = 'root'
            .cClave = ''
        ENDWITH
    ENDFUNC

    **/
    * Desconecta la fuente de datos cuando se libera el objeto.
    *
    * @return boolean true (default)
    */
    FUNCTION Destroy
        THIS.desconectar()
    ENDFUNC

    **/
    * Devuelve un valor numérico positivo distinto de cero como manejador de
    * sentencias SQL.
    *
    * @return integer
    * entero positivo distinto de cero si logra obtener una conexión con la base
    * de datos o cero en caso contrario.
    */
    FUNCTION obtener_conexion
        LOCAL lnConexion
        lnConexion = 0

        IF VARTYPE(THIS.nConexion) == 'N' AND THIS.nConexion > 0 THEN
            lnConexion = THIS.nConexion
        ELSE
            IF THIS.conectar() THEN
                lnConexion = THIS.nConexion
            ENDIF
        ENDIF

        RETURN lnConexion
    ENDFUNC

    **/
    * Desconecta la fuente de datos.
    *
    * @return boolean
    * true si se desconecta correctamente y false en caso contrario.
    */
    FUNCTION desconectar
        IF VARTYPE(THIS.nConexion) == 'N' AND THIS.nConexion > 0 THEN
            IF SQLDISCONNECT(THIS.nConexion) == 1 THEN
                THIS.nConexion = 0
            ENDIF
        ENDIF

        IF VARTYPE(THIS.nConexion) == 'N' AND THIS.nConexion == 0 THEN
            RETURN .T.
        ELSE
            RETURN .F.
        ENDIF
    ENDFUNC

    **/
    * Devuelve el mensaje de error.
    *
    * @return string
    * empty string si no hay ningún error y non-empty string en caso contrario.
    */
    FUNCTION obtener_error
        LOCAL lcError
        lcError = ''

        IF VARTYPE(THIS.cError) == 'C' THEN
            lcError = THIS.cError
        ENDIF

        RETURN lcError
    ENDFUNC

    **/
    * Conecta a la fuente de datos.
    *
    * @return boolean
    * true si se conecta correctamente y false en caso contrario.
    */
    PROTECTED FUNCTION conectar
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) == 'N' AND THIS.nConexion > 0 THEN
            RETURN .T.
        ENDIF

        IF VARTYPE(THIS.cControlador) != 'C' OR EMPTY(THIS.cControlador) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'conectar', BD_CONTROLADOR_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cServidor) != 'C' OR EMPTY(THIS.cServidor) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'conectar', BD_SERVIDOR_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cBaseDatos) != 'C' OR EMPTY(THIS.cBaseDatos) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'conectar', BD_NOMBRE_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cUsuario) != 'C' OR EMPTY(THIS.cUsuario) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'conectar', BD_USUARIO_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cClave) != 'C' THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'conectar', BD_CLAVE_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcCadena, lnConexion
        lcCadena = 'Driver={' + THIS.cControlador + '};' + ;
                   'Server=' + THIS.cServidor + ';' + ;
                   'Database=' + ';' + ;
                   'User=' + THIS.cUsuario + ';' + ;
                   'Password=' + THIS.cClave + ';' + ;
                   'Option=3;'
        lnConexion = SQLSTRINGCONNECT(lcCadena)
MESSAGEBOX(lnconexion)
        IF lnConexion > 0 THEN
            THIS.nConexion = lnConexion

            IF THIS.existe_base_datos() THEN
                IF !THIS.seleccionar_base_datos() THEN
                    THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                        'conectar', BD_NO_SELECCIONADA))
                ENDIF
            ELSE
                IF THIS.crear_base_datos() THEN
                    IF THIS.seleccionar_base_datos() THEN
                        IF !THIS.crear_tabla_categorias() THEN
                            THIS.establecer_error(mensaje_error( ;
                                LOWER(THIS.Name), 'conectar', ;
                                STRTRAN(BD_TABLA_NO_CREADA, '{}', ;
                                'categorias')))
                        ENDIF

                        IF !THIS.crear_tabla_marcas() THEN
                            THIS.establecer_error(mensaje_error( ;
                                LOWER(THIS.Name), 'conectar', ;
                                STRTRAN(BD_TABLA_NO_CREADA, '{}', 'marcas')))
                        ENDIF

                        IF !THIS.crear_tabla_unidades_medidas() THEN
                            THIS.establecer_error(mensaje_error( ;
                                LOWER(THIS.Name), 'conectar', ;
                                STRTRAN(BD_TABLA_NO_CREADA, '{}', ;
                                'unidades_medidas')))
                        ENDIF

                        IF !THIS.crear_tabla_productos() THEN
                            THIS.establecer_error(mensaje_error( ;
                                LOWER(THIS.Name), 'conectar', ;
                                STRTRAN(BD_TABLA_NO_CREADA, '{}', 'productos')))
                        ENDIF
                    ELSE
                        THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                            'conectar', BD_NO_SELECCIONADA))
                    ENDIF
                ELSE
                    THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                        'conectar', BD_NO_CREADA))
                ENDIF
            ENDIF
        ENDIF

        RETURN IIF(THIS.nConexion > 0, .T., .F.)
    ENDFUNC

    **/
    * Determina si la base de datos existe.
    *
    * @return boolean
    * true si la base de datos existe u ocurre un error y false en caso
    * contrario.
    */
    PROTECTED FUNCTION existe_base_datos
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'existe_base_datos', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .T.
        ENDIF

        IF VARTYPE(THIS.cBaseDatos) != 'C' OR EMPTY(THIS.cBaseDatos) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'existe_base_datos', BD_NOMBRE_NO_ESTABLECIDO))
            RETURN .T.
        ENDIF
        * fin { validaciones }

        LOCAL llExiste, lcSql, lcCursor
        llExiste = .T.
        lcSql = [SHOW DATABASES LIKE '] + THIS.cBaseDatos + [']
        lcCursor = createmp()

        IF SQLEXEC(THIS.nConexion, lcSql, lcCursor) > 0 THEN
            IF USED(lcCursor) THEN
                SELECT (lcCursor)
                IF RECCOUNT() == 0 THEN
                    llExiste = .F.
                ENDIF
                USE
            ENDIF
        ELSE
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'existe_base_datos', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
        ENDIF

        RETURN llExiste
    ENDFUNC

    **/
    * Selecciona la base de datos.
    *
    * @return boolean
    * true si logra seleccionar la base de datos y false en caso contrario.
    */
    PROTECTED FUNCTION seleccionar_base_datos
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'seleccionar_base_datos', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cBaseDatos) != 'C' OR EMPTY(THIS.cBaseDatos) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'seleccionar_base_datos', BD_NOMBRE_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcSql, llSeleccionada
        lcSql = 'USE `' + THIS.cBaseDatos + '`;'

        IF SQLEXEC(THIS.nConexion, lcSql) > 0 THEN
            llSeleccionada = .T.
        ELSE
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'seleccionar_base_datos', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
        ENDIF

        RETURN llSeleccionada
    ENDFUNC

    **/
    * Crea la base de datos.
    *
    * @return boolean
    * true si la base de datos es creada y false en caso contrario.
    */
    PROTECTED FUNCTION crear_base_datos
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_base_datos', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cBaseDatos) != 'C' OR EMPTY(THIS.cBaseDatos) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_base_datos', BD_NOMBRE_NO_ESTABLECIDO))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcTextMerge, lcSql, llCreada
        lcTextMerge = SET('TEXTMERGE')

        SET TEXTMERGE ON

        TEXT TO lcSql NOSHOW
            CREATE DATABASE IF NOT EXISTS <<THIS.cBaseDatos>>
            DEFAULT CHARACTER SET = 'latin1'
            DEFAULT COLLATE = 'latin1_swedish_ci';
        ENDTEXT

        SET TEXTMERGE &lcTextMerge

        IF SQLEXEC(THIS.nConexion, lcSql) > 0 THEN
            llCreada = .T.
        ELSE
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_base_datos', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
        ENDIF

        RETURN llCreada
    ENDFUNC

    **/
    * Crea la tabla 'categorias'.
    *
    * @return boolean
    * true si la tabla es creada y false en caso contrario.
    */
    PROTECTED FUNCTION crear_tabla_categorias
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_tabla_categorias', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcTextMerge, lcSqlCreate, lcSqlAlter, lcSqlChange, ;
              lnValRetCreate, lnValRetAlter, lnValRetChange, llCreada

        lcTextMerge = SET('TEXTMERGE')
        SET TEXTMERGE ON

        TEXT TO lcSqlCreate NOSHOW
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
        ENDTEXT

        TEXT TO lcSqlAlter NOSHOW
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
        ENDTEXT

        TEXT TO lcSqlChange NOSHOW
            ALTER TABLE categorias
                CHANGE COLUMN codigo
                    codigo SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;
        ENDTEXT

        SET TEXTMERGE &lcTextMerge

        lnValRetCreate = SQLEXEC(THIS.nConexion, lcSqlCreate)
        lnValRetAlter  = SQLEXEC(THIS.nConexion, lcSqlAlter)
        lnValRetChange = SQLEXEC(THIS.nConexion, lcSqlChange)

        IF lnValRetCreate > 0 AND lnValRetAlter > 0 AND lnValRetChange > 0 THEN
            llCreada = .T.
        ELSE
            IF lnValRetCreate < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_categorias', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlCreate))
            ENDIF

            IF lnValRetAlter < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_categorias', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlAlter))
            ENDIF

            IF lnValRetChange < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_categorias', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlChange))
            ENDIF
        ENDIF

        RETURN llCreada
    ENDFUNC

    **/
    * Crea la tabla 'marcas'.
    *
    * @return boolean
    * true si la tabla es creada y false en caso contrario.
    */
    PROTECTED FUNCTION crear_tabla_marcas
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_tabla_marcas', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcTextMerge, lcSqlCreate, lcSqlAlter, lcSqlChange, ;
              lnValRetCreate, lnValRetAlter, lnValRetChange, llCreada

        lcTextMerge = SET('TEXTMERGE')
        SET TEXTMERGE ON

        TEXT TO lcSqlCreate NOSHOW
            CREATE TABLE IF NOT EXISTS marcas (
                codigo SMALLINT(5) UNSIGNED NOT NULL,
                descripcion VARCHAR(40) NOT NULL,
                estado TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
                creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                actualizado_en DATETIME NULL DEFAULT NULL
            )
            ENGINE=InnoDB
            DEFAULT CHARACTER SET = 'latin1'
            DEFAULT COLLATE = 'latin1_swedish_ci';
        ENDTEXT

        TEXT TO lcSqlAlter NOSHOW
            ALTER TABLE marcas
                ADD CONSTRAINT pk_marcas_codigo
                    PRIMARY KEY (codigo),
                ADD CONSTRAINT uk_marcas_descripcion
                    UNIQUE KEY (descripcion),
                ADD CONSTRAINT ck_marcas_codigo
                    CHECK (codigo BETWEEN 1 AND 65535),
                ADD CONSTRAINT ck_marcas_descripcion
                    CHECK (descripcion <> ''),
                ADD CONSTRAINT ck_marcas_estado
                    CHECK (estado IN (0, 1));
        ENDTEXT

        TEXT TO lcSqlChange NOSHOW
            ALTER TABLE marcas
                CHANGE COLUMN codigo
                    codigo SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;
        ENDTEXT

        SET TEXTMERGE &lcTextMerge

        lnValRetCreate = SQLEXEC(THIS.nConexion, lcSqlCreate)
        lnValRetAlter  = SQLEXEC(THIS.nConexion, lcSqlAlter)
        lnValRetChange = SQLEXEC(THIS.nConexion, lcSqlChange)

        IF lnValRetCreate > 0 AND lnValRetAlter > 0 AND lnValRetChange > 0 THEN
            llCreada = .T.
        ELSE
            IF lnValRetCreate < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_marcas', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlCreate))
            ENDIF

            IF lnValRetAlter < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_marcas', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlAlter))
            ENDIF

            IF lnValRetChange < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_marcas', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSqlChange))
            ENDIF
        ENDIF

        RETURN llCreada
    ENDFUNC

    **/
    * Crea la tabla 'unidades_medidas'.
    *
    * @return boolean
    * true si la tabla es creada y false en caso contrario.
    */
    PROTECTED FUNCTION crear_tabla_unidades_medidas
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_tabla_unidades_medidas', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcTextMerge, lcSqlCreate, lcSqlAlter, lcSqlChange, ;
              lnValRetCreate, lnValRetAlter, lnValRetChange, llCreada

        lcTextMerge = SET('TEXTMERGE')
        SET TEXTMERGE ON

        TEXT TO lcSqlCreate NOSHOW
            CREATE TABLE IF NOT EXISTS unidades_medidas (
                codigo SMALLINT(5) UNSIGNED NOT NULL,
                descripcion VARCHAR(40) NOT NULL,
                abreviatura VARCHAR(5) NOT NULL,
                estado TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
                creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                actualizado_en DATETIME NULL DEFAULT NULL
            )
            ENGINE=InnoDB
            DEFAULT CHARACTER SET = 'latin1'
            DEFAULT COLLATE = 'latin1_swedish_ci';
        ENDTEXT

        TEXT TO lcSqlAlter NOSHOW
            ALTER TABLE unidades_medidas
                ADD CONSTRAINT pk_unidades_medidas_codigo
                    PRIMARY KEY (codigo),
                ADD CONSTRAINT uk_unidades_medidas_descripcion
                    UNIQUE KEY (descripcion),
                ADD CONSTRAINT uk_unidades_medidas_abreviatura
                    UNIQUE KEY (abreviatura),
                ADD CONSTRAINT ck_unidades_medidas_codigo
                    CHECK (codigo BETWEEN 1 AND 65535),
                ADD CONSTRAINT ck_unidades_medidas_descripcion
                    CHECK (descripcion <> ''),
                ADD CONSTRAINT ck_unidades_medidas_abreviatura
                    CHECK (abreviatura <> ''),
                ADD CONSTRAINT ck_unidades_medidas_estado
                    CHECK (estado IN (0, 1));
        ENDTEXT

        TEXT TO lcSqlChange NOSHOW
            ALTER TABLE unidades_medidas
                CHANGE COLUMN codigo
                    codigo SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;
        ENDTEXT

        SET TEXTMERGE &lcTextMerge

        lnValRetCreate = SQLEXEC(THIS.nConexion, lcSqlCreate)
        lnValRetAlter  = SQLEXEC(THIS.nConexion, lcSqlAlter)
        lnValRetChange = SQLEXEC(THIS.nConexion, lcSqlChange)

        IF lnValRetCreate > 0 AND lnValRetAlter > 0 AND lnValRetChange > 0 THEN
            llCreada = .T.
        ELSE
            IF lnValRetCreate < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_unidades_medidas', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlCreate))
            ENDIF

            IF lnValRetAlter < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_unidades_medidas', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlAlter))
            ENDIF

            IF lnValRetChange < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_unidades_medidas', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlChange))
            ENDIF
        ENDIF

        RETURN llCreada
    ENDFUNC

    **/
    * Crea la tabla 'productos'.
    *
    * @return boolean
    * true si la tabla es creada y false en caso contrario.
    */
    PROTECTED FUNCTION crear_tabla_productos
        * inicio { validaciones }
        IF VARTYPE(THIS.nConexion) != 'N' OR THIS.nConexion == 0 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'crear_tabla_productos', BD_CONEXION_NO_ESTABLECIDA))
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL lcTextMerge, lcSqlCreate, lcSqlAlter, lcSqlChange, ;
              lnValRetCreate, lnValRetAlter, lnValRetChange, llCreada

        lcTextMerge = SET('TEXTMERGE')
        SET TEXTMERGE ON

        TEXT TO lcSqlCreate NOSHOW
            CREATE TABLE IF NOT EXISTS productos (
                codigo SMALLINT(5) UNSIGNED NOT NULL,
                descripcion VARCHAR(100) NOT NULL,
                marca SMALLINT(5) UNSIGNED NOT NULL,
                unidad_medida SMALLINT(5) UNSIGNED NOT NULL,
                categoria SMALLINT(5) UNSIGNED NOT NULL,
                stock_min DECIMAL(10,2) UNSIGNED NULL,
                stock_max DECIMAL(10,2) UNSIGNED NULL,
                estado TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
                creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                actualizado_en DATETIME NULL DEFAULT NULL
            )
            ENGINE=InnoDB
            DEFAULT CHARACTER SET = 'latin1'
            DEFAULT COLLATE = 'latin1_swedish_ci';
        ENDTEXT

        TEXT TO lcSqlAlter NOSHOW
            ALTER TABLE productos
                ADD CONSTRAINT pk_productos_codigo
                    PRIMARY KEY (codigo),
                ADD CONSTRAINT uk_productos_descripcion
                    UNIQUE KEY (descripcion),
                ADD CONSTRAINT fk_productos_marca
                    FOREIGN KEY (marca) REFERENCES marcas (codigo)
                        ON DELETE NO ACTION
                        ON UPDATE NO ACTION,
                ADD CONSTRAINT fk_productos_unidad_medida
                    FOREIGN KEY (unidad_medida)
                            REFERENCES unidades_medidas (codigo)
                        ON DELETE NO ACTION
                        ON UPDATE NO ACTION,
                ADD CONSTRAINT fk_productos_categoria
                    FOREIGN KEY (categoria) REFERENCES categorias (codigo)
                        ON DELETE NO ACTION
                        ON UPDATE NO ACTION,
                ADD CONSTRAINT ck_productos_codigo
                    CHECK (codigo BETWEEN 1 AND 65535),
                ADD CONSTRAINT ck_productos_descripcion
                    CHECK (descripcion <> ''),
                ADD CONSTRAINT chk_productos_stock_min
                    CHECK (stock_min >= 0),
                ADD CONSTRAINT chk_productos_stock_max
                    CHECK (stock_max >= 0),
                ADD CONSTRAINT ck_productos_estado
                    CHECK (estado IN (0, 1));
        ENDTEXT

        TEXT TO lcSqlChange NOSHOW
            ALTER TABLE productos
                CHANGE COLUMN codigo
                    codigo SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;
        ENDTEXT

        SET TEXTMERGE &lcTextMerge

        lnValRetCreate = SQLEXEC(THIS.nConexion, lcSqlCreate)
        lnValRetAlter  = SQLEXEC(THIS.nConexion, lcSqlAlter)
        lnValRetChange = SQLEXEC(THIS.nConexion, lcSqlChange)

        IF lnValRetCreate > 0 AND lnValRetAlter > 0 AND lnValRetChange > 0 THEN
            llCreada = .T.
        ELSE
            IF lnValRetCreate < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_productos', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlCreate))
            ENDIF

            IF lnValRetAlter < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_productos', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlAlter))
            ENDIF

            IF lnValRetChange < 0 THEN
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'crear_tabla_productos', BD_ERROR_SENTENCIA_SQL + ;
                    CR + lcSqlChange))
            ENDIF
        ENDIF

        RETURN llCreada
    ENDFUNC

    **/
    * Establece el mensaje de error.
    *
    * @param string tcMensaje
    * Especifica el mensaje de error.
    *
    * @return boolean
    * true si establece el mensaje de error y false en caso contrario.
    */
    PROTECTED FUNCTION establecer_error
        LPARAMETERS tcMensaje

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(tcMensaje) != 'C' OR EMPTY(tcMensaje) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        LOCAL lcError
        lcError = THIS.obtener_error()

        IF !EMPTY(lcError) THEN
            lcError = CR + CR + lcError
        ENDIF

        THIS.cError = tcMensaje + lcError
    ENDFUNC

ENDDEFINE
