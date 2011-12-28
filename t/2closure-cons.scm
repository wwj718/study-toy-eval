; Copyright (C) 2011 Hiroki Horiuchi <https://github.com/x19290>
;
; Copying and distribution of this file, with or without modification,
; are permitted in any medium without royalty provided the copyright
; notice and this notice are preserved.  This file is offered as-is,
; without any warranty.
;
; see http://www.gnu.org/licenses/gpl-faq.html#WhatIfWorkIsShort
; and http://www.gnu.org/licenses/license-list.html#GNUAllPermissive

(*eval
 '(
   (lambda (*cons *car *cdr)
     (
      (lambda (pair)
	(cons
	 (print (*car pair))
	 (print (*cdr pair))))
      (*cons 1 2)))
   (lambda (car cdr) (lambda (get-car) (if get-car car cdr)))
   (lambda (which) (which #t))
   (lambda (which) (which #f)))
 *base-env)
