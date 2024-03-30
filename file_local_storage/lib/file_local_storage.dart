import "dart:async";
import "dart:typed_data";

import "package:file_local_storage_impl/file_local_storage_impl.dart";

export "package:file_local_storage_impl/file_local_storage_impl.dart"
    show FileLocalStorageException;

class FileLocalStorage {
  FileLocalStorage({
    required FutureOr<String> dirPath,
    required String indexedDBName,
  }) : impl = FileLocalStorageImpl(
          dirPath: dirPath,
          indexedDBName: indexedDBName,
        );

  late final FileLocalStorageImpl impl;

  Future<void> save(String name, ByteBuffer data) => impl.save(name, data);
  Future<ByteBuffer> load(String name) => impl.load(name);
  Future<void> delete(String name) => impl.delete(name);
}
