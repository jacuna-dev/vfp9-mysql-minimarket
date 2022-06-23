**/
* excepcion_sql() function
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
* Devuelve una cadena con la descripción del error SQL.
*
* @param array taErrorArray
* Especifica el arreglo con los datos del error.
*
* @return string
*/
FUNCTION excepcion_sql
    LPARAMETERS taErrorArray

    LOCAL lcMensaje, lnInicio, lnLongitud
    lcMensaje = 'Excepción SQL desconocida.'

    * inicio { validaciones del parámetro }
    IF PARAMETERS() < 1 THEN
        RETURN lcMensaje
    ENDIF

    IF TYPE('taErrorArray', 1) != 'A' THEN
        RETURN lcMensaje
    ENDIF
    * fin { validaciones del parámetro }

    lcMensaje = taErrorArray[2]

    IF taErrorArray[4] == 'S1000' THEN
        IF OCCURS('|', taErrorArray[3]) == 2 THEN
            lnInicio = AT('|', taErrorArray[3]) + 1
            lnLongitud = AT('|', taErrorArray[3], 2) - lnInicio
            lcMensaje = SUBSTR(taErrorArray[3], lnInicio, lnLongitud)
        ENDIF
    ENDIF

    RETURN lcMensaje
ENDFUNC
