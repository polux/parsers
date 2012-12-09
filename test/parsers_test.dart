// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library parsers_test;

import 'package:parsers/parsers.dart';
import 'package:persistent/persistent.dart';
import 'package:unittest/unittest.dart';


final isFailure = equals(new Option.none());

isSuccess(res, rest) => equals(new Option.some(new Pair(res, rest)));

checkFloat(res, f, rest) {
  expect(res.isDefined, isTrue);
  expect((res.value.fst - f).abs() < 0.00001, isTrue);
  expect(res.value.snd, equals(rest));
}

checkList(res, list, rest) {
  expect(res.isDefined, isTrue);
  expect(res.value.fst, orderedEquals(list));
  expect(res.value.snd, equals(rest));
}

main() {
  final let = string("let").notFollowedBy(alphanum);

  test('notFollowedBy 1', () =>
      expect(let.run('let aa'), isSuccess('let', ' aa')));

  test('notFollowedBy 2', () =>
      expect(let.run('letaa'), isFailure));

  final comment = string('/*') > anyChar.manyUntil(string('*/'));

  test('manyUntil', () =>
    checkList(comment.run('/* abcdef */'), ' abcdef '.splitChars(), ''));

  test('maybe 1', () =>
      expect(char('a').maybe.run('a'), isSuccess(new Option.some('a'),'')));

  test('maybe 2', () =>
      expect(char('a').maybe.run('b'), isSuccess(new Option.none(),'b')));

  test('sepEndBy 1', () =>
      checkList(char('a').sepEndBy(char(';')).run('a;a;a'),
                ['a', 'a', 'a'],
                ''));

  test('sepEndBy 2', () =>
      checkList(char('a').sepEndBy(char(';')).run('a;a;a;'),
                ['a', 'a', 'a'],
                ''));

  test('sepEndBy 3', () =>
      checkList(char('a').sepEndBy(char(';')).run(''), [], ''));

  test('sepEndBy 4', () =>
      checkList(char('a').sepEndBy(char(';')).run(';'), [], ';'));

  test('sepEndBy1 1', () =>
      checkList(char('a').sepEndBy1(char(';')).run('a;a'), ['a','a'], ''));

  test('sepEndBy1 2', () =>
      checkList(char('a').sepEndBy1(char(';')).run('a;a;'), ['a','a'], ''));

  test('sepEndBy1 3', () =>
      expect(char('a').sepEndBy1(char(';')).run(''), isFailure));

  test('sepEndBy1 3', () =>
      expect(char('a').sepEndBy1(char(';')).run(';'), isFailure));

  test('letter', () =>
      expect(letter.run('a'), isSuccess('a', '')));

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
             isFailure));

  test('identifier 5', () =>
      expect(lang.identifier.run('_7B6ar_Foo toto'),
             isSuccess('_7B6ar_Foo', 'toto')));

  test('multi-line comment 1', () =>
      expect((lang.identifier > lang.identifier).run('a /* abc */ b'),
             isSuccess('b', '')));

  test('multi-line comment 2', () =>
      expect((lang.identifier > lang.identifier).run('a /* x /* abc */ y */ b'),
             isSuccess('b', '')));

  test('multi-line comment 3', () =>
      expect((lang.identifier > lang.identifier).run('a // foo \n b'),
             isSuccess('b', '')));

  test('reserved 1', () =>
      expect(lang.reserved['for'].run('for a'), isSuccess('for', 'a')));

  test('reserved 2', () =>
      expect(lang.reserved['for'].run('fora'), isFailure));

  test('reserved 3', () =>
      expect(() => lang.reserved['foo'].run('fora'), throws));

  test('char 1', () =>
      expect(lang.charLiteral.run(r"'a'"), isSuccess('a', '')));

  test('char 2', () =>
      expect(lang.charLiteral.run(r"'aa'"), isFailure));

  test('char 3', () =>
      expect(lang.charLiteral.run(r"''"), isFailure));

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
      expect(lang.natural.run('-0x42'), isFailure));

  test('int 1', () =>
      expect(lang.intLiteral.run('-0x42'), isSuccess(-66, '')));

  test('int 2', () =>
      expect(lang.intLiteral.run('-  0x42'), isSuccess(-66, '')));

  test('float 1', () =>
      checkFloat(lang.floatLiteral.run('3.14'), 3.14, ''));

  test('float 2', () =>
      checkFloat(lang.floatLiteral.run('3.14e5'), 314000.0, ''));

  test('float 3', () =>
      checkFloat(lang.floatLiteral.run('3.14e-5'), 0.0000314, ''));

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
             isFailure));

  test('chainl1 3', () =>
      expect(lang.natural.chainl1(addop).run('3 - 1 - 2'),
             isSuccess(0, '')));

  test('chainl1 4', () =>
      expect(lang.natural.chainl1(addop).run('a - 1 - 2'),
              isFailure));

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
             isFailure));

  test('chainr1 3', () =>
      expect(lang.intLiteral.chainr1(addop).run('3 - 1 - 2'),
             isSuccess(4, '')));

  test('chainr1 4', () =>
      expect(lang.intLiteral.chainr1(addop).run('a - 1 - 2'),
              isFailure));

  var big = "a";
  for (int i = 0; i < 15; i++) { big = '$big$big'; }

  test('no stack overflow many', () =>
      expect(char('a').many.run(big).value.fst.length, equals(32768)));

  test('no stack overflow skipMany', () =>
      expect(char('a').skipMany.run('${big}bb'), isSuccess(null, 'bb')));

  test('no stack overflow comment', () =>
      expect(lang.natural.run('1 /* $big */'), isSuccess(1, '')));
}
