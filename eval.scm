(define undef (if #f #f))

(define globals (make-hash-table))

(define dummy-env (cons globals ()))

(define (make-pad params values)
  (define
    (make-pad-iter pad params values)
    (cond
     ((null? params) pad)
     (else
      (hash-table-put! pad (car params) (car values))
      (make-pad-iter pad (cdr params) (cdr values)))))
  (make-pad-iter (make-hash-table) params values))

(define dummy-env
  (cons (make-pad '(x) '(123)) dummy-env))

(define delegate '(car cdr cons eq? boolean? number?))

(dolist
 (symbol delegate)
 (hash-table-put!
  globals symbol
  (cons 'delegate (eval symbol (interaction-environment)))))

(define (*eval form env)
  (cond
   ((or (null? form) (boolean? form) (number? form)) form)
   ((symbol? form) (binding form env))
   ((pair? form) (eval-pair (car form) form env))
   (else
    (error "unknown atom"))))

(define (binding symbol env)
  (cond
   ((null? env) undef)
   (else
    (let ((pad (car env)))
      (let ((got (hash-table-get pad symbol undef)))
	(cond
	 ((eq? undef got)
	  (binding symbol (cdr env)))
	 (else
	  got)))))))

(define (eval-pair xcar form env)
  (cond
   ((eq? 'lambda xcar) (make-closure form env))
   (else
    (let ((xcdr (cdr form)))
      (cond
       ((eq? 'define xcar) (*define (car xcdr) (cadr xcdr) env))
       ((eq? 'quote xcar) (car xcdr))
       ((eq? 'cond xcar) (eval-cond xcdr env))
       (else
	(*apply
	 (*eval xcar env)
	 (args xcdr env))))))))

(define (*define symbol form env)
  (hash-table-put! globals symbol (*eval form env))
  symbol)

(define (args xargs env)
  (cond
   ((null? xargs) ())
   (else
    (cons (*eval (car xargs) env) (args (cdr xargs) env)))))

(define (progn forms env)
  (cond
   ((null? forms) undef)
   (else
    (let ((xcar (car forms)) (xcdr (cdr forms)))
      (cond
       ((null? xcdr) (*eval xcar env))
       (else
	(*eval xcar env)
	(progn xcdr env)))))))

(define (eval-cond clauses env)
  (cond
   ((null? clauses) undef)
   (else
    (eval-cond-body clauses env))))

(define (eval-cond-body clauses env)
  (let* ((clause (car clauses)) (clauses (cdr clauses)) (pred (car clause)))
     (cond
      ((if
	(eq? 'else pred)
	(if (null? clauses) #t (error "else and more"))
	(*eval pred env))
       (progn (cdr clause) env))
      ((null? clauses) undef)
      (else (eval-cond-body clauses env)))))
 
(define (*apply function args)
  (let ((xcar (car function)))
    (cond
     ((eq? xcar 'delegate)
      (apply (cdr function) args))
     (else
      (let*
	  ((xcdr (cdr function))
	   (lambda (car xcdr))
	   (env
	    (cons
	     (make-pad (cadr lambda) args)
	     (cdr xcdr)))) ; old env
	(progn (cddr lambda) env))))))

(define (make-closure lambda-form env)
  (cons 'closure (cons lambda-form env)))

(define *cons
  (lambda (x y)
    (lambda (get-car)
      (cond
       (get-car x)
       (else y)))))

(define *car (lambda (z) (z #t)))
(define *cdr (lambda (z) (z #f)))
