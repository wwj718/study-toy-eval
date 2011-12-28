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
There is no tail call optimization, no first class continuation,
no `define-syntax`

<dl
><dt>[eval.scm][]</dt
><dd>eval and apply.</dd
><dt>[base-env.scm][]</dt
><dd>Basic environment to pass to eval.</dd
><dt>[t/*]</a></dt
><dd>Tests. Run, for example, by `gosh t/9all.scm`</dd
></dl
>

[eval.scm]: /study-toy-eval/blob/master/eval.scm
[base-env.scm]: /study-toy-eval/blob/master/base-env.scm
[t/*]: /study-toy-eval/blob/master/t/

All names defined in [eval.scm][] and [base-env.scm][] are prefixed with `*,`
so use `*eval` instead of `eval`, for example.

