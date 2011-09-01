(load "./eval.scm")
(load "./application.scm")
(*eval () ())
(*eval #t ())
(*eval #f ())
(*eval 'x dummy-env)
(*eval ''quoted ())
(*eval '(cond) ())
(*eval '(cond (#f ...)) ())
(*eval
 '(cond
   (else #f #t))
 ()
)
(*eval
 '(cond
   (#f ...)
   (else #f #t))
 ()
)
(*eval
 '(cond
   (#f ...)
   (#t #f #t)
   (#t ...))
 ()
)
(*eval ; error expected
 '(cond
   (else)
   (#t 123))
 ()
)
(*eval '(lambda ()) dummy-env)
(*eval
 '(
   (lambda (x) #f #t)
   123)
 dummy-env
)
(*eval '
 (
  (lambda (x) x)
  123)
 dummy-env
)
(*eval '((lambda (x) x) 1) ())

(*eval '(car '(a)) dummy-env)
(*eval '(cdr '(a)) dummy-env)
(*eval '(cons 1 2) dummy-env)
(*eval '(eq? 'a 'a) dummy-env)
(*eval '(eq? 'a 'b) dummy-env)
(*eval '(null? ()) dummy-env)
(*eval '(null? 'a) dummy-env)
(*eval '(boolean? #t) dummy-env)
(*eval '(boolean? ()) dummy-env)
(*eval '(number? 0) dummy-env)
(*eval '(number? ()) dummy-env)

(*eval
 '(define *cons
    (lambda (x y)
      (lambda (get-car)
	(cond
	 (get-car x)
	 (else y)))))
 dummy-env)

(*eval
 '(define *car (lambda (z) (z #t)))
 dummy-env)

(*eval
 '(define *cdr (lambda (z) (z #f)))
 dummy-env)

(*eval
 '(*car (*cons 1 2))
 dummy-env)

(*eval
 '(*cdr (*cons 1 2))
 dummy-env)
