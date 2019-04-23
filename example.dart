class FancyClassWithTypeParameter<T> {
  /// My type is unknown untill someonce instantate the class
  final T aValue;

  /// When we construct it it automatically takes the type
  FancyClassWithTypeParameter(this.aValue);

  /// Fo sweet looking syntax I made a shortcut for [map]
  FancyClassWithTypeParameter operator %(Function(T) mapper) => map(mapper);

  FancyClassWithTypeParameter<M> map<M>(M Function(T) mapper) {
    return FancyClassWithTypeParameter(mapper(aValue));
  }
}

void main([List<String> args]) {}
