// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library full_arith;

import 'package:parsers/parsers.dart';
import 'dart:math';

// Same example as example.dart, with the additional use of chainl1 which
// helps handling infix operators with the same precedence.

class Arith {

  digits2int(digits) => parseInt(Strings.concatAll(digits));

  lexeme(parser) => parser < spaces;
  token(str)     => lexeme(string(str));
  parens(parser) => token('(') + parser + token(')')  ^ (a,b,c) => b;

  get start => expr() < eof;

  get comma  => token(',');
  get times  => token('*');
  get div    => token('~/');
  get plus   => token('+');
  get minus  => token('-');
  get number => lexeme(digit.many1)  ^ digits2int;

  expr() => rec(term).chainl1(mulop);
  term() => rec(atom).chainl1(addop);
  atom() => number | parens(rec(expr));

  get mulop => plus  > pure((x, y) => x + y)
             | minus > pure((x, y) => x - y);

  get addop => times > pure((x, y) => x * y)
             | div   > pure((x, y) => x ~/ y);
}

main() {
  String good = "1 * 2 ~/ 2 + 3 * (4 + 5 - 1)";
  print(new Arith().start.parse(good)); // prints 25
}
