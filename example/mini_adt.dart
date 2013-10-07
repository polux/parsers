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
  dynamic name;
  dynamic body;
  Option doc;
  NamespaceDeclaration(this.name, this.body, [this.doc]);
}

class InterfaceDeclaration {
  dynamic name;
  dynamic body;
  Option doc;
  InterfaceDeclaration(this.name, this.body, [this.doc]);
}

class DictionaryDeclaration {
  dynamic name;
  dynamic body;
  Option doc;
  DictionaryDeclaration(this.name, this.body, [this.doc]);
}

class TypeAppl {
  final String name;
  final List<TypeAppl> arguments;

  TypeAppl(this.name, this.arguments);
}

class Parameter {
  final String name;
  final TypeAppl type;

  Parameter(this.type, this.name);
}

class MethodDeclaration {
  dynamic returnType;
  dynamic name;
  dynamic parameters;
  Option doc;
  MethodDeclaration(this.returnType, this.name, this.parameters, [this.doc]) {
  }
}

class FieldDeclaration {
  dynamic type;
  dynamic name;
  Option doc;
  FieldDeclaration(this.type, this.name, [this.doc]);
}

class DataCoreParser extends LanguageParsers {

  DataCoreParser() : super(reservedNames: reservedNames);

  get docString => lexeme(_docStringOrSpaces);

  get _docStringOrSpaces =>
      everythingBetween(string('//'), string('\n')).many.maybe
      | everythingBetween(string('/*'), string('*/'), nested: true).many.maybe
      | everythingBetween(string('/**'), string('*/'), nested: true).many.maybe
      | whiteSpace;

  get namespaceDeclaration =>
      docString
      + reserved["namespace"]
      + identifier
      + braces(namespaceBody)
      + semi
      ^ (d, _, n, nsb, __) => new NamespaceDeclaration(n, nsb, d);

  get namespaceBody => body.many;

  get body => _body;

  get _body => interfaceDeclaration | dictionaryDeclaration;

  get interfaceDeclaration =>
      docString
      + reserved["interface"].record
      + identifier.record
      + braces(interfaceBody)
      + semi
      ^ (d, _, n, nb, __) => new InterfaceDeclaration(n, nb, d);

  get interfaceBody => method.many;

  get method => _method;

  get _method => regularMethod | voidMethod;

  typeAppl() =>
      identifier
      + angles(rec(typeAppl).sepBy(comma)).orElse([])
      ^ (c, args) => new TypeAppl(c, args);

  get parameter =>
      (typeAppl() % 'type')
      + (identifier % 'parameter')
      ^ (t, p) => new Parameter(t, p);

  get regularMethod =>
      docString
      + typeAppl().record
      + identifier.record
      + parens(parameter.sepBy(comma)).record
      + semi.record
      ^ (d, t, i, p, _) => new MethodDeclaration(t, i, p, d);

  get voidMethod =>
      docString
      + reserved['void'].record
      + identifier.record
      + parens(parameter.sepBy(comma)).record
      + semi.record
      ^ (d, t, i, p, _) => new MethodDeclaration(t, i, p, d);

  get dictionaryDeclaration =>
      docString
      + reserved["dictionary"]
      + identifier
      + braces(dictionaryBody)
      + semi
      ^ (d, _, n, db, __) => new DictionaryDeclaration(n, db, d);

  get dictionaryBody => field.many;

  get field => _field;

  get _field => regularField;

  get regularField =>
      typeAppl().record
      + identifier.record
      + semi
      ^ (t, i, _) => new FieldDeclaration(t, i);
}

final test = """

// Data core processor package
// Second comment line

namespace datacore {
  // Defined interface of the processor
  interface DataProc {
    // Loads data for the processor
    bool loadData(array data);

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