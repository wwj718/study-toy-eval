(define undef (if #f #f))

(define dummy-pad (make-hash-table))
(hash-table-put! dummy-pad 'x 123)
(define dummy-env (cons dummy-pad ()))

(define (*eval form env)
  (cond
   ((or (null? form) (boolean? form) (number? form)) form)
   ((symbol? form) (binding form env))
   ((pair? form) (eval-pair (car form) (cdr form) env))
   (else
    (error "unknown atom"))))

(define (binding symbol env)
  (cond
   ((null? env))
   (else
    (let ((pad (car env)))
      (let ((got (hash-table-get pad symbol)))
	(cond
	 ((eq? undef got)
	  (binding symbol (cdr env)))
	 (else
	  got)))))))

(define (eval-pair xcar xcdr env)
  (cond
   ((eq? 'quote xcar) (car xcdr))
   ((eq? 'cond xcar) (eval-cond xcdr env))
   ((eq? 'lambda xcar) (make-closure xcdr env))
   (*apply
    (if (symbol? xcar) (binding xcar) xcar)
    (args xcdr env))))

(define (progn forms env)
  (cond
   ((null? forms))
   (else
    (let ((xcar (car forms)) (xcdr (cdr forms)))
      (cond
       ((null? xcdr) (*eval xcar env))
       (else
	(*eval xcar env)
	(progn xcdr env)))))))

(define (eval-cond clauses env)
  (cond
   ((null? clauses))
   (else
    (eval-cond-body clauses env))))

(define (eval-cond-body clauses env)
   (let* (
	 (clause (car clauses)) (clauses (cdr clauses)) (p (car clause)))
     (cond
      ((or (eq? 'else p) (*eval p env)) (progn (cdr clause) env))
      ((null? clauses))
      (eval-cond-body clauses env))))
      
(define (*apply function args)
  (print "stub apply"))

(define (make-closure spec env)
  (print "stub make-closure"))

(*eval () ())
(*eval #t ())
(*eval #f ())
(*eval 'x dummy-env)
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

