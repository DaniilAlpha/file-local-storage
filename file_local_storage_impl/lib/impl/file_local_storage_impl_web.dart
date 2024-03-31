import "dart:async";
import "dart:html";
import "dart:indexed_db";
import "dart:js_interop";
import "dart:typed_data";

import "package:file_local_storage_impl/file_local_storage_impl.dart";

final class FileLocalStorageImpl extends FileLocalStorageInterface {
  FileLocalStorageImpl({super.dirPath = "", required super.indexedDBName}) {
    if (!IdbFactory.supported) {
      throw FileLocalStorageException("IndexedDB is not supported.");
    }
  }

  static const storageName = "file_local_storage";

  late final connection = window.indexedDB!
      .open(indexedDBName, version: 1, onUpgradeNeeded: _onUpgradeNeeded);

  @override
  Future<ByteBuffer> load(String name) => _action(
        (store) async {
          final result = await store.getObject(KeyRange.only(name));
          if (result is! ByteBuffer)
            throw FileLocalStorageException(
              result == null ? "No saved data." : "Invalid saved data.",
            );
          return result;
        },
        storeMode: "readonly",
        fallbackErrorMessage: "IndexedDB getObject error.",
      );

  @override
  Future<void> save(String name, ByteBuffer data) => _action(
        (store) => store.put(data.toJS, name),
        storeMode: "readwrite",
        fallbackErrorMessage: "IndexedDB put error.",
      );

  @override
  Future<String> loadString(String name) => _action(
        (store) async {
          final result = await store.getObject(KeyRange.only(name));
          if (result is! String)
            throw FileLocalStorageException(
              result == null ? "No saved data." : "Invalid saved data.",
            );
          return result;
        },
        storeMode: "readonly",
        fallbackErrorMessage: "IndexedDB getObject error.",
      );

  @override
  Future<void> saveString(String name, String data) => _action(
        (store) => store.put(data.toJS, name),
        storeMode: "readwrite",
        fallbackErrorMessage: "IndexedDB put error.",
      );

  @override
  Future<void> delete(String name) => _action(
        (store) => store.delete(name),
        storeMode: "readwrite",
        fallbackErrorMessage: "IndexedDB delete error.",
      );

  void _onUpgradeNeeded(VersionChangeEvent event) {
    final Database db = event.target.result;
    if (db.objectStoreNames?.contains(storageName) != true) {
      db.createObjectStore(storageName);
    }
  }

  Future<T> _action<T>(
    Future<T> Function(ObjectStore store) action, {
    required String storeMode,
    String? fallbackErrorMessage,
  }) async {
    final db = await connection;
    final store =
        db.transactionStore(storageName, storeMode).objectStore(storageName);

    try {
      return await action(store);
    } on Exception catch (e) {
      throw FileLocalStorageException.fromException(
        e,
        fallbackErrorMessage ?? "${e.runtimeType}",
      );
    }
  }
}
