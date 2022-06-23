**/
* crear_cursor() function
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
* Crea una tabla temporal que existe hasta que se cierra.
*
* @param string tcTabla
* Especifica el nombre de la tabla en la que se basará la estructura.
*
* @param string tcCursor
* Especifica el nombre del cursor de 8 caracteres de longitud.
*
* @return boolean
* true si puede crear el cursor y false en caso contrario.
*/
FUNCTION crear_cursor
    LPARAMETERS tcTabla, tcCursor

    * inicio { validación de parámetros }
    IF !validar_texto(tcTabla, 1, 16) THEN
        RETURN .F.
    ENDIF

    IF !validar_texto(tcCursor, 8, 8) THEN
        RETURN .F.
    ENDIF
    * fin { validación de parámetros }

    DO CASE
    CASE tcTabla == 'base'
        base(tcCursor)
    CASE tcTabla == 'categorias'
        categorias(tcCursor)
    CASE tcTabla == 'marcas'
        marcas(tcCursor)
    CASE tcTabla == 'productos'
        productos(tcCursor)
    CASE tcTabla == 'unidades_medidas'
        unidades_medidas(tcCursor)
    OTHERWISE
        RETURN .F.
    ENDCASE
ENDFUNC

**/
* Crea un cursor con la estructura de la tabla base.
*
* @param string tcCursor
* Especifica el nombre del cursor.
*
* @return boolean true (default)
*/
FUNCTION base
    LPARAMETERS tcCursor

    CREATE CURSOR (tcCursor) ( ;
        codigo N(5), ;
        descripcion C(40) ;
    )
ENDFUNC

**/
* Crea un cursor con la estructura de la tabla 'categorias'.
*
* @param string tcCursor
* Especifica el nombre del cursor.
*
* @return boolean true (default)
*/
FUNCTION categorias
    LPARAMETERS tcCursor
    base(tcCursor)
ENDFUNC

**/
* Crea un cursor con la estructura de la tabla 'marcas'.
*
* @param string tcCursor
* Especifica el nombre del cursor.
*
* @return boolean true (default)
*/
FUNCTION marcas
    LPARAMETERS tcCursor
    base(tcCursor)
ENDFUNC

**/
* Crea un cursor con la estructura de la tabla 'productos'.
*
* @param string tcCursor
* Especifica el nombre del cursor.
*
* @return boolean true (default)
*/
FUNCTION productos
    LPARAMETERS tcCursor

    CREATE CURSOR (tcCursor) ( ;
        codigo N(5), ;
        descripcion C(100), ;
        marca N(5), ;
        unidad_medida N(5), ;
        categoria N(5), ;
        stock_min N(10,2), ;
        stock_max N(10,2) ;
    )
ENDFUNC

**/
* Crea un cursor con la estructura de la tabla 'unidades_medidas'.
*
* @param string tcCursor
* Especifica el nombre del cursor.
*
* @return boolean true (default)
*/
FUNCTION unidades_medidas
    LPARAMETERS tcCursor

    CREATE CURSOR (tcCursor) ( ;
        codigo N(5), ;
        descripcion C(40), ;
        abreviatura C(5) ;
    )
ENDFUNC
