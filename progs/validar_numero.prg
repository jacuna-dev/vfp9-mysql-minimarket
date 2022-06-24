**/
* validar_numero() function
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

**/
* Determina si el tipo de dato de una expresi�n es num�rico (numeric).
*
* Determina si el valor de una expresi�n est� inclusive entre el
* valores de dos expresiones del mismo tipo.
*
* @param integer tnNumero
* Especifica la expresi�n a ser evaluada.
*
* @param integer tnMinimo
* Especifica el valor m�nimo que debe tener la expresi�n.
*
* @param integer tnMaximo
* Especifica el valor m�ximo que puede tener la expresi�n.
*
* @return boolean
* true si la expresi�n es v�lida y false en caso contrario.
*/
FUNCTION validar_numero
    LPARAMETERS tnNumero, tnMinimo, tnMaximo

    * inicio { validaciones de par�metros }
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
    * fin { validaciones de par�metros }

    IF !BETWEEN(tnNumero, tnMinimo, tnMaximo) THEN
        RETURN .F.
    ENDIF
ENDFUNC
