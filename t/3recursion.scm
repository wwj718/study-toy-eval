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
 '(*define 'add (lambda (x y) (if (= x 0) y (+ (add (- x 1) y) 1))))
 *base-env)

#?=(*eval '(add 3 4) *base-env)
