// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library parsers_test;

import 'package:parsers/parsers.dart';
import 'package:persistent/persistent.dart';
import 'package:unittest/unittest.dart';


class FailureMatcher extends BaseMatcher {
  String rest;
  FailureMatcher(this.rest);
  bool matches(item, MatchState matchState) {
    return !item.isSuccess
        && item.rest == rest;
  }
  Description describe(Description description) =>
    description.add('a parse failure with rest "$rest"');
}

class SuccessMatcher extends BaseMatcher {
  final Object res;
  final String rest;
  SuccessMatcher(this.res, this.rest);

  bool _equals(value) {
    if (res is List) {
      if (value is! List) return false;
      if (value.length != res.length) return false;
      bool same = true;
      for (int i = 0; i < res.length && same; i++) {
        same = same && res[i] == value[i];
      }
      return same;
    } else if (res is double) {
      if (value is! double) return false;
      return (res - value).abs() < 0.00001;
    } else {
      return res == value;
    }
  }

  bool matches(item, MatchState matchState) {
    return item.isSuccess
        && _equals(item.value)
        && item.rest == rest;
  }
  Description describe(Description description) =>
    description.add('a parse success with value $res and rest "$rest"');
}

isFailure(rest) => new FailureMatcher(rest);

isSuccess(res, rest) => new SuccessMatcher(res, rest);

checkFloat(res, f, rest) {
  expect(res.isSuccess, isTrue);
  expect((res.value - f).abs() < 0.00001, isTrue);
  expect(res.rest, equals(rest));
}

checkList(res, list, rest) {
  expect(res.isSuccess, isTrue);
  expect(res.value, orderedEquals(list));
  expect(res.value.rest, equals(rest));
}

