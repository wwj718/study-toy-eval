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
