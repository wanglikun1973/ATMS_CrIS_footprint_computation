PRO set_plot_ps,filename,portrait=portrait,printfile=printfile

   ;--------------------------------------------------------------------------
   ;    set the plot system
   IF KEYWORD_SET(portrait) THEN portrait=1 ELSE portrait=0
   IF KEYWORD_SET(printfile) THEN printfile=1 ELSE printfile=0

   IF (printfile) THEN BEGIN
       set_plot, 'ps'
       !p.font=1
       ;device, set_font = 'Times', /TT_FONT
       device, set_font = 'Times Bold', /TT_FONT
       !y.thick=3.0
       !x.thick=3.0
       !p.thick = 3.0
       !x.style=1 
       !y.style=1
       !x.charsize=1.5
       !y.charsize=1.5
       !p.charthick = 2.0
       !x.ticklen = -0.02
       !y.ticklen = -0.02
       IF(portrait) THEN BEGIN
         DEVICE,/PORT,/INCH,XSIZE=6.5, YSIZE=9, $
                    XOFF=1.0, YOFF=1.0, /COLOR,BITS=8,$
                   FILENAME=filename ;XSIZE=7 YSIZE=9.5
         ENDIF ELSE BEGIN

	   DEVICE,/inches,xoffset=0.7,yoffset=10,xsize=9,ysize=6.5,/COLOR,$
        	     filename=filename,bits_per_pixel=8,/landscape

       ENDELSE
    ENDIF ELSE BEGIN
        SET_PLOT,'x'
        DEVICE,decompose=0
        WINDOW,0,XSIZE=800,YSIZE=600
        !y.thick=2.0
        !x.thick=2.0
        !p.thick = 2.0
        
        !x.style=1 
        !y.style=1
        
        !x.charsize=1.5
        !y.charsize=1.5
        !p.charsize=1.5
        
        !x.ticklen = -0.02
        !y.ticklen = -0.02
        
        !p.background = 0
        !p.color = 255

    ENDELSE
END
