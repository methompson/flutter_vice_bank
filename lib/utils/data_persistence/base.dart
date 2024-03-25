/// The data persistence layer is a simplified interface to save underlying data.
/// It has to be useable both by the web and native platforms. For the time
/// being, we will only utilize a key / value store.
abstract class AbstractDataPersistence {
  Future<AbstractDataPersistence> init();
  Future<void> set(String key, String value);
  Future<String?> get(String key);
}

class DataPersistence extends AbstractDataPersistence {
  final Map<String, String> _data = {};

  @override
  Future<DataPersistence> init() async {
    return this;
  }

  @override
  Future<String?> get(String key) async {
    return _data[key];
  }

  @override
  Future<void> set(String key, String value) async {
    _data[key] = value;
  }
}
