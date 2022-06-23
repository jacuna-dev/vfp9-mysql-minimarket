* Copyright (C) 2000-2022 de José Acuña. Reservados todos los derechos.

*/ Misc. teclas */
#DEFINE K_ENTER                 13     && Enter, Ctrl-M
#DEFINE K_INTRO                 CHR(13)
#DEFINE K_RETURN                CHR(13)     && Return, Ctrl-M
#DEFINE K_SPACE                 CHR(32)     && Space bar
#DEFINE K_ESC                   27     && Esc, Ctrl-[

*/ Teclas de edición */
#DEFINE K_INS                   CHR(22)     && Ins, Ctrl-V
#DEFINE K_DEL                   CHR(7)      && Del, Ctrl-G
#DEFINE K_BS                    CHR(127)    && Backspace, Ctrl-H
#DEFINE K_TAB                   9      && Tab, Ctrl-I
#DEFINE K_SH_TAB                CHR(15)     && Shift-Tab

*/ Archivo E/S */
#DEFINE CRLF                    CHR(13) + CHR(10)
#DEFINE CR                      CHR(13)
#DEFINE LF                      CHR(10)
#DEFINE TAB                     CHR(9)

*/ Nombre del archivo ejecutable */
#DEFINE PUNTO_EXE 'minimarket.exe'

*/ Ruta de la base de datos */
#DEFINE RUTA_DATOS 'c:\turtle\aya\integrad.000\'

*/ Mensajes */
#DEFINE BD_TABLA_NO_CREADA            [No se ha podido crear la tabla '{}'.]
#DEFINE BD_CONEXION_NO_ESTABLECIDA    'No se ha establecido la conexión con la base de datos.'
#DEFINE BD_NOMBRE_NO_ESTABLECIDO      'No se ha establecido el nombre de la base de datos.'
#DEFINE BD_CONTROLADOR_NO_ESTABLECIDO 'No se ha establecido el nombre del controlador de la base de datos.'
#DEFINE BD_USUARIO_NO_ESTABLECIDO     'No se ha establecido el usuario de la base de datos.'
#DEFINE BD_CLAVE_NO_ESTABLECIDA       'No se ha establecido la clave de acceso de la base de datos.'
#DEFINE BD_SERVIDOR_NO_ESTABLECIDO    'No se ha establecido el servidor de la base de datos.'
#DEFINE BD_NO_SELECCIONADA            'No se ha podido seleccionar la base de datos.'
#DEFINE BD_NO_CREADA                  'No se ha podido crear la base de datos.'
#DEFINE BD_ERROR_SENTENCIA_SQL        'La sentencia SQL ha fallado.'
#DEFINE ETIQUETA_PROCEDIMIENTO        'Procedimiento'
#DEFINE ETIQUETA_PROGRAMA             'Programa'
#DEFINE ETIQUETA_MENSAJE              'Mensaje'
#DEFINE PARAM_DEBE_SER_TIPO_NUMERO    [El parámetro '{}' debe ser de tipo número.]
#DEFINE PARAM_DEBE_SER_TIPO_TEXTO     [El parámetro '{}' debe ser de tipo texto.]
#DEFINE VAR_DEBE_SER_TIPO_OBJETO      [La variable '{}' debe ser de tipo objeto.]
#DEFINE EXCEPCION_SISTEMA             'Excepción'
#DEFINE ERROR_SISTEMA                 'Error'
#DEFINE MENSAJE_SISTEMA               'Mensaje del sistema'
#DEFINE CONFIRMAR_ACCION              'Confirmar acción'
#DEFINE BANDERA_VALIDA                'Bandera: Debe ser 1 ó 2.'
#DEFINE MUY_POCOS_ARGUMENTOS          'Muy pocos argumentos.'
#DEFINE NO_ES_VALIDO                  'No es válido.'
#DEFINE NO_ES_VALIDA                  'No es válida.'
#DEFINE NO_SE_PUEDE_VALIDAR           'No se puede validar el registro actual, porque:' + CR + CR
#DEFINE ETIQUETA_CODIGO               'Código'
#DEFINE ETIQUETA_DESCRIPCION          'Descripción'
#DEFINE DEBE_SER_IGUAL_A_CERO         'Debe ser igual a cero.'
#DEFINE YA_EXISTE                     'Ya existe.'
#DEFINE DEBE_SER_MAYOR_QUE_CERO       'Debe ser mayor que cero.'
#DEFINE NO_EXISTE                     'No existe.'
#DEFINE ENTIDAD_NO_CREADA             'No se pudo crear el objeto entidad.'
#DEFINE REGISTRO_GUARDADO             'Registro guardado correctamente.'
#DEFINE NO_NADA_QUE_REPORTAR          'No hay nada que reportar.'
#DEFINE REGISTRO_ELIMINADO            'Registro eliminado correctamente.'
#DEFINE ELIMINAR_REGISTRO             '¿Desea eliminar el registro seleccionado?'
#DEFINE DEBE_SELECCIONAR_REGISTRO     'Debe seleccionar un registro.'

