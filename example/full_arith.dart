// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Authors:
//   Paul Brauner (polux@google.com)
//   Dinesh Ahuja (dev@kabiir.me)

library example;

import 'package:parsers/parsers.dart';

// Same example as example.dart, with the additional use of chainl1 which
// helps handling infix operators with the same precedence.

class Arith {
  int digits2int(List<String> digits) => int.parse(digits.join());

  Parser<A> lexeme<A>(Parser<A> parser) => parser < spaces;
  Parser<String> token(String str) => lexeme(string(str));
  Parser<A> parens<A>(Parser<A> parser) =>
      parser.between(token('('), token(')'));

  Parser get start => expr() < eof;

  Parser get comma => token(',');
  Parser get times => token('*');
  Parser get div => token('~/');
  Parser get plus => token('+');
  Parser get minus => token('-');
  Parser get number => (lexeme(digit.many1) ^ digits2int);

  Parser expr() => rec(term).chainl1(addop);
  Parser term() => rec(atom).chainl1(mulop);
  Parser atom() => number | parens(rec(expr));

  Parser<Function> get addop => (plus.thenKeep(success((x, y) => x + y)))
      .or(minus.thenKeep(success((x, y) => x - y)));

  Parser<Function> get mulop => (times.thenKeep(success((x, y) => x * y)))
      .or(div.thenKeep(success((x, y) => x ~/ y)));
}

main() {
  const s = '1 * 2 ~/ 2 + 3 * (4 + 5 - 1)';
  print(Arith().start.parse(s)); // prints 25
}
