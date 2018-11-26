;+
; NAME: 
;       compute_geolocation
;
;PURPOSE:
;   Given the satellite position and the line-of-sight (or lookup vector), this
;   function returns the geodetic (or geographic) latitude and longitude of the  
;   geolocation point on the Earth ellipsoid characterized by the Earth radius and 
;   flattening factor. This is Basic Earth Ellipsoid Intersection Algorithm. Please 
;   check "3.3.2.2.1. Basic Earth Ellipsoid Intersection Algorithm" in VIIRS   
;   Geolocation Algorithm Theoretical Basis Document - NASA     
;
; CATEGORY:
;       Geolocation computation       
;
; INPUTS:
;     satellitePosition: 
;        [x, y, z]:  satellite position vector in ECEF (meter) 
; 
;     lineOfSight, 
;        [x, y, z]:  line-of-sight vector in ECEF (meter) 
; 
;     earthRadius:  
;        earth Radius (m) - dependent on Earth ellipsoid Model   
;         
;     flatFact: 
;        flatFact (unitless) -  dependent on Earth ellipsoid Model   
;
; OUTPUTS:
;    Geodetic latitude and longitude for intersection point of LOS vector
;          with Earth ellipsoid
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
; First written by Likun.Wang@noaa.gov from UMD/ESSIC/CICS on 06/2012
; Make some notes for GitHub release  on 11/26/2018
;
;-

FUNCTION compute_geolocation, satellitePosition, lineOfSight, earthRadius, flatFact

   ;;  The basic equations are:
   ;;
   ;;  P + lambda LOS = G  ( P = satellite position, LOS = line of sight, G = geolocation point).
   ;;  and lambda is the slant range.
   ;;
   ;;  and
   ;;
   ;;  Gx^2 / a^2 + Gy^2 / a^2 + Gz^2 / c^2 = 1    Earth ellipsoid equation, a = equatorial radius.
   ;;  c is polar radius ( c = ( 1-f) * a) where f is flattening factor.
   ;;

   ;;  Initialize working variable.
   ;;
   geolocationPoint = make_array(3, /double);
   deg2rad = !dpi / 180.0;

   ;;  The geolocation vector position is the solution of
   ;;  a quadratic equation where  A lambda^2 + B lambda + C = 0, here x is the slant range.
   ;;
   polarRadius = earthRadius * ( 1.0e0 - flatFact);
   termA = ((lineOfSight(0) / earthRadius)^2) + $
           ((lineOfSight(1) / earthRadius)^2) + $
           ((lineOfSight(2) / polarRadius)^2);

   termB =  ( satellitePosition(0) * lineOfSight(0) / (earthRadius^2)) + $
            ( satellitePosition(1) * lineOfSight(1) / (earthRadius^2)) + $
            ( satellitePosition(2) * lineOfSight(2) / (polarRadius^2))  ;
   termB = termB * 2.0d;

   termC =  (satellitePosition(0)/earthRadius)^2 + $
            (satellitePosition(1)/earthRadius)^2 + $
            (satellitePosition(2)/polarRadius)^2 - 1.0;

   radical = termB^2 - (4.0d * termA * termC);

   if( radical lt 0.0) THEN BEGIN 
      ;;  The line of sight does not intercept the Earth ellipsoid.
      ;;
      ellLat = -999.0;
      ellLon = -999.0;
   ENDIF 
   if( radical eq 0.0) THEN BEGIN 
      ;;  The line of sight does not intercept the Earth ellipsoid tangentially.
      ;;
      slantRange = -termB / (2.0 * termA);
      geolocationPoint = satellitePosition + slantRange * lineOfSight;
   ENDIF 
   
   if( radical GT  0.0) THEN BEGIN 
      ;;  The line of sight intercepts the Earth ellipsoid at 2 point, the solution
      ;;  is the shorter slant range.
      ;;
      slantRange1 = (-termB - sqrt(radical))  / (2.0 * termA);
      slantRange2 = (-termB + sqrt(radical))  / (2.0 * termA);
      slantRange = min( [ slantRange1, slantRange2]);
      geolocationPoint = satellitePosition + slantRange * lineOfSight;
   endif

   geoLon = atan( geolocationPoint(1) , geolocationPoint(0)) / deg2rad;
   magXY = sqrt( geolocationPoint(0)^2 +  geolocationPoint(1)^2); 
   geocentricLat = atan( geolocationPoint(2) , magXY) / deg2rad;
   geoLat = latitude_transform( geocentricLat, flatFact, 2);
  
   s = [geolat, geolon]
   
   return, s

END 
