**/
* entidades class definition
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

DEFINE CLASS entidades AS Custom

    * Propiedades.
    PROTECTED nCodigo
    PROTECTED cDescripcion
    PROTECTED cError

    * Inicialización de propiedades.
    nCodigo = 0
    cDescripcion = ''

    **/
    * Constructor.
    *
    * @param integer tnCodigo
    * Especifica el código del registro.
    *
    * @param string tcDescripcion
    * Especifica la descripcion del registro.
    *
    * @return boolean
    * true si puede crear la instancia y false en caso contrario.
    */
    FUNCTION Init
        LPARAMETERS tnCodigo, tcDescripcion

        IF PARAMETERS() == 2 THEN
            IF !THIS.establecer_codigo(tnCodigo) ;
                    OR !THIS.establecer_descripcion(tcDescripcion) THEN
                RETURN .F.
            ENDIF
        ENDIF
    ENDFUNC

    **/
    * Devuelve el código del registro.
    *
    * @return integer
    */
    FUNCTION obtener_codigo
        RETURN THIS.nCodigo
    ENDFUNC

    **/
    * Establece el código del registro.
    *
    * @param integer tnCodigo
    * Especifica el código del registro.
    *
    * @return boolean
    * true si puede establecer el valor y false en caso contrario.
    */
    FUNCTION establecer_codigo
        LPARAMETERS tnCodigo

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'establecer_codigo', MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_numero(tnCodigo, 0, 65535) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'establecer_codigo', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_NUMERO, '{}', 'tnCodigo')))
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        THIS.nCodigo = tnCodigo
    ENDFUNC

    **/
    * Devuelve la descripción del registro.
    *
    * @return string
    */
    FUNCTION obtener_descripcion
        RETURN THIS.cDescripcion
    ENDFUNC

    **/
    * Establece la descripción del registro.
    *
    * @param string tcDescripcion
    * Especifica la descripción del registro.
    *
    * @return boolean
    * true si puede establecer el valor y false en caso contrario.
    */
    FUNCTION establecer_descripcion
        LPARAMETERS tcDescripcion

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'establecer_descripcion', MUY_POCOS_ARGUMENTOS))
            RETURN .F.
        ENDIF

        IF !validar_texto(tcDescripcion, 0, 40) THEN
            THIS.establecer_error(mensaje_error(LOWER(THIS.Name), ;
                'establecer_descripcion', ;
                STRTRAN(PARAM_DEBE_SER_TIPO_TEXTO, '{}', 'tcDescripcion')))
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        THIS.cDescripcion = ALLTRIM(UPPER(tcDescripcion))
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
