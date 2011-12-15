(use util.match)

(define (*eval-pair *car *cdr env)
  (call/cc
   (lambda (return)
     (if (eq? *car 'lambda) (return (cons 'closure (cons env *cdr))))
     (let ((ecar (*eval *car env)))
       (if
	(symbol? *car)
	(match
	 ecar
	 (('syntax pattern clauses)
	  (return (*eval-syntax pattern clauses *cdr env)))
	 (('macro pattern clauses)
	  (return (*eval-macro pattern clauses *cdr env)))
	 (_ 'any)))
       (*apply ecar (map (lambda (arg) (*eval arg env)) *cdr))))))

(define (*eval-syntax pattern clauses cdr env)
  (define (trigger) (list 'quote (cons env cdr)))
  (eval
   (list 'match (trigger) (list pattern clauses))
   (interaction-environment)))

(define (*eval-macro pattern clauses cdr env)
  (list 'macro pattern clauses cdr env))

(define (*apply func args)
  (cond
   ((or (subr? func) (closure? func)) (apply func args))
   (else (*apply-closure (cdr func) args))))

(define (*apply-closure func-body args)
  (call-with-values
      (lambda ()
	(match
	 func-body
	 (((? *null-or-pair? env) params form)
	  (values env params form))
	 (_ (*error func-body "syntax: broken func-body"))))
    (lambda (env params form)
      (*eval form (cons (*frame (make-hash-table) params args) env)))))

(define (*null-or-pair? s)
  (or (null? s) (pair? s)))

(define (*frame frame params args)
  (cond
   ((null? params)
    (cond
     ((null? args) frame)
     (else
      (*error args "syntax: broken args"))))
   ((symbol? params)
    (hash-table-put! frame params args)
    frame)
   ((pair? params)
    (cond
     ((pair? args)
      (hash-table-put! frame (car params) (car args))
      (*frame frame (cdr params) (cdr args)))
     (*error args "syntax: broken args")))
   (else
    (*error params "syntax: broken params"))))

(define (*eval form env)
  (match
   form
   ((car . cdr) (*eval-pair car cdr env))
   ((? *literal? _) form)
   (_ (*binding form env))))

(define (*literal? form)
  (or
   (null? form)
   (boolean? form)
   (number? form)))

(define (*binding var env)
  (call/cc
   (lambda (return)
     (for-each
      (lambda (frame)
	(if (not (hash-table? frame)) (*error frame "broken data: frame"))
	(guard (_ (else)) (return (hash-table-get frame var))))
      env)
     (*error var "unbound"))))

(define *error
  (lambda x
    (apply error (cons "*MINIEVAL*" x))))

(load "./base-env.scm")
