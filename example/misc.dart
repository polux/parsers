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
}
