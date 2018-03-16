part of parsers;

class ParserAccumulator2<T1, T2> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  ParserAccumulator2(this.p1, this.p2);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator3<T1, T2, T3> and<T3>(Parser<T3> p) =>
      new ParserAccumulator3(p1, p2, p);

  /// Alias for [and]
  ParserAccumulator3 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2)) =>
      success((T1 x1) => (T2 x2) => f(x1, x2)).apply(p1).apply(p2);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => [x1, x2]).apply(p1).apply(p2);
}

class ParserAccumulator3<T1, T2, T3> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  ParserAccumulator3(this.p1, this.p2, this.p3);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator4<T1, T2, T3, T4> and<T4>(Parser<T4> p) =>
      new ParserAccumulator4(p1, p2, p3, p);

  /// Alias for [and]
  ParserAccumulator4 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => f(x1, x2, x3)).apply(p1).apply(p2).apply(p3);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => [x1, x2, x3]).apply(p1).apply(p2).apply(p3);
}

class ParserAccumulator4<T1, T2, T3, T4> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  ParserAccumulator4(this.p1, this.p2, this.p3, this.p4);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator5<T1, T2, T3, T4, T5> and<T5>(Parser<T5> p) =>
      new ParserAccumulator5(p1, p2, p3, p4, p);

  /// Alias for [and]
  ParserAccumulator5 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => f(x1, x2, x3, x4)).apply(p1).apply(p2).apply(p3).apply(p4);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => [x1, x2, x3, x4]).apply(p1).apply(p2).apply(p3).apply(p4);
}

class ParserAccumulator5<T1, T2, T3, T4, T5> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  ParserAccumulator5(this.p1, this.p2, this.p3, this.p4, this.p5);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator6<T1, T2, T3, T4, T5, T6> and<T6>(Parser<T6> p) =>
      new ParserAccumulator6(p1, p2, p3, p4, p5, p);

  /// Alias for [and]
  ParserAccumulator6 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => f(x1, x2, x3, x4, x5)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => [x1, x2, x3, x4, x5]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5);
}

class ParserAccumulator6<T1, T2, T3, T4, T5, T6> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  ParserAccumulator6(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator7<T1, T2, T3, T4, T5, T6, T7> and<T7>(Parser<T7> p) =>
      new ParserAccumulator7(p1, p2, p3, p4, p5, p6, p);

  /// Alias for [and]
  ParserAccumulator7 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => f(x1, x2, x3, x4, x5, x6)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => [x1, x2, x3, x4, x5, x6]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6);
}

class ParserAccumulator7<T1, T2, T3, T4, T5, T6, T7> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  ParserAccumulator7(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator8<T1, T2, T3, T4, T5, T6, T7, T8> and<T8>(Parser<T8> p) =>
      new ParserAccumulator8(p1, p2, p3, p4, p5, p6, p7, p);

  /// Alias for [and]
  ParserAccumulator8 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => f(x1, x2, x3, x4, x5, x6, x7)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => [x1, x2, x3, x4, x5, x6, x7]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7);
}

class ParserAccumulator8<T1, T2, T3, T4, T5, T6, T7, T8> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  ParserAccumulator8(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator9<T1, T2, T3, T4, T5, T6, T7, T8, T9> and<T9>(Parser<T9> p) =>
      new ParserAccumulator9(p1, p2, p3, p4, p5, p6, p7, p8, p);

  /// Alias for [and]
  ParserAccumulator9 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => f(x1, x2, x3, x4, x5, x6, x7, x8)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => [x1, x2, x3, x4, x5, x6, x7, x8]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8);
}

class ParserAccumulator9<T1, T2, T3, T4, T5, T6, T7, T8, T9> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  ParserAccumulator9(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> and<T10>(Parser<T10> p) =>
      new ParserAccumulator10(p1, p2, p3, p4, p5, p6, p7, p8, p9, p);

  /// Alias for [and]
  ParserAccumulator10 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => [x1, x2, x3, x4, x5, x6, x7, x8, x9]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9);
}

class ParserAccumulator10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  ParserAccumulator10(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> and<T11>(Parser<T11> p) =>
      new ParserAccumulator11(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p);

  /// Alias for [and]
  ParserAccumulator11 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10);
}

