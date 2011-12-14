(*eval
 '(*define 'add (lambda (x y) (if (= x 0) y (+ (add (- x 1) y) 1))))
 *base-env)

#?=(*eval '(add 3 4) *base-env)
