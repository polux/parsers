// Copyright (c) 2012, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Authors:
//  Adam Singer (financecoding@gmail.com)
//  Paul Brauner (polux@google.com)

library mini_ast;

import 'package:parsers/parsers.dart';

final reservedNames = ["namespace", "interface", "dictionary", "void"];

class NamespaceDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  NamespaceDeclaration(this.name, this.body, [this.doc]);

  String toString() => "NamespaceDeclaration($name, $body, $doc)";
}

class InterfaceDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  InterfaceDeclaration(this.name, this.body, [this.doc]);

  String toString() => "InterfaceDeclaration($name, $body, $doc)";
}

class DictionaryDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  DictionaryDeclaration(this.name, this.body, [this.doc]);

  String toString() => "DictionaryDeclaration($name, $body, $doc)";
}

class TypeAppl {
  final String name;
  final List<TypeAppl> arguments;

  TypeAppl(this.name, this.arguments);

  String toString() => "TypeAppl($name, $arguments)";
}

class Parameter {
  final String name;
  final TypeAppl type;

  Parameter(this.type, this.name);

  String toString() => "Parameter($type, $name)";
}

class MethodDeclaration {
  TypeAppl returnType;
  String name;
  List parameters;
  List<String> doc;

  MethodDeclaration(this.returnType, this.name, this.parameters, [this.doc]);

  String toString() =>
      "MethodDeclaration($returnType, $name, $parameters, $doc)";
}

class FieldDeclaration {
  TypeAppl type;
  String name;
  List<String> doc;

  FieldDeclaration(this.type, this.name, [this.doc]);

  String toString() => "FieldDeclaration($type, $name, $doc)";
}

NamespaceDeclaration namespaceDeclarationMapping(doc, _, name, body, __) =>
    NamespaceDeclaration(name, body, doc);

InterfaceDeclaration interfaceDeclarationMapping(doc, _, name, body, __) =>
    InterfaceDeclaration(name, body, doc);

MethodDeclaration methodDeclarationRegularMapping(
        doc, returnType, name, parameters, _) =>
    MethodDeclaration(returnType, name, parameters, doc);

MethodDeclaration methodDeclarationReservedMapping(
        doc, returnType, name, parameters, _) =>
    MethodDeclaration(TypeAppl(returnType, null), name, parameters, doc);

DictionaryDeclaration dictionaryDeclarationMapping(doc, _, name, body, __) =>
    DictionaryDeclaration(name, body, doc);

FieldDeclaration fieldDeclarationMapping(doc, type, name, _) =>
    FieldDeclaration(type, name, doc);

class DataCoreParser extends LanguageParsers {
  DataCoreParser()
      : super(
            reservedNames: reservedNames,
            // tells LanguageParsers to not handle comments
            commentStart: "",
            commentEnd: "",
            commentLine: "");

  Parser get docString => lexeme(_docString).many;

  Parser get _docString =>
      everythingBetween(string('//'), string('\n')) |
      everythingBetween(string('/*'), string('*/')) |
      everythingBetween(string('/**'), string('*/'));

  Parser get namespaceDeclaration =>
      docString +
          reserved["namespace"] +
          identifier +
          braces(namespaceBody) +
          semi ^
      namespaceDeclarationMapping;

  Parser get namespaceBody => body.many;

  Parser get body => interfaceDeclaration | dictionaryDeclaration;

  Parser get interfaceDeclaration =>
      docString +
          reserved["interface"] +
          identifier +
          braces(interfaceBody) +
          semi ^
      interfaceDeclarationMapping;

  Parser get interfaceBody => method.many;

  Parser get method => regularMethod | voidMethod;

  Parser typeAppl() =>
      identifier + angles(rec(typeAppl).sepBy(comma)).orElse([]) ^
      (c, args) => TypeAppl(c, args);

  Parser get parameter =>
      (typeAppl() % 'type') + (identifier % 'parameter') ^
      (t, p) => Parameter(t, p);

  Parser get regularMethod =>
      docString +
          typeAppl() +
          identifier +
          parens(parameter.sepBy(comma)) +
          semi ^
      methodDeclarationRegularMapping;

  Parser get voidMethod =>
      docString +
          reserved['void'] +
          identifier +
          parens(parameter.sepBy(comma)) +
          semi ^
      methodDeclarationReservedMapping;

  Parser get dictionaryDeclaration =>
      docString +
          reserved["dictionary"] +
          identifier +
          braces(dictionaryBody) +
          semi ^
      dictionaryDeclarationMapping;

  Parser get dictionaryBody => field.many;

  Parser get field =>
      docString + typeAppl() + identifier + semi ^ fieldDeclarationMapping;
}

final test = """
// Data core processor package
// Second comment line

namespace datacore {
  // Defined interface of the processor
  interface DataProc {
    // Loads data for the processor,
    // pass the size of the loaded data
    bool loadData(array data, int size);

    // Executes the processor
    void run();

    /* Returns the result of the processor */
    DataProcResult result();
  };

  /**
   * A data type for the processor result
   * Multi line comment
   * With information. 
   */
  dictionary DataProcResult {
    // Time spent processing
    double timeSpent;

    // Value calculated from processing
    int value;
  };
};
""";

void main() {
  DataCoreParser dataCoreParser = DataCoreParser();
  NamespaceDeclaration namespaceDeclaration =
      dataCoreParser.namespaceDeclaration.between(spaces, eof).parse(test);
  print(namespaceDeclaration);
}
