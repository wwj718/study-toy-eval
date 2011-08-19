(use srfi-17)

(define globals (make-hash-table))

(define (*eval form env)
  (cond
   ((eq? 'else form) #t)
   ((or (null? form) (eq? (class-of form) <boolean>))
    form)
   ((pair? form)
    (eval-pair form env))
   ((symbol? form)
    (binding form env))
   (else
    (error "unknown atom"))))

(define (eval-pair form env)
  (let ((ar (car form)) (dr (cdr form)))
    (cond
     ((eq? 'quote ar) (cadr form))
     ((eq? 'cond ar) (eval-cond dr env))
     ((eq? 'define ar) (eval-define dr env))
     ((eq? 'lambda ar) form)
     (else
      (*apply
       (if (symbol? ar) (binding ar env) ar)
       (cdr form)
       env)))))

(define (binding symbol env)
  (cond
   ((null? env) undef)
   (else
    (let ((got (hash-table-get (car env) symbol undef)))
      (if (eq? undef got) (binding symbol (cdr env)) got)))))

(define (eval-cond clauses env)
  (cond
   ((null? clauses) undef)
   ((*eval (caar clauses) env)
    (progn (cdar clauses) env))
   (else
    (eval-cond (cdr clauses) env))))

(define (progn forms env)
  (cond
   ((null? forms) undef)
   ((null? (cdr forms))
    (*eval (car forms) env))
   (else
    (*eval (car forms) env)
    (progn (cdr forms) env))))

(define (*apply lambda args env)
  (let ((new-env (build-env args env)))
    (progn (cddr lambda) new-env)))

(define (build-env args env)
  (let ((pad (make-hash-table)) (car-args #f))
    (cond
     ((null? args) (cons pad env))
     (else
      (set! car-args (car args))
      (hash-table-put! pad car-args (*eval car-args env))
      (build-env (cdr args) env)))))

(*eval 'a ())
