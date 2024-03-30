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
  Future<ByteBuffer> load(String name) async {
    final db = await connection;
    final store =
        db.transactionStore(storageName, "readonly").objectStore(storageName);

    try {
      final result = await store.getObject(KeyRange.only(name));
      if (result is! ByteBuffer)
        throw FileLocalStorageException(
          result == null ? "No saved data." : "Invalid saved data.",
        );
      return result;
    } on Exception catch (e) {
      throw FileLocalStorageException.fromException(
        e,
        "IndexedDB getObject failed.",
      );
    }
  }

  @override
  Future<void> save(String name, ByteBuffer data) async {
    final db = await connection;
    final store =
        db.transactionStore(storageName, "readwrite").objectStore(storageName);

    try {
      await store.put(data.toJS, name);
    } on Exception catch (e) {
      throw FileLocalStorageException.fromException(
        e,
        "IndexedDB put failed.",
      );
    }
  }

  @override
  Future<void> delete(String name) async {
    final db = await connection;
    final store =
        db.transactionStore(storageName, "readwrite").objectStore(storageName);

    try {
      await store.delete(name);
    } on Exception catch (e) {
      throw FileLocalStorageException.fromException(
        e,
        "IndexedDB delete failed.",
      );
    }
  }

  void _onUpgradeNeeded(VersionChangeEvent event) {
    final Database db = event.target.result;
    if (db.objectStoreNames?.contains(storageName) != true) {
      db.createObjectStore(storageName);
    }
  }
}
