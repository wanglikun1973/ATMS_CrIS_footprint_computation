;+
; NAME:
; dot.pro
;
;
; PURPOSE:
; calculate the scalar (dot) product in any number of dimensions
;
;
; CATEGORY:
; vector
;
;
; 
; INPUTS:
; a: first vector in operation
; b: second vecotr in operation
;
;
; OUTPUTS:
; the scalar (dot) product answer of the input vectors
;
;
; PROCEDURE:
; it is the product of the components of the vecors a_i*b_i (sum on i)
;
;
; EXAMPLE:
;
; ans=dot([1,2,3,4,5,6],[6,5,43,3,2,1])
;
; MODIFICATION HISTORY:
;
;       Sun Jan 12 17:28:34 2014, Likun Wang
;       <Likun.Wang@noaa.gov>
;   Changed as vectorized form to handle arrays         
;		
;
;       Sun Feb 18 17:16:23 2007, Brian Larsen
;
;   added message call and remorved for loop in favor of total()
;
;       Wed Nov 5 22:06:11 2003, Brian Larsen
;
;   Written and finished
;
;-
FUNCTION dot, a, b
compile_opt strictarr

IF n_elements(a) NE n_elements(b) THEN $
    message, /ioerror, 'DOT(): the two vectors must have same number of elements'

IF n_elements(a)/3 NE n_elements(b)/3 THEN $
   message, /ioerror, 'DOT(): the two vectors must have same number of elements'



ans = total(a * b, 1)

return,  ans
END 
