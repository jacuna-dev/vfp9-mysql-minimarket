**/
* crear_objeto() function
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
* Crea una instancia de una clase.
*
* @param string tcClase
* Especifica el nombre de la clase.
*
* @return boolean
* true si puede crear la instancia y false en caso contrario.
*/
FUNCTION crear_objeto
    LPARAMETERS tcClase

    * inicio { validaciones del parámetro }
    IF PARAMETERS() < 1 THEN
        RETURN .F.
    ENDIF

    IF VARTYPE(tcClase) != 'C' OR EMPTY(tcClase) THEN
        RETURN .F.
    ENDIF
    * fin { validaciones del parámetro }

    LOCAL loObjeto, loExcepcion

    TRY
        loObjeto = CREATEOBJECT(tcClase)
    CATCH TO loExcepcion
        loObjeto = .F.
    ENDTRY

    RETURN loObjeto
ENDFUNC
