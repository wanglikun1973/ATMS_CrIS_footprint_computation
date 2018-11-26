;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   get_h5_data.pro
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Pro get_h5_data, fid, data_name, data
    dataset_id= H5D_OPEN(fid, data_name)
    data = H5D_Read(dataset_id)
    H5D_CLOSE, dataset_id
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   read_cris_geo.pro
;   
;       Read the geolocation data only for CrIS
;
;   Written by Likun.Wang@noaa.gov on 10/01/2012
;   Notes:
;   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO read_cris_geo, filename, $
                   lat=lat, lon=lon, height=height, $
                   zenith=zenith, azimuth=azimuth, range=range, $
                   SolarZenith=SolarZenith, SolarAzimuth=SolarAzimuth, $ 
                   satPos=satPos, satVel=satVel, satAtt=satAtt, $
                   MidTime=MidTime, forTime=forTime
  
  IF ~ file_test(filename) THEN BEGIN 
     print, filename + ' does not exist ... return.'
     return
  ENDIF 
  
  file_id = H5F_OPEN(filename)
  
  ;;; Pixel Information 
  IF ARG_PRESENT(lat) OR ARG_PRESENT(lon) THEN BEGIN
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/Latitude', lat
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/Longitude', lon
  ENDIF
  
  IF ARG_PRESENT(zenith) OR ARG_PRESENT(azimuth) THEN BEGIN
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SatelliteZenithAngle', zenith
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SatelliteAzimuthAngle', azimuth
  ENDIF
  
  IF ARG_PRESENT(height) THEN BEGIN
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/Height', height
  ENDIF
  
  
  ;;; Solor angles 
  IF ARG_PRESENT(SolarZenith) OR ARG_PRESENT(SolarAzimuth) THEN BEGIN
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SolarZenithAngle', SolarZenith
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SolarAzimuthAngle', SolarAzimuth
  ENDIF
  
  ;;; Satellite information 
  IF ARG_PRESENT(satPos) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SCPosition', SatPos
  endIF 
  
  IF ARG_PRESENT(satVel) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SCVelocity', SatVel
  endIF 
  
    IF ARG_PRESENT(satAtt) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SCAttitude', SatAtt
  endIF 
  
  ;;; Time Information 
  IF ARG_PRESENT(MidTime) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/MidTime', MidTime
     midtime = midTime*0.000001D
  endIF 
  
  IF ARG_PRESENT(forTime) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/FORTime', forTime
     forTime = forTime*0.000001D
  endIF 
  
  IF ARG_PRESENT(range) THEN BEGIN 
     GET_H5_DATA, file_id, '/All_Data/CrIS-SDR-GEO_All/SatelliteRange', Range
  endIF
  
  
  
  H5F_CLOSE, file_id
END 
