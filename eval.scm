(define undef (if #f #f))

(define globals (make-hash-table))

(define dummy-env (cons globals ()))

(define dummy-env
  (let ((pad #f))
    (set! pad (make-hash-table))
    (hash-table-put! pad 'x 123)
    (cons pad dummy-env)))

(define built-in '(cons))

(dolist
 (symbol built-in)
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
       ((eq? 'quote xcar) (car xcdr))
       ((eq? 'cond xcar) (eval-cond xcdr env))
       (else
	(*apply
	 (*eval xcar env)
	 (args xcdr env))))))))

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
  (let* ((clause (car clauses)) (clauses (cdr clauses)) (p (car clause)))
     (cond
      ((if
	(eq? 'else p)
	(if (null? clauses) #t (error "else and more"))
	(*eval p env))
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

(define (make-pad params values)
  (define
    (make-pad-iter pad params values)
    (cond
     ((null? params) pad)
     (else
      (hash-table-put! pad (car params) (car values))
      (make-pad-iter pad (cdr params) (cdr values)))))
  (make-pad-iter (make-hash-table) params values))

(define (make-closure lambda-form env)
  (cons 'closure (cons lambda-form env)))
