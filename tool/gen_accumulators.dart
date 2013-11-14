#!/usr/bin/env dart

// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

main(List<String> arguments) {
  final n = int.parse(arguments[0]);
  for (int i = 2; i <= n; i++) {
    final plist = [];
    final xlist = [];
    for (int j = 1; j <= i; j++) {
      plist.add('p$j');
      xlist.add('x$j');
    }
    final ps = plist.join(', ');
    final these = plist.map((p) => 'this.$p').join(', ');
    final xs = xlist.join(', ');
    final curriedXs = xlist.map((x) => '($x)').join(' => ');
    final psProduct = plist.join(' * ');

  print('''
class ParserAccumulator$i {
  final Parser $ps;
  ParserAccumulator$i($these);
''');

  if (i < n) {
    print('''
  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator${i+1} operator +(Parser p) =>
    new ParserAccumulator${i+1}($ps, p);
''');
  }

  print('''
  /// Action application
  Parser operator ^(Object f($xs)) =>
      success($curriedXs => f($xs)) * $psProduct;

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success($curriedXs => [$xs]) * $psProduct;
}
''');
  }
}
