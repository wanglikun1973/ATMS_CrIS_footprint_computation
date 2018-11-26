
nCh = 22
nFOV = 96
nScan = 12
;;;   %  in radians
;;;  5.2 degrees (ch 1 & 2) 
;;;  2.2 degrees (ch 3-16) 
;;;  1.1 degrees (ch 17-22)            
fovDia = !dpi/180d * 2.2

atms_sdr_file = './data/SATMS_npp_d20181022_t0022213_e0022529_b36187_c20181022014936019618_noac_ops.h5'
atms_geo_file = './data/GATMO_npp_d20181022_t0022213_e0022529_b36187_c20181022014936013060_noac_ops.h5'

read_atms_sdr, atms_sdr_file, atms_geo_file, $
   bt=atms_rad, lat=atms_lat, lon=atms_lon, $
   midtime=atms_time, satzenith=atms_zenith, $
   satazimuth=atms_azimuth, $
   range=atms_range
  
psfile = 'atms_fov.ps' 
print  = 0
set_plot_ps, 'atms_fov.ps', print=print

jScan= 4
map_set, limit=[min(atms_lat[*, jScan])-2, min(atms_lon[*, jScan])-2, $
               max(atms_lat[*, jScan])+2, max(atms_lon[*, jScan])+2], $
    /isotropic 

FOR j=jScan, jScan DO BEGIN
   FOR i=0, nFOV-1  DO BEGIN           
      geodeticLat = atms_lat[i, j]
      longitude = atms_lon[i, j]
      azimuth = atms_azimuth[i, j]
      zenith = atms_zenith[i, j]
      range = atms_range[i, j]
                                         
      ellipse = compute_ellipse_footprint(geodeticLat, longitude, $
                                    range, azimuth, zenith, fovDia)
      
      oplot, ellipse.lon, ellipse.lat
   ENDFOR 
ENDFOR
map_grid
map_continents 

if print then device, /close_file
  
  
  
END 
  
