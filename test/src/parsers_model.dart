part of parsers_test;

// Simple models of the most complex combinators (the one that use while loops
// to avoid stack overflows).

Iterable Function(dynamic) _cons(x) {
  return (xs) {
    return []
      ..add(x)
      ..addAll(xs as Iterable);
  };
}

Parser<List> manyModel(Parser p) {
  Parser go() => success(_cons).apply(p).apply(rec(go)).or(success([]));
  return go() as Parser<List>;
}

Parser<List> manyImpl(Parser p) => p.many;

Parser<Null> skipManyModel(Parser p) => manyModel(p).thenKeep(success(null));

Parser skipManyImpl(Parser p) => p.skipMany;

Parser<List> manyUntilModel(Parser p, Parser end) {
  Parser go() =>
      (end.thenKeep(success([]))).or(success(_cons)).apply(p).apply(rec(go));
  return go() as Parser<List>;
}

Parser<List> manyUntilImpl(Parser p, Parser end) => p.manyUntil(end);

Parser<Null> skipManyUntilModel(Parser p, Parser end) {
  return manyUntilModel(p, end).thenKeep(success(null));
}

Parser skipManyUntilImpl(Parser p, Parser end) => p.skipManyUntil(end);

Parser chainl1Model(Parser p, Parser sep) {
  Parser rest(acc) {
    combine(f) => (x) => f(acc, x);
    return (success(combine).apply(sep).apply(p)).then(rest).or(success(acc));
  }

  return p.then(rest);
}

Parser chainl1Impl(Parser p, Parser sep) => p.chainl1(sep as Parser<Function>);
