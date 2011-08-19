(define (*eval form env)
  (cond
   ((or (null? form) (boolean? form)) form)
   ((symbol? form) (binding form env))
   ((pair? form) (eval-pair (car form) (cdr form) env))
   (else
    (error "unknown atom"))))

(define (binding symbol env)
  (print "stub binding"))

(define (eval-pair xcar xcdr env)
  (cond
   ((eq? 'quote xcar) (car xcdr))
   ((eq? 'cond xcar) (eval-cond xcdr env))
   ((eq? 'lambda xcar) (make-closure xcdr env))
   (*apply
    (if (symbol? xcar) (binding xcar) xcar)
    (args xcdr env))))

(define (eval-cond clauses env)
  (print "stub eval-cond"))

(define (*apply function args)
  (print "stub apply"))

(define (make-closure spec env)
  (print "stub make-closure"))

(*eval () ())
(*eval #t ())
(*eval #f ())
(*eval 'x ())
(*eval ''quoted ())
(*eval '(cond) ())
(*eval '(cond (#f ...)) ())
(*eval
 '(cond
   (#f ...)
   (else #f #t))
 ())
(*eval
 '(cond
   (#f ...)
   (else #f #t)
   (#t ...))
 ())
(*eval
	(
		(
			(lambda (x) (lambda () x))
			#t
		)
	)
	()
))
	)
		;()
	)
	;()
	(ineraction-environment)
)

