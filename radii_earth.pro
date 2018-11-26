
;;;; Given Geodectic lattidue (degree), return earth Radii
;;;  Author: Likun.Wang@noaa.gov from UMD/ESSIC/CICS
;;;  Date: August 23, 2012
;;;  Notes: 
;;;       All Earth Ellipsoid is defined as WGS84, check here for reference  
;;;           https://en.wikipedia.org/wiki/World_Geodetic_System 

function  Radii_Earth, geodectic_lat 

  ;;; lat=geodectic_lat
  latD = geodectic_lat

  ;;; WGS84 Parameters
  a = 6378137.0D
  f =1/298.257223563D
  b = a*(1.0d - f)
  e=sqrt((a^2.0-b^2.0)/a^2.0)
  
  deg2rad = !dpi / 180.d
  lat= deg2rad * latD
  
  ;; R_N = Radius of Curvature (meters), deﬁned as:
  R_N= a/sqrt(1-(e^2.0)*(sin(lat)^2.0))
  
  ;;; Radius of ellipsoid
  term1=(1-e^2.0)^2.0*sin(lat)^2.0+cos(lat)^2.0
  term2=a*sqrt(term1)
  R_E=term2/sqrt(1-e^2.0*sin(lat)^2.0)
  
  R=CREATE_STRUCT('R_N',R_N, 'R_E', R_E)
  
  return, R
END 