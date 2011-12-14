(use util.match)

(define *keywords (make-hash-table))

(hash-table-put!
 *keywords 'quote '(
 (form)
 form))
 
(hash-table-put!
 *keywords 'if '(
 (pred on-true on-false)
 (if (*eval pred) (*eval on-true) (*eval on-false))))

(define (*eval-pair car cdr)
  (guard
   (ex
    (else (*apply (*eval car) '(dummy-args))))
   (*try-special car cdr)))

(define (*try-special car cdr)
  (define (quoted-expression) (list 'quote cdr))
  (define (clauses) (hash-table-get *keywords car))
  (eval
   (list 'match (quoted-expression) (clauses))
   (interaction-environment)))

(define (*eval form)
  (match
   form
   ((car . cdr) (*eval-pair car cdr))
   ((or (? null? _) (? number? _)) form)
   (_ 'dummy-value)))

(define (*apply func args)
  (cons '*apply (cons func args)))

#?=(*eval ''abc)
#?=(*eval '(if *pred* *on-true* *on-false*))
#?=(*eval 123)
#?=(*eval '(car))
