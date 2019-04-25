// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Authors:
//   Paul Brauner (polux@google.com)
//   Dinesh Ahuja (dev@kabiir.me)

library example;

import 'package:parsers/parsers.dart';

// Same example as example.dart, with the additional use of chainl1 which
// helps handling infix operators with the same precedence.

typedef MathFunction<T> = T Function(T a, T b);

class Arith {
  int digits2int(List<String> digits) => int.parse(digits.join());

  Parser<A> lexeme<A>(Parser<A> parser) => parser.thenDrop(spaces);
  Parser<String> token(String str) => lexeme(string(str));
  Parser<A> parens<A>(Parser<A> parser) =>
      parser.between(token('('), token(')'));

  Parser<int> get start => expr().thenDrop(eof);

  Parser<String> get comma => token(',');
  Parser<String> get times => token('*');
  Parser<String> get div => token('~/');
  Parser<String> get plus => token('+');
  Parser<String> get minus => token('-');
  Parser<int> get number => (lexeme(digit.many1).map(digits2int));

  Parser<int> expr() => rec(term).chainl1(addop);
  Parser<int> term() => rec(atom).chainl1(mulop);
  Parser<int> atom() => number.or(parens(rec(expr)));

  Parser<MathFunction> get addop => (plus.thenKeep(success((x, y) => x + y)))
      .or(minus.thenKeep(success((x, y) => x - y)));

  Parser<MathFunction> get mulop => (times.thenKeep(success((x, y) => x * y)))
      .or(div.thenKeep(success((x, y) => x ~/ y)));
}

main() {
  const s = '1 * 2 ~/ 2 + 3 * (4 + 5 - 1)';
  print(Arith().start.parse(s)); // prints 25
}
