; Copyright (C) 2011 Hiroki Horiuchi <https://github.com/x19290>
;
; Copying and distribution of this file, with or without modification,
; are permitted in any medium without royalty provided the copyright
; notice and this notice are preserved.  This file is offered as-is,
; without any warranty.
;
; see http://www.gnu.org/licenses/gpl-faq.html#WhatIfWorkIsShort
; and http://www.gnu.org/licenses/license-list.html#GNUAllPermissive

(define *base-frame (make-hash-table))

(define *base-env (list *base-frame))

(hash-table-put!
 *base-frame 'quote
 '(syntax
   (any-env s)
   s))

(hash-table-put!
 *base-frame 'if
 '(syntax
   (env pred on-true on-false)
   (if (*eval pred env) (*eval on-true env) (*eval on-false env))))

(hash-table-put!
 *base-frame 'cond
 '(macro
      cond-clauses
    (cond2if cond-clauses)))

(for-each
 (lambda (delegate)
   (hash-table-put!
    *base-frame delegate (eval delegate (interaction-environment))))
 '(car cdr cons eq? = + - print))

(hash-table-put!
 *base-frame '*define
 (lambda (var val) (hash-table-put! *base-frame var val)))
