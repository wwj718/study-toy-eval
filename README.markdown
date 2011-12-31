<!--
Copyright (C) 2011 Hiroki Horiuchi &lt;https://github.com/x19290&gt;

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.

see http://www.gnu.org/licenses/gpl-faq.html#WhatIfWorkIsShort
and http://www.gnu.org/licenses/license-list.html#GNUAllPermissive
!-->

This is a very simple Scheme like Lisp interpreter written in Gauche.
There is no tail call optimization, no `define-syntax`, etc.

<!--
For current github browser, it is not a good idea to make hyper refs
from README.markdown into the repository in which the file is included.
!-->

# study-toy-eval

## Contents

* eval.scm  
  eval and apply.
* base-env.scm  
  Basic environment to be passed to eval.
* t/*  
  Minimal tests. To run them, for example, do `gosh t/9all.scm`.

## Note

All names defined in eval.scm and base-env.scm are prefixed with *,
so use `*eval` instead of `eval`, for example.
