**/
* negocio class definition
*
* Copyright (C) 2000-2022 José Acuña <jacuna.dev@gmail.com>
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

DEFINE CLASS negocio AS Custom

    * Propiedades.
    PROTECTED cError
    PROTECTED cTabla
    PROTECTED oDatos

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

        THIS.oDatos = crear_objeto('d_' + THIS.cTabla)

        IF VARTYPE(THIS.oDatos) != 'O' ;
                OR LOWER(THIS.oDatos.ParentClass) != 'datos' THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    **/
    * Verifica si existe un código.
    *
    * @param integer tnCodigo
    * Código a verificar.
    *
    * @return boolean
    * true si existe o se produce un error y false en caso contrario.
    */
    FUNCTION codigo_existe
        LPARAMETERS tnCodigo

        LOCAL llExiste

        IF THIS.oDatos.codigo_existe(tnCodigo) THEN
            llExiste = .T.
            THIS.establecer_error(THIS.oDatos.obtener_error())
        ENDIF

        RETURN llExiste
    ENDFUNC

    **/
    * Verifica si existe una descripción.
    *
    * @param string tcDescripcion
    * Descripción a verificar.
    *
    * @return boolean
    * true si existe o se produce un error y false en caso contrario.
    */
    FUNCTION descripcion_existe
        LPARAMETERS tcDescripcion

        LOCAL llExiste

        IF THIS.oDatos.descripcion_existe(tcDescripcion) THEN
            llExiste = .T.
            THIS.establecer_error(THIS.oDatos.obtener_error())
        ENDIF

        RETURN llExiste
    ENDFUNC

    **/
    * Realiza una búsqueda por código o descripción.
    *
    * @param string tcTexto
    * Texto a buscar.
    *
    * @param string tcCursor
    * Cursor en el que se guardará el resultado de la búsqueda.
    *
    * @return cursor|boolean
    * cursor|true si la búsqueda se ejecuta correctamente y false en caso
    * contrario.
    */
    FUNCTION listado
        LPARAMETERS tcTexto, tcCursor

        LOCAL llExito

        IF THIS.oDatos.listado(tcTexto, tcCursor) THEN
            llExito = .T.
        ELSE
            THIS.establecer_error(THIS.oDatos.obtener_error())
        ENDIF

        RETURN llExito
    ENDFUNC

    **/
    * Realiza una búsqueda por código.
    *
    * @param integer tnCodigo
    * Código a buscar.
    *
    * @return object|boolean
    * object si encuentra el registro y false en caso contrario.
    */
    FUNCTION obtener_por_codigo
        LPARAMETERS tnCodigo

        LOCAL loEntidad
        loEntidad = THIS.oDatos.obtener_por_codigo(tnCodigo)
        THIS.establecer_error(THIS.oDatos.obtener_error())

        RETURN loEntidad
    ENDFUNC

    **/
    * Realiza una búsqueda por descripción.
    *
    * @param string tcDescripcion
    * Descripción a buscar.
    *
    * @return object|boolean
    * object si encuentra el registro y false en caso contrario.
    */
    FUNCTION obtener_por_descripcion
        LPARAMETERS tcDescripcion

        LOCAL loEntidad
        loEntidad = THIS.oDatos.obtener_por_descripcion(tcDescripcion)
        THIS.establecer_error(THIS.oDatos.obtener_error())

        RETURN loEntidad
    ENDFUNC

    **/
    * Guarda una entidad en la base de datos.
    *
    * @param integer tnOpcion
    * Opción de guardado. Si el valor es igual a 1, crea un nuevo registro;
    * de lo contrario, actualiza un registro existente.

    * @param object toEntidad
    * Especifica el objeto entidad a guardar.
    *
    * @return boolean
    * true si guarda los datos correctamente y false en caso contrario.
    */
    FUNCTION guardar
        LPARAMETERS tnOpcion, toEntidad

        LOCAL llGuardado

        IF THIS.oDatos.guardar(tnOpcion, toEntidad) THEN
            llGuardado = .T.
        ELSE
            THIS.cError = THIS.oDatos.obtener_error()
        ENDIF

        RETURN llGuardado
    ENDFUNC

    **/
    * Elimina un registro de la base de datos.
    *
    * @param integer tnCodigo
    * Código a eliminar.
    *
    * @return boolean
    * true si elimina el registro correctamente y false en caso contrario.
    */
    FUNCTION eliminar
        LPARAMETERS tnCodigo

        LOCAL llEliminado

        IF THIS.oDatos.eliminar(tnCodigo) THEN
            llEliminado = .T.
        ELSE
            THIS.cError = THIS.oDatos.obtener_error()
        ENDIF

        RETURN llEliminado
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
