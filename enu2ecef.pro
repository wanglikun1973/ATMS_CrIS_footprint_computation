
;;; Convert local East, North, Up (ENU) coordinates to the (x,y,z) Earth Centred Earth Fixed (ECEF) coordinates
;;; Reference is here:  
;;; http://www.navipedia.net/index.php/Transformations_between_ECEF_and_ENU_coordinates
;;; Note that laitutde should be geocentric latitude instead of geodetic latitude 
;;; Note: 
;;;
;;; On June 16 2015
;;;  This note from https://en.wikipedia.org/wiki/Geodetic_datum 
;;; Note: \ \phi is the geodetic latitude. A prior version of this page showed use of the geocentric latitude (\ \phi^\prime).
;;; The geocentric latitude is not the appropriate up direction for the local tangent plane. If the
;;; original geodetic latitude is available it should be used, otherwise, the relationship between geodetic and geocentric
;;; latitude has an altitude dependency, and is captured by ...
;;; 

FUNCTION ENU2ECEF, east, north, up, lat, lon  


  ;;; check input parameters
  n_arguments = 5 
  IF N_PARAMS() lt n_arguments THEN BEGIN 
     message, 'input parameter must include [east, north, up, lat, lon]', /info
     return, -1 	
  ENDIF 

  ;;; Check for base input argument validity  
  sz_east = size(east,/dim) 
  sz_north = size(north,/dim)
  sz_up = size(up,/dim)
  sz_lat = size(lat, /dim)
  sz_lon = size(lon, /dim)  
 
  IF ~ARRAY_EQUAL(sz_east, sz_north) or $
     ~ARRAY_EQUAL(sz_east, sz_up) or  $
     ~ARRAY_EQUAL(sz_east, sz_lon) or $
     ~ARRAY_EQUAL(sz_east, sz_lat) or $
     ~ARRAY_EQUAL(sz_lat, sz_lon) THEN BEGIN
    MESSAGE, 'size of input parameters do not match', /INFO
    RETURN, -1
  ENDIF  

  ;p0=xyz ;;; [east, north, up]
  ;p1=rot3d(p0, xAng=(90-lat), ROTMAT=rotmat_x)
  ;p2=rot3d(p1, zAng=(90+lon), ROTMAT=rotmat_z)
  ;rotmat=MATRIX_MULTIPLY(rotmat_z, rotmat_x)

  x0=east
  y0=north 
  z0=up
  
  lm = lon*!dpi/180.d  
  ph = lat*!dpi/180.d 
 
  x=-1.0*x0*sin(lm)-y0*cos(lm)*sin(ph)+z0*cos(lm)*cos(ph)
  y= x0*cos(lm) -y0*sin(lm)*sin(ph)+z0*sin(lm)*cos(ph)
  z=x0*0       +y0*cos(ph)        +z0*sin(ph)   


  result= {x:x, y:y, z:z}
    
  return, result 

END  
