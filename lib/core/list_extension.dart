extension YFListExtension<T> on List<T> {
  void addSeparator(
    T separator, {
    bool hasPrefix = false,
    bool hasSuffix = false,
  }) {
    if (isEmpty) {
      return;
    }

    var i = 0;

    if (hasPrefix) {
      insert(0, separator);
      i++;
    }

    for (i; i < length - 1; i++) {
      insert(++i, separator);
    }

    if (hasSuffix) {
      add(separator);
    }
  }

  void toggleInclusion(T item, {bool Function(T item, T other)? testEquality}) {
    if (testEquality == null) {
      contains(item) ? remove(item) : add(item);

      return;
    }

    any((e) => testEquality(e, item))
        ? removeWhere((e) => testEquality(e, item))
        : add(item);
  }
}
