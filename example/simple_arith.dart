// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library simple_arith;

import 'package:parsers/parsers.dart';

class Arith {
  // Some combinators: functions that take parsers and return a parser.

  lexeme(parser) => parser < spaces;
  token(str) => lexeme(string(str as String));
  parens(parser) => token('(') + parser + token(')') ^ (a, b, c) => b;

  // The axiom of the grammar is an expression followed by end of file.

  get start => expr() < eof;

  // We define some lexemes.

  get comma => token(',');
  get times => token('*');
  get plus => token('+');
  get number => (lexeme(digit.many1) ^ digits2int) % 'natural number';

  // This is the gist of the grammar, the BNF-like rules.

  expr() => rec(mult as Parser Function()).sepBy1(plus as Parser) ^ sum;
  mult() => rec(atom as Parser Function()).sepBy1(times as Parser) ^ prod;
  atom() => number | parens(rec(expr as Parser Function()));

  // These are simple Dart functions used as "actions" above to transform the
  // results of intermediate parsing steps.

  digits2int(digits) => int.parse((digits as Iterable).join());
  prod(xs) => xs.fold(1, (a, b) => a * b);
  sum(xs) => xs.fold(0, (a, b) => a + b);
}

main() {
  final good = "1 * 2 + 3 * (4 + 5)";
  print(new Arith().start.parse(good)); // prints 29

  final bad = "1 * x + 2";
  try {
    new Arith().start.parse(bad);
  } catch (e) {
    print('parsing of 1 * x + 2 failed as expected: "$e"');
  }
}
