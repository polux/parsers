// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library parsers;

import 'package:persistent/persistent.dart';
import 'dart:math';

_consStr(c) => (String cs) => "$c$cs";
String _strHead(String s) => s[0];
String _strTail(String s) => s.substring(1);
_some(x) => new Option.some(x);
final _none = new Option.none();
_humanOr(List es) {
  assert(es.length > 0);
  if (es.length == 1) {
    return es[0];
  } else {
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < es.length - 2; i++) {
      result.add('$es[i], ');
    }
    result.add('${es[es.length - 2]} or ${es[es.length - 1]}');
    return result;
  }
}
_single(x) => new PersistentSet().insert(x);

class ParseResult<A> {
  final bool isSuccess;
  /// [:null:] if [:!isSuccess:]
  final A value;
  final String text;
  final int position;
  /// [:null:] if [:isSuccess:]
  final PersistentSet<String> expected;

  String get rest => text.substring(position);

  String get errorMessage {
    final seen = text[position];
    if (expected.isEmpty) {
      return 'unexpected $seen';
    } else {
      final or = _humanOr(new List.from(expected.toSet()));
      return "expected $or, got '$seen'";
    }
  }

  ParseResult.success(A value, String text, int position)
      : this.isSuccess = true
      , this.value = value
      , this.text = text
      , this.position = position
      , this.expected = null;

  ParseResult.failure(String text, int position, PersistentSet<String> expected)
      : this.isSuccess = false
      , this.value = null
      , this.text = text
      , this.position = position
      , this.expected = expected;

  get _shortRest => rest.length < 10 ? rest : '${rest.substring(0, 10)}...';

  toString() =>
      isSuccess ? 'success: {value: $value, rest: "$_shortRest"}'
                : 'failure: {message: $errorMessage, rest: "$_shortRest"}';
}

ParseResult _success(value, String text, int position) =>
    new ParseResult.success(value, text, position);

ParseResult _failure(String text, int position, [PersistentSet expected]) =>
    new ParseResult.failure(text, position,
        ?expected ? expected : new PersistentSet());

typedef ParseResult ParseFunction(String s, int pos);

class Parser<A> {
  final ParseFunction _run;

  Parser(ParseResult<A> f(String s, int pos)) : this._run = f;

  ParseResult run(String s, [int pos = 0]) => _run(s, pos);

  Object parse(String s) {
    ParseResult<A> result = _run(s, 0);
    if (result.isSuccess) return result.value;
    else throw result.errorMessage;
  }

  /// Monadic bind.
  Parser operator >>(Parser g(A x)) {
    return new Parser((text, pos) {
      ParseResult res = _run(text, pos);
      return res.isSuccess
          ? g(res.value)._run(text, res.position)
          : res;
    });
  }

