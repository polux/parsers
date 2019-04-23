// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Authors:
//   Paul Brauner (polux@google.com)
//   Adam Singer (financecoding@gmail.com)
//   Maxim Dikun (me@dikmax.name)

library parsers_test;

import 'package:parsers/parsers.dart';

import 'package:test/test.dart';

part 'src/parsers_model.dart';

_rest(parseResult) => parseResult.text.substring(parseResult.position.offset);

class FailureMatcher extends Matcher {
  String rest;

  FailureMatcher(this.rest);

  bool matches(parseResult, Map matchState) {
    return parseResult is ParseResult &&
        !parseResult.isSuccess &&
        _rest(parseResult) == rest;
  }

  Description describe(Description description) =>
      description.add('a parse failure with rest "$rest"');
}

class SuccessMatcher extends Matcher {
  final Object res;
  final String rest;

  SuccessMatcher(this.res, this.rest);

  bool matches(parseResult, Map matchState) {
    return parseResult is ParseResult &&
        parseResult.isSuccess &&
        equals(parseResult.value).matches(res, null) &&
        parseResult.text.substring(parseResult.position.offset) == rest;
  }

  Description describe(Description description) =>
      description.add('a parse success with value $res and rest "$rest"');
}

isFailure(rest) => FailureMatcher(rest as String);

isSuccess(res, rest) => SuccessMatcher(res, rest as String);

checkFloat(res, f, rest) {
  expect(res.isSuccess, isTrue);
  expect((res.value - f).abs() < 0.00001, isTrue);
  expect(res.rest, equals(rest));
}

checkList(res, list, rest) {
  expect(res.isSuccess, isTrue);
  expect(res.value, orderedEquals(list as Iterable));
  expect(res.value.rest, equals(rest));
}

