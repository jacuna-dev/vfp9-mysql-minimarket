@echo off
cls

echo :: Limpia el proyecto de archivos innecesarios ::
::    /s    Deletes specified files from the current directory and all
::    subdirectories. Displays the names of the files as they are being deleted.
del /s *.bak
del /s *.err
del /s *.fxp
del /s tm*.*

echo :: Renombrando archivos ::
echo Ï datos
cd datos
ren conexion.prg conexion.prg
ren d_categorias.prg d_categorias.prg
ren datos.prg datos.prg
ren validador_base.prg validador_base.prg
ren validador_base_actualizar.prg validador_base_actualizar.prg
ren validador_base_nuevo.prg validador_base_nuevo.prg
ren validador_categorias_actualizar.prg validador_categorias_actualizar.prg
ren validador_categorias_nuevo.prg validador_categorias_nuevo.prg
ren mysql.sql mysql.sql
cd..

echo Ï entidades
cd entidades
ren e_categorias.prg e_categorias.prg
ren entidades.prg entidades.prg
cd..

echo Ï include
cd include
ren constantes.h constantes.h
cd..

echo Ï negocio
cd negocio
ren n_categorias.prg n_categorias.prg
ren negocio.prg negocio.prg
cd..

echo Ï presentacion
cd presentacion
ren bcv.vct bcv.vct
ren bcv.vcx bcv.vcx
ren formularios.vct formularios.vct
ren formularios.vcx formularios.vcx
ren frm_categorias.prg frm_categorias.prg
ren frm_categorias.sct frm_categorias.sct
ren frm_categorias.scx frm_categorias.scx
ren frm_mantener.prg frm_mantener.prg
cd..

echo Ï progs
cd progs
ren biblioteca.prg biblioteca.prg
ren crear_cursor.prg crear_cursor.prg
ren crear_objeto.prg crear_objeto.prg
ren createmp.prg createmp.prg
ren excepcion_sql.prg excepcion_sql.prg
ren limpiar_texto_sql.prg limpiar_texto_sql.prg
ren mensaje_error.prg mensaje_error.prg
ren mensaje_excepcion.prg mensaje_excepcion.prg
ren validar_form.prg validar_form.prg
ren validar_numero.prg validar_numero.prg
ren validar_texto.prg validar_texto.prg
cd..

echo Ï directorio ra¡z
ren establecer_ruta.prg establecer_ruta.prg
ren prueba.prg prueba.prg
