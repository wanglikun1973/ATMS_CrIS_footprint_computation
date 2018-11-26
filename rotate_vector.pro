;+
; NAME: 
;
;       rotate_vector
;
; PURPOSE:
;        Given an axis or rotation, the angle (right hand screw motion), and
;        the original (old) vector, this function rotates the old vector
;        around the rotation axis by the amount of specified angle. 
;        geocentric. Please check here for background knowledge, 
;               https://en.wikipedia.org/wiki/Axis%E2%80%93angle_representation
;
; CATEGORY:
;       Vector computation.      
;
; INPUTS:
;   rotationAxis
;       : Three elements unit vector of the rotation axis ( cartesian coordinate)
;               (float or double)
;               Example, rotate around the Y axis, then the rotation axis is [ 0, 1, 0].
;     oldVector
;       : Three elements vector to be rotated  ( cartesian coordinate)
;               (float or double)
;     angle
;       : Angle of ratation in radian.
;               (float or double)
;
; OPTIONAL INPUTS:
;     newVector Three elements vector after rotation.
;               (float or double)
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;    newVector Three elements vector after rotation.
;               (float or double)
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
; First written by Likun.Wang@noaa.gov from UMD/ESSIC/CICS on 06/2012
; Make some notes for GitHub release  on 11/26/2018
;
;-

FUNCTION rotate_vector, rotationAxis, angle, oldVector 
  
  cosAngle = cos(angle)        ;
  sinAngle = sin(angle)        ;

  firstTerm = oldVector * cosAngle ;
  secondTerm =  CROSSP( oldVector, rotationAxis) * sinAngle ;
  thirdTerm = (dot( oldVector, rotationAxis) * rotationAxis) * ( 1.0e0 - cosAngle) ;
  newVector = firstTerm - secondTerm + thirdTerm ;
  
  RETURN, newVector 
END



