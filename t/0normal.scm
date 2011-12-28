; Copyright (C) 2011 Hiroki Horiuchi <https://github.com/x19290>
;
; Copying and distribution of this file, with or without modification,
; are permitted in any medium without royalty provided the copyright
; notice and this notice are preserved.  This file is offered as-is,
; without any warranty.
;
; see http://www.gnu.org/licenses/gpl-faq.html#WhatIfWorkIsShort
; and http://www.gnu.org/licenses/license-list.html#GNUAllPermissive

#?=(*eval () *base-env)
#?=(*eval #f *base-env)
#?=(*eval 123 *base-env)
;#?=(*eval 'quote *base-env)
#?=(*eval ''quote *base-env)
#?=(*eval (car (cons 1 2)) *base-env)
#?=(*eval '((lambda (x) (cons x x)) 456) *base-env)
#?=(*eval '(if #t (car '(car . cdr)) (car ())) *base-env)
;#?=(*eval '(if #f (car '(car . cdr)) (car ())) *base-env)
(*eval '(*define 'snoc (lambda (cdr car) (cons car cdr))) *base-env)
#?=(*eval '(snoc 1 2) *base-env)
(*eval '(*define 'list (lambda x x)) *base-env)
#?=(*eval '(list (cons 1 1) (cons 2 2)) *base-env)
