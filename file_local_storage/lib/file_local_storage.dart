import "dart:async";
import "dart:typed_data";

import "package:file_local_storage_impl/file_local_storage_impl.dart";
import "package:path_provider/path_provider.dart";

class FileLocalStorage {
  FileLocalStorage(String storageName) {
    impl = FileLocalStorageImpl(
      storagePath: _getDocsDir(storageName),
      storageName: "file_local_storage",
    );
  }

  late final FileLocalStorageImpl impl;

  Future<void> save(String name, ByteBuffer data) => impl.save(name, data);
  Future<ByteBuffer> load(String name) => impl.load(name);

  Future<String?> _getDocsDir(String storageName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return "${dir.path}/$storageName/";
    } on Exception {
      return null;
    }
  }
}
