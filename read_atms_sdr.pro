;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ATMS SDR simplest reader
;;;  Purpose: Use IDL to read and display a ATMS SDR granule in HDF5 format with minimal coding.
;;;  Author: Likun.Wang@noaa.gov from UMD/ESSIC/CICS
;;;  Date: August 23, 2016
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 08/23/2016 First wrote it by modifying the VIIRS SDR reader. 


PRO Read_ATMS_SDR, sdrFile, geoFile, $
                   bt=bt, $
                   lat=lat, lon=lon, $
                   midTime=midTime, $
                   satZenith=SatZenith, satAzimuth=satAzimuth, $
                   solarZenith=solarZenith, $
                   range=range, $
                   sdrQa=sdrQa, geoQa=geoQa,$
                   satPos=satPos, satVel=satVel,$
                   satAtt=satAtt
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; READ SDR file first 
file_id = H5F_OPEN(sdrFile)

IF ARG_PRESENT(BT) THEN BEGIN
   ;get one band radiances
   Data='/All_Data/ATMS-SDR_All/BrightnessTemperature'
   dataset_id= H5D_OPEN(file_id,Data)
   BT = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id

  
   Data='/All_Data/ATMS-SDR_All/BrightnessTemperatureFactors'
   dataset_id= H5D_OPEN(file_id,Data)
   factor = H5D_Read(dataset_id)
   BT = factor[0]*BT + factor[1]
   H5D_CLOSE, dataset_id
ENDIF 


;;; get the SDR Quality Flag
IF ARG_PRESENT(sdrQa) THEN BEGIN
   Data='/All_Data/'+VIIRSBAND+'/QF1_VIIRSMBANDSDR/'
   dataset_id= H5D_OPEN(file_id, Data)
   sdrQa = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF

H5F_CLOSE, file_id

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; geolocation information

file_id = H5F_OPEN(GeoFile)
Geo=H5G_GET_MEMBER_NAME(file_id,'All_Data',0)
;get latitude
IF ARG_PRESENT(lat) or ARG_PRESENT(lon) THEN BEGIN 

   Data='/All_Data/'+Geo+'/Latitude'
   dataset_id= H5D_OPEN(file_id,Data) 
   lat = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id

   ;get longitude
   Data='/All_Data/'+Geo+'/Longitude'
   dataset_id= H5D_OPEN(file_id,Data)
   lon = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id

ENDIF

; get satellite zenith angle 
IF ARG_PRESENT(satZenith) THEN BEGIN  
   Data='/All_Data/'+Geo+'/SatelliteZenithAngle/'
   dataset_id= H5D_OPEN(file_id,Data)
   satZenith = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
endIF 

; get satellite azimuth angle 
IF ARG_PRESENT(satAzimuth) THEN BEGIN  
   Data='/All_Data/'+Geo+'/SatelliteAzimuthAngle/'
   dataset_id= H5D_OPEN(file_id,Data)
   satAzimuth = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
endIF 

;get mid scan time 
IF ARG_PRESENT(midTime) THEN BEGIN  
   Data='/All_Data/'+Geo+'/MidTime/'
   dataset_id= H5D_OPEN(file_id,Data)
   midTime = H5D_Read(dataset_id)
   midTIme = midTime*0.000001D
   H5D_CLOSE, dataset_id
ENDIF

;;; get the GEO Quality Flag
IF ARG_PRESENT(geoQa) THEN BEGIN
   Data='/All_Data/'+Geo+'/QF2_VIIRSSDRGEO/'
   dataset_id= H5D_OPEN(file_id, Data)
   geoQa = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF

IF ARG_PRESENT(range) THEN BEGIN
   Data='/All_Data/'+Geo+'/SatelliteRange/'
   dataset_id= H5D_OPEN(file_id,Data)
   range = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF


IF ARG_PRESENT(satPos) THEN BEGIN
   Data='/All_Data/'+Geo+'/SCPosition/'
   dataset_id= H5D_OPEN(file_id,Data)
   satPos = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF

IF ARG_PRESENT(satVel) THEN BEGIN
   Data='/All_Data/'+Geo+'/SCVelocity/'
   dataset_id= H5D_OPEN(file_id,Data)
   satVel = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF

IF ARG_PRESENT(satAtt) THEN BEGIN
   Data='/All_Data/'+Geo+'/SCAttitude/'
   dataset_id= H5D_OPEN(file_id,Data)
   satAtt = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id
ENDIF

  ;;; Solor angles 
IF ARG_PRESENT(SolarZenith) THEN BEGIN
   Data='/All_Data/'+Geo+'/SolarZenithAngle/'
   dataset_id= H5D_OPEN(file_id,Data)
   solarZenith = H5D_Read(dataset_id)
   H5D_CLOSE, dataset_id

 ENDIF

H5F_CLOSE, file_id

return

END
