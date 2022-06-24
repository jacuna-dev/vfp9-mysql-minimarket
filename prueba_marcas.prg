CLEAR
CLEAR ALL
CLOSE ALL

#INCLUDE 'constantes.h'

PUBLIC goConexion

DO biblioteca.prg

goConexion = CREATEOBJECT('conexion')

lomarcas = CREATEOBJECT('n_marcas')

? lomarcas.descripcion_existe('bebidas44')
? lomarcas.codigo_existe(4)
loEntidad = LOmarcas.obtener_por_codigo(4)
MESSAGEBOX(LOmarcas.OBTENER_ERROR())
? loEntidad.obtener_codigo()
? loEntidad.obtener_descripcion()
? VARTYPE(loEntidad)

loEntidad = LOmarcas.obtener_por_descripcion('bebidas4    ')
MESSAGEBOX(LOmarcas.OBTENER_ERROR())
? loEntidad.obtener_codigo()
? loEntidad.obtener_descripcion()
? VARTYPE(loEntidad)



*!*    IF VARTYPE(lomarcas) == 'O' THEN
*!*        ? 'lomarcas'
*!*        lomarcas.listado('B', 'pepe1234')
*!*        IF USED('pepe1234') THEN
*!*           SELECT pepe1234
*!*           BROWSE
*!*        ELSE
*!*            MESSAGEBOX(LOmarcas.obtener_error())
*!*       ENDIF
*!*       
*!*    ENDIF

*!*    SQLEXEC(goConexion.obtener_conexion(), 'SELECT * FROM marcas', 'kkk')
*!*    SELECT kkk
*!*    browse

*!*    loNmarcas = CREATEOBJECT('n_marcas')

*!*    ? loNmarcas.ParentClass

*            MESSAGEBOX(BANDERA_VALIDA, 0+16, ERROR_SISTEMA)
DO FORM frm_marcas

*goConexion = .NULL.