class Option<T> {
  final T _value;
  final bool isDefined;

  const Option._internal(this.isDefined, this._value);

  factory Option.none() => const Option._internal(false, null);

  factory Option.some(T value) => new Option._internal(true, value);

  factory Option.fromNullable(T nullableValue) => nullableValue == null
      ? new Option.none()
      : new Option.some(nullableValue);

  T get value {
    if (isDefined) return _value;
    throw new StateError('Option.none() has no value');
  }

  T get asNullable => isDefined ? _value : null;

  T orElse(T defaultValue) => isDefined ? _value : defaultValue;

  T orElseCompute(T defaultValue()) => isDefined ? _value : defaultValue();

  /// [:forall U, Option<U> map(U f(T value)):]
  Option map(f(T value)) => isDefined ? new Option.some(f(_value)) : this;

  /// [:forall U, Option<U> map(Option<U> f(T value)):]
  Option expand(Option f(T value)) => isDefined ? f(_value) : this;

  /// Precondition: [:this is Option<Option>:]
  Option get flattened {
    // enforces the precondition in checked mode
    final self = this as Option<Option>;
    return self.orElse(new Option.none());
  }

  bool operator ==(Object other) =>
      other is Option<T> &&
      ((isDefined && other.isDefined && _value == other._value) ||
          (!isDefined && !other.isDefined));

  int get hashCode => asNullable.hashCode;

  String toString() => isDefined ? "Option.some($_value)" : "Option.none()";
}
