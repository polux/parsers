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
}
