// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library parsers;

import 'package:persistent/persistent.dart';
import 'dart:math';

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

List _sort(List l, Comparator c) {
  List res = new List.from(l);
  res.sort(c);
  return res;
}

String _strHead(String s) => s[0];
String _strTail(String s) => s.substring(1);

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

  /**
   * Parses without consuming any input.
   *
   * Used for defining followedBy, which is probably what you're looking for.
   */
  Parser get lookAhead {
    return new Parser((s) {
      Option<Pair<A, String>> res = run(s);
      return res.isDefined
          ? _some(_pair(res.value.fst, s))
          : res;
    });
  }

  /**
   * Succeeds if and only if [this] succeeds and [p] succeeds on what remains to
   * parse without cosuming it.
   *
   *     string("let").followedBy(space)
   */
  Parser followedBy(Parser p) => this < p.lookAhead;

  /**
   * Fails if and only if [this] succeeds on what's ahead.
   *
   * Used for defining notFollowedBy, which is probably what you're looking for.
   */
  Parser get notAhead {
    return new Parser((s) {
      Option<Pair<A, String>> res = run(s);
      return res.isDefined
          ? _none
          : _some(_pair(null, s));
    });
  }

  /**
   * Succeeds if and only if [this] succeeds and [p] fails on what remains to
   * parse.
   *
   *     string("let").notFollowedBy(alphanum)
   */
  Parser notFollowedBy(Parser p) => this < p.notAhead;

  /**
   * Parses [this] 0 or more times until [end] succeeds.
   *
   * Returns the list of values returned by [p]. It is useful for parsing
   * comments.
   *
   *     string('/*') > anyChar.manyUntil(string('*/'))
   *
   * The input consumed by [p] is consumed. Use [:p.lookAhead:] if you don't
   * want this.
   */
  Parser<List> manyUntil(Parser end) {
    // Imperative version to avoid stack overflows.
    return new Parser((s) {
      List res = [];
      String tape = s;
      while(true) {
        final mend = end.run(tape);
        if (mend.isDefined) {
          return _some(_pair(res, mend.value.snd));
        } else {
          final mx = this.run(tape);
          if (mx.isDefined) {
            res.add(mx.value.fst);
            tape = mx.value.snd;
          } else {
            return _none;
          }
        }
      }
    });
  }

  // Derived combinators, defined here for infix notation

  Parser orElse(A value) => this | pure(value);

  Parser<Option> get maybe => this.map(_some).orElse(_none);


  // Imperative version to avoid stack overflows. !Side effect on acc!
  Parser<List> _many(List acc) {
    return new Parser((s) {
      String tape = s;
      while(true) {
        Option<Pair<A, String>> o = this.run(tape);
        if (o.isDefined) {
          acc.add(o.value.fst);
          tape = o.value.snd;
        } else {
          return _some(_pair(acc, tape));
        }
      }
    });
  }

  Parser<List> get many => _many([]);

  Parser<List> get many1 => this >> (x) => _many([x]);

  /**
   * Parses [this] zero or more time, skipping its result.
   *
   * Equivalent to [:this.many > pure(null):] but more efficient.
   */
  Parser get skipMany {
    // Imperative version to avoid stack overflows.
    return new Parser((s) {
      String tape = s;
      while(true) {
        Option<Pair<A, String>> o = this.run(tape);
        if (o.isDefined) {
          tape = o.value.snd;
        } else {
          return _some(_pair(null, tape));
        }
      }
    });
  }

  /**
   * Parses [this] one or more time, skipping its result.
   *
   * Equivalent to [:this.many1 > pure(null):] but more efficient.
   */
  Parser get skipMany1 => this > this.skipMany;

  Parser<List> sepBy(Parser sep) => sepBy1(sep).orElse([]);

  Parser<List> sepBy1(Parser sep) => this >> (x) => (sep > this)._many([x]);

  Parser<List> endBy(Parser sep) => (this < sep).many;

  Parser<List> endBy1(Parser sep) => (this < sep).many1;

  /**
   * Parses zero or more occurences of [this] separated and optionally ended
   * by [sep].
   */
  Parser<List> sepEndBy(Parser sep) => sepEndBy1(sep).orElse([]);

  /**
   * Parses one or more occurences of [this] separated and optionally ended
   * by [sep].
   */
  Parser<List> sepEndBy1(Parser sep) => sepBy1(sep) < sep.maybe;

  Parser chainl(Parser sep, defaultValue) => chainl1(sep) | pure(defaultValue);

  Parser chainl1(Parser sep) {
    rest(acc) {
      var res = acc;
      return new Parser((s) {
        String tape = s;
        while(true) {
          final newres = (pure((f) => (x) => f(res, x)) * sep * this).run(tape);
          if (newres.isDefined) {
            res = newres.value.fst;
            tape = newres.value.snd;
          } else {
            return _some(_pair(res, tape));
          }
        }
      });
    }
    return this >> rest;
  }

  /// Warning: may lead to stack overflows.
  Parser chainr(Parser sep, defaultValue) => chainr1(sep) | pure(defaultValue);

  /// Warning: may lead to stack overflows.
  Parser chainr1(Parser sep) {
    rest(x) => pure((f) => (y) => f(x, y)) * sep * chainr1(sep)
             | pure(x);
    return this >> rest;
  }

  Parser<A> between(Parser left, Parser right) => left > (this < right);
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
      String c = _strHead(s);
      return p(c) ? _some(_pair(c, _strTail(s))) : _none;
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
        : pure(_consStr) * char(_strHead(str)) * string(_strTail(str));

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

