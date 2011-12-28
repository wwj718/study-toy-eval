<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC
	"-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
>
<!--
Copyright (C) 2011 Hiroki Horiuchi &lt;https://github.com/x19290&gt;

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.

see http://www.gnu.org/licenses/gpl-faq.html#WhatIfWorkIsShort
and http://www.gnu.org/licenses/license-list.html#GNUAllPermissive
!-->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja"><head
><link rev="made" href="."
/><link rel="stylesheet" href="shared.css"
/><link rel="contents" href="."
/><title>README</title></head><body
><h1>README</h1
><p
>This is a very simple Scheme like Lisp interpreter written in Gauche.
There is no tail call optimization, no first class continuation,
no &lsquo;define-syntax.&rsquo;</p
><dl
><dt id="eval"><a href="eval.scm">eval.scm</a></dt
><dd>eval and apply.</dd
><dt id="base-env"><a href="base-env.scm">base-env.scm</a></dt
><dd>Basic environment to pass to eval.</dd
><dt><a href="t/">t/*</a></dt
><dd>Tests. Run, for example, by &lsquo;gosh t/9all.scm&rsquo;</dd
></dl
><p
>All names defined in <a title="inner" href="#eval">eval.scm</a> and
<a title="inner" href="#base-env">base-env.scm</a> are prefixed with
&lsquo;*,&rsquo;
so use &lsquo;*eval&rsquo; instead of &lsquo;eval&rsquo;, for example.</p
></body></html>