class ParserAccumulator11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  ParserAccumulator11(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> and<T12>(Parser<T12> p) =>
      new ParserAccumulator12(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p);

  /// Alias for [and]
  ParserAccumulator12 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11);
}

class ParserAccumulator12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  ParserAccumulator12(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> and<T13>(Parser<T13> p) =>
      new ParserAccumulator13(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p);

  /// Alias for [and]
  ParserAccumulator13 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12);
}

class ParserAccumulator13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  ParserAccumulator13(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> and<T14>(Parser<T14> p) =>
      new ParserAccumulator14(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p);

  /// Alias for [and]
  ParserAccumulator14 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13);
}

class ParserAccumulator14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  ParserAccumulator14(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> and<T15>(Parser<T15> p) =>
      new ParserAccumulator15(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p);

  /// Alias for [and]
  ParserAccumulator15 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14);
}

class ParserAccumulator15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  ParserAccumulator15(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> and<T16>(Parser<T16> p) =>
      new ParserAccumulator16(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p);

  /// Alias for [and]
  ParserAccumulator16 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15);
}

class ParserAccumulator16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  final Parser<T16> p16;
  ParserAccumulator16(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15, this.p16);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> and<T17>(Parser<T17> p) =>
      new ParserAccumulator17(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p);

  /// Alias for [and]
  ParserAccumulator17 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16);
}

class ParserAccumulator17<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  final Parser<T16> p16;
  final Parser<T17> p17;
  ParserAccumulator17(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15, this.p16, this.p17);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> and<T18>(Parser<T18> p) =>
      new ParserAccumulator18(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p);

  /// Alias for [and]
  ParserAccumulator18 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17);
}

class ParserAccumulator18<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  final Parser<T16> p16;
  final Parser<T17> p17;
  final Parser<T18> p18;
  ParserAccumulator18(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15, this.p16, this.p17, this.p18);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator19<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19> and<T19>(Parser<T19> p) =>
      new ParserAccumulator19(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p);

  /// Alias for [and]
  ParserAccumulator19 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18);
}

class ParserAccumulator19<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  final Parser<T16> p16;
  final Parser<T17> p17;
  final Parser<T18> p18;
  final Parser<T19> p19;
  ParserAccumulator19(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15, this.p16, this.p17, this.p18, this.p19);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator20<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20> and<T20>(Parser<T20> p) =>
      new ParserAccumulator20(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p);

  /// Alias for [and]
  ParserAccumulator20 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18 , T19 x19)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => (T19 x19) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18).apply(p19);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18 , T19 x19)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => (T19 x19) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18).apply(p19);
}

class ParserAccumulator20<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  final Parser<T8> p8;
  final Parser<T9> p9;
  final Parser<T10> p10;
  final Parser<T11> p11;
  final Parser<T12> p12;
  final Parser<T13> p13;
  final Parser<T14> p14;
  final Parser<T15> p15;
  final Parser<T16> p16;
  final Parser<T17> p17;
  final Parser<T18> p18;
  final Parser<T19> p19;
  final Parser<T20> p20;
  ParserAccumulator20(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8, this.p9, this.p10, this.p11, this.p12, this.p13, this.p14, this.p15, this.p16, this.p17, this.p18, this.p19, this.p20);

  /// Action application
  Parser<R> map<R>(R f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18 , T19 x19 , T20 x20)) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => (T19 x19) => (T20 x20) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20)).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18).apply(p19).apply(p20);

  /// Alias for map
  Parser operator ^(Object f(T1 x1 , T2 x2 , T3 x3 , T4 x4 , T5 x5 , T6 x6 , T7 x7 , T8 x8 , T9 x9 , T10 x10 , T11 x11 , T12 x12 , T13 x13 , T14 x14 , T15 x15 , T16 x16 , T17 x17 , T18 x18 , T19 x19 , T20 x20)) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) => (T9 x9) => (T10 x10) => (T11 x11) => (T12 x12) => (T13 x13) => (T14 x14) => (T15 x15) => (T16 x16) => (T17 x17) => (T18 x18) => (T19 x19) => (T20 x20) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20]).apply(p1).apply(p2).apply(p3).apply(p4).apply(p5).apply(p6).apply(p7).apply(p8).apply(p9).apply(p10).apply(p11).apply(p12).apply(p13).apply(p14).apply(p15).apply(p16).apply(p17).apply(p18).apply(p19).apply(p20);
}

