part of parsers_test;

// Simple models of the most complex combinators (the one that use while loops
// to avoid stack overflows).

_cons(x) => (xs) => []..add(x)..addAll(xs);

Parser<List> manyModel(Parser p) {
  go () => success(_cons) * p * rec(go) | success([]);
  return go();
}

Parser<List> manyImpl(Parser p) => p.many;

Parser skipManyModel(Parser p) => manyModel(p) > success(null);

Parser skipManyImpl(Parser p) => p.skipMany;

Parser<List> manyUntilModel(Parser p, Parser end) {
  go () => end > success([]) | success(_cons) * p * rec(go);
  return go();
}

Parser<List> manyUntilImpl(Parser p, Parser end) => p.manyUntil(end);

Parser skipManyUntilModel(Parser p, Parser end) {
  return manyUntilModel(p, end) > success(null);
}

Parser skipManyUntilImpl(Parser p, Parser end) => p.skipManyUntil(end);

Parser chainl1Model(Parser p, Parser sep) {
  rest(acc) {
    combine(f) => (x) => f(acc, x);
    return (success(combine) * sep * p) >> rest | success(acc);
  }
  return p >> rest;
}

Parser chainl1Impl(Parser p, Parser sep) => p.chainl1(sep);
