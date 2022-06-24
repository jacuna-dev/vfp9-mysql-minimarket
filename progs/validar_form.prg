**/
* validar_form() function
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
* Determina si un objeto es de tipo formulario (form).
*
* @param object toForm
* Especifica el objeto a ser evaluado.
*
* @return boolean
* true si es de tipo formulario y false en caso contrario.
*/
FUNCTION validar_form
    LPARAMETERS toForm

  * inicio { validaciones del parámetro }
    IF PARAMETERS() < 1 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(toForm) != 'O' THEN
        RETURN .F.
    ENDIF
    * fin { validaciones del parámetro }

    IF LOWER(toForm.BaseClass) != 'form' THEN
        RETURN .F.
    ENDIF
ENDFUNC
