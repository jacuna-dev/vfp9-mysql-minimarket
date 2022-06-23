**/
* datos class definition
*
* Copyright (C) 2000-2022 Jos� Acu�jacuna.dev@gmail.comcom>
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

DEFINE CLASS datos AS Custom

    * Propiedades.
    PROTECTED cError
    PROTECTED cTabla

    **/
    * Constructor.
    *
    * @return boolean
    * true si puede crear la instancia y false en caso contrario.
    */
    FUNCTION Init
        IF VARTYPE(THIS.cTabla) != 'C' OR EMPTY(THIS.cTabla) THEN
            THIS.cTabla = LOWER(SUBSTR(THIS.Name, 3))
        ENDIF

        IF VARTYPE(goConexion) != 'O' ;
                OR LOWER(goConexion.Class) != 'conexion' THEN
            RETURN .F.
        ENDIF

        * La conexi�n puede llegar a fallar si el SGBD o el controlador ODBC no
        * est�n instalados.
        IF goConexion.obtener_conexion() <= 0 THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    **/
    * Verifica si existe un c�digo.
    *
    * @param integer tnCodigo
    * C�digo a verificar.
    *
    * @return boolean
    * true si existe o se produce un error y false en caso contrario.
    */
    FUNCTION codigo_existe
        LPARAMETERS tnCodigo

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'codigo_existe', MUY_POCOS_ARGUMENTOS))
            RETURN .T.
        ENDIF

        IF !validar_numero(tnCodigo, , 65535) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'codigo_existe', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_NUMERO, '{}', 'tnCodigo')))
            RETURN .T.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL llExiste, lcCursor, lcSql, loExcepcion
        llExiste = .T.
        lcCursor = createmp()

        TRY
            lcSql = [SELECT fn_] + THIS.cTabla + ;
                [_codigo_existe(?tnCodigo) AS existe]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql, lcCursor) > 0 THEN
                IF USED(lcCursor) THEN
                    SELECT (lcCursor)
                    GOTO TOP
                    IF EMPTY(existe) THEN
                        llExiste = .F.
                    ENDIF
                    USE
                ENDIF
            ELSE
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'codigo_existe', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN llExiste
    ENDFUNC

    **/
    * Verifica si existe una descripci�n.
    *
    * @param string tcDescripcion
    * Descripci�n a verificar.
    *
    * @return boolean
    * true si existe o se produce un error y false en caso contrario.
    */
    FUNCTION descripcion_existe
        LPARAMETERS tcDescripcion

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'descripcion_existe', MUY_POCOS_ARGUMENTOS))
            RETURN .T.
        ENDIF

        IF !validar_texto(tcDescripcion, , 40) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'descripcion_existe', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_TEXTO, '{}', 'tcDescripcion')))
            RETURN .T.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL llExiste, lcCursor, lcSql, loExcepcion
        llExiste = .T.
        lcCursor = createmp()

        TRY
            lcSql = [SELECT fn_] + THIS.cTabla + ;
                [_descripcion_existe(?tcDescripcion) AS existe]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql, lcCursor) > 0 THEN
                IF USED(lcCursor) THEN
                    SELECT (lcCursor)
                    GOTO TOP
                    IF EMPTY(existe) THEN
                        llExiste = .F.
                    ENDIF
                    USE
                ENDIF
            ELSE
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'descripcion_existe', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN llExiste
    ENDFUNC

    **/
    * Realiza una b�squeda por c�digo o descripci�n.
    *
    * @param string tcTexto
    * Texto a buscar.
    *
    * @param string tcCursor
    * Cursor en el que se guardar� el resultado de la b�squeda.
    *
    * @return cursor|boolean
    * cursor|true si la b�squeda se ejecuta correctamente y false en caso
    * contrario.
    */
    FUNCTION listado
        LPARAMETERS tcTexto, tcCursor

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 2 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'listado', ;
                MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_texto(tcTexto, , 100) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'listado', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_TEXTO, '{}', 'tcTexto')))
            RETURN .F.
        ENDIF

        IF !validar_texto(tcCursor, 8, 8) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'listado', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_TEXTO, '{}', 'tcCursor')))
            RETURN .F.
        ENDIF

        tcTexto = limpiar_texto_sql(tcTexto)
        * fin { validaciones de par�metros }

        LOCAL lcSql, llExito, loExcepcion

        TRY
            lcSql = [CALL sp_] + THIS.cTabla + [_listado(?tcTexto)]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql, tcCursor) > 0 THEN
                llExito = .T.
            ELSE
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'listado', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN llExito
    ENDFUNC

    **/
    * Realiza una b�squeda por c�digo.
    *
    * @param integer tnCodigo
    * C�digo a buscar.
    *
    * @return object|boolean
    * object si encuentra el registro y false en caso contrario.
    */
    FUNCTION obtener_por_codigo
        LPARAMETERS tnCodigo

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'obtener_por_codigo', MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_numero(tnCodigo, , 65535) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'obtener_por_codigo', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_NUMERO, '{}', 'tnCodigo')))
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL lcCursor, lcSql, loEntidad, loExcepcion
        lcCursor = createmp()

        TRY
            lcSql = [CALL sp_] + THIS.cTabla + [_obtener_por_codigo(?tnCodigo)]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql, lcCursor) > 0 THEN
                IF USED(lcCursor) THEN
                    SELECT (lcCursor)
                    GOTO TOP
                    loEntidad = THIS.cargar_datos()
                    USE
                ENDIF
            ELSE
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'obtener_por_codigo', BD_ERROR_SENTENCIA_SQL + CR + lcSql))
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN loEntidad
    ENDFUNC

    **/
    * Realiza una b�squeda por descripci�n.
    *
    * @param string tcDescripcion
    * Descripci�n a buscar.
    *
    * @return object|boolean
    * object si encuentra el registro y false en caso contrario.
    */
    FUNCTION obtener_por_descripcion
        LPARAMETERS tcDescripcion

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'obtener_por_descripcion', MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_texto(tcDescripcion, , 40) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'obtener_por_descripcion', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_TEXTO, '{}', 'tcDescripcion')))
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL lcCursor, lcSql, loEntidad, loExcepcion
        lcCursor = createmp()

        TRY
            lcSql = [CALL sp_] + THIS.cTabla + ;
                [_obtener_por_descripcion(?tcDescripcion)]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql, lcCursor) > 0 THEN
                IF USED(lcCursor) THEN
                    SELECT (lcCursor)
                    GOTO TOP
                    loEntidad = THIS.cargar_datos()
                    USE
                ENDIF
            ELSE
                THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                    'obtener_por_descripcion', BD_ERROR_SENTENCIA_SQL + CR + ;
                    lcSql))
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN loEntidad
    ENDFUNC

    **/
    * Guarda una entidad en la base de datos.
    *
    * @param integer tnOpcion
    * Opci�n de guardado. Si el valor es igual a 1, crea un nuevo registro;
    * de lo contrario, actualiza un registro existente.

    * @param object toEntidad
    * Especifica el objeto entidad a guardar.
    *
    * @return boolean
    * true si guarda los datos correctamente y false en caso contrario.
    */
    FUNCTION guardar
        LPARAMETERS tnOpcion, toEntidad

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 2 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'guardar', ;
                MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_numero(tnOpcion, 1, 2) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'guardar', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_NUMERO, '{}', 'tnOpcion')))
            RETURN .F.
        ENDIF

        IF VARTYPE(toEntidad) != 'O' ;
                OR LOWER(toEntidad.ParentClass) != 'entidades' THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'guardar', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_OBJETO, '{}', 'toEntidad')))
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL lcSql, llGuardado, loExcepcion, ;
              lnCodigo, lcDescripcion

        TRY
            WITH toEntidad
                lnCodigo = .obtener_codigo()
                lcDescripcion = .obtener_descripcion()
            ENDWITH

            lcSql = [CALL sp_] + THIS.cTabla + ;
                [_guardar(?tnOpcion, ?lnCodigo, ?lcDescripcion)]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql) > 0 THEN
                llGuardado = .T.
            ELSE
                AERROR(aErrorArray)
                THIS.cError = excepcion_sql(@aErrorArray)
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN llGuardado
    ENDFUNC

    **/
    * Elimina un registro de la base de datos.
    *
    * @param integer tnCodigo
    * C�digo a eliminar.
    *
    * @return boolean
    * true si elimina el registro correctamente y false en caso contrario.
    */
    FUNCTION eliminar
        LPARAMETERS tnCodigo

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'eliminar', ;
                MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_numero(tnCodigo, , 65535) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), 'eliminar', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_NUMERO, '{}', 'tnCodigo')))
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL llEliminado, lcSql, loExcepcion

        TRY
            lcSql = [CALL sp_] + THIS.cTabla + [_eliminar(?tnCodigo)]

            IF SQLEXEC(goConexion.obtener_conexion(), lcSql) > 0 THEN
                llEliminado = .T.
            ELSE
                AERROR(aErrorArray)
                THIS.cError = excepcion_sql(@aErrorArray)
            ENDIF
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN llEliminado
    ENDFUNC

    **/
    * Devuelve el mensaje de error.
    *
    * @return string
    * empty string si no hay ning�n error y non-empty string en caso contrario.
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

        * inicio { validaciones del par�metro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(tcMensaje) != 'C' OR EMPTY(tcMensaje) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del par�metro }

        LOCAL lcError
        lcError = THIS.obtener_error()

        IF !EMPTY(lcError) THEN
            lcError = CR + CR + lcError
        ENDIF

        THIS.cError = tcMensaje + lcError
    ENDFUNC

    **/
    * Carga los datos de la tabla a un objeto.
    *
    * @return object|boolean
    * object si carga los datos con �xito y false en caso contrario.
    */
    PROTECTED FUNCTION cargar_datos
        LOCAL loEntidad, loExcepcion

        TRY
            loEntidad = CREATEOBJECT('e_' + THIS.cTabla, ;
                codigo, ;
                descripcion ;
            )
        CATCH TO loExcepcion
            THIS.establecer_error(mensaje_excepcion(loExcepcion))
        ENDTRY

        RETURN loEntidad
    ENDFUNC

ENDDEFINE
