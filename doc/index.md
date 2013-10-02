# Parsers User Guide

This document guides you through the usage of the [parsers][parsers homepage]
library, a parser combinator library for Dart. It assumes some basic knowledge
of Dart.

## Introduction

The _parsers_ library helps you build functions that take a string, check that
it belongs to some language and compute something out of it.

![parser image]

For instance, it helps you write a function that accepts strings made of digits
only and compute the integer they represent. But it can also help you building
more involved functions, like one that accepts valid Java programs only and
returns their AST (Abstract Syntax Tree).

It is called a [parser combinator] library because it is made of functions
which build complex parsers out of simpler parsers. For instance, by feeding
the `sepBy` function with a parser of integers and a parser of commas, we
obtain a parser of integers separated by commas. These parsers are themselves
a combination of simple parsers, etc. Ultimately, the library exposes a very
small set of primitive parsers and every other function it defines is built on
top of them.

![parser combinator image]

It is a powerful concept because it allows you to define domain specific
combinators and parameterized parsers. For instance, the `LanguageParser`
class that ships with the library defines a set of parsers specialized in
parsing programming languages. It is parameterized by things like the keywords
of the programming language, or the syntax of its comments, which gives you
control over the behaviour of these parsers while sparing you the gory details.

Now that you're convinced parser combinators are the greatest thing since
sliced bread, let's get started!

## Getting Started

