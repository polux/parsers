part of parsers;

class ParserAccumulator2<T1, T2> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  ParserAccumulator2(this.p1, this.p2);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator3<T1, T2, T3> and<T3>(Parser<T3> p) =>
      ParserAccumulator3(p1, p2, p);

  /// Alias for [and]
  ParserAccumulator3 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2) f) =>
      success((T1 x1) => (T2 x2) => f(x1, x2)).apply(p1).apply(p2);

  /// Alias for map
  Parser operator ^(Object Function(T1 x1, T2 x2) f) => map(f);

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
      ParserAccumulator4(p1, p2, p3, p);

  /// Alias for [and]
  ParserAccumulator4 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2, T3 x3) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => f(x1, x2, x3))
          .apply(p1)
          .apply(p2)
          .apply(p3);

  /// Alias for map
  Parser operator ^(Object Function(T1 x1, T2 x2, T3 x3) f) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => [x1, x2, x3])
          .apply(p1)
          .apply(p2)
          .apply(p3);
}

class ParserAccumulator4<T1, T2, T3, T4> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  ParserAccumulator4(this.p1, this.p2, this.p3, this.p4);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator5<T1, T2, T3, T4, T5> and<T5>(Parser<T5> p) =>
      ParserAccumulator5(p1, p2, p3, p4, p);

  /// Alias for [and]
  ParserAccumulator5 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2, T3 x3, T4 x4) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => f(x1, x2, x3, x4))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4);

  /// Alias for map
  Parser operator ^(Object Function(T1 x1, T2 x2, T3 x3, T4 x4) f) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => [x1, x2, x3, x4])
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4);
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
      ParserAccumulator6(p1, p2, p3, p4, p5, p);

  /// Alias for [and]
  ParserAccumulator6 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5) f) => success((T1 x1) =>
          (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => f(x1, x2, x3, x4, x5))
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5);

  /// Alias for map
  Parser operator ^(Object Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5) f) => map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list => success((T1 x1) =>
          (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => [x1, x2, x3, x4, x5])
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5);
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
      ParserAccumulator7(p1, p2, p3, p4, p5, p6, p);

  /// Alias for [and]
  ParserAccumulator7 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) =>
              (T4 x4) => (T5 x5) => (T6 x6) => f(x1, x2, x3, x4, x5, x6))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6);

  /// Alias for map
  Parser operator ^(Object Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6) f) =>
      map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list => success((T1 x1) => (T2 x2) =>
          (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) => [x1, x2, x3, x4, x5, x6])
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5)
      .apply(p6);
}

class ParserAccumulator7<T1, T2, T3, T4, T5, T6, T7> {
  final Parser<T1> p1;
  final Parser<T2> p2;
  final Parser<T3> p3;
  final Parser<T4> p4;
  final Parser<T5> p5;
  final Parser<T6> p6;
  final Parser<T7> p7;
  ParserAccumulator7(
      this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator8<T1, T2, T3, T4, T5, T6, T7, T8> and<T8>(Parser<T8> p) =>
      ParserAccumulator8(p1, p2, p3, p4, p5, p6, p7, p);

  /// Alias for [and]
  ParserAccumulator8 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) =>
              (T5 x5) => (T6 x6) => (T7 x7) => f(x1, x2, x3, x4, x5, x6, x7))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6)
          .apply(p7);

  /// Alias for map
  Parser operator ^(
          Object Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7) f) =>
      map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list => success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) =>
          (T5 x5) => (T6 x6) => (T7 x7) => [x1, x2, x3, x4, x5, x6, x7])
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5)
      .apply(p6)
      .apply(p7);
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
  ParserAccumulator8(
      this.p1, this.p2, this.p3, this.p4, this.p5, this.p6, this.p7, this.p8);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator9<T1, T2, T3, T4, T5, T6, T7, T8, T9> and<T9>(
          Parser<T9> p) =>
      ParserAccumulator9(p1, p2, p3, p4, p5, p6, p7, p8, p);

  /// Alias for [and]
  ParserAccumulator9 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(
          R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) =>
              (T7 x7) => (T8 x8) => f(x1, x2, x3, x4, x5, x6, x7, x8))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6)
          .apply(p7)
          .apply(p8);

  /// Alias for map
  Parser operator ^(
          Object Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8) f) =>
      map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) =>
              (T6 x6) => (T7 x7) => (T8 x8) => [x1, x2, x3, x4, x5, x6, x7, x8])
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6)
          .apply(p7)
          .apply(p8);
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
  ParserAccumulator9(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6,
      this.p7, this.p8, this.p9);

  /// Parser sequencing: creates a parser accumulator
  ParserAccumulator10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> and<T10>(
          Parser<T10> p) =>
      ParserAccumulator10(p1, p2, p3, p4, p5, p6, p7, p8, p9, p);

  /// Alias for [and]
  ParserAccumulator10 operator +(Parser p) => and(p);

  /// Action application
  Parser<R> map<R>(
          R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) =>
              (T7 x7) =>
                  (T8 x8) => (T9 x9) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6)
          .apply(p7)
          .apply(p8)
          .apply(p9);

  /// Alias for map
  Parser operator ^(
          Object Function(
              T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9) f) =>
      map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list => success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) =>
          (T5 x5) => (T6 x6) => (T7 x7) =>
              (T8 x8) => (T9 x9) => [x1, x2, x3, x4, x5, x6, x7, x8, x9])
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5)
      .apply(p6)
      .apply(p7)
      .apply(p8)
      .apply(p9);
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
  ParserAccumulator10(this.p1, this.p2, this.p3, this.p4, this.p5, this.p6,
      this.p7, this.p8, this.p9, this.p10);

  /// Action application
  Parser<R> map<R>(
          R Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
              T10 x10) f) =>
      success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) => (T5 x5) => (T6 x6) =>
              (T7 x7) => (T8 x8) => (T9 x9) =>
                  (T10 x10) => f(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10))
          .apply(p1)
          .apply(p2)
          .apply(p3)
          .apply(p4)
          .apply(p5)
          .apply(p6)
          .apply(p7)
          .apply(p8)
          .apply(p9)
          .apply(p10);

  /// Alias for map
  Parser operator ^(
          Object Function(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8,
              T9 x9, T10 x10) f) =>
      map(f);

  /// Creates a [:Parser<List>:] from [this].
  Parser<List> get list => success((T1 x1) => (T2 x2) => (T3 x3) => (T4 x4) =>
          (T5 x5) => (T6 x6) => (T7 x7) => (T8 x8) =>
              (T9 x9) => (T10 x10) => [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10])
      .apply(p1)
      .apply(p2)
      .apply(p3)
      .apply(p4)
      .apply(p5)
      .apply(p6)
      .apply(p7)
      .apply(p8)
      .apply(p9)
      .apply(p10);
}
