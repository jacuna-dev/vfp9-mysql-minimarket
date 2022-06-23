**/
* mensaje_error() function
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
* Devuelve una cadena con la descripción completa del error.
*
* @param string tcPrograma
* Especifica el nombre del programa.
*
* @param string tcProcedimiento
* Especifica el nombre del procedimiento.
*
* @param string tcMensaje
* Especifica el mensaje de error.
*
* @return string|boolean
* string con la descripción completa de error de sistema y false si se produce
* un error.
*/
#INCLUDE 'constantes.h'

FUNCTION mensaje_error
    LPARAMETERS tcPrograma, tcProcedimiento, tcMensaje

    * inicio { validaciones de parámetros }
    IF PARAMETERS() < 3 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tcPrograma) != 'C' OR EMPTY(tcPrograma) THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tcProcedimiento) != 'C' OR EMPTY(tcProcedimiento) THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tcMensaje) != 'C' OR EMPTY(tcMensaje) THEN
        RETURN .F.
    ENDIF
    * fin { validaciones de parámetros }

    LOCAL lcMensaje

    lcMensaje = ETIQUETA_PROGRAMA + ': ' + LOWER(tcPrograma) + CR + ;
        ETIQUETA_PROCEDIMIENTO + ': ' + LOWER(tcProcedimiento) + CR + ;
        ETIQUETA_MENSAJE + ': ' + tcMensaje

    RETURN lcMensaje
ENDFUNC
