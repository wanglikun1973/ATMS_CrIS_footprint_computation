

FUNCTION RAE2ENU, azimuth, zenith, range   

  ;;; check input parameters
  n_arguments = 3 
  IF N_PARAMS() lt n_arguments THEN BEGIN 
     message, 'input parameter must include [azimuth, zenith, range]', /info
     return, -1 	
  ENDIF 

  ;;; Check for base input argument validity  
  sz_azimuth = size(azimuth,/dim) 
  sz_zenith = size(zenith,/dim)
  sz_range = size(range,/dim)  
 
  IF ~ARRAY_EQUAL(sz_azimuth, sz_zenith) or $
     ~ARRAY_EQUAL(sz_azimuth, sz_range) or $
     ~ARRAY_EQUAL(sz_zenith, sz_range) THEN BEGIN
    MESSAGE, 'size of input parameters do not match', /INFO
    RETURN, -1
  ENDIF

 
  deg2rad = !dpi / 180.0d 
  
  ;;; up 
  up = range*cos(zenith * deg2rad)
  
  ;;; projection on the x-y plane 
  p = range*sin(zenith*deg2rad)  
  
  ;;; north 
  north = p*cos(azimuth*deg2rad)
 
  ;;; east
  east = p*sin(azimuth*deg2rad)   

  result =  {east: east, north: north,  up: up}
    
  return, result 
  
END    
