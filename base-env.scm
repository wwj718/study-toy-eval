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
