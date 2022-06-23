**/
* createmp() function
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
* Devuelve un nombre de archivo legal que se puede usar para crear archivos
* temporales.
*
* @return string
* Nombre de archivo único de 8 caracteres que comienza con 'tm' seguido de una
* combinación de letras y números.
*/
FUNCTION createmp
    LOCAL lcNombreArchivo

    DO WHILE .T.
        lcNombreArchivo = 'tm' + RIGHT(SYS(2015), 6)
        IF !FILE(lcNombreArchivo + '.dbf') ;
                AND !FILE(lcNombreArchivo + '.cdx') ;
                AND !FILE(lcNombreArchivo + '.txt') ;
                AND !FILE(lcNombreArchivo + '.rtf') ;
                AND !FILE(lcNombreArchivo + '.doc') ;
                AND !FILE(lcNombreArchivo + '.xls') ;
                AND !FILE(lcNombreArchivo + '.docx') ;
                AND !FILE(lcNombreArchivo + '.xlsx') ;
                AND !FILE(lcNombreArchivo + '.pdf') THEN
            EXIT
        ENDIF
    ENDDO

    RETURN lcNombreArchivo
ENDFUNC
