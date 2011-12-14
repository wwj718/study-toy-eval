(use util.match)

(define (*eval form env)
  (cond
   ((*literal? form) form)
   ((symbol? form) (*binding form env))
   ((pair? form) (*eval-pair form env))
   (else (*error form "syntax: bad form"))))

(define (*literal? form)
  (or
   (null? form)
   (boolean? form)
   (number? form)))

(define (*binding var env)
  (cond
   ((null? env) (*error env "no more frame"))
   ((not (pair? env)) (*error env "broken data: env"))
   (else
    (let ((frame (car env)))
      (if (not (hash-table? frame)) (error frame "broken data: frame"))
      (guard
       (_
	(else
	 (*binding var (cdr env))))
       (hash-table-get frame var))))))

(define (*eval-pair form env)
  (match
   form
   (('lambda params body . _)
    (list 'closure env params body))
   (_
    (*apply form env))))

(define (*null-or-pair? s)
  (or (null? s) (pair? s)))

(define (*apply form env)
  (match
   form
   ((func . args)
    (match
     (*eval func env)
     ((func-tag . func-body)
      (let ((args2 (*eval-args-or-not func-tag args env)))
	(match
	 func-tag
	 ('closure (*apply-closure func-body args2))
	 ('special (apply func-body (list args env)))
	 ((or 'misc 'primitive)
	  (apply func-body args2))
	(_ (*error func-tag "syntax: broken func-tag")))))
     (_ (*error func "syntax: broken func"))))
   (_ (*error form "syntax: broken application"))))

(define (*eval-args-or-not func-tag args env)
  (match
   func-tag
   ((or 'special 'misc) args)
   (_  (*eval-args args env))))

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

(define (*eval-args args env)
  (map (lambda (var) (*eval var env)) args))

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

(define (*error s m)
  (error "*MINIEVAL*" s m))

(define *base-funcs
  (let
      ((e (interaction-environment))
       (frame (make-hash-table)))
    (for-each
     (lambda (name)
       (hash-table-put! frame name (cons 'primitive (eval name e))))
     '(car cdr cons eq? pair? = + - print))
    frame))

(define *base-misc
  (let ((frame (make-hash-table)))
    (hash-table-put! frame 'quote (cons 'misc identity))
    frame))

(define *base-specials
  (let ((frame (make-hash-table)))
    (hash-table-put!
     frame
     'if
     (cons
      'special
      (lambda (args env)
	(match
	 args
	 ((pred t f) (if (*eval pred env) (*eval t env) (*eval f env)))
	 (_ (*error args "syntax: if"))))))
    (hash-table-put!
     frame
     'define
     (cons
      'special
      (lambda (args env)
	(match
	 args
	 ((name expression)
	  (hash-table-put! *base-user name (*eval expression env)))
	 (_ (*error args "syntax: define"))))))
    frame))

(define *base-user (make-hash-table))

(define *base-env (list *base-user *base-funcs *base-misc *base-specials))
