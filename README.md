# [Parser Combinators](http://en.wikipedia.org/wiki/Parser_combinator) for Dart

Check out the [user guide](http://doc.parsers.googlecode.com/git/userguide.html) 
(work in progress).

## Quick Start

```dart
import 'package:parsers/parsers.dart';
import 'dart:math';

// grammar

final number = digit.many1       ^ digits2int
             | string('none')    ^ none
             | string('answer')  ^ answer;

final comma = char(',') < spaces;

final numbers = number.sepBy(comma) < eof;

// actions

digits2int(digits) => parseInt(Strings.concatAll(digits));
none(_) => null;
answer(_) => 42;

// parsing

main() {
  print(numbers.parse('0,1, none, 3,answer'));
  // [0, 1, null, 3, 42]

  print(numbers.parse('0,1, boom, 3,answer'));
  // line 1, character 6: expected digit, 'none' or 'answer', got 'b'.
}
```

See the
[example](http://code.google.com/p/parsers/source/browse/#git%2Fexample)
directory for advanced usage.

## About

This library is heavily inspired by
[Parsec](http://hackage.haskell.org/package/parsec), but differs on some
points. In particular, the `|` operator has a sane backtracking semantics, as
in [Polyparse](http://code.haskell.org/~malcolm/polyparse/docs/). As a
consequence it is slower but also easier to use. I've also introduced some
syntax for transforming parsing results that doesn't require any knowledge of
monads or applicative functors and features uncurried functions, which are
nicer-looking than curried ones in Dart.