  Parser expecting(String expected) {
    return new Parser((s, pos) {
      final res = _run(s, pos);
      return res.isSuccess
          ? res
          : _failure(res.text, res.position, _single(expected));
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
    return new Parser((s, pos) {
      ParseResult<A> res = _run(s, pos);
      if (res.isSuccess) {
        return res;
      } else {
        ParseResult pres = p._run(s, pos);
        if (pres.isSuccess) {
          return pres;
        } else {
          return _failure(pres.text, pres.position,
                          res.expected.union(pres.expected));
        }
      }
    });
  }

  /**
   * Parses without consuming any input.
   *
   * Used for defining followedBy, which is probably what you're looking for.
   */
  Parser get lookAhead {
    return new Parser((s, pos) {
      ParseResult res = _run(s, pos);
      return res.isSuccess
          ? _success(res.value, s, pos)
          : res;
    });
  }

  /**
   * Succeeds if and only if [this] succeeds and [p] succeeds on what remains to
   * parse without cosuming it.
   *
   *     string("let").followedBy(space)
   */
  Parser<A> followedBy(Parser p) => this < p.lookAhead;

  /**
   * Fails if and only if [this] succeeds on what's ahead.
   *
   * Used for defining notFollowedBy, which is probably what you're looking for.
   */
  Parser get notAhead {
    return new Parser((s, pos) {
      ParseResult res = _run(s, pos);
      return res.isSuccess
          ? _failure(s, pos)
          : _success(null, s, pos);
    });
  }

  /**
   * Succeeds if and only if [this] succeeds and [p] fails on what remains to
   * parse.
   *
   *     string("let").notFollowedBy(alphanum)
   */
  Parser<A> notFollowedBy(Parser p) => this < p.notAhead;

  /**
   * Parses [this] 0 or more times until [end] succeeds.
   *
   * Returns the list of values returned by [this]. It is useful for parsing
   * comments.
   *
   *     string('/*') > anyChar.manyUntil(string('*/'))
   *
   * The input parsed by [end] is consumed. Use [:end.lookAhead:] if you don't
   * want this.
   */
  Parser<List<A>> manyUntil(Parser end) {
    // Imperative version to avoid stack overflows.
    return new Parser((s, pos) {
      List res = [];
      int index = pos;
      while(true) {
        final endRes = end._run(s, index);
        if (endRes.isSuccess) {
          return _success(res, s, endRes.position);
        } else {
          final xRes = this._run(s, index);
          if (xRes.isSuccess) {
            res.add(xRes.value);
            index = xRes.position;
          } else {
            return xRes;
          }
        }
      }
    });
  }

  /**
   * Parses [this] 0 or more times until [end] succeeds and discards the result.
   *
   * Equivalent to [:this.manyUntil(end) > pure(null):] but faster. The input
   * parsed by [end] is consumed. Use [:end.lookAhead:] if you don't want this.
   */
  Parser skipManyUntil(Parser end) {
    // Imperative version to avoid stack overflows.
    return new Parser((s, pos) {
      int index = pos;
      while(true) {
        final endRes = end._run(s, index);
        if (endRes.isSuccess) {
          return _success(null, s, endRes.position);
        } else {
          final xRes = this._run(s, index);
          if (xRes.isSuccess) {
            index = xRes.position;
          } else {
            return xRes;
          }
        }
      }
    });
  }

  // Derived combinators, defined here for infix notation

  Parser orElse(A value) => this | pure(value);

  Parser<Option<A>> get maybe => this.map(_some).orElse(_none);

  // Imperative version to avoid stack overflows.
  Parser<List<A>> _many(List<A> acc()) {
    return new Parser((s, pos) {
      final res = acc();
      int index = pos;
      while(true) {
        ParseResult<A> o = this._run(s, index);
        if (o.isSuccess) {
          res.add(o.value);
          index = o.position;
        } else {
          return _success(res, s, index);
        }
      }
    });
  }

  Parser<List<A>> get many => _many(() => []);

  Parser<List<A>> get many1 => this >> (x) => _many(() => [x]);

  /**
   * Parses [this] zero or more time, skipping its result.
   *
   * Equivalent to [:this.many > pure(null):] but more efficient.
   */
  Parser get skipMany {
    // Imperative version to avoid stack overflows.
    return new Parser((s, pos) {
      int index = pos;
      while(true) {
        ParseResult<A> o = this._run(s, index);
        if (o.isSuccess) {
          index = o.position;
        } else {
          return _success(null, s, index);
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

  Parser<List<A>> sepBy(Parser sep) => sepBy1(sep).orElse([]);

  Parser<List<A>> sepBy1(Parser sep) =>
      this >> (x) => (sep > this)._many(() => [x]);

  Parser<List<A>> endBy(Parser sep) => (this < sep).many;

  Parser<List<A>> endBy1(Parser sep) => (this < sep).many1;

  /**
   * Parses zero or more occurences of [this] separated and optionally ended
   * by [sep].
   */
  Parser<List<A>> sepEndBy(Parser sep) => sepEndBy1(sep).orElse([]);

  /**
   * Parses one or more occurences of [this] separated and optionally ended
   * by [sep].
   */
  Parser<List<A>> sepEndBy1(Parser sep) => sepBy1(sep) < sep.maybe;

  Parser chainl(Parser sep, defaultValue) => chainl1(sep) | pure(defaultValue);

  Parser chainl1(Parser sep) {
    rest(acc) {
      var res = acc;
      return new Parser((s, pos) {
        int index = pos;
        while(true) {
          final newres =
              (pure((f) => (x) => f(res, x)) * sep * this)._run(s, index);
          if (newres.isSuccess) {
            res = newres.value;
            index = newres.position;
          } else {
            return _success(res, s, index);
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

  /// Returns the substring comsumed by [this].
  Parser<String> get record {
    return new Parser((s, pos) {
        final result = run(s, pos);
        if (result.isSuccess) {
          return _success(s.substring(pos, result.position),
                          s, result.position);
        } else {
          return result;
        }
    });
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

final Parser fail = new Parser((s, pos) => _failure(s, pos));

Parser pure(value) => new Parser((s, pos) => _success(value, s, pos));

final Parser eof = new Parser((s, pos) =>
    pos >= s.length ? _success(null, s, pos)
                    : _failure(s, pos, _single("eof")));

Parser pred(bool p(String char)) {
  return new Parser((s, pos) {
    if (pos >= s.length) return _failure(s, pos);
    else {
      String c = s[pos];
      return p(c) ? _success(c, s, pos + 1)
                  : _failure(s, pos);
    }
  });
}

// Util

rec(f) => new Parser((s, pos) => f()._run(s, pos));

// Derived combinators

Parser char(String chr) => pred((c) => c == chr).expecting("'$chr'");

Parser string(String str) {
  // Primitive version for efficiency
  return new Parser((s, pos) {
    int max = pos + str.length;
    bool match = s.length >= max;
    for (int i = 0; i < str.length && match; i++) {
      match = match && str[i] == s[pos + i];
    }
    if (match) {
      return _success(str, s, max);
    } else {
      return _failure(s, pos, _single("'$str'"));
    }
  });
}

Parser choice(List<Parser> ps) {
  // Imperative version for efficiency
  return new Parser((s, pos) {
    var expected = new PersistentSet();
    for (final p in ps) {
      final res = p._run(s, pos);
      if (res.isSuccess) {
        return res;
      }
      else {
        expected = expected.union(res.expected);
      }
    }
    return _failure(s, pos, expected);
  });
}

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

  Parser get _start => string(_commentStart);
  Parser get _end => string(_commentEnd);
  Parser get _startOrEnd => _start | _end;

  Parser _multiLineComment() => _start > _inComment();

  Parser _inComment() =>
      _nestedComments ? _inCommentMulti() : _inCommentSingle();

  Parser _inCommentMulti() =>
      _end > pure(null)
    | rec(_multiLineComment) > rec(_inCommentMulti)
    | anyChar.skipManyUntil(_startOrEnd.lookAhead) > rec(_inCommentMulti);

  Parser _inCommentSingle() =>
      _end > pure(null)
    | anyChar.skipManyUntil(_end.lookAhead) > rec(_inCommentSingle);

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