part of parsers_test;

// Simple models of the most complex combinators (the one that use while loops
// to avoid stack overflows).

_cons(x) => (xs) => []
  ..add(x)
  ..addAll(xs as Iterable);

Parser<List> manyModel(Parser p) {
  Parser go() => success(_cons) * p * rec(go) | success([]);
  return go() as Parser<List>;
}

Parser<List> manyImpl(Parser p) => p.many;

Parser skipManyModel(Parser p) => manyModel(p) > success(null);

Parser skipManyImpl(Parser p) => p.skipMany;

Parser<List> manyUntilModel(Parser p, Parser end) {
  Parser go() => (end > success([])) | success(_cons) * p * rec(go);
  return go() as Parser<List>;
}

Parser<List> manyUntilImpl(Parser p, Parser end) => p.manyUntil(end);

Parser skipManyUntilModel(Parser p, Parser end) {
  return manyUntilModel(p, end) > success(null);
}

Parser skipManyUntilImpl(Parser p, Parser end) => p.skipManyUntil(end);

Parser chainl1Model(Parser p, Parser sep) {
  Parser rest(acc) {
    combine(f) => (x) => f(acc, x);
    return (success(combine) * sep * p) >> rest | success(acc);
  }

  return p >> rest;
}

Parser chainl1Impl(Parser p, Parser sep) => p.chainl1(sep as Parser<Function>);
