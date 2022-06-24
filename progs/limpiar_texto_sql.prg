**/
* limpiar_texto_sql() function
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

**/
* Devuelve una cadena sin caracteres especiales para ser utilizada en una
* sentencia SQL.
*
* @param string tcTexto
* Especifica la cadena a tratar.
*
* @return string|boolean
* string sin caracteres especiales y false si se produce un error.
*/
FUNCTION limpiar_texto_sql
    LPARAMETERS tcTexto

    * inicio { validación del parámetro }
    IF !validar_texto(tcTexto) THEN
        RETURN .F.
    ENDIF
    * fin { validación del parámetro }

    LOCAL lcTexto
    lcTexto = ALLTRIM(UPPER(tcTexto))
    lcTexto = STRTRAN(lcTexto, '[', '')
    lcTexto = STRTRAN(lcTexto, ']', '')
    lcTexto = STRTRAN(lcTexto, '*', '%')

    DO WHILE ATC('%%', lcTexto) > 0
        lcTexto = STRTRAN(lcTexto, '%%', '%')
    ENDDO

    RETURN lcTexto
ENDFUNC
