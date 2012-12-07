// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library parsers;

import 'package:persistent/persistent.dart';

final Option _none = new Option.none();
Option _some(x) => new Option.some(x);
Pair _pair(x, y) => new Pair(x, y);
final _nil = new LList.nil();
_cons(x) => (xs) => new LList.cons(x, xs);
_consStr(c) => (String cs) => "$c$cs";
LList _list2ll(List l) {
  LListBuilder result = new LListBuilder();
  for (final x in l) {
    result.add(x);
  }
  return result.build();
}
List _ll2list(LList ll) {
  List result = [];
  ll.foreach((x) { result.add(x); });
  return result;
}

class Parser<A> {
  final Function run;

  Parser(Option<Pair<A, String>> f(String)) : this.run = f;

  Object parse(String s) {
    Option<Pair<Object, String>> result = run(s);
    if (result.isDefined) return result.value.fst;
    else throw "parse error";
  }

  /// Monadic bind.
  Parser operator >>(Parser g(A x)) {
    return new Parser((s) {
      Option<Pair<A, String>> res = run(s);
      return res.isDefined
          ? g(res.value.fst).run(res.value.snd)
          : new Option.none();
    });
  }

  /// Applicative <*>
  Parser operator *(Parser p) => this >> (f) => p >> (x) => pure(f(x));

  /// Applicative *>
  Parser operator >(Parser p) => this >> (_) => p;

  /// Applicative <*
  Parser operator <(Parser p) => this >> (x) => p > pure(x);

  /// Functor map
  Parser map(Object f(A x)) => pure(f) * this;

  /// Infix syntax for map
  Parser operator ^(Object f(A x)) => map(f);

  /// Parser sequencing: creates a parser accumulator.
  ParserAccumulator2 operator +(Parser p) => new ParserAccumulator2(this, p);

  /// Alternative
  Parser operator |(Parser p) {
    return new Parser((s) {
      Option<Pair<A, String>> res = run(s);
      return res.isDefined
          ? res
          : p.run(s);
    });
  }

  // Derived combinators, defined here for infix notation

  Parser orElse(A value) => this | pure(value);

  Parser<List> get many => _many.map(_ll2list);
  Parser<LList> get _many =>
      // eta-expansion required to prevent infinite loop
      (pure(_cons) * this * new Parser((s) => this._many.run(s)))
      .orElse(_nil);

  Parser<List> get many1 => _many1.map(_ll2list);
  Parser<LList> get _many1 =>
      // eta-expansion required to prevent infinite loop
      pure(_cons) * this * new Parser((s) => this._many.run(s));

  Parser<List> sepBy(Parser sep) => sepBy1(sep).orElse([]);

  Parser<List> sepBy1(Parser sep) => _sepBy1(sep).map(_ll2list);
  Parser<LList> _sepBy1(Parser sep) => pure(_cons) * this * (sep > this)._many;

  Parser<List> endBy(Parser sep) => (this < sep).many;

  Parser<List> endBy1(Parser sep) => (this < sep).many1;

  Parser chainl(Parser sep, defaultValue) => chainl1(sep) | pure(defaultValue);

  Parser chainl1(Parser sep) {
    rest(acc) => (sep >> (f) => this >> (x) => rest(f(acc,x)))
                | pure(acc);
    return this >> rest;
  }
}

class ParserAccumulator2 {
  final Parser p1, p2;
  ParserAccumulator2(this.p1, this.p2);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator3 operator +(Parser p) => new ParserAccumulator3(p1, p2, p);

  /// Action application
  Parser operator ^(Object f(x1, x2)) =>
      pure((x1) => (x2) => f(x1, x2)) * p1 * p2;
}

class ParserAccumulator3 {
  final Parser p1, p2, p3;
  ParserAccumulator3(this.p1, this.p2, this.p3);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator4 operator +(Parser p) =>
      new ParserAccumulator4(p1, p2, p3, p);

  /// Action application
  Parser operator ^(Object f(x1, x2, x3)) =>
      pure((x1) => (x2) => (x3) => f(x1, x2, x3)) * p1 * p2 * p3;
}

class ParserAccumulator4 {
  final Parser p1, p2, p3, p4;
  ParserAccumulator4(this.p1, this.p2, this.p3, this.p4);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator5 operator +(Parser p) =>
      new ParserAccumulator5(p1, p2, p3, p4, p);

  /// Action application
  Parser operator ^(Object f(x1, x2, x3, x4)) =>
      pure((x1) => (x2) => (x3) => (x4) => f(x1, x2, x3, x4))
      * p1 * p2 * p3 * p4;
}

class ParserAccumulator5 {
  final Parser p1, p2, p3, p4, p5;
  ParserAccumulator5(this.p1, this.p2, this.p3, this.p4, this.p5);

  /// Action application
  Parser operator ^(Object f(x1, x2, x3, x4, x5)) =>
      pure((x1) => (x2) => (x3) => (x4) => (x5) => f(x1, x2, x3, x4, x5))
      * p1 * p2 * p3 * p4 * p5;
}

// Primitive parsers

final Parser fail = new Parser((s) => _none);

final Parser empty = new Parser((s) => _some(_pair(null, s)));

Parser pure(value) => new Parser((s) => _some(_pair(value, s)));

final Parser eof = new Parser((s) => s.isEmpty ? _some(_pair(null, s)) : _none);

Parser pred(bool p(String char)) {
  return new Parser((String s) {
    if (s.isEmpty) return _none;
    else {
      String c = s[0];
      return p(c) ? _some(_pair(c, s.substring(1))) : _none;
    }
  });
}

// Util

rec(f) => new Parser((s) => f().run(s));

// Derived combinators

Parser char(String chr) => pred((c) => c == chr);

Parser string(String str) =>
    str.isEmpty
        ? pure('')
        : pure(_consStr) * char(str[0]) * string(str.substring(1));

Parser _choice(LList<Parser> ps) =>
    ps.isNil() ? fail : ps.elem | _choice(ps.tail);

Parser choice(List<Parser> ps) => _choice(_list2ll(ps));

// Derived character parsers

final Parser<String> anyChar = pred((c) => true);

Parser<String> oneOf(String chars) => pred((c) => chars.contains(c));

Parser<String> noneOf(String chars) => pred((c) => !chars.contains(c));

final _spaces = " \t\n";
final _lower = "abcdefghijklmnopqrstuvwxyz";
final _upper = _lower.toUpperCase();
final _alpha = "$_lower$_upper";
final _digit = "1234567890";
final _alphanum = "$_alpha$_digit";

final Parser<String> tab = char('\t');

final Parser<String> newline = char('\n');

final Parser<String> space = oneOf(_spaces);

final Parser spaces = space.many > pure(null);

final Parser<String> upper = oneOf(_upper);

final Parser<String> lower = oneOf(_lower);

final Parser<String> alphanum = oneOf(_alphanum);

final Parser<String> letter = oneOf(_alpha);

final Parser<String> digit = oneOf(_digit);
