

cris_geo_list = ['GCRSO_j01_d20181022_t0023599_e0024297_b04790_c20181022005852745013_noac_ops.h5', 'GCRSO_j01_d20181022_t0024319_e0025017_b04790_c20181022005900474501_noac_ops.h5']
dir = './data/'

;;;  read CrIS data
;;; data variable
nFOV = 9
nFOR = 30
nScan = 4*n_elements(cris_geo_list)
nBand = 3

c_lat = make_array(nFOV, nFOR, nScan, /float)
c_lon = make_array(nFOV, nFOR, nScan, /float)
c_zenith = make_array(nFOV, nFOR, nScan, /float)
c_azimuth = make_array(nFOV, nFOR, nScan, /float)
c_range = make_array(nFOV, nFOR, nScan, /float)

lines = 0L

FOR k=0, n_elements(cris_geo_list) -1 DO BEGIN

    read_cris_geo, dir+cris_geo_list[k], $
        lat=s_lat, lon=s_lon, $
        zenith=s_zenith, $
        azimuth=s_azimuth, $
        range=s_range

    c_lon[*, *, lines:lines+3] = s_lon
    c_lat[*, *, lines:lines+3] = s_lat
    c_zenith[*, *, lines:lines+3] = s_zenith
    c_azimuth[*, *, lines:lines+3] = s_azimuth
    c_range[*, *, lines:lines+3] = s_range

    lines += 4
ENDFOR

;;; make plot
print = 1
psfile='cris_fov.ps'
set_plot_ps, psfile, print=print

map_set, mean(c_lat), mean(c_lon), $
     limit=[min(c_lat[*, *, *])-1, min(c_lon[*, *, *]-1), $
            max(c_lat[*,*, *])+1, max(c_lon[*, *, *])+1], $
     /isotropic, $
     title=' CrIS Footprint'
     
FOR kk=0, nScan-1 DO BEGIN
     FOR jj=0, nFor-1 DO BEGIN
        FOR ii=0, nFov-1 DO BEGIN
           geodeticLat = c_lat[ii, jj, kk]
           longitude = c_lon[ii, jj, kk]
           azimuth = c_azimuth[ii, jj, kk]
           zenith = c_zenith[ii, jj, kk]
           range = c_range[ii, jj, kk]

           fovDia = 0.016808d ;   %  in radians ==> 0.963 degrees CrIS
           
           ellipse = compute_ellipse_footprint(geodeticLat, longitude, $
                                               range, azimuth, zenith, fovDia)

           oplot, ellipse.lon, ellipse.lat

        ENDFOR
     ENDFOR
  endFOR

map_grid
map_continents, /hi_res

IF print THEN BEGIN
      device, /close_file
      set_plot, 'x'
ENDIF
  
END 
  
