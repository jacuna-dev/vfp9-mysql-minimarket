**/
* validar_texto() function
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
* Determina si el tipo de dato de una expresión es cadena (character).
*
* Determina si el valor de una expresión está inclusive entre el
* valores de dos expresiones del mismo tipo.
*
* @param string tcTexto
* Especifica la expresión a ser evaluada.
*
* @param integer tnMinimo
* Especifica la longitud mínima que debe tener la expresión.
*
* @param integer tnMaximo
* Especifica la longitud máxima que puede tener la expresión.
*
* @return boolean
* true si la expresión es válida y false en caso contrario.
*/
FUNCTION validar_texto
    LPARAMETERS tcTexto, tnMinimo, tnMaximo

    * inicio { validaciones de parámetros }
    IF PARAMETERS() < 1 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tcTexto) != 'C' THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tnMinimo) != 'N' THEN
        tnMinimo = 1
    ENDIF

    IF VARTYPE(tnMaximo) != 'N' THEN
        tnMaximo = 30
    ENDIF

    IF tnMinimo < 0 THEN
        RETURN .F.
    ENDIF

    IF tnMaximo > 254 THEN
        RETURN .F.
    ENDIF
    * fin { validaciones de parámetros }

    IF tnMinimo > 0 THEN
        IF EMPTY(tcTexto) THEN
            RETURN .F.
        ENDIF
    ENDIF

    IF !BETWEEN(LEN(tcTexto), tnMinimo, tnMaximo) THEN
        RETURN .F.
    ENDIF
ENDFUNC
