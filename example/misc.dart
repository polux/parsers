library misc;

import 'package:parsers/parsers.dart';

main() {
  final let = string("let").notFollowedBy(alphanum);
  final comment = string('/*') > anyChar.manyUntil(string('*/'));
  print(let.run('let aa'));
  print(let.run('letaa'));
  print(comment.run('/* abcdef */'));
  print(char('a').maybe.parse('a'));
  print(char('a').maybe.parse('b'));
  print(char('a').sepEndBy(char(';')).parse('a;a;a'));
  print(char('a').sepEndBy(char(';')).parse('a;a;a;'));
  print(char('a').sepEndBy(char(';')).parse(''));
  print(char('a').sepEndBy(char(';')).parse(';'));
  print(char('a').sepEndBy1(char(';')).parse('a;a'));
  print(char('a').sepEndBy1(char(';')).parse('a;a;'));
  print(char('a').sepEndBy1(char(';')).run(''));
  print(char('a').sepEndBy1(char(';')).run(';'));

  final lang = new LanguageParsers(
      nestedComments: true,
      reservedNames: ['for', 'in']);
  print(letter.run('a'));
  print(lang.identifier.run('BarFoo toto'));
  print(lang.identifier.run('B6ar_Foo toto'));
  print(lang.identifier.run('7B6ar_Foo toto'));
  print(lang.identifier.run('_7B6ar_Foo toto'));

  print((lang.identifier > lang.identifier).run('a /* abc */ b'));
  print((lang.identifier > lang.identifier).run('a /* /* abc */ */ b'));
  print((lang.identifier > lang.identifier).run('a // blah \n b'));

  print(lang.reserved['for'].run('for a'));
  print(lang.reserved['for'].run('fora'));
  // print(lang.reserved['foo'].run('fora')); // should fail

  print(lang.charLiteral.run(r"'a'"));
  print(lang.charLiteral.run(r"'aa'"));
  print(lang.charLiteral.run(r"'''"));
  print(lang.charLiteral.run(r"'\t'"));
  print(lang.charLiteral.run(r"'\\'"));

  print(lang.stringLiteral.run(r'"aaa"'));
  print(lang.stringLiteral.run(r'"a\ta"'));
  print(lang.stringLiteral.run(r'"a"a"'));
  print(lang.stringLiteral.run(r'"aa\"aa"'));

  print(lang.natural.run('42'));
  print(lang.natural.run('0O42'));
  print(lang.natural.run('0X42'));
  print(lang.natural.run('0xFF'));
  print(lang.natural.run('-0X42'));
  print(lang.intLiteral.run('-0X42'));
  print(lang.intLiteral.run('-  0X42'));

  print(lang.floatLiteral.run('3.14116'));
  print(lang.floatLiteral.run('3e5'));
  print(lang.floatLiteral.run('3e-5'));
  print(lang.floatLiteral.run('3.14e5'));
  print(lang.floatLiteral.run('3.14e-5'));
}
