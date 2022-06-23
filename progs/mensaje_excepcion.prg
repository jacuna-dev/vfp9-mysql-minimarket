**/
* mensaje_excepcion() function
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

**/
* Devuelve una cadena con la descripción completa de la excepción.
*
* @param object toExcepcion
* Especifica el objeto excepción.
*
* @return string|boolean
* string con la descripción completa de la excepción y false si se produce un
* error.
*/
#INCLUDE 'constantes.h'

FUNCTION mensaje_excepcion
    LPARAMETERS toExcepcion

    * inicio { validaciones del parámetro }
    IF PARAMETERS() < 1 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(toExcepcion) != 'O' THEN
        RETURN .F.
    ENDIF

    IF LOWER(toExcepcion.Class) != 'exception' THEN
        RETURN .F.
    ENDIF
    * fin { validaciones del parámetro }

    LOCAL lcMensaje

    lcMensaje = 'ErrorNo: ' + ALLTRIM(STR(toExcepcion.ErrorNo)) + CR + ;
        'LineNo: ' + ALLTRIM(STR(toExcepcion.LineNo)) + CR + ;
        'Message: ' + toExcepcion.Message + CR + ;
        'Procedure: ' + toExcepcion.Procedure + CR + ;
        'Details: ' + toExcepcion.Details + CR + ;
        'StackLevel: ' + ALLTRIM(STR(toExcepcion.StackLevel)) + CR + ;
        'LineContents: ' + toExcepcion.LineContents + CR + ;
        'UserValue: ' + toExcepcion.UserValue

    RETURN lcMensaje
ENDFUNC
