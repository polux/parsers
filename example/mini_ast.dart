library mini_adt;

import 'package:parsers/parsers.dart';
import 'package:persistent/persistent.dart';

final reservedNames = ["namespace",
                  "interface",
                  "dictionary",
//                  "bool",
                  "void"];
//                  "double",
//                  "int"];

class NamespaceDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  NamespaceDeclaration(this.name, this.body, [this.doc]);

  toString() => "NamespaceDeclaration($name, $body, $doc);";
}

class InterfaceDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  InterfaceDeclaration(this.name, this.body, [this.doc]);

  toString() => "InterfaceDeclaration($name, $body, $doc);";
}

class DictionaryDeclaration {
  final String name;
  final List body;
  final List<String> doc;

  DictionaryDeclaration(this.name, this.body, [this.doc]);

  toString() => "DictionaryDeclaration($name, $body, $doc);";
}

class TypeAppl {
  final String name;
  final List<TypeAppl> arguments;

  TypeAppl(this.name, this.arguments);

  toString() => "TypeAppl($name, $arguments);";
}

class Parameter {
  final String name;
  final TypeAppl type;

  Parameter(this.type, this.name);

  toString() => "Parameter($type, $name);";
}

class MethodDeclaration {
  TypeAppl returnType;
  String name;
  List parameters;
  List<String> doc;

  MethodDeclaration(this.returnType, this.name, this.parameters, [this.doc]);

  toString() => "MethodDeclaration($returnType, $name, $parameters, $doc)";
}

class FieldDeclaration {
  TypeAppl type;
  String name;
  List<String> doc;

  FieldDeclaration(this.type, this.name, [this.doc]);

  toString() => "FieldDeclaration($type, $name, $doc)";
}

NamespaceDeclaration namespaceDeclarationMapping(List<String> doc, _,
                                                 String name, List body, __) =>
    new NamespaceDeclaration(name.trim(), body, doc);

InterfaceDeclaration interfaceDeclarationMapping(List<String> doc, _,
                                                 String name, List body, __) =>
    new InterfaceDeclaration(name.trim(), body, doc);

MethodDeclaration methodDeclarationRegularMapping(List<String> doc,
                                                  TypeAppl returnType,
                                                  String name,
                                                  List parameters, _) =>
  new MethodDeclaration(returnType, name.trim(), parameters, doc);

MethodDeclaration methodDeclarationReservedMapping(List<String> doc,
                                                   String returnType,
                                                   String name,
                                                   List parameters, _) =>
  new MethodDeclaration(new TypeAppl(returnType.trim(), null), name.trim(),
      parameters, doc);

DictionaryDeclaration dictionaryDeclarationMapping(List<String> doc, _,
                                                   String name,
                                                   List body, __) =>
    new DictionaryDeclaration(name, body, doc);

FieldDeclaration fieldDeclarationMapping(List<String> doc, TypeAppl type,
                                         String name, _) =>
  new FieldDeclaration(type, name.trim(), doc);

class DataCoreParser extends LanguageParsers {

  DataCoreParser() : super(reservedNames: reservedNames,
                           commentStart: "",
                           commentEnd: "",
                           commentLine: "");

  Parser get docString => lexeme(_docStringOrSpaces.many);

  Parser get _docStringOrSpaces =>
        everythingBetween(string('//'), string('\n'))
      | everythingBetween(string('/*'), string('*/'), nested: true)
      | everythingBetween(string('/**'), string('*/'), nested: true);

  Parser get namespaceDeclaration =>
      docString
      + reserved["namespace"]
      + identifier
      + braces(namespaceBody)
      + semi
      ^ namespaceDeclarationMapping;

  Parser get namespaceBody => body.many;

  Parser get body => _body;

  Parser get _body => interfaceDeclaration | dictionaryDeclaration;

  Parser get interfaceDeclaration =>
      docString
      + reserved["interface"].record
      + identifier.record
      + braces(interfaceBody)
      + semi
      ^ interfaceDeclarationMapping;

  Parser get interfaceBody => method.many;

  Parser get method => _method;

  Parser get _method => regularMethod | voidMethod;

  Parser typeAppl() =>
      identifier
      + angles(rec(typeAppl).sepBy(comma)).orElse([])
      ^ (c, args) => new TypeAppl(c, args);

  Parser get parameter =>
      (typeAppl() % 'type')
      + (identifier % 'parameter')
      ^ (t, p) => new Parameter(t, p);

  Parser get regularMethod =>
      docString
      + typeAppl()
      + identifier.record
      + parens(parameter.sepBy(comma))
      + semi.record
      ^ methodDeclarationRegularMapping;

  Parser get voidMethod =>
      docString
      + reserved['void'].record
      + identifier.record
      + parens(parameter.sepBy(comma))
      + semi.record
      ^ methodDeclarationReservedMapping;

  Parser get dictionaryDeclaration =>
      docString
      + reserved["dictionary"]
      + identifier
      + braces(dictionaryBody)
      + semi
      ^ dictionaryDeclarationMapping;

  Parser get dictionaryBody => field.many;

  Parser get field => _field;

  Parser get _field => regularField;

  Parser get regularField =>
      docString
      + typeAppl()
      + identifier.record
      + semi
      ^ fieldDeclarationMapping;
}

final test = """

// Data core processor package
// Second comment line

namespace datacore {
  // Defined interface of the processor
  interface DataProc {
    // Loads data for the processor
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
  DataCoreParser dataCoreParser = new DataCoreParser();
  NamespaceDeclaration namespaceDeclaration =
      dataCoreParser.namespaceDeclaration.between(spaces, eof).parse(test);
  print("namespaceDeclaration = ${namespaceDeclaration}");
}