If you know how to set up a Dart project with dependencies on third-party
libraries, you can safely [skip this section](#primitive-parsers). Simply
create a project depending on the latest version of the _parsers_ library.

Create a directory called `tutorial` with the following layout.

~~~{.bash}
tutorial/
  pubspec.yaml
  bin/
    tutorial.dart
~~~

In `pubspec.yaml`, define a project named `tutorial` depending the latest
version of the _parsers_ library.

~~~{.yaml}
name: tutorial
dependencies:
  parsers: any
~~~

In `bin/tutorial.dart`, import the _parsers_ library and define the main
function as below.

~~~{.dart}
import 'package:parsers/parsers.dart';

main() {
  final p = string('Hello World');
  print(p.parse('Hello World'));
}
~~~

Install the dependencies by running `pub install` in the `tutorial` directory.

~~~{.bash}
$ pub install
Resolving dependencies...
Downloading parsers 0.9.1...
Downloading unittest 0.2.8+2...
Downloading args 0.2.8+2...
Dependencies installed!
~~~

And finally run your program.

~~~{.bash}
$ dart bin/tutorial.dart 
Hello World
~~~

You're all Set!

## Primitive Parsers

The main class exposed by the library is [`Parser<A>`][Parser dartdoc]. What we
refer to as "parsers" in this document are instances of this class.

An instance of `Parser<A>` is an object which -- via the
[`parse`][parse dartdoc] method -- consumes a string and either computes a
value of type `A` or fails.

~~~{.dart}
Parser<Foo> p = ...;
p.parse("some string");  // returns a Foo or throws a parse error 
~~~

You should never have to call the constructor of `Parser`. That's what
primitive parsers combinators do for you. We introduce them below.

### String

One of the most primitive and simple parser combinators is [`string`][string
dartdoc]. It is a function that takes a string and returns a `Parser<String>`.

~~~{.dart}
Parser<String> p = string('foo');
~~~

Here `p` expects the string `'foo'` and will return `'foo'` on success.

~~~{.dart}
p.parse('foo');  // returns 'foo'
p.parse('bar');  // parse error
~~~

One thing to be aware of is that `p` accepts any string _starting with_ `'foo'`
and not only the 3-character long `'foo'` string.

~~~{.dart}
p.parse('foobar');  // returns 'foo'
~~~

It simply consumes the three first characters and leaves the rest to whichever
parser it is chained with, as we will see later.

### Disjunction

The `Parser` class overrides the [`|`][or dartdoc] operator which is the first
"real" parser combinator we'll encounter: it combines two `Parser`s to create a
new one.

Given two parsers `a` and `b`, the parser `a | b` (pronounced "a or b") is the
parser that returns `a`'s result if `a` succeeds, `b`'s result otherwise.

~~~{.dart}
final p = string('foo') | string('bar');

p.parse('foo');  // returns 'foo'
p.parse('bar');  // returns 'bar'
~~~

Of course, `b` can fail too, in which case `a | b` fails as a whole.

~~~{.dart}
p.parse('qux');  // fails
~~~

What is the type of `p`? In this case it is `Parser<String>` because both
`string('foo')` and `string('bar')` are parsers of type `Parser<String>`. But
if they were computing values of different types that would be their closest
common ancestor (usually `Parser<Object>`). So far however we have only
encountered parsers that compute strings. Let us see how to create parsers
computing something else.

### Mapping

The [`^`][map dartdoc] operator of `Parser` transforms the result
of a successful parse. It leaves a failure unchanged.

~~~{.dart}
Parser<int> p = string('123') ^ ((s) => int.parse(s) + 1);

p.parse('123');  // returns 124
p.parse('foo');  // parse error
~~~

This is how we obtain parsers which compute something useful (like an AST)
instead of simply echoing their input. It should be stressed that `^` doesn't
change which input the parser it applies to accepts, only its result.

As any other combinator, `^` applies to any parser, even to
composite ones.

~~~{.dart}
Parser<int> p = (string('1') | string('2') | string('3')) ^ int.parse;

p.parse('1');  // returns 1 
p.parse('2');  // returns 2 
p.parse('3');  // returns 3 
~~~

It can as well apply to individual branches of a disjunction, to unify their
types.

~~~{.dart}
Parser<String> one = string('one');
Parser<int> two = string('2') ^ int.parse;

Parser<int> oneOrTwo = one ^ ((_) => 1) | two;
~~~

These examples however are not very exciting, because we might as well write
`string('2') ^ ((_) => 2)` instead of `string('a') ^ int.parse` since 
`string('2')` is always going to return `'2'` on success anyway. In order
to build more interesting parsers we need to chain them an undetermined number
of times, which is what the next two sections are about.

### Sequencing

It would have been natural to introduce the sequencing of parsers earlier in
this guide. However, the way it is exposed in the _parsers_ library requires
some understanding of the `^` operator, which is why we only tackle it now.

Sequencing is achieved via the `+` operator.

~~~{.dart}
final protoParser = a + b;
~~~

Given two parsers `a` and `b`, `a + b` parses `a` then `b`. If one of them
fails, it fails altogether. However `a + b` is not quite completely a parser,
hence the name `protoParser`. The reason why it is not a parser is because it
is not obvious what it should compute. Parser `a` computes some value, parser
`b` computes some other value, but what should `a + b` compute?

The only available way to turn a proto parser into a real one is by calling its
`^` operator. It takes as many arguments as there are elements in the sequence.

~~~{.dart}
combine(x, y, z) => ['$z$y', x];
final p = string('foo') + string('bar') + string('baz') ^ combine;

p.parse('foobarbaz');  // returns ['bazbar', 'foo]
~~~

Since [+ has a higher precedence than ^][precedence] in Dart, `combine`
applies to the whole sequence. The operators in _parsers_ are chosen so that
they usually "do the right thing", but precedence can be tricky. When in doubt,
use parenthesis.

Thanks to `+` and `^` we can now define our very first combinator: a combinator
that takes a parser `p` and returns a parser of `p` parenthesized.

~~~{.dart}
Parser parens(Parser p) {
  return string('(') + p + string(')') ^ (left, x, right) => x;
}
final p = parens(string('foo'));

p.parse('(foo)');  // returns 'foo'
~~~

That's the beauty of parser combinator libraries: we piggyback on the host
language's abstraction mechanisms (here Dart functions) to define reusable
parsing behaviours. Most of the combinators of the _parsers_ library are
defined this way.

### Recursion

[parsers homepage]: https://github.com/polux/parsers
[parser combinator]: https://en.wikipedia.org/wiki/Parser_combinator
[Parser dartdoc]: dartdoc/parsers/Parser.html
[parse dartdoc]: dartdoc/parsers/Parser.html#parse
[string dartdoc]: dartdoc/parsers.html#string
[or dartdoc]: dartdoc/parsers/Parser.html#|
[map dartdoc]: dartdoc/parsers/Parser.html#^
[precedence]: https://www.dartlang.org/docs/spec/latest/dart-language-specification.html#h.sn1uuf2ffwwd
[parser image]: images/parser.png 
[parser combinator image]: images/parser_combinator.png 
