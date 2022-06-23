**/
* frm_mantener class definition
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
#INCLUDE 'constantes.h'

DEFINE CLASS frm_mantener AS Custom

    * Propiedades.
    PROTECTED cResultado
    PROTECTED nBandera
    PROTECTED nCodigo
    PROTECTED oForm
    PROTECTED oNegocio

    **/
    * Constructor.
    *
    * @param object toForm
    * Especifica el objeto formulario.
    *
    * @return boolean
    * true si puede crear la instancia y false en caso contrario.
    */
    FUNCTION Init
        LPARAMETERS toForm

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF !validar_form(toForm) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        WITH THIS
            .cResultado = createmp()
            .oForm = toForm
            .oNegocio = crear_objeto('n_' + LOWER(SUBSTR(THIS.Name, 5)))

            .establecer_bandera(0)
            .establecer_titulo()
            .formatear_cuadricula()
        ENDWITH

        IF !crear_cursor(LOWER(SUBSTR(THIS.Name, 5)), THIS.cResultado) THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.oNegocio) != 'O' ;
                OR LOWER(THIS.oNegocio.ParentClass) != 'negocio' THEN
            RETURN .F.
        ENDIF

        WITH THIS.oForm.pgfPrincipal
            .page1.txtBuscar.SetFocus()
            .page2.cmdGuardar.Default = .T.
        ENDWITH

        BINDEVENT(THIS.oForm.cmdNuevo, 'Click', THIS, 'nuevo')
        BINDEVENT(THIS.oForm.cmdActualizar, 'Click', THIS, 'actualizar')
        BINDEVENT(THIS.oForm.cmdEliminar, 'Click', THIS, 'eliminar')
        BINDEVENT(THIS.oForm.cmdReporte, 'Click', THIS, 'reporte')

        BINDEVENT(THIS.oForm.pgfPrincipal.page1.grdResultado.grcCodigo.txtCodigo, ;
            'DblClick', THIS, 'seleccionar_registro')
        BINDEVENT(THIS.oForm.pgfPrincipal.page1.grdResultado.grcDescripcion.txtDescripcion, ;
            'DblClick', THIS, 'seleccionar_registro')

        BINDEVENT(THIS.oForm.pgfPrincipal.page2.txtDescripcion, ;
            'InteractiveChange', THIS, 'estado_boton_guardar')
        BINDEVENT(THIS.oForm.pgfPrincipal.page2.txtDescripcion, ;
            'ProgrammaticChange', THIS, 'estado_boton_guardar')
        BINDEVENT(THIS.oForm.pgfPrincipal.page1.cmdBuscar, 'Click', THIS, ;
            'listado')
        BINDEVENT(THIS.oForm.pgfPrincipal.page2.cmdGuardar, 'Click', THIS, ;
            'guardar')
        BINDEVENT(THIS.oForm.pgfPrincipal.page2.cmdCancelar, 'Click', THIS, ;
            'cancelar')
    ENDFUNC

    **/
    * Realiza una búsqueda por código o descripción.
    *
    * @return boolean true (default)
    */
    FUNCTION listado
        LOCAL lcCursor, lcDescripcion
        lcCursor = createmp()
        lcDescripcion = ALLTRIM(UPPER( ;
            THIS.oForm.pgfPrincipal.page1.txtBuscar.Value))

        IF EMPTY(lcDescripcion) THEN
            lcDescripcion = '*'
        ENDIF

        IF !THIS.oNegocio.listado(lcDescripcion, lcCursor) THEN
            IF !EMPTY(THIS.oNegocio.obtener_error()) THEN
                MESSAGEBOX(THIS.oNegocio.obtener_error(), 0+16, MENSAJE_SISTEMA)
            ENDIF
        ENDIF

        * Vacía el cursor de resultados de la búsqueda.
        SELECT (THIS.cResultado)
        ZAP

        * Copia los registros del cursor temporal al cursor de resultados de
        * la búsqueda.
        IF USED(lcCursor) THEN
            SELECT (lcCursor)
            SCAN ALL
                SCATTER MEMVAR MEMO
                INSERT INTO (THIS.cResultado) FROM MEMVAR
            ENDSCAN

            SELECT (lcCursor)
            USE
        ENDIF

        SELECT (THIS.cResultado)
        GOTO TOP
        THIS.formatear_cuadricula()

        IF RECCOUNT() > 0 THEN
            IF TYPE('_SCREEN.ActiveForm.ActiveControl') == 'O' THEN
                IF LOWER(_SCREEN.ActiveForm.ActiveControl.Name) == ;
                        LOWER('cmdBuscar') THEN
                    KEYBOARD '{DNARROW}'
                ENDIF
            ENDIF
        ENDIF
    ENDFUNC

    **/
    * Guarda una entidad en la base de datos.
    *
    * @return boolean true (default)
    */
    FUNCTION guardar
        * inicio { validaciones }
        IF !validar_numero(THIS.nBandera, 1, 2) THEN
            MESSAGEBOX(BANDERA_VALIDA, 0+16, ERROR_SISTEMA)
            RETURN .F.
        ENDIF
        * fin { validaciones }

        LOCAL loEntidad
        loEntidad = THIS.obtener_entidad()

        IF VARTYPE(loEntidad) == 'O' ;
                AND LOWER(loEntidad.ParentClass) == 'entidades' THEN
            IF THIS.oNegocio.guardar(THIS.nBandera, loEntidad) THEN
                WAIT REGISTRO_GUARDADO WINDOW NOWAIT

                WITH THIS
                    .establecer_bandera(0)
                    .oForm.pgfPrincipal.page1.txtBuscar.Value = ;
                        loEntidad.obtener_descripcion()
                    .oForm.pgfPrincipal.page1.cmdBuscar.Click()
                ENDWITH
            ELSE
                IF !EMPTY(THIS.oNegocio.obtener_error()) THEN
                    MESSAGEBOX(THIS.oNegocio.obtener_error(), 0+48, ;
                        MENSAJE_SISTEMA)
                    THIS.oForm.pgfPrincipal.page2.txtDescripcion.SetFocus()
                ENDIF
            ENDIF
        ELSE
            MESSAGEBOX(ENTIDAD_NO_CREADA, 0+16, ERROR_SISTEMA)
        ENDIF
    ENDFUNC

    **/
    * Elimina un registro de la base de datos.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION eliminar
        LOCAL lnRespuesta

        SELECT (THIS.cResultado)
        IF codigo > 0 THEN
            lnRespuesta = MESSAGEBOX(ELIMINAR_REGISTRO, 4+32+256, ;
                CONFIRMAR_ACCION)

            IF lnRespuesta == 6 THEN
                IF THIS.oNegocio.eliminar(codigo) THEN
                    WAIT REGISTRO_ELIMINADO WINDOW NOWAIT
                    THIS.oForm.pgfPrincipal.page1.cmdBuscar.Click()
                ELSE
                    MESSAGEBOX(THIS.oNegocio.obtener_error(), 0+48, MENSAJE_SISTEMA)
                ENDIF
            ENDIF
        ELSE
            MESSAGEBOX(DEBE_SELECCIONAR_REGISTRO, 0+64, MENSAJE_SISTEMA)
        ENDIF

        SELECT (THIS.cResultado)
        IF RECCOUNT() > 0 THEN
            THIS.oForm.pgfPrincipal.page1.grdResultado.SetFocus()
        ENDIF
    ENDFUNC

    **/
    * Establece el título del formulario.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION establecer_titulo
        LOCAL lcTitulo
        lcTitulo = 'Sin título'

        DO CASE
        CASE LOWER(THIS.Name) == 'frm_categorias'
            THIS.oForm.Caption = 'Categorías'
        CASE LOWER(THIS.Name) == 'frm_marcas'
            THIS.oForm.Caption = 'Marcas'
        CASE LOWER(THIS.Name) == 'frm_productos'
            THIS.oForm.Caption = 'Productos'
        CASE LOWER(THIS.Name) == 'frm_unidades_medidas'
            THIS.oForm.Caption = 'Unidades de medidas'
        ENDCASE
    ENDFUNC

    **/
    * Establece el formato de la cuadrícula (grid).
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION formatear_cuadricula
        WITH THIS.oForm.pgfPrincipal.page1.grdResultado
            .DeleteMark = .F.
            .FontName = 'Arial'
            .FontSize = 9
            .GridLineColor = RGB(192, 192, 192)
            .GridLines = 2    && 2 - Vertical   ¦   3 - Both (Default)
            .HighlightStyle = 2    && 2 - Current row highlighting enabled with visual persistence
            .ReadOnly = .T.
            .RecordMark = .F.
            .RecordSource = (THIS.cResultado)
            .ScrollBars = 2    && 2 - Vertical   ¦   3 - Both (Default)

            .grcCodigo.ControlSource = 'codigo'
            .grcDescripcion.ControlSource = 'descripcion'

            .grcCodigo.Width = 50
            .grcDescripcion.Width = 250

            .grcCodigo.grhCodigo.Caption = ' Código '
            .grcDescripcion.grhDescripcion.Caption = ' Descripción '
        ENDWITH
    ENDFUNC

    **/
    * Cancela el proceso en curso.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION cancelar
        THIS.establecer_bandera(0)
    ENDFUNC

    **/
    * Inicia el proceso para crear un nuevo registro.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION nuevo
        THIS.establecer_bandera(1)
    ENDFUNC

    **/
    * Inicia el proceso para actualizar un registro existente.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION actualizar
        SELECT (THIS.cResultado)
        IF RECCOUNT() > 0 THEN
            THIS.establecer_bandera(2)
        ELSE
            MESSAGEBOX(DEBE_SELECCIONAR_REGISTRO, 0+64, MENSAJE_SISTEMA)
        ENDIF
    ENDFUNC

    **/
    * Lista los datos de la tabla.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION reporte
        LOCAL lcReporte
        lcReporte = 'rpt_' + LOWER(SUBSTR(THIS.Name, 5)) + '.frx'

        SELECT (THIS.cResultado)
        IF RECCOUNT() > 0 THEN
            KEYBOARD '{CTRL+F10}'
            REPORT FORM (lcReporte) TO PRINTER PROMPT PREVIEW
        ELSE
            MESSAGEBOX(NO_NADA_QUE_REPORTAR, 0+64, MENSAJE_SISTEMA)
        ENDIF
    ENDFUNC

    **/
    * Devuelve un objeto entidad con los datos de todas las propiedades.
    *
    * @return object
    * object en caso de éxito y false en caso contrario.
    */
    PROTECTED FUNCTION obtener_entidad
        LOCAL loEntidad, loExcepcion, ;
              lnCodigo, lcDescripcion

        lnCodigo = THIS.nCodigo
        lcDescripcion = ALLTRIM(UPPER( ;
            THIS.oForm.pgfPrincipal.page2.txtDescripcion.Value))

        TRY
            loEntidad = CREATEOBJECT('e_' + LOWER(SUBSTR(THIS.Name, 5)), ;
                lnCodigo, ;
                lcDescripcion ;
            )
        CATCH TO loExcepcion
            MESSAGEBOX(mensaje_excepcion(loExcepcion), 0+16, EXCEPCION_SISTEMA)
        ENDTRY

        RETURN loEntidad
    ENDFUNC

    **/
    * Establece el estado de los botones.
    *
    * @param boolean tlEstado
    * Especifica el estado de los botones.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION estado_botones
        LPARAMETERS tlEstado

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(tlEstado) != 'L' THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        WITH THIS.oForm
            .cmdNuevo.Enabled = tlEstado
            .cmdActualizar.Enabled = tlEstado
            .cmdEliminar.Enabled = tlEstado
            .cmdReporte.Enabled = tlEstado
            .cmdSalir.Enabled = tlEstado
            .pgfPrincipal.page2.cmdCancelar.Enabled = !tlEstado
        ENDWITH
    ENDFUNC

    **/
    * Establece el estado de la bandera.
    *
    * @param integer tnBandera
    * Especifica el estado de la bandera.
    *
    * @return boolean
    * true si puede establecer el valor y false en caso contrario.
    */
    PROTECTED FUNCTION establecer_bandera
        LPARAMETERS tnBandera

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF !validar_numero(tnBandera, 0, 2) THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        THIS.nBandera = tnBandera

        DO CASE
        CASE THIS.nBandera == 0
            WITH THIS
                .oForm.LockScreen = .T.
                .oForm.pgfPrincipal.page1.Enabled = .T.
                .oForm.pgfPrincipal.ActivePage = 1
                .oForm.pgfPrincipal.page2.Enabled = .F.
                .estado_campos(.F.)
                .limpiar_campos()
                .estado_botones(.T.)
                .oForm.LockScreen = .F.
            ENDWITH

            WITH THIS.oForm.pgfPrincipal.page2
                .cmdGuardar.Visible = .T.
                .cmdCancelar.Caption = '\<Cancelar'
                .cmdCancelar.Picture = 'graphics\bmp\cancelar.bmp'
            ENDWITH
        CASE THIS.nBandera == 1    && nuevo.
            WITH THIS
                .oForm.LockScreen = .T.
                .oForm.pgfPrincipal.page2.Enabled = .T.
                .oForm.pgfPrincipal.ActivePage = 2
                .oForm.pgfPrincipal.page1.Enabled = .F.
                .estado_campos(.T.)
                .limpiar_campos()
                .estado_botones(.F.)
                .oForm.pgfPrincipal.page2.txtDescripcion.SetFocus()
                .oForm.LockScreen = .F.
            ENDWITH
        CASE THIS.nBandera == 2    && actualizar.
            WITH THIS
                .oForm.LockScreen = .T.
                .oForm.pgfPrincipal.page2.Enabled = .T.
                .oForm.pgfPrincipal.ActivePage = 2
                .oForm.pgfPrincipal.page1.Enabled = .F.
                .estado_campos(.T.)
                .cargar_campos()
                .estado_botones(.F.)
                .oForm.pgfPrincipal.page2.txtDescripcion.SetFocus()
                .oForm.LockScreen = .F.
            ENDWITH
        ENDCASE

        IF INLIST(THIS.nBandera, 1, 2) THEN
            IF TYPE('_SCREEN.ActiveForm.ActiveControl') == 'O' THEN
                LOCAL loActiveControl
                loActiveControl = _SCREEN.ActiveForm.ActiveControl

                IF LOWER(loActiveControl.Name) != LOWER('txtDescripcion') THEN
                    THIS.oForm.pgfPrincipal.page2.txtDescripcion.SetFocus()
                ENDIF
            ENDIF
        ENDIF
    ENDFUNC

    **/
    * Inicializa los campos.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION limpiar_campos
        WITH THIS
            .nCodigo = 0
            .oForm.pgfPrincipal.page2.txtDescripcion.Value = ''
        ENDWITH
    ENDFUNC

    **/
    * Carga los datos desde un cursor a los campos del formulario.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION cargar_campos
        WITH THIS
            .nCodigo = codigo
            .oForm.pgfPrincipal.page2.txtDescripcion.Value = ;
                ALLTRIM(UPPER(descripcion))
        ENDWITH
    ENDFUNC

    **/
    * Establece el estado de los campos.
    *
    * @param boolean tlEstado
    * Especifica el estado de los campos.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION estado_campos
        LPARAMETERS tlEstado

        * inicio { validaciones del parámetro }
        IF PARAMETERS() < 1 THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(tlEstado) != 'L' THEN
            RETURN .F.
        ENDIF
        * fin { validaciones del parámetro }

        THIS.oForm.pgfPrincipal.page2.txtDescripcion.Enabled = tlEstado
    ENDFUNC

    **/
    * Establece el estado del botón guardar.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION estado_boton_guardar
        THIS.oForm.pgfPrincipal.page2.cmdGuardar.Enabled = .F.

        IF !EMPTY(THIS.oForm.pgfPrincipal.page2.txtDescripcion.Value) THEN
            IF INLIST(THIS.nBandera, 1, 2) THEN
                THIS.oForm.pgfPrincipal.page2.cmdGuardar.Enabled = .T.
            ENDIF
        ENDIF
    ENDFUNC

    **/
    * Establece los valores de los campos a partir de un registro seleccionado
    * desde la cuadrícula.
    *
    * @return boolean true (default)
    */
    PROTECTED FUNCTION seleccionar_registro
        IF USED(THIS.cResultado) THEN
            SELECT (THIS.cResultado)
            WITH THIS
                .oForm.LockScreen = .T.
                .oForm.pgfPrincipal.page2.Enabled = .T.
                .oForm.pgfPrincipal.ActivePage = 2
                .oForm.pgfPrincipal.page1.Enabled = .F.
                .estado_campos(.F.)
                .cargar_campos()
                .estado_botones(.F.)
                .oForm.LockScreen = .F.
            ENDWITH

            WITH THIS.oForm.pgfPrincipal.page2
                .cmdGuardar.Visible = .F.
                .cmdCancelar.Caption = '\<Volver'
                .cmdCancelar.Picture = ''
            ENDWITH
        ENDIF
    ENDFUNC

ENDDEFINE
