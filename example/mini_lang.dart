// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library misc;

import 'package:parsers/parsers.dart';

// In a real parser, these would be AST node constructors. We use nested lists
// for simplicity here.

list1(a) => [a];
list2(a, b) => [a, b];
list3(a, b, c) => [a, b, c];
list4(a, b, c, d) => [a, b, c, d];
list5(a, b, c, d, e) => [a, b, c, d, e];
list6(a, b, c, d, e, f) => [a, b, c, d, e, f];

// We extend LanguageParsers to benefit from all the C-like language-specific
// comment-aware, reserved names-aware, literals combinators.

class MiniLang extends LanguageParsers {
  MiniLang() : super(reservedNames: ['var', 'if', 'else', 'true', 'false']);

  get start => spaces > (stmts() < eof);

  stmts() => stmt().endBy(semi);
  stmt() => declStmt()
          | assignStmt()
          | ifStmt();
  declStmt() => reserved['var'] + identifier + symbol('=') + expr() ^ list4;
  assignStmt() => identifier + symbol('=') + expr() ^ list3;
  ifStmt() => reserved['if']
                 + parens(expr())
                 + braces(rec(stmts))
                 + reserved['else']
                 + braces(rec(stmts)) ^ list5;

  expr() => disj().sepBy1(symbol('||'));
  disj() => comp().sepBy1(symbol('&&'));
  comp() => arith().sepBy1(symbol('<') | symbol('>'));
  arith() => term().sepBy1(symbol('+') | symbol('-'));
  term() => atom().withPosition.sepBy1(symbol('*') | symbol('/'));

  atom() => floatLiteral
          | intLiteral
          | stringLiteral
          | reserved['true']
          | reserved['false']
          | identifier
          | parens(rec(expr));
}

final test = """
  var i = 14;     // "vari = 14" is a parse error
  var j = 2.3e4;  // using var instead of j is a parse error
  /* 
     multi-line comments are 
     supported and tunable
  */
  if (i < j + 2 * 3 || true) {
    i = "foo\t";
  } else {
    j = false;
  };  // we need a semicolon here because of endBy
""";

main() {
  print(new MiniLang().start.parse(test));
}
