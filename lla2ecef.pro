;+
; NAME:
;   LLA2ECEF
;
; PURPOSE:
;   Convert geodectic lat(degree), lon(degree), h(m)  into
;   (X, Y, Z) in meters in the Earth-Centered, Earth-Fixed frame 
;    USAGE:
;     [x,y,z] = lla2ecef(lat,lon,alt)
; 
;     x = ECEF X-coordinate (m)
;     y = ECEF Y-coordinate (m)
;     z = ECEF Z-coordinate (m)
;     lat = geodetic latitude (radians)
;     lon = longitude (radians)
;     alt = height above WGS84 ellipsoid (m)
;   
;   
; CATEGORY:
;   Geolocaion 
;
; INPUTS:
;   lat(degree), lon(degree), h(m)
;
; OPTIONAL INPUTS:
;   None 
;
; KEYWORD PARAMETERS:
;   None 
;
; OUTPUTS:
;   [x, y, z]: [x, y, z] in meters Earth-Centered, Earth-Fixed frame  
;
; OPTIONAL OUTPUTS:
;   None 
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Tue Dec 11 10:50:52 2012, Likun Wang
;       <Likun.Wang@noaa.gov>
;       Wrote it and test it for SGP4 model 
;		
;-

FUNCTION lla2ecef, lat_in, lon_in, height_in
  
  ;;; check input parameters
  n_arguments = 3
  IF N_PARAMS() lt n_arguments THEN BEGIN 
     message, 'input parameter must include [lat, lon, height]', /info
     return, -1 	
  ENDIF 

  ;;; Check for base input argument validity  
  sz_height = size(height,/dim)
  sz_lat    = size(lat, /dim)
  sz_lon    = size(lon, /dim)  
 
  IF ~ARRAY_EQUAL(sz_height, sz_lon) or $
     ~ARRAY_EQUAL(sz_height, sz_lat) or $
     ~ARRAY_EQUAL(sz_lat, sz_lon) THEN BEGIN
    MESSAGE, 'size of input parameters do not match', /INFO
    RETURN, -1
  ENDIF  

  
  latD = lat_in
  lonD = lon_in
  h = height_in
  
  ;;;; from degree into radius
  deg2rad = !dpi / 180.d
  lat= deg2rad * latD
  lon= deg2rad * lonD

  ;;; WGS84 Parameters
  a = 6378137.0D
  f =1/298.257223563D
  b = a*(1.0d - f)
  e=sqrt((a^2.0-b^2.0)/a^2.0)
  

  ;; N = Radius of Curvature (meters), deﬁned as:
  N= a/sqrt(1-(e^2.0)*(sin(lat)^2.0))

  ;;; calcute X, Y, Z
  x=(N+h)*cos(lat)*cos(lon)
  y=(N+h)*cos(lat)*sin(lon)
  z=(b^2.0/a^2.0*N+h)*sin(lat)

  p={x:x, y:y, z:z}
  
  return, p

end 