main() {
  test('char 1', () =>
      expect(char('a').run('abc'), isSuccess('a', 'bc')));

  test('char 2', () =>
      expect(char('a').run('a'), isSuccess('a', '')));

  test('char 3', () =>
      expect(char('a').run('bac'), isFailure('bac')));

  test('char 4', () =>
      expect(char('a').run('b'), isFailure('b')));

  test('char 5', () =>
      expect(char('a').run(''), isFailure('')));

  test('string 1', () =>
      expect(string('').run('abc'), isSuccess('', 'abc')));

  test('string 2', () =>
      expect(string('foo').run('fooabc'), isSuccess('foo', 'abc')));

  test('string 3', () =>
      expect(string('foo').run('barabc'), isFailure('barabc')));

  test('string 4', () =>
      expect(string('foo').run('fo'), isFailure('fo')));

  test('string 5', () =>
      expect(string('foo').run('foo'), isSuccess('foo', '')));

  test('> 1', () =>
      expect((char('a') > char('b')).run('abc'), isSuccess('b','c')));

  test('> 2', () =>
      expect((char('a') > char('b')).run('bbc'), isFailure('bbc')));

  test('> 3', () =>
      expect((char('a') > char('b')).run('aac'), isFailure('ac')));

  final let = string("let").notFollowedBy(alphanum);

  test('notFollowedBy 1', () =>
      expect(let.run('let aa'), isSuccess('let', ' aa')));

  test('notFollowedBy 2', () =>
      expect(let.run('letaa'), isFailure('aa')));

  final comment = string('/*') > anyChar.manyUntil(string('*/'));

  test('manyUntil', () =>
    expect(comment.run('/* abcdef */'),
           isSuccess(' abcdef '.splitChars(), '')));

  test('maybe 1', () =>
      expect(char('a').maybe.run('a'), isSuccess(new Option.some('a'),'')));

  test('maybe 2', () =>
      expect(char('a').maybe.run('b'), isSuccess(new Option.none(),'b')));

  test('sepBy 1', () =>
      expect(char('a').sepBy(char(';')).run('a;a;a'),
             isSuccess(['a', 'a', 'a'], '')));

  test('sepBy 2', () =>
      expect(char('a').sepBy(char(';')).run('a;a;a;'),
             isSuccess(['a', 'a', 'a'], ';')));

  test('sepBy 3', () =>
      expect(char('a').sepBy(char(';')).run(''),
             isSuccess([], '')));

  test('sepBy 4', () =>
      expect(char('a').sepBy(char(';')).run(';'),
             isSuccess([], ';')));

  test('sepBy 5', () =>
      expect(char('a').sepBy(char(';')).run(''),
             isSuccess([], '')));

  test('sepBy1 1', () =>
      expect(char('a').sepBy1(char(';')).run('a;a'),
             isSuccess(['a','a'], '')));

  test('sepBy1 2', () =>
      expect(char('a').sepBy1(char(';')).run('a;a;'),
             isSuccess(['a','a'], ';')));

  test('sepBy1 3', () =>
      expect(char('a').sepBy1(char(';')).run(''),
             isFailure('')));

  test('sepBy1 4', () =>
      expect(char('a').sepEndBy1(char(';')).run(';'),
             isFailure(';')));

  test('sepEndBy 1', () =>
      expect(char('a').sepEndBy(char(';')).run('a;a;a'),
             isSuccess(['a', 'a', 'a'], '')));

  test('sepEndBy 2', () =>
      expect(char('a').sepEndBy(char(';')).run('a;a;a;'),
             isSuccess(['a', 'a', 'a'], '')));

  test('sepEndBy 3', () =>
      expect(char('a').sepEndBy(char(';')).run(''),
             isSuccess([], '')));

  test('sepEndBy 4', () =>
      expect(char('a').sepEndBy(char(';')).run(';'),
             isSuccess([], ';')));

  test('sepEndBy1 1', () =>
      expect(char('a').sepEndBy1(char(';')).run('a;a'),
             isSuccess(['a','a'], '')));

  test('sepEndBy1 2', () =>
      expect(char('a').sepEndBy1(char(';')).run('a;a;'),
             isSuccess(['a','a'], '')));

  test('sepEndBy1 3', () =>
      expect(char('a').sepEndBy1(char(';')).run(''), isFailure('')));

  test('sepEndBy1 4', () =>
      expect(char('a').sepEndBy1(char(';')).run(';'), isFailure(';')));

  test('letter', () =>
      expect(letter.run('a'), isSuccess('a', '')));

  test('manyUntil 1', () =>
      expect(anyChar.manyUntil(string('*/')).run(' a b c d */ e'),
             isSuccess(' a b c d '.splitChars(), ' e')));

  test('manyUntil 2', () =>
      expect(anyChar.manyUntil(string('*/')).run(' a b c d e'),
             isFailure('')));

  test('manyUntil 3', () =>
      expect(anyChar.manyUntil(string('*/').lookAhead).run(' a b c d */ e'),
             isSuccess(' a b c d '.splitChars(), '*/ e')));

  test('skipManyUntil 1', () =>
      expect(anyChar.skipManyUntil(string('*/')).run(' a b c d */ e'),
             isSuccess(null, ' e')));

  test('skipManyUntil 2', () =>
      expect(anyChar.skipManyUntil(string('*/')).run(' a b c d e'),
             isFailure('')));

  test('skipManyUntil 3', () =>
      expect(anyChar.skipManyUntil(string('*/').lookAhead).run(' a b c d */ e'),
             isSuccess(null, '*/ e')));

  final lang = new LanguageParsers(
      nestedComments: true,
      reservedNames: ['for', 'in']);

  test('identifier 1', () =>
      expect(lang.identifier.run('BarFoo toto'),
             isSuccess('BarFoo', 'toto')));

  test('identifier 2', () =>
      expect(lang.identifier.run('B6ar_Foo toto'),
             isSuccess('B6ar_Foo', 'toto')));

  test('identifier 3', () =>
      expect(lang.identifier.run('B6ar_Foo toto'),
             isSuccess('B6ar_Foo', 'toto')));

  test('identifier 4', () =>
      expect(lang.identifier.run('7B6ar_Foo toto'),
             isFailure('7B6ar_Foo toto')));

  test('identifier 5', () =>
      expect(lang.identifier.run('_7B6ar_Foo toto'),
             isSuccess('_7B6ar_Foo', 'toto')));

  test('identifier 6', () =>
      expect(lang.identifier.sepBy(lang.comma).run('abc, def, hij'),
             isSuccess(['abc', 'def', 'hij'], '')));

  test('multi-line comment 1.1', () =>
      expect((lang.identifier > lang.identifier).run('a /* abc */ b'),
             isSuccess('b', '')));

  test('multi-line comment 1.2', () =>
      expect((lang.identifier > lang.identifier).run('a /* x /* abc */ y */ b'),
             isSuccess('b', '')));

  test('multi-line comment 1.3', () =>
      expect((lang.identifier > lang.identifier).run('a /* x /* abc */ y b'),
             isFailure('/* x /* abc */ y b')));

  test('single-line comment 1.1', () =>
      expect((lang.identifier > lang.identifier).run('a // foo \n b'),
             isSuccess('b', '')));

  final noNest = new LanguageParsers(nestedComments: false);

  test('multi-line comment 2.1', () =>
      expect((noNest.identifier > lang.identifier).run('a /* abc */ b'),
             isSuccess('b', '')));

  test('multi-line comment 2.2', () =>
      expect((noNest.identifier > lang.identifier).run(
                 'a /* x /* abc */ y */ b'),
             isSuccess('y', '*/ b')));

  test('multi-line comment 2.3', () =>
      expect((noNest.identifier > lang.identifier).run('a /* x /* abc */ y b'),
             isSuccess('y', 'b')));

  test('single-line comment 2.1', () =>
      expect((lang.identifier > lang.identifier).run('a // foo \n b'),
             isSuccess('b', '')));

  test('reserved 1', () =>
      expect(lang.reserved['for'].run('for a'), isSuccess('for', 'a')));

  test('reserved 2', () =>
      expect(lang.reserved['for'].run('fora'), isFailure('a')));

  test('reserved 3', () =>
      expect(() => lang.reserved['foo'].run('fora'), throws));

  test('char 1', () =>
      expect(lang.charLiteral.run(r"'a'"), isSuccess('a', '')));

  test('char 2', () =>
      expect(lang.charLiteral.run(r"'aa'"), isFailure("a'")));

  test('char 3', () =>
      expect(lang.charLiteral.run(r"''"), isFailure("'")));

  test('char 4', () =>
      expect(lang.charLiteral.run(r"'\t'"), isSuccess('\t', '')));

  test('char 5', () =>
      expect(lang.charLiteral.run(r"'\\'"), isSuccess(r'\', '')));

  test('string 1', () =>
      expect(lang.stringLiteral.run(r'"aaa"'), isSuccess('aaa', '')));

  test('string 2', () =>
      expect(lang.stringLiteral.run(r'"a\ta"'), isSuccess('a\ta', '')));

  test('string 3', () =>
      expect(lang.stringLiteral.run(r'"a\\a"'), isSuccess(r'a\a', '')));

  test('string 4', () =>
      expect(lang.stringLiteral.run(r'"a"a"'), isSuccess(r'a', 'a"')));

  test('natural 1', () =>
      expect(lang.natural.run('42'), isSuccess(42, '')));

  test('natural 2', () =>
      expect(lang.natural.run('0O42'), isSuccess(34, '')));

  test('natural 3', () =>
      expect(lang.natural.run('0o42'), isSuccess(34, '')));

  test('natural 4', () =>
      expect(lang.natural.run('0X42'), isSuccess(66, '')));

  test('natural 5', () =>
      expect(lang.natural.run('0xFf'), isSuccess(255, '')));

  test('natural 6', () =>
      expect(lang.natural.run('-0x42'), isFailure('-0x42')));

  test('int 1', () =>
      expect(lang.intLiteral.run('-0x42'), isSuccess(-66, '')));

  test('int 2', () =>
      expect(lang.intLiteral.run('-  0x42'), isSuccess(-66, '')));

  test('float 1', () =>
      expect(lang.floatLiteral.run('3.14'), isSuccess(3.14, '')));

  test('float 2', () =>
      expect(lang.floatLiteral.run('3.14e5'), isSuccess(314000.0, '')));

  test('float 3', () =>
      expect(lang.floatLiteral.run('3.14e-5'), isSuccess(0.0000314, '')));

  test('chainl 1', () =>
      expect(lang.natural.chainl(pure((x, y) => x + y), 42).run('1 2 3'),
             isSuccess(6, '')));

  test('chainl 2', () =>
      expect(lang.natural.chainl(pure((x, y) => x + y), 42).run('a 2 3'),
             isSuccess(42, 'a 2 3')));

  final addop = lang.symbol('+') > pure((x, y) => x + y)
              | lang.symbol('-') > pure((x, y) => x - y);

  test('chainl 3', () =>
      expect(lang.natural.chainl(addop, 42).run('3 - 1 - 2'),
             isSuccess(0, '')));

  test('chainl 4', () =>
      expect(lang.natural.chainl(addop, 42).run('a - 1 - 2'),
              isSuccess(42, 'a - 1 - 2')));

  test('chainl1 1', () =>
      expect(lang.natural.chainl1(pure((x, y) => x + y)).run('1 2 3'),
             isSuccess(6, '')));

  test('chainl1 2', () =>
      expect(lang.natural.chainl1(pure((x, y) => x + y)).run('a 2 3'),
             isFailure('a 2 3')));

  test('chainl1 3', () =>
      expect(lang.natural.chainl1(addop).run('3 - 1 - 2'),
             isSuccess(0, '')));

  test('chainl1 4', () =>
      expect(lang.natural.chainl1(addop).run('a - 1 - 2'),
              isFailure('a - 1 - 2')));

  test('chainr 1', () =>
      expect(lang.natural.chainr(pure((x, y) => x + y), 42).run('1 2 3'),
             isSuccess(6, '')));

  test('chainr 2', () =>
      expect(lang.natural.chainr(pure((x, y) => x + y), 42).run('a 2 3'),
             isSuccess(42, 'a 2 3')));

  test('chainr 3', () =>
      expect(lang.natural.chainr(addop, 42).run('3 - 1 - 2'),
             isSuccess(4, '')));

  test('chainr 4', () =>
      expect(lang.intLiteral.chainr(addop, 42).run('a - 1 - 2'),
              isSuccess(42, 'a - 1 - 2')));

  test('chainr1 1', () =>
      expect(lang.intLiteral.chainr1(pure((x, y) => x + y)).run('1 2 3'),
             isSuccess(6, '')));

  test('chainr1 2', () =>
      expect(lang.intLiteral.chainr1(pure((x, y) => x + y)).run('a 2 3'),
             isFailure('a 2 3')));

  test('chainr1 3', () =>
      expect(lang.intLiteral.chainr1(addop).run('3 - 1 - 2'),
             isSuccess(4, '')));

  test('chainr1 4', () =>
      expect(lang.intLiteral.chainr1(addop).run('a - 1 - 2'),
              isFailure('a - 1 - 2')));

  test('choice 1', () =>
      expect(choice([char('a'), char('b'), char('c')]).run('b'),
             isSuccess('b', '')));

  test('choice 2', () =>
      expect(choice([char('a'), char('b'), char('c')]).run('d'),
             isFailure('d')));

  test('record 1', () =>
      expect(char('a').many.record.run('aaaabb'),
             isSuccess('aaaa', 'bb')));

  test('record 2', () =>
      expect(string('aa').record.run('abaabb'),
             isFailure('abaabb')));

  test('record 2', () =>
      expect(char('a').record.run(''),
             isFailure('')));

  var big = "a";
  for (int i = 0; i < 15; i++) { big = '$big$big'; }

  test('no stack overflow many', () =>
      expect(char('a').many.run(big).value.length, equals(32768)));

  test('no stack overflow skipMany', () =>
      expect(char('a').skipMany.run('${big}bb'), isSuccess(null, 'bb')));

  test('no stack overflow manyUntil', () =>
      expect(anyChar.manyUntil(char('b')).run('${big}b').value.length,
             equals(32768)));

  test('no stack overflow comment', () =>
      expect(lang.natural.run('1 /* $big */'), isSuccess(1, '')));
}
