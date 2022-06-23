**/
* validador_base_actualizar class definition
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

DEFINE CLASS validador_base_actualizar AS validador_base

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
    * @Override
    FUNCTION validar_codigo
        LPARAMETERS tnCodigo

        * inicio { validaciones del par�metro }
        IF PARAMETERS() < 1 THEN
            THIS.cErrorCodigo = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validador_base::validar_codigo(tnCodigo) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del par�metro }

        IF THIS.nCodigo <= 0 THEN
            THIS.cErrorCodigo = DEBE_SER_MAYOR_QUE_CERO
            RETURN .F.
        ENDIF

        IF !THIS.oDatos.codigo_existe(THIS.nCodigo) THEN
            THIS.cErrorCodigo = NO_EXISTE
            RETURN .F.
        ENDIF
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
    * @Override
    FUNCTION validar_descripcion
        LPARAMETERS tcDescripcion, tnCodigo

        * inicio { validaciones de par�metros }
        IF PARAMETERS() < 2 THEN
            THIS.cErrorDescripcion = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validador_base::validar_descripcion(tcDescripcion, tnCodigo) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones de par�metros }

        LOCAL loEntidad
        loEntidad = THIS.oDatos.obtener_por_descripcion(THIS.cDescripcion)

        IF VARTYPE(loEntidad) == 'O' THEN
            IF loEntidad.obtener_codigo() != tnCodigo THEN
                THIS.cErrorDescripcion = YA_EXISTE
                RETURN .F.
            ENDIF
        ENDIF
    ENDFUNC

ENDDEFINE
