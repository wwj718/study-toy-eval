(use util.match)

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

(define (*eval-pair *car *cdr env)
  ; internal functions below all use closure variables directly or indirectly.
  (define (make-closure)
    (cons 'closure (cons env *cdr)))
  (define (evaluated-args)
    (map (lambda (arg) (*eval arg env)) *cdr))
  (define (choose-special-form-handler selector)
    (match
     selector
     ('syntax syntax-handler)
     ('macro macro-handler)
     (_ #f)))
  (define (syntax-handler pattern clauses)
    (define (trigger) (list 'quote (cons env *cdr)))
    (eval
     (list 'match (trigger) (list pattern clauses))
     (interaction-environment)))
  (define (macro-handler pattern clauses)
    (list 'macro pattern clauses cdr env))
  ; (call/cc (lambda (return) ... (if ... (return ...)) ...))
  ; is an idiom simulating a `return short cut.'
  (call/cc
   (lambda (return)
     (if (eq? *car 'lambda) (return (make-closure)))
     (let ((ecar (*eval *car env)))
       ; apply if
       ; *car is not a symbol or
       ; *car is a symbol but ecar does not match the special form pattern.
       ; i used a `return' because i did not want to repeat apply calles.
       (if
	(symbol? *car)
	(match
	 ecar
	 (((= choose-special-form-handler handler) pattern clauses)
	  (return (handler pattern clauses)))
	 (_ "not an error. proceed to the *apply call")))
       (*apply ecar (evaluated-args))))))

(define (*apply func args)
  (cond
   ((or (subr? func) (closure? func)) (apply func args))
   (else (*apply-closure (cdr func) args))))

(define (*apply-closure func-body args)
  (define (parse-func-body)
    (match
     func-body
     (((? *null-or-pair? env) params form)
      (values env params form))
     (_ (*error func-body "syntax: broken func-body"))))
  (define (grown-env env params)
    (cons
     (*frame params args)
     env))
  (call-with-values parse-func-body
    (lambda (env params form)
      (*eval form (grown-env env params)))))

(define (*null-or-pair? s)
  (or (null? s) (pair? s)))

(define (*frame params args)
  (let ((frame (make-hash-table)))
    (define (iter params args)
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
	  (iter (cdr params) (cdr args)))
	 (else
	  (*error args "syntax: broken args"))))
       (else
	(*error params "syntax: broken params"))))
    (iter params args)))

(define *error
  (lambda x
    (apply error (cons "*MINIEVAL*" x))))

(load "./base-env.scm")