main() {
  test(
      'position 1',
      () => expect(
          Position(1, 1, 1, tabStop: 4).addChar('\t').character, equals(5)));
  test(
      'position 2',
      () => expect(
          Position(1, 1, 2, tabStop: 4).addChar('\t').character, equals(5)));
  test(
      'position 3',
      () => expect(
          Position(1, 1, 4, tabStop: 4).addChar('\t').character, equals(5)));
  test(
      'position 4',
      () => expect(
          Position(1, 1, 5, tabStop: 4).addChar('\t').character, equals(9)));
  test('position 5',
      () => expect(Position(1, 1, 3).addChar('\t').character, equals(4)));

  test('char 1', () => expect(char('a').run('abc'), isSuccess('a', 'bc')));

  test('char 2', () => expect(char('a').run('a'), isSuccess('a', '')));

  test('char 3', () => expect(char('a').run('bac'), isFailure('bac')));

  test('char 4', () => expect(char('a').run('b'), isFailure('b')));

  test('char 5', () => expect(char('a').run(''), isFailure('')));

  test('string 1', () => expect(string('').run('abc'), isSuccess('', 'abc')));

  test('string 2',
      () => expect(string('foo').run('fooabc'), isSuccess('foo', 'abc')));

  test('string 3',
      () => expect(string('foo').run('barabc'), isFailure('barabc')));

  test('string 4', () => expect(string('foo').run('fo'), isFailure('fo')));

  test(
      'string 5', () => expect(string('foo').run('foo'), isSuccess('foo', '')));

  test(
      '> 1',
      () => expect(
          (char('a').thenKeep(char('b'))).run('abc'), isSuccess('b', 'c')));

  test(
      '> 2',
      () =>
          expect((char('a').thenKeep(char('b'))).run('bbc'), isFailure('bbc')));

  test(
      '> 3',
      () =>
          expect((char('a').thenKeep(char('b'))).run('aac'), isFailure('ac')));

  final let = string('let').notFollowedBy(alphanum);

  test('notFollowedBy 1',
      () => expect(let.run('let aa'), isSuccess('let', ' aa')));

  test('notFollowedBy 2', () => expect(let.run('letaa'), isFailure('aa')));

  many1Prop(f) => expect(f(char('a')).run(''), isSuccess([], ''));

  test('many 1 model', () => many1Prop(manyModel));
  test('many 1 impl', () => many1Prop(manyModel));

  many2Prop(f) => expect(f(char('a')).run('aab'), isSuccess(['a', 'a'], 'b'));

  test('many 2 model', () => many2Prop(manyModel));
  test('many 2 impl', () => many2Prop(manyModel));

  many3Prop(f) => expect(f(char('a')).run('bab'), isSuccess([], 'bab'));

  test('many 3 model', () => many3Prop(manyModel));
  test('many 3 impl', () => many3Prop(manyModel));

  skipMany1Prop(f) => expect(f(char('a')).run(''), isSuccess(null, ''));

  test('skipMany 1 model', () => skipMany1Prop(skipManyModel));
  test('skipMany 1 impl', () => skipMany1Prop(skipManyModel));

  skipMany2Prop(f) => expect(f(char('a')).run('aab'), isSuccess(null, 'b'));

  test('skipMany 2 model', () => skipMany2Prop(skipManyModel));
  test('skipMany 2 impl', () => skipMany2Prop(skipManyModel));

  skipMany3Prop(f) => expect(f(char('a')).run('bab'), isSuccess(null, 'bab'));

  test('skipMany 3 model', () => skipMany3Prop(skipManyModel));
  test('skipMany 3 impl', () => skipMany3Prop(skipManyModel));

  test('maybe 1',
      () => expect(char('a').maybe.run('a'), isSuccess(Option.some('a'), '')));

  test('maybe 2',
      () => expect(char('a').maybe.run('b'), isSuccess(Option.none(), 'b')));

  test(
      'sepBy 1',
      () => expect(char('a').sepBy(char(';')).run('a;a;a'),
          isSuccess(['a', 'a', 'a'], '')));

  test(
      'sepBy 2',
      () => expect(char('a').sepBy(char(';')).run('a;a;a;'),
          isSuccess(['a', 'a', 'a'], ';')));

  test('sepBy 3',
      () => expect(char('a').sepBy(char(';')).run(''), isSuccess([], '')));

  test('sepBy 4',
      () => expect(char('a').sepBy(char(';')).run(';'), isSuccess([], ';')));

  test('sepBy 5',
      () => expect(char('a').sepBy(char(';')).run(''), isSuccess([], '')));

  test(
      'sepBy1 1',
      () => expect(
          char('a').sepBy1(char(';')).run('a;a'), isSuccess(['a', 'a'], '')));

  test(
      'sepBy1 2',
      () => expect(
          char('a').sepBy1(char(';')).run('a;a;'), isSuccess(['a', 'a'], ';')));

  test('sepBy1 3',
      () => expect(char('a').sepBy1(char(';')).run(''), isFailure('')));

  test('sepBy1 4',
      () => expect(char('a').sepEndBy1(char(';')).run(';'), isFailure(';')));

  test(
      'sepEndBy 1',
      () => expect(char('a').sepEndBy(char(';')).run('a;a;a'),
          isSuccess(['a', 'a', 'a'], '')));

  test(
      'sepEndBy 2',
      () => expect(char('a').sepEndBy(char(';')).run('a;a;a;'),
          isSuccess(['a', 'a', 'a'], '')));

  test('sepEndBy 3',
      () => expect(char('a').sepEndBy(char(';')).run(''), isSuccess([], '')));

  test('sepEndBy 4',
      () => expect(char('a').sepEndBy(char(';')).run(';'), isSuccess([], ';')));

  test(
      'sepEndBy1 1',
      () => expect(char('a').sepEndBy1(char(';')).run('a;a'),
          isSuccess(['a', 'a'], '')));

  test(
      'sepEndBy1 2',
      () => expect(char('a').sepEndBy1(char(';')).run('a;a;'),
          isSuccess(['a', 'a'], '')));

  test('sepEndBy1 3',
      () => expect(char('a').sepEndBy1(char(';')).run(''), isFailure('')));

  test('sepEndBy1 4',
      () => expect(char('a').sepEndBy1(char(';')).run(';'), isFailure(';')));

  test('letter', () => expect(letter.run('a'), isSuccess('a', '')));

  manyUntilProp0(Parser Function(Parser<String>, Parser<String>) f) => expect(
      (string('/*').thenKeep((f(anyChar, string('*/'))))).run('/* abcdef */'),
      isSuccess(' abcdef '.split(''), ''));

  test('manyUntil 0 model', () => manyUntilProp0(manyUntilModel));
  test('manyUntil 0 impl', () => manyUntilProp0(manyUntilImpl));

  manyUntilProp1(f) => expect(f(anyChar, string('*/')).run(' a b c d */ e'),
      isSuccess(' a b c d '.split(''), ' e'));

  test('manyUntil 1 model', () => manyUntilProp1(manyUntilModel));
  test('manyUntil 1 impl', () => manyUntilProp1(manyUntilImpl));

  manyUntilProp2(f) =>
      expect(f(anyChar, string('*/')).run(' a b c d e'), isFailure(''));

  test('manyUntil 2 model', () => manyUntilProp2(manyUntilModel));
  test('manyUntil 2 impl', () => manyUntilProp2(manyUntilImpl));

  manyUntilProp3(f) => expect(
      f(anyChar, string('*/').lookAhead).run(' a b c d */ e'),
      isSuccess(' a b c d '.split(''), '*/ e'));

  test('manyUntil 3 model', () => manyUntilProp3(manyUntilModel));
  test('manyUntil 3 impl', () => manyUntilProp3(manyUntilImpl));

  skipManyUntilProp1(f) => expect(
      f(anyChar, string('*/')).run(' a b c d */ e'), isSuccess(null, ' e'));

  test('skipManyUntil 1 model', () => skipManyUntilProp1(skipManyUntilModel));
  test('skipManyUntil 1 impl', () => skipManyUntilProp1(skipManyUntilImpl));

  skipManyUntilProp2(f) =>
      expect(f(anyChar, string('*/')).run(' a b c d e'), isFailure(''));

  test('skipManyUntil 2 model', () => skipManyUntilProp2(skipManyUntilModel));
  test('skipManyUntil 2 impl', () => skipManyUntilProp2(skipManyUntilImpl));

  skipManyUntilProp3(f) => expect(
      f(anyChar, string('*/').lookAhead).run(' a b c d */ e'),
      isSuccess(null, '*/ e'));

  test('skipManyUntil 3 model', () => skipManyUntilProp3(skipManyUntilModel));
  test('skipManyUntil 3 impl', () => skipManyUntilProp3(skipManyUntilImpl));

  final lang =
      LanguageParsers(nestedComments: true, reservedNames: ['for', 'in']);

  test('semi 1', () => expect(lang.semi.run(';rest'), isSuccess(';', 'rest')));

  test('semi 2', () => expect(lang.semi.run('a'), isFailure('a')));

  test(
      'comma 1', () => expect(lang.comma.run(',rest'), isSuccess(',', 'rest')));

  test('comma 2', () => expect(lang.comma.run('a'), isFailure('a')));

  test(
      'colon 1', () => expect(lang.colon.run(':rest'), isSuccess(':', 'rest')));

  test('colon 2', () => expect(lang.colon.run('a'), isFailure('a')));

  test('dot 1', () => expect(lang.dot.run('.rest'), isSuccess('.', 'rest')));

  test('dot 2', () => expect(lang.dot.run('a'), isFailure('a')));

  test(
      'identifier 1',
      () => expect(
          lang.identifier.run('BarFoo toto'), isSuccess('BarFoo', 'toto')));

  test(
      'identifier 2',
      () => expect(
          lang.identifier.run('B6ar_Foo toto'), isSuccess('B6ar_Foo', 'toto')));

  test(
      'identifier 3',
      () => expect(
          lang.identifier.run('B6ar_Foo toto'), isSuccess('B6ar_Foo', 'toto')));

  test(
      'identifier 4',
      () => expect(
          lang.identifier.run('7B6ar_Foo toto'), isFailure('7B6ar_Foo toto')));

  test(
      'identifier 5',
      () => expect(lang.identifier.run('_7B6ar_Foo toto'),
          isSuccess('_7B6ar_Foo', 'toto')));

  test(
      'identifier 6',
      () => expect(lang.identifier.sepBy(lang.comma).run('abc, def, hij'),
          isSuccess(['abc', 'def', 'hij'], '')));

  test(
      'multi-line comment 1.1',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier)).run('a /* abc */ b'),
          isSuccess('b', '')));

  test(
      'multi-line comment 1.2',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier))
              .run('a /* x /* abc */ y */ b'),
          isSuccess('b', '')));

  test(
      'multi-line comment 1.3',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier))
              .run('a /* x /* abc */ y b'),
          isFailure('/* x /* abc */ y b')));

  test(
      'multi-line comment 1.4',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier)).run('a /*/**/*/ y b'),
          isSuccess('y', 'b')));

  test(
      'multi-line comment 1.5',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier)).run('a /*/**/ y b'),
          isFailure('/*/**/ y b')));

  test(
      'single-line comment 1.1',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier)).run('a // foo \n b'),
          isSuccess('b', '')));

  final noNest = LanguageParsers(nestedComments: false);

  test(
      'multi-line comment 2.1',
      () => expect(
          (noNest.identifier.thenKeep(lang.identifier)).run('a /* abc */ b'),
          isSuccess('b', '')));

  test(
      'multi-line comment 2.2',
      () => expect(
          (noNest.identifier.thenKeep(lang.identifier))
              .run('a /* x /* abc */ y */ b'),
          isSuccess('y', '*/ b')));

  test(
      'multi-line comment 2.3',
      () => expect(
          (noNest.identifier.thenKeep(lang.identifier))
              .run('a /* x /* abc */ y b'),
          isSuccess('y', 'b')));

  test(
      'multi-line comment 2.4',
      () => expect(
          (noNest.identifier.thenKeep(lang.identifier)).run('a /*/**/*/ y b'),
          isFailure('*/ y b')));

  test(
      'multi-line comment 2.5',
      () => expect(
          (noNest.identifier.thenKeep(lang.identifier)).run('a /*/**/ y b'),
          isSuccess('y', 'b')));

  test(
      'single-line comment 2.1',
      () => expect(
          (lang.identifier.thenKeep(lang.identifier)).run('a // foo \n b'),
          isSuccess('b', '')));

  test('reserved 1',
      () => expect(lang.reserved['for'].run('for a'), isSuccess('for', 'a')));

  test('reserved 2',
      () => expect(lang.reserved['for'].run('fora'), isFailure('a')));

  test('reserved 3',
      () => expect(() => lang.reserved['foo'].run('fora'), throws));

  test(
      'char 1', () => expect(lang.charLiteral.run(r"'a'"), isSuccess('a', '')));

  test('char 2', () => expect(lang.charLiteral.run(r"'aa'"), isFailure("a'")));

  test('char 3', () => expect(lang.charLiteral.run(r"''"), isFailure("'")));

  test('char 4',
      () => expect(lang.charLiteral.run(r"'\t'"), isSuccess('\t', '')));

  test('char 5',
      () => expect(lang.charLiteral.run(r"'\\'"), isSuccess(r'\', '')));

  test('string 1',
      () => expect(lang.stringLiteral.run(r'"aaa"'), isSuccess('aaa', '')));

  test('string 2',
      () => expect(lang.stringLiteral.run(r'"a\ta"'), isSuccess('a\ta', '')));

  test('string 3',
      () => expect(lang.stringLiteral.run(r'"a\\a"'), isSuccess(r'a\a', '')));

  test('string 4',
      () => expect(lang.stringLiteral.run(r'"a"a"'), isSuccess(r'a', 'a"')));

  test('natural 1', () => expect(lang.natural.run('42'), isSuccess(42, '')));

  test('natural 2', () => expect(lang.natural.run('0O42'), isSuccess(34, '')));

  test('natural 3', () => expect(lang.natural.run('0o42'), isSuccess(34, '')));

  test('natural 4', () => expect(lang.natural.run('0X42'), isSuccess(66, '')));

  test('natural 5', () => expect(lang.natural.run('0xFf'), isSuccess(255, '')));

  test(
      'natural 6', () => expect(lang.natural.run('-0x42'), isFailure('-0x42')));

  test('decimal 1', () => expect(lang.decimal.run('42'), isSuccess(42, '')));

  test(
      'decimal 2', () => expect(lang.decimal.run('-0x42'), isFailure('-0x42')));

  test('int 1', () => expect(lang.intLiteral.run('-0x42'), isSuccess(-66, '')));

  test('int 2',
      () => expect(lang.intLiteral.run('-  0x42'), isSuccess(-66, '')));

  test('int 3', () => expect(lang.intLiteral.run('1'), isSuccess(1, '')));

  test('int 4', () => expect(lang.intLiteral.run(' 1'), isSuccess(1, '')));

  test('int 5',
      () => expect(lang.intLiteral.run('6492   '), isSuccess(6492, '')));

  test('float 1',
      () => expect(lang.floatLiteral.run('3.14'), isSuccess(3.14, '')));

  test('float 2',
      () => expect(lang.floatLiteral.run('3.14e5'), isSuccess(314000.0, '')));

  test('float 3',
      () => expect(lang.floatLiteral.run('3.14e-5'), isSuccess(3.14e-5, '')));

  test(
      'parens 1',
      () => expect(lang.parens(string('abc')).run('(abc)rest'),
          isSuccess('abc', 'rest')));

  test('parens 2',
      () => expect(lang.parens(string('abc')).run('abc)'), isFailure('abc)')));

  test('parens 3',
      () => expect(lang.parens(string('abc')).run('(abc'), isFailure('')));

  test(
      'braces 1',
      () => expect(lang.braces(string('abc')).run('{abc}rest'),
          isSuccess('abc', 'rest')));

  test('braces 2',
      () => expect(lang.braces(string('abc')).run('abc}'), isFailure('abc}')));

  test('braces 3',
      () => expect(lang.braces(string('abc')).run('{abc'), isFailure('')));

  test(
      'angles 1',
      () => expect(lang.angles(string('abc')).run('<abc>rest'),
          isSuccess('abc', 'rest')));

  test('angles 2',
      () => expect(lang.angles(string('abc')).run('abc>'), isFailure('abc>')));

  test('angles 3',
      () => expect(lang.angles(string('abc')).run('<abc'), isFailure('')));

  test(
      'brackets 1',
      () => expect(lang.brackets(string('abc')).run('[abc]rest'),
          isSuccess('abc', 'rest')));

  test(
      'brackets 2',
      () =>
          expect(lang.brackets(string('abc')).run('abc]'), isFailure('abc]')));

  test('brackets 3',
      () => expect(lang.brackets(string('abc')).run('[abc'), isFailure('')));

  test(
      'chainl 1',
      () => expect(
          lang.natural.chainl(success((x, y) => x + y), 42).run('1 2 3'),
          isSuccess(6, '')));

  test(
      'chainl 2',
      () => expect(
          lang.natural.chainl(success((x, y) => x + y), 42).run('a 2 3'),
          isSuccess(42, 'a 2 3')));

  final addop = (lang.symbol('+').thenKeep(success((x, y) => x + y))) |
      (lang.symbol('-').thenKeep(success((x, y) => x - y)));

  test(
      'chainl 3',
      () => expect(
          lang.natural.chainl(addop as Parser<Function>, 42).run('3 - 1 - 2'),
          isSuccess(0, '')));

  test(
      'chainl 4',
      () => expect(
          lang.natural.chainl(addop as Parser<Function>, 42).run('a - 1 - 2'),
          isSuccess(42, 'a - 1 - 2')));

  chainl1Prop1(f) => expect(
      f(lang.natural, success((x, y) => x + y)).run('1 2 3'), isSuccess(6, ''));

  test('chainl1 1 model', () => chainl1Prop1(chainl1Model));
  test('chainl1 1 impl', () => chainl1Prop1(chainl1Impl));

  chainl1Prop2(f) => expect(
      f(lang.natural, success((x, y) => x + y)).run('a 2 3'),
      isFailure('a 2 3'));

  test('chainl1 2 model', () => chainl1Prop2(chainl1Model));
  test('chainl1 2 impl', () => chainl1Prop2(chainl1Impl));

  chainl1Prop3(f) =>
      expect(f(lang.natural, addop).run('3 - 1 - 2'), isSuccess(0, ''));

  test('chainl1 3 model', () => chainl1Prop3(chainl1Model));
  test('chainl1 3 impl', () => chainl1Prop3(chainl1Impl));

  chainl1Prop4(f) =>
      expect(f(lang.natural, addop).run('a - 1 - 2'), isFailure('a - 1 - 2'));

  test('chainl1 4 model', () => chainl1Prop4(chainl1Model));
  test('chainl1 4 impl', () => chainl1Prop4(chainl1Impl));

  test(
      'chainr 1',
      () => expect(
          lang.natural.chainr(success((x, y) => x + y), 42).run('1 2 3'),
          isSuccess(6, '')));

  test(
      'chainr 2',
      () => expect(
          lang.natural.chainr(success((x, y) => x + y), 42).run('a 2 3'),
          isSuccess(42, 'a 2 3')));

  test(
      'chainr 3',
      () => expect(
          lang.natural.chainr(addop as Parser<Function>, 42).run('3 - 1 - 2'),
          isSuccess(4, '')));

  test(
      'chainr 4',
      () => expect(
          lang.intLiteral
              .chainr(addop as Parser<Function>, 42)
              .run('a - 1 - 2'),
          isSuccess(42, 'a - 1 - 2')));

  test(
      'chainr1 1',
      () => expect(
          lang.intLiteral.chainr1(success((x, y) => x + y)).run('1 2 3'),
          isSuccess(6, '')));

  test(
      'chainr1 2',
      () => expect(
          lang.intLiteral.chainr1(success((x, y) => x + y)).run('a 2 3'),
          isFailure('a 2 3')));

  test(
      'chainr1 3',
      () => expect(
          lang.intLiteral.chainr1(addop as Parser<Function>).run('3 - 1 - 2'),
          isSuccess(4, '')));

  test(
      'chainr1 4',
      () => expect(
          lang.intLiteral.chainr1(addop as Parser<Function>).run('a - 1 - 2'),
          isFailure('a - 1 - 2')));

  test(
      'choice 1',
      () => expect(choice([char('a'), char('b'), char('c')]).run('b'),
          isSuccess('b', '')));

  test(
      'choice 2',
      () => expect(
          choice([char('a'), char('b'), char('c')]).run('d'), isFailure('d')));

  test(
      'skipEverythingBetween 1',
      () => expect(
          skipEverythingBetween(string('ab'), string('ac'))
              .run('ab aaa ab aaa ac aaa ac foo'),
          isSuccess(null, ' aaa ac foo')));

  test(
      'skipEverythingBetween 2',
      () => expect(
          skipEverythingBetween(string('ab'), string('ac'), nested: true)
              .run('ab aaa ab aaa ac aaa ac foo'),
          isSuccess(null, ' foo')));

  test(
      'skipEverythingBetween 3',
      () => expect(
          skipEverythingBetween(string('ab'), string('ac')).run('abaaaaa'),
          isFailure('')));

  test(
      'skipEverythingBetween 4',
      () => expect(
          skipEverythingBetween(string('ab'), string('ac'), nested: true)
              .run('abaaaaa'),
          isFailure('')));

  test(
      'everythingBetween 1',
      () => expect(
          everythingBetween(string('ab'), string('ac'))
              .run('ab aaa ab aaa ac aaa ac foo'),
          isSuccess(' aaa ab aaa ', ' aaa ac foo')));

  test(
      'everythingBetween 2',
      () => expect(
          everythingBetween(string('ab'), string('ac'), nested: true)
              .run('ab aaa ab aaa ac aaa ac foo'),
          isSuccess(' aaa ab aaa ac aaa ', ' foo')));

  test(
      'everythingBetween 3',
      () => expect(everythingBetween(string('ab'), string('ac')).run('abaaaaa'),
          isFailure('')));

  test(
      'everythingBetween 4',
      () => expect(
          everythingBetween(string('ab'), string('ac'), nested: true)
              .run('abaaaaa'),
          isFailure('')));

  test(
      'record 1',
      () =>
          expect(char('a').many.record.run('aaaabb'), isSuccess('aaaa', 'bb')));

  test('record 2',
      () => expect(string('aa').record.run('abaabb'), isFailure('abaabb')));

  test('record 2', () => expect(char('a').record.run(''), isFailure('')));

  test(
      'commit 1',
      () =>
          expect((char('a').committed | char('b')).run('bc'), isFailure('bc')));

  test(
      'commit 2',
      () => expect(
          (char('a').committed | char('b')).run('ac'), isSuccess('a', 'c')));

  test(
      'commit 3',
      () => expect(
          (char('a').thenKeep(char('b').committed) | char('a')).run('acc'),
          isFailure('cc')));

  test(
      'commit 4',
      () => expect(
          (char('a').thenKeep(char('b').committed) | char('a')).run('abc'),
          isSuccess('b', 'c')));

  test('commit 5',
      () => expect(char('a').committed.many.run('ccc'), isFailure('ccc')));

  test('commit 6',
      () => expect(char('a').committed.many.run('aac'), isFailure('c')));

  test('commit 7',
      () => expect(char('a').committed.many.run('aaa'), isFailure('')));

  test('commit 8',
      () => expect(char('a').committed.many.run(''), isFailure('')));

  test('commit 9',
      () => expect(char('a').committed.skipMany.run('ccc'), isFailure('ccc')));

  test('commit 10',
      () => expect(char('a').committed.skipMany.run('aac'), isFailure('c')));

  test('commit 11',
      () => expect(char('a').committed.skipMany.run('aaa'), isFailure('')));

  test('commit 12',
      () => expect(char('a').committed.skipMany.run(''), isFailure('')));

  plus(x, y) => x + y;

  test(
      'commit 13',
      () => expect(
          lang.natural.committed.chainl(success(plus), 42).run('1 2 3'),
          isFailure('')));

  commit135(f) => expect(
      f(lang.natural.committed, success(plus)).run('1 2 3'), isFailure(''));

  test('commit 13.5 model', () => commit135(chainl1Model));
  test('commit 13.5 model', () => commit135(chainl1Impl));

  test(
      'commit 14',
      () => expect(
          lang.natural.committed.chainl(success(plus), 42).run('a 2 3'),
          isFailure('a 2 3')));

  commit145(f) => expect(f(lang.natural.committed, success(plus)).run('a 2 3'),
      isFailure('a 2 3'));

  test('commit 14.5 model', () => commit145(chainl1Model));
  test('commit 14.5 model', () => commit145(chainl1Impl));

  test(
      'commit 15',
      () => expect(
          lang.natural.chainl(success(plus).committed, 42).run('1 2 3'),
          isFailure('')));

  commit155(f) => expect(
      f(lang.natural, success(plus).committed).run('1 2 3'), isFailure(''));

  test('commit 15.5 model', () => commit155(chainl1Model));
  test('commit 15.5 model', () => commit155(chainl1Impl));

  test(
      'commit 16',
      () => expect(
          lang.natural.chainl(success(plus).committed, 42).run('a 2 3'),
          isSuccess(42, 'a 2 3')));

  commit165(f) => expect(f(lang.natural, success(plus).committed).run('a 2 3'),
      isFailure('a 2 3'));

  test('commit 16.5 model', () => commit165(chainl1Model));
  test('commit 16.5 model', () => commit165(chainl1Impl));

  test(
      'commit 17',
      () => expect(
          choice([char('a').committed, char('b'), char('c')]).run('az'),
          isSuccess('a', 'z')));

  test(
      'commit 18',
      () => expect(
          choice([char('a').committed, char('b'), char('c')]).run('bz'),
          isFailure('bz')));

  test(
      'commit 19',
      () => expect(
          choice([char('a'), char('b').committed, char('c')]).run('bz'),
          isSuccess('b', 'z')));

  test(
      'commit 20',
      () => expect(
          choice([char('a'), char('b').committed, char('c')]).run('cz'),
          isFailure('cz')));

  commit21Prop(f) =>
      expect(f(char('a').committed, char('z')).run('ccc'), isFailure('ccc'));

  test('commit 21 model', () => commit21Prop(skipManyUntilModel));
  test('commit 21 impl', () => commit21Prop(skipManyUntilImpl));

  commit22Prop(f) =>
      expect(f(char('a').committed, char('z')).run('aac'), isFailure('c'));

  test('commit 22 model', () => commit22Prop(skipManyUntilModel));
  test('commit 22 impl', () => commit22Prop(skipManyUntilImpl));

  commit23Prop(f) =>
      expect(f(char('a').committed, char('z')).run('aaa'), isFailure(''));

  test('commit 23 model', () => commit23Prop(skipManyUntilModel));
  test('commit 23 impl', () => commit23Prop(skipManyUntilImpl));

  commit24Prop(f) =>
      expect(f(char('a').committed, char('z')).run(''), isFailure(''));

  test('commit 24 model', () => commit24Prop(skipManyUntilModel));
  test('commit 24 impl', () => commit24Prop(skipManyUntilImpl));

  commit25Prop(f) => expect(
      f(char('a').committed, char('z')).run('aaazw'), isSuccess(null, 'w'));

  test('commit 25 model', () => commit25Prop(skipManyUntilModel));
  test('commit 25 impl', () => commit25Prop(skipManyUntilImpl));

  commit26Prop(f) => expect(
      f(char('a'), char('z').committed).run('aaazw'), isFailure('aaazw'));

  test('commit 26 model', () => commit26Prop(skipManyUntilModel));
  test('commit 26 impl', () => commit26Prop(skipManyUntilImpl));

  commit27Prop(f) =>
      expect(f(char('a'), char('z').committed).run('zw'), isSuccess(null, 'w'));

  test('commit 27 model', () => commit27Prop(skipManyUntilModel));
  test('commit 27 impl', () => commit27Prop(skipManyUntilImpl));

  commit28Prop(f) =>
      expect(f(char('a').committed, char('z')).run('ccc'), isFailure('ccc'));

  test('commit 28 model', () => commit28Prop(manyUntilModel));
  test('commit 28 impl', () => commit28Prop(manyUntilImpl));

  commit29Prop(f) =>
      expect(f(char('a').committed, char('z')).run('aac'), isFailure('c'));

  test('commit 29 model', () => commit29Prop(manyUntilModel));
  test('commit 29 impl', () => commit29Prop(manyUntilImpl));

  commit30Prop(f) =>
      expect(f(char('a').committed, char('z')).run('aaa'), isFailure(''));

  test('commit 30 model', () => commit30Prop(manyUntilModel));
  test('commit 30 impl', () => commit30Prop(manyUntilImpl));

  commit31Prop(f) =>
      expect(f(char('a').committed, char('z')).run(''), isFailure(''));

  test('commit 31 model', () => commit31Prop(manyUntilModel));
  test('commit 31 impl', () => commit31Prop(manyUntilImpl));

  commit32Prop(f) => expect(f(char('a').committed, char('z')).run('aaazw'),
      isSuccess(['a', 'a', 'a'], 'w'));

  test('commit 32 model', () => commit32Prop(manyUntilModel));
  test('commit 32 impl', () => commit32Prop(manyUntilImpl));

  commit33Prop(f) => expect(
      f(char('a'), char('z').committed).run('aaazw'), isFailure('aaazw'));

  test('commit 33 model', () => commit33Prop(manyUntilModel));
  test('commit 33 impl', () => commit33Prop(manyUntilImpl));

  commit34Prop(f) =>
      expect(f(char('a'), char('z').committed).run('zw'), isSuccess([], 'w'));

  test('commit 34 model', () => commit34Prop(manyUntilModel));
  test('commit 34 impl', () => commit34Prop(manyUntilImpl));

  commit35Prop(f) =>
      expect(f(char('a').committed).run('ccc'), isFailure('ccc'));

  test('commit 35 model', () => commit35Prop(manyModel));
  test('commit 35 impl', () => commit35Prop(manyImpl));

  commit36Prop(f) => expect(f(char('a').committed).run('aac'), isFailure('c'));

  test('commit 36 model', () => commit36Prop(manyModel));
  test('commit 36 impl', () => commit36Prop(manyImpl));

  commit37Prop(f) => expect(f(char('a').committed).run('aaa'), isFailure(''));

  test('commit 37 model', () => commit37Prop(manyModel));
  test('commit 37 impl', () => commit37Prop(manyImpl));

  commit38Prop(f) => expect(f(char('a').committed).run(''), isFailure(''));

  test('commit 38 model', () => commit38Prop(manyModel));
  test('commit 38 impl', () => commit38Prop(manyImpl));

  commit39Prop(f) =>
      expect(f(char('a').committed).run('aaazw'), isFailure('zw'));

  test('commit 39 model', () => commit39Prop(manyModel));
  test('commit 39 impl', () => commit39Prop(manyImpl));

  commit40Prop(f) =>
      expect(f(char('a').committed).run('ccc'), isFailure('ccc'));

  test('commit 40 model', () => commit40Prop(skipManyModel));
  test('commit 40 impl', () => commit40Prop(skipManyImpl));

  commit41Prop(f) => expect(f(char('a').committed).run('aac'), isFailure('c'));

  test('commit 41 model', () => commit41Prop(skipManyModel));
  test('commit 41 impl', () => commit41Prop(skipManyImpl));

  commit42Prop(f) => expect(f(char('a').committed).run('aaa'), isFailure(''));

  test('commit 42 model', () => commit42Prop(skipManyModel));
  test('commit 42 impl', () => commit42Prop(skipManyImpl));

  commit43Prop(f) => expect(f(char('a').committed).run(''), isFailure(''));

  test('commit 43 model', () => commit43Prop(skipManyModel));
  test('commit 43 impl', () => commit43Prop(skipManyImpl));

  commit44Prop(f) =>
      expect(f(char('a').committed).run('aaazw'), isFailure('zw'));

  test('commit 44 model', () => commit44Prop(skipManyModel));
  test('commit 44 impl', () => commit44Prop(skipManyImpl));

  commit45Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('d')).apply(char('e')).apply(char('f')));
    return expect(f(p).run('abcabczz'), isSuccess(['abc', 'abc'], 'zz'));
  }

  test('commit 45 model', () => commit45Prop(manyModel));
  test('commit 45 impl', () => commit45Prop(manyImpl));

  commit46Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('d')).apply(char('e')).apply(char('f')));
    return expect(
        f(p).run('abcdefabczz'), isSuccess(['abc', 'def', 'abc'], 'zz'));
  }

  test('commit 46 model', () => commit46Prop(manyModel));
  test('commit 46 impl', () => commit46Prop(manyImpl));

  commit47Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('a')).apply(char('e')).apply(char('f')));
    return expect(f(p).run('abcaefzz'), isFailure('efzz'));
  }

  test('commit 47 model', () => commit47Prop(manyModel));
  test('commit 47 impl', () => commit47Prop(manyImpl));

  commit475Prop(f) {
    final p = f(char('x').thenKeep(char('a').committed)).thenKeep(string('b')) |
        string('xaxac');
    return expect(p.run('xaxac'), isFailure('c'));
  }

  test('commit 47.5 model', () => commit475Prop(manyModel));
  test('commit 47.5 impl', () => commit475Prop(manyImpl));

  commit48Prop(f) {
    final p = (char('a').thenKeep(char('b').committed.thenKeep(char('c')))) |
        (char('d').thenKeep(char('e').thenKeep(char('f'))));
    return expect(f(p).run('abcabczz'), isSuccess(null, 'zz'));
  }

  test('commit 48 model', () => commit48Prop(skipManyModel));
  test('commit 48 impl', () => commit48Prop(skipManyImpl));

  commit49Prop(f) {
    final p = (char('a').thenKeep(char('b').committed.thenKeep(char('c')))) |
        (char('d').thenKeep(char('e').thenKeep(char('f'))));
    return expect(f(p).run('abcdefabczz'), isSuccess(null, 'zz'));
  }

  test('commit 49 model', () => commit49Prop(skipManyModel));
  test('commit 49 impl', () => commit49Prop(skipManyImpl));

  commit50Prop(f) {
    final p = (char('a').thenKeep(char('b').committed.thenKeep(char('c')))) |
        (char('d').thenKeep(char('e').thenKeep(char('f'))));
    return expect(f(p).run('abcaefzz'), isFailure('efzz'));
  }

  test('commit 50 model', () => commit50Prop(skipManyModel));
  test('commit 50 impl', () => commit50Prop(skipManyImpl));

  commit51Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('a')).apply(char('e')).apply(char('f')));
    return expect(
        f(p, char('z')).run('abcabczz'), isSuccess(['abc', 'abc'], 'z'));
  }

  test('commit 51 model', () => commit51Prop(manyUntilModel));
  test('commit 51 impl', () => commit51Prop(manyUntilImpl));

  commit515Prop(f) {
    final p =
        (f(char('x').thenKeep(char('a').committed)).thenKeep(string('b'))) |
            string('xaxac');
    return expect(p.run('xaxac'), isFailure('c'));
  }

  test('commit 51.5 model', () => commit515Prop(skipManyModel));
  test('commit 51.5 impl', () => commit515Prop(skipManyImpl));

  commit52Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('d')).apply(char('e')).apply(char('f')));
    return expect(f(p, char('z')).run('abcdefabczz'),
        isSuccess(['abc', 'def', 'abc'], 'z'));
  }

  test('commit 52 model', () => commit52Prop(manyUntilModel));
  test('commit 52 impl', () => commit52Prop(manyUntilModel));

  commit53Prop(f) {
    t3(x) => (y) => (z) => '$x$y$z';
    final p = (success(t3)
            .apply(char('a'))
            .apply(char('b').committed)
            .apply(char('c'))) |
        (success(t3).apply(char('a')).apply(char('e')).apply(char('f')));
    return expect(f(p, char('z')).run('abcaefzz'), isFailure('efzz'));
  }

  test('commit 53 model', () => commit53Prop(manyUntilModel));
  test('commit 53 impl', () => commit53Prop(manyUntilModel));

  commit54Prop(f) {
    final p = f(char('x').thenKeep(char('a').committed), char('z'))
            .thenKeep(string('b')) |
        string('xaxazc');
    return expect(p.run('xaxazc'), isFailure('c'));
  }

  test('commit 54 model', () => commit54Prop(manyUntilModel));
  test('commit 54 impl', () => commit54Prop(manyUntilImpl));

  commit55Prop(f) {
    final p = f(char('x').thenKeep(char('a').committed), char('z')) |
        string('xaxazc');
    return expect(p.run('xaxaw'), isFailure('w'));
  }

  test('commit 55 model', () => commit55Prop(manyUntilModel));
  test('commit 55 impl', () => commit55Prop(manyUntilImpl));

  commit56Prop(f) {
    t3(x) => (y) => (z) =>
        int.parse(x as String) +
        int.parse(y as String) +
        int.parse(z as String);
    plus(x, y) => x + y;
    final p = (success(t3)
            .apply(char('1'))
            .apply(char('2').committed)
            .apply(char('3'))) |
        (success(t3).apply(char('4')).apply(char('5')).apply(char('6')));
    return expect(f(p, success(plus)).run('123456123zz'), isSuccess(27, 'zz'));
  }

  test('commit 56 model', () => commit56Prop(chainl1Model));
  test('commit 56 impl', () => commit56Prop(chainl1Impl));

  commit57Prop(f) {
    t3(x) => (y) => (z) =>
        int.parse(x as String) +
        int.parse(y as String) +
        int.parse(z as String);
    plus(x, y) => x + y;
    final p = (success(t3)
            .apply(char('1'))
            .apply(char('2').committed)
            .apply(char('3'))) |
        (success(t3).apply(char('1')).apply(char('5')).apply(char('6')));
    return expect(f(p, success(plus)).run('123156zz'), isFailure('56zz'));
  }

  test('commit 57 model', () => commit57Prop(chainl1Model));
  test('commit 57 impl', () => commit57Prop(chainl1Impl));

  commit58Prop(f) {
    plus(x, y) => '$x$y';
    final p = f(char('x').thenKeep(char('a').committed), success(plus))
            .thenKeep(string('b')) |
        string('xaxac');
    return expect(p.run('xaxac'), isFailure('c'));
  }

  test('commit 58 model', () => commit58Prop(chainl1Model));
  test('commit 58 impl', () => commit58Prop(chainl1Impl));

  commit59Prop(f) {
    plus(x, y) => '$x$y';
    final p = f(char('x').thenKeep(char('a')), success(plus).committed)
            .thenKeep(string('b')) |
        string('xaxac');
    return expect(p.run('xaxac'), isFailure('c'));
  }

  test('commit 59 model', () => commit59Prop(chainl1Model));
  test('commit 59 impl', () => commit59Prop(chainl1Impl));

  test(
      'sequence map 1',
      () => expect((char('a').and(char('b')).map((x, y) => '$y$x')).run('abc'),
          isSuccess('ba', 'c')));

  test(
      'sequence map 2',
      () => expect((char('a').and(char('b')).map((x, y) => '$y$x')).run('acb'),
          isFailure('cb')));

  test(
      'sequence list 1',
      () => expect(
          (char('a') + char('b')).list.run('abc'), isSuccess(['a', 'b'], 'c')));

  test('sequence list 2',
      () => expect((char('a') + char('b')).list.run('acb'), isFailure('cb')));

  var big = 'a';
  for (int i = 0; i < 15; i++) {
    big = '$big$big';
  }

  test('no stack overflow many',
      () => expect(char('a').many.run(big).value.length, equals(32768)));

  test('no stack overflow skipMany',
      () => expect(char('a').skipMany.run('${big}bb'), isSuccess(null, 'bb')));

  test(
      'no stack overflow manyUntil',
      () => expect(anyChar.manyUntil(char('b')).run('${big}b').value.length,
          equals(32768)));

  test('no stack overflow comment',
      () => expect(lang.natural.run('1 /* $big */'), isSuccess(1, '')));
}
