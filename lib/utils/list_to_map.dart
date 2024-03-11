Map<String, T> listToMap<T>(
  List<T> list,
  String Function(T) keygen,
) {
  return Map.fromEntries(
    list.map(
      (e) => MapEntry(keygen(e), e),
    ),
  );
}

Map<String, U> listToMapWithValue<T, U>(
  List<T> list,
  String Function(T) keygen,
  U Function(T) valuegen,
) {
  return Map.fromEntries(
    list.map(
      (e) => MapEntry(keygen(e), valuegen(e)),
    ),
  );
}
