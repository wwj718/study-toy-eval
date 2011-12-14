(use util.match)

(define *keywords (make-hash-table))

(hash-table-put!
 *keywords 'quote '(
 (_ form)
 form))
 
(hash-table-put!
 *keywords 'if '(
 (env pred on-true on-false)
 (if (*eval pred env) (*eval on-true env) (*eval on-false env))))

(define (*eval-pair car cdr env)
  (cond
   ((eq? car 'lambda) (cons 'closure (cons env cdr)))
  (else
   (guard
    (_
     (else
      (*apply
       (*eval car env)
       (map (lambda (arg) (*eval arg env)) cdr))))
    (*try-special car cdr env)))))

(define (*try-special car cdr env)
  (define (trigger) (list 'quote (cons env cdr)))
  (define (clauses) (hash-table-get *keywords car))
  (eval
   (list 'match (trigger) (clauses))
   (interaction-environment)))

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
   (lambda (x)
     (for-each
      (lambda (frame)
	(if (not (hash-table? frame)) (*error frame "broken data: frame"))
	(guard (_ (else)) (x (hash-table-get frame var))))
      env)
     (*error var "unbound"))))

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

(define (*error a b)
  (error "*MINIEVAL*" a b))

(define *base-frame (make-hash-table))

(hash-table-put! *base-frame 'car car)
(hash-table-put! *base-frame 'cdr cdr)
(hash-table-put! *base-frame 'cons cons)
(hash-table-put! *base-frame 'eq? eq?)
(hash-table-put! *base-frame '= =)
(hash-table-put! *base-frame '+ +)
(hash-table-put! *base-frame '- -)
(hash-table-put! *base-frame 'print print)

(hash-table-put!
 *base-frame '*define
 (lambda (var val) (hash-table-put! *base-frame var val)))

(define *base-env (list *base-frame))
