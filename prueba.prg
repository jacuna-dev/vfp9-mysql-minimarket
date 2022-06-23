CLEAR
CLEAR ALL
CLOSE ALL

#INCLUDE 'constantes.h'

PUBLIC goConexion

DO biblioteca.prg

goConexion = CREATEOBJECT('conexion')

loCategorias = CREATEOBJECT('n_categorias')

? locategorias.descripcion_existe('bebidas44')
? locategorias.codigo_existe(4)
loEntidad = LOCATEGORIAS.obtener_por_codigo(4)
MESSAGEBOX(LOCATEGORIAS.OBTENER_ERROR())
? loEntidad.obtener_codigo()
? loEntidad.obtener_descripcion()
? VARTYPE(loEntidad)

loEntidad = LOCATEGORIAS.obtener_por_descripcion('bebidas4    ')
MESSAGEBOX(LOCATEGORIAS.OBTENER_ERROR())
? loEntidad.obtener_codigo()
? loEntidad.obtener_descripcion()
? VARTYPE(loEntidad)



*!*    IF VARTYPE(loCategorias) == 'O' THEN
*!*        ? 'loCategorias'
*!*        loCategorias.listado('B', 'pepe1234')
*!*        IF USED('pepe1234') THEN
*!*           SELECT pepe1234
*!*           BROWSE
*!*        ELSE
*!*            MESSAGEBOX(LOCATEGORIAS.obtener_error())
*!*       ENDIF
*!*       
*!*    ENDIF

*!*    SQLEXEC(goConexion.obtener_conexion(), 'SELECT * FROM categorias', 'kkk')
*!*    SELECT kkk
*!*    browse

*!*    loNCategorias = CREATEOBJECT('n_categorias')

*!*    ? loNCategorias.ParentClass

*            MESSAGEBOX(BANDERA_VALIDA, 0+16, ERROR_SISTEMA)
DO FORM frm_categorias

*goConexion = .NULL.