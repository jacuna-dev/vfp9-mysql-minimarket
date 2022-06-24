**/
* validador_base class definition
*
* Copyright (C) 2000-2022 Jos� Acu�a <jacuna.dev@gmail.com>
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

DEFINE CLASS validador_base AS Custom

    * Propiedades.
    PROTECTED cTabla
    PROTECTED oDatos

    PROTECTED nCodigo
    PROTECTED cDescripcion

    PROTECTED cErrorCodigo
    PROTECTED cErrorDescripcion

    * Inicializaci�n de propiedades.
    cTabla = ''
    oDatos = .F.

    nCodigo = 0
    cDescripcion = ''

    cErrorCodigo = ''
    cErrorDescripcion = ''

    **/
    * Constructor.
    *
    * @param object toEntidad
    * Objeto entidad a validar.
    *
    * @return boolean
    * true si puede crear la instancia y false en caso contrario.
    */
    FUNCTION Init
        LPARAMETERS toEntidad

        IF VARTYPE(THIS.cTabla) != 'C' OR EMPTY(THIS.cTabla) THEN
            THIS.cTabla = LOWER(STRTRAN(STRTRAN(STRTRAN( ;
                THIS.Name, 'validador_', ''), '_nuevo'), '_actualizar'))
        ENDIF

        THIS.oDatos = crear_objeto('d_' + THIS.cTabla)

        IF VARTYPE(THIS.oDatos) != 'O' ;
                OR LOWER(THIS.oDatos.ParentClass) != 'datos' THEN
            RETURN .F.
        ENDIF

        IF PCOUNT() == 1 THEN
            IF !THIS.establecer_valores(toEntidad) THEN
                RETURN .F.
            ENDIF
        ENDIF
    ENDFUNC

    **/
    * Establece los valores del objeto entidad.
    *
    * @param object toEntidad
    * Objeto entidad.
    *
    * @return boolean
    * true si tiene �xito y false en caso contrario.
    */
    PROTECTED FUNCTION establecer_valores
        LPARAMETERS toEntidad

        * inicio { validaciones del par�metro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(toEntidad) != 'O' ;
                OR LOWER(toEntidad.ParentClass) != 'entidad' THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del par�metro }

        LOCAL llExito, loExcepcion

        TRY
            WITH THIS
                .nCodigo = toEntidad.obtener_codigo()
                .cDescripcion = toEntidad.obtener_descripcion()
            ENDWITH

            llExito = .T.
        CATCH TO loExcepcion
            llExito = .F.
        ENDTRY

        RETURN llExito
    ENDFUNC

    **/
    * Devuelve un objeto entidad con los datos de todas las propiedades.
    *
    * @return object
    * object en caso de �xito y false en caso contrario.
    */
    FUNCTION obtener_entidad
        LOCAL loEntidad, loExcepcion

        IF THIS.es_valido() THEN
            TRY
                loEntidad = CREATEOBJECT('e_' + THIS.cTabla, ;
                    THIS.nCodigo, ;
                    THIS.cDescripcion ;
                )
            CATCH TO loExcepcion
            ENDTRY
        ENDIF

        RETURN loEntidad
    ENDFUNC

    **/
    * Determina si todas las propiedades son v�lidas.
    *
    * @return boolean
    * true si todas las propiedades son v�lidas y false en caso contrario.
    */
    FUNCTION es_valido
        IF THIS.validar_codigo(THIS.nCodigo) ;
                AND THIS.validar_descripcion(THIS.cDescripcion, ;
                THIS.nCodigo) THEN
            RETURN .T.
        ENDIF

        RETURN .F.
    ENDFUNC

    **/
    * Valida el campo 'codigo'.
    *
    * @field
    * codigo N(5) not null unique
    *
    * @param integer tnCodigo
    * C�digo a validar.
    *
    * @return boolean
    * true si es v�lido y false en caso contrario.
    */
    FUNCTION validar_codigo
        LPARAMETERS tnCodigo

        * inicio { validaciones del par�metro }
        IF PARAMETERS() < 1 THEN
            THIS.cErrorCodigo = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validar_numero(tnCodigo, 0, 65535) THEN
            THIS.cErrorCodigo = NO_ES_VALIDO
            RETURN .F.
        ENDIF
        * fin { validaciones del par�metro }

        WITH THIS
            .nCodigo = tnCodigo
            .cErrorCodigo = ''
        ENDWITH
    ENDFUNC

    **/
    * Valida el campo 'descripcion'.
    *
    * @field
    * descripcion C(40) not null unique
    *
    * @param string tcDescripcion
    * Descripci�n a validar.
    *
    * @param integer tnCodigo
    * C�digo a validar.
    *
    * @return boolean
    * true si es v�lido y false en caso contrario.
    */
    FUNCTION validar_descripcion
        LPARAMETERS tcDescripcion, tnCodigo

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 2 THEN
            THIS.cErrorDescripcion = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validar_texto(tcDescripcion, , 40) THEN
            THIS.cErrorDescripcion = NO_ES_VALIDA
            RETURN .F.
        ENDIF

        IF !validar_numero(tnCodigo, 0, 65535) THEN
            THIS.cErrorDescripcion = 'C�digo ' + LOWER(NO_ES_VALIDO)
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        WITH THIS
            .cDescripcion = ALLTRIM(UPPER(tcDescripcion))
            .cErrorDescripcion = ''
        ENDWITH
    ENDFUNC

    **/
    * Devuelve el mensaje de error de la propiedad 'nCodigo'.
    *
    * @return string
    */
    FUNCTION obtener_error_codigo
        RETURN THIS.cErrorCodigo
    ENDFUNC

    **/
    * Devuelve el mensaje de error de la propiedad 'cDescripcion'.
    *
    * @return string
    */
    FUNCTION obtener_error_descripcion
        RETURN THIS.cErrorDescripcion
    ENDFUNC

    **/
    * Devuelve todos los mensajes de error.
    *
    * @return string
    * empty string si no hay ning�n error y non-empty string en caso contrario.
    */
    FUNCTION obtener_error
        LOCAL lcError
        lcError = ''

        IF !EMPTY(THIS.cErrorCodigo) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CR
            ENDIF
            lcError = lcError + ETIQUETA_CODIGO + ': ' + THIS.cErrorCodigo
        ENDIF

        IF !EMPTY(THIS.cErrorDescripcion) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CR
            ENDIF
            lcError = lcError + ETIQUETA_DESCRIPCION + ': ' + ;
                THIS.cErrorDescripcion
        ENDIF

        IF !EMPTY(lcError) THEN
            lcError = NO_SE_PUEDE_VALIDAR + lcError
        ENDIF

        RETURN lcError
    ENDFUNC

ENDDEFINE
