#!/usr/bin/env dart

// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

main(List<String> arguments) {
  final n = int.parse(arguments[0]);
  for (int i = 2; i <= n; i++) {
    final plist = [];
    final pdecllist = [];
    final xlist = [];
    final tlist = [];
    final typedxlist = [];
    for (int j = 1; j <= i; j++) {
      pdecllist.add('  final Parser<T$j> p$j;');
      plist.add('p$j');
      xlist.add('x$j');
      tlist.add('T$j');
      typedxlist.add('T$j x$j');
    }
    final newt = 'T${i+1}';
    final newtlist = new List.from(tlist)..add(newt);
    final ts = tlist.join(', ');
    final newts = newtlist.join(', ');
    final ps = plist.join(', ');
    final pdecls = pdecllist.join('\n');
    final these = plist.map((p) => 'this.$p').join(', ');
    final xs = xlist.join(', ');
    final typedxs = typedxlist.join(' , ');
    final curriedXs = typedxlist.map((x) => '($x)').join(' => ');
    final psProduct = plist.map((p) => '.apply($p)').join('');

  print('''
class ParserAccumulator${i}<${ts}> {
$pdecls
  ParserAccumulator$i($these);
''');

  if (i < n) {
    print('''
  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator${i+1}<${newts}> and<${newt}>(Parser<${newt}> p) =>
      new ParserAccumulator${i+1}($ps, p);

  /// Alias for [and]
  ParserAccumulator${i+1} operator +(Parser p) => and(p);
''');
  }

  print('''
  /// Action application
  Parser<R> map<R>(R f($typedxs)) =>
      success($curriedXs => f($xs))$psProduct;

  /// Alias for map
  Parser operator ^(Object f($typedxs)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success($curriedXs => [$xs])$psProduct;
}
''');
  }
}