class ReservedNames {
  Map<String, Parser<String>> _map;
  ReservedNames._(this._map);
  Parser<String> operator[](String key) {
    final res = _map[key];
    if (res == null) throw "$key is not a reserved name";
    else return res;
  }
}

/// Programming language specific combinators
class LanguageParsers {
  String _commentStart;
  String _commentEnd;
  String _commentLine;
  bool _nestedComments;
  Parser<String> _identStart;
  Parser<String> _identLetter;
  Set<String> _reservedNames;
  bool _caseSensitive;

  ReservedNames _reserved;

  LanguageParsers({
    String         commentStart   : '/*',
    String         commentEnd     : '*/',
    String         commentLine    : '//',
    bool           nestedComments : false,
    Parser<String> identStart     : null, // letter | char('_')
    Parser<String> identLetter    : null, // alphanum | char('_')
    List<String>   reservedNames  : const []
  }) {
    final identStartDefault = letter | char('_');
    final identLetterDefault = alphanum | char('_');

    _commentStart = commentStart;
    _commentEnd = commentEnd;
    _commentLine = commentLine;
    _nestedComments = nestedComments;
    _identStart = (identStart == null) ? identStartDefault : identStart;
    _identLetter = (identLetter == null) ? identLetterDefault : identLetter;
    _reservedNames = new Set<String>.from(reservedNames);
  }

  Parser<String> get semi => symbol(';');
  Parser<String> get comma => symbol(',');
  Parser<String> get colon => symbol(':');
  Parser<String> get dot => symbol('.');

  Parser<String> get _ident =>
      pure((c) => (cs) => _consStr(c)(Strings.concatAll(cs)))
      * _identStart
      * _identLetter.many;

  Parser<String> get identifier =>
      lexeme(_ident >> (name) =>
             _reservedNames.contains(name) ? fail : pure(name));

  ReservedNames get reserved {
    if (_reserved == null) {
      final map = new Map<String, Parser<String>>();
      for (final name in _reservedNames) {
        map[name] = lexeme(string(name).notFollowedBy(_identLetter));
      }
      _reserved = new ReservedNames._(map);
    }
    return _reserved;
  }

  final Parser<String> _escapeCode =
      char('a')  > pure('\a') | char('b')  > pure('\b')
    | char('f')  > pure('\f') | char('n')  > pure('\n')
    | char('r')  > pure('\r') | char('t')  > pure('\t')
    | char('v')  > pure('\v') | char('\\') > pure('\\')
    | char('"')  > pure('"')  | char("'")  > pure("'");

