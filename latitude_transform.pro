FUNCTION latitude_transform, latRef, flatteningFactor, option

   deg2rad = !dpi / 180.0d            ;
   latIn = latRef * deg2rad;
   ff = 1.0d - flatteningFactor;

   if( option EQ  1) THEN BEGIN 

      latOut = atan( ((ff)^2) * tan(latIn)) ;
      latitudeOutput = latOut / deg2rad ;
   ENDIF ELSE BEGIN 
   
      latOut = atan( (1.0/ (ff^2)) * tan(latIn)) ;
      latitudeOutput = latOut / deg2rad ;

   ENDELSE 

   return, latitudeOutput



END 
