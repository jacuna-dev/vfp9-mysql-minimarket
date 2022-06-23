establecer_ruta()

FUNCTION establecer_ruta()
    LOCAL lcSys16, lcPrograma, lcRuta

    lcSys16 = SYS(16)
    lcPrograma = SUBSTR(lcSys16, AT(':', lcSys16) - 1)
    lcRuta = JUSTPATH(lcPrograma)

    SET DEFAULT TO (lcRuta)
    SET PATH TO datos, ;
                entidades, ;
                include, ;
                negocio, ;
                presentacion, ;
                presentacion\reportes, ;
                progs
ENDFUNC