  Parser<String> get _charChar => char('\\') > _escapeCode
                                | pred((c) => c != "'");

  Parser<String> get charLiteral =>
      lexeme(_charChar.between(char("'"), char("'")));

  Parser<String> get _stringChar => char('\\') > _escapeCode
                                  | pred((c) => c != '"');

  Parser<String> get stringLiteral =>
      lexeme(_stringChar.many.between(char('"'), char('"')))
      .map(Strings.concatAll);

  Map<String, int> _digitToInt = {
    '0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8,
    '9': 9, 'a': 10, 'b': 11, 'c': 12, 'd': 13, 'e': 14, 'f': 15, 'A': 10,
    'B': 11, 'C': 12, 'D': 13, 'E': 14, 'F': 15
  };

  Parser<int> _number(int base, Parser baseDigit) => baseDigit.many1 >> (ds) {
    int res = 0;
    for (final d in ds) { res = base * res + _digitToInt[d]; }
    return pure(res);
  };

  Parser<int> get _zeroNumber =>
      char('0') > (hexaDecimal | octal | decimal | pure(0));

  Parser<int> get _nat => _zeroNumber | decimal;

  Parser<int> get _int => lexeme(_sign) * _nat;

  Parser<Function> get _sign => char('-') > pure((n) => -n)
                              | char('+') > pure((n) => n)
                              | pure((n) => n);

  Parser<int> get natural => lexeme(_nat);

  Parser<int> get intLiteral => lexeme(_int);

  num _power(num e) => e < 0 ? 1.0 / _power(-e) : pow(10, e);

  Parser<double> get _exponent =>
      oneOf('eE') > pure((f) => (e) => _power(f(e))) * _sign * decimal;

  Parser<double> get _fraction => char('.') > digit.many1 >> (ds) {
    double res = 0.0;
    for (int i = ds.length - 1; i >= 0; i--) {
      res = (res + _digitToInt[ds[i]]) / 10.0;
    }
    return pure(res);
  };

  Parser<double> _fractExponent(int n) =>
      (pure((fract) => (expo) => (n + fract) * expo)
          * _fraction
          * _exponent.orElse(1.0))
      | _exponent.map((expo) => n * expo);

  Parser<double> get floatLiteral => lexeme(decimal >> _fractExponent);

  Parser<int> get decimal => _number(10, digit);

  Parser<int> get hexaDecimal =>
      oneOf("xX") > _number(16, oneOf("0123456789abcdefABCDEF"));

  Parser<int> get octal =>
      oneOf("oO") > _number(8, oneOf("01234567"));

  Parser<String> symbol(String symb) => lexeme(string(symb));

  Parser lexeme(Parser p) => p < whiteSpace;

  Parser _multiLineComment() => string(_commentStart) > _inComment();

  Parser _inComment() =>
      _nestedComments ? _inCommentMulti() : _inCommentSingle();

  String get _startEnd => '$_commentStart$_commentEnd';

  Parser _inCommentMulti() => string(_commentEnd) > pure(null)
                            | rec(_multiLineComment) > rec(_inCommentMulti)
                            | anyChar > rec(_inCommentMulti);

  Parser _inCommentSingle() => string(_commentEnd) > pure(null)
                             | anyChar > rec(_inCommentSingle);

  Parser get _oneLineComment =>
      string(_commentLine) > (pred((c) => c != '\n').skipMany > pure(null));

  Parser get whiteSpace {
    if (_commentLine.isEmpty && _commentStart.isEmpty) {
      return space.skipMany;
    } else if (_commentLine.isEmpty) {
      return (space | _multiLineComment()).skipMany;
    } else if (_commentStart.isEmpty) {
      return (space | _oneLineComment).skipMany;
    } else {
      return (space | _oneLineComment | _multiLineComment()).skipMany;
    }
  }

  Parser parens(Parser p) => p.between(symbol('('), symbol(')'));

  Parser braces(Parser p) => p.between(symbol('{'), symbol('}'));

  Parser angles(Parser p) => p.between(symbol('<'), symbol('>'));

  Parser brackets(Parser p) => p.between(symbol('['), symbol(']'));
}