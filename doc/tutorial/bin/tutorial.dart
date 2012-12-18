import 'package:parsers/parsers.dart';

assertFails(f) {
  var witness = false;
  try {
    f();
    witness = true;
  } catch (_) {}
  assert(!witness);
}

strings() {
  Parser<String> p = string('foo');
  assert(p.parse('foo') == 'foo');
  assertFails(() => p.parse('bar'));
  assert(p.parse('foobar') == 'foo');
}

disjunction() {
  final p = string('foo') | string('bar');
  assert(p.parse('foo') == 'foo');
  assert(p.parse('bar') == 'bar');
  assertFails(() => p.parse('qux'));
}

mapping1() {
  Parser<int> p = string('123') ^ ((s) => int.parse(s) + 1);
  assert(p.parse('123') == 124);
  assertFails(() => p.parse('foo'));
}

mapping2() {
  Parser<int> p = (string('1') | string('2') | string('3')) ^ int.parse;
  assert(p.parse('1') == 1);
  assert(p.parse('2') == 2);
  assert(p.parse('3') == 3);
}

mapping3() {
  Parser<String> one = string('one');
  Parser<int> two = string('2') ^ int.parse;
  Parser<int> oneOrTwo = one ^ ((_) => 1) | two; 
  assert(oneOrTwo.parse('one') == 1);
  assert(oneOrTwo.parse('2') == 2);
}

sequence1() {
  combine(x, y, z) => ['$z$y', x];
  final p = string('foo') + string('bar') + string('baz') ^ combine;
  final res = p.parse('foobarbaz');
  assert(res.length == 2);
  assert(res[0] == 'bazbar');
  assert(res[1] == 'foo');
}

sequence2() {
  Parser parens(Parser p) {
      return string('(') + p + string(')') ^ (left, x, right) => x;
  }
  final p = parens(string('foo'));
  assert(p.parse('(foo)') == 'foo');
}

main() {
  strings();
  disjunction();
  mapping1();
  mapping2();
  mapping3();
  sequence1();
  sequence2();
}
