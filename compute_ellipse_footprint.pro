;+
; NAME: 
;
;       compute_ellipse_footprint
;
; PURPOSE:
;        Given geodetic Latitude, longitude, Satellite Range, azimuth, zenith, 
;             and detector fovDia angle, compute FOV footprint on the Earth 
;             ellipsoid surface (WGS84). Please check "3.2 Computation of CrIS FOV Footprint" 
;             in the following paper, 
;               Wang, L., D. A. Tremblay, Y. Han, M. Esplin, D. E. Hagan, J. Predina, 
;               L. Suwinski, X. Jin, and Y. Chen (2013), Geolocation assessment for 
;               CrIS sensor data records, J. Geophys. Res. Atmos., 118, 12,690–12,704, 
;               doi: 10.1002/2013JD020376.    
;         
;
; CATEGORY:
;       Geolocation computation       
;
; INPUTS:
;   geodeticLat: 
;       : Geodetic Latitude (degree)  ==> contained in JPSS GEO file
;   longitude: 
;       : Longitude (degree) ==> contained in JPSS GEO file
;   range:   
;       : Satellite Range (meter) ==> contained in JPSS GEO file
;   azimuth: 
;       : Satellite Azimuth angle (degree) ==> contained in JPSS GEO file
;   zenith: 
;       : Satellite Zenith angle (degree) ==> contained in JPSS GEO file
;   fovDia: 
;       : Detector or Beam FOV angle (radian)
;         For CrIS   
;             fovDia = 0.016808d ;   %  in radians ==> 0.963 degrees CrIS
;         For ATMS: 
;             5.2 degrees (ch 1 & 2) 
;             2.2 degrees (ch 3-16) 
;             1.1 degrees (ch 17-22)              
; OPTIONAL INPUTS:
;     
;
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;    Structure {lat [37] (Degree), lon [37] (Degree)}   
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
; First written by Likun.Wang@noaa.gov from UMD/ESSIC/CICS on 06/2012
; Make some notes for GitHub release  on 11/26/2018
;
;-

FUNCTION compute_ellipse_footprint, geodeticLat, longitude,range, azimuth, zenith, fovDia

   ;;; WGS84 Parameters 
   earthRadius = 6378137.0d        
   flatFact = 1.0e0 / 298.257223563d 
  
   ;;; From Diameter to Radius 
   fovRadius = fovDia / 2.0d

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 1: 
   ;;;   compute position vector in ECEF using laitude and longitude  
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   temp = lla2ecef(geodeticLat, longitude, 0.0)
   pos = [temp.x, temp.y, temp.z]

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 2: 
   ;;;   compute LOS vector in ENU coordinate using satellite range, azimuth, 
   ;;;        zenith angle  
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   s = RAE2ENU(azimuth, zenith, range)
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 3: 
   ;;;   compute LOS vector in ECEF coordinate using laitude and longitude
   geocentricLat = latitude_transform(geodeticLat, flatFact, 1) 
   r = ENU2ECEF(s.east, s.north, s.up, geocentricLat, longitude)
   los = -1.0d*[r.x, r.y, r.z]
    
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 4: 
   ;;;   compute satellite position 
   sat_pos = pos - los
      
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 5: 
   ;;;   compute orthoVectorLOS   
   orthoVectorLOS = CROSSP(los, [ 0.0d, 0.0d, 1.0d]);
   orthoVectorLOS = orthoVectorLOS / sqrt( dot(orthoVectorLOS, orthoVectorLOS))
   
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 6: 
   ;;  Rotate LOS vector along the orthoVector by the FOV radius (in radians).
   ;; 
   los_unit = los / sqrt( dot(los, los))
   fovVector = rotate_vector(orthoVectorLOS, fovRadius, los_unit);
   
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;; Step 7: 
   ;;  
   ;;  Rotate the fovVector along LOS vector in step of 10 degrees, and find 
   ;;  the ellipsoid geolocation ( in geodetic latitude/longitude coordiante).
   ;;  The final result is a vector of longitude (an array with 37 elements) and 
   ;;  latitude (an array with 37 elements). The last entry (36) should be identical
   ;;  to the first index, hence allowing the plotting using plotm routine.
   ;;
   deg2rad = !dpi / 180.0d             
   angleStep = dindgen(37) * (10.0d * deg2rad)

   ellLat = make_array(37, /double)
   ellLon = make_array(37, /double)

   for iAngleStep=0, 36 DO BEGIN 
 
      curAngle = angleStep(iAngleStep) ;
      curFovVector = rotate_vector(los_unit, curAngle, fovVector) ;

      ;;  Find the geodetic latitude and longitude ( geolocation)
      ;;  for the given current fov Vector and satellite position.
      ;;
                                
      r = compute_geolocation(sat_pos, curFovVector, earthRadius, flatFact) 
      ellLat(iAngleStep) = r[0]
      ellLon(iAngleStep) = r[1]
        
   ENDFOR 
   
   return, {lat:ellLat, lon:ellLon}
END 
