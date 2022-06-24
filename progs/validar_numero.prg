**/
* validar_numero() function
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
* Determina si el tipo de dato de una expresión es numérico (numeric).
*
* Determina si el valor de una expresión está inclusive entre el
* valores de dos expresiones del mismo tipo.
*
* @param integer tnNumero
* Especifica la expresión a ser evaluada.
*
* @param integer tnMinimo
* Especifica el valor mínimo que debe tener la expresión.
*
* @param integer tnMaximo
* Especifica el valor máximo que puede tener la expresión.
*
* @return boolean
* true si la expresión es válida y false en caso contrario.
*/
FUNCTION validar_numero
    LPARAMETERS tnNumero, tnMinimo, tnMaximo

    * inicio { validaciones de parámetros }
    IF PARAMETERS() < 1 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tnNumero) != 'N' THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tnMinimo) != 'N' THEN
        tnMinimo = 1
    ENDIF

    IF VARTYPE(tnMaximo) != 'N' THEN
        tnMaximo = 9999
    ENDIF

    IF tnMinimo < 0 THEN
        RETURN .F.
    ENDIF

    IF tnMaximo > 2147483647 THEN
        RETURN .F.
    ENDIF
    * fin { validaciones de parámetros }

    IF !BETWEEN(tnNumero, tnMinimo, tnMaximo) THEN
        RETURN .F.
    ENDIF
ENDFUNC
