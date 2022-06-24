**/
* validador_base_nuevo class definition
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

DEFINE CLASS validador_base_nuevo AS validador_base

    **/
    * Valida el campo 'codigo'.
    *
    * @field
    * codigo N(5) not null unique
    *
    * @param integer tnCodigo
    * Código a validar.
    *
    * @return boolean
    * true si es válido y false en caso contrario.
    */
    * @Override
    FUNCTION validar_codigo
        LPARAMETERS tnCodigo

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            THIS.cErrorCodigo = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validador_base::validar_codigo(tnCodigo) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        IF THIS.nCodigo != 0 THEN
            THIS.cErrorCodigo = DEBE_SER_IGUAL_A_CERO
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
    * Descripción a validar.
    *
    * @param integer tnCodigo
    * Código a validar.
    *
    * @return boolean
    * true si es válido y false en caso contrario.
    */
    * @Override
    FUNCTION validar_descripcion
        LPARAMETERS tcDescripcion, tnCodigo

        * inicio { validaciones de parámetros }
        IF PARAMETERS() < 2 THEN
            THIS.cErrorDescripcion = MUY_POCOS_ARGUMENTOS
            RETURN .F.
        ENDIF

        IF !validador_base::validar_descripcion(tcDescripcion, tnCodigo) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones de parámetros }

        IF THIS.oDatos.descripcion_existe(THIS.cDescripcion) THEN
            THIS.cErrorDescripcion = YA_EXISTE
            RETURN .F.
        ENDIF
    ENDFUNC

ENDDEFINE
