#?=(*eval '(if #t (car '(car . cdr)) (car ())) *base-env)
#?=(guard
    (_ (else 'caught))
    (*eval '(if #f (car '(car . cdr)) (car ())) *base-env))
