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
(*eval '(cons 1 2) dummy-env)
(*eval '
 (
  (lambda (x) x)
  123)
 dummy-env
)
(*eval '((lambda (x) x) 1) ())
(*eval '((lambda (x y) (cons x y)) 1 2) dummy-env)
(
	(
		(lambda (x) (lambda () x))
		#t
	)
)