#DEFINE ACCESO_DENEGADO            'Acceso denegado.'
#DEFINE BANDERA_NO_VALIDA          'Bandera no es válida.'
#DEFINE DEBE_ESTAR_EN_BLANCO       'Debe estar en blanco.'
#DEFINE DEBE_SER_TIPO_FECHA        'Debe ser de tipo fecha.'
#DEFINE DEBE_SER_TIPO_FECHA_HORA   'Debe ser de tipo fecha y hora.'
#DEFINE DEBE_SER_TIPO_LOGICO       'Debe ser de tipo lógico.'
#DEFINE ERROR_CONEXION             'Error de conectividad.'
#DEFINE ETIQUETA_ACTUALIZADO       'Actualizado en'
#DEFINE ETIQUETA_CREADO            'Creado en'
#DEFINE ETIQUETA_VIGENTE           'Vigente'
#DEFINE MODELO_NO_VALIDO           'Modelo no válido.'
#DEFINE NO_TIENE_PERMISO_AGREGAR   'No tiene permiso para agregar registros.'
#DEFINE NO_TIENE_PERMISO_BORRAR    'No tiene permiso para borrar registros.'
#DEFINE NO_TIENE_PERMISO_MODIFICAR 'No tiene permiso para modificar registros.'
#DEFINE OBJETO_NO_CREADO           'No se puede crear el objeto.'
#DEFINE PARAM_DEBE_SER_TIPO_FECHA  [El parámetro '{}' debe ser de tipo fecha.]
#DEFINE PARAM_DEBE_SER_TIPO_OBJETO [El parámetro '{}' debe ser de tipo objeto.]
#DEFINE PARAM_NO_DEBE_ESTAR_VACIO  [El parámetro '{}' no debe estar vacío.]
#DEFINE PROP_DEBE_SER_TIPO_TEXTO   [La propiedad '{}' debe ser de tipo texto.]
#DEFINE REGISTRO_ACTUALIZADO       'Registro actualizado exitosamente.'
#DEFINE REGISTRO_ALMACENADO        'Registro almacenado correctamente.'
#DEFINE REGISTRO_BORRADO           'Registro borrado exitosamente.'
#DEFINE REGISTRO_RELACIONADO       'Registro figura en otros archivos, no se puede borrar.'
#DEFINE USUARIO_BLOQUEADO          'Usuario bloqueado.'
#DEFINE USUARIO_NO_VALIDO          'Nombre de usuario o contraseña incorrectos.'
#DEFINE VALIDADOR_NO_CREADO        'Validador no creado.'
#DEFINE VALIDADOR_NO_ESTABLECIDO   'Validador no establecido.'
#DEFINE VAR_DEBE_SER_TIPO_TEXTO    [La variable '{}' debe ser de tipo texto.]
#DEFINE VERIFICANDO_IR             'Verificando integridad referencial...'

*/ SQL */
#DEFINE SELECT_BASE 'SELECT codigo, nombre, vigente FROM '
