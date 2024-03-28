import "dart:async";
import "dart:io";
import "dart:typed_data";

import "package:file_local_storage_impl/file_local_storage_impl.dart";

final class FileLocalStorageImpl extends FileLocalStorageInterface {
  FileLocalStorageImpl({required super.dirPath, super.indexedDBName = ""});

  @override
  Future<ByteBuffer> load(String name) async {
    final file = File("${await dirPath}/file_local_storage/$name");
    if (!await file.exists()) {
      throw FileLocalStorageException("File not exists.");
    }

    try {
      return (await file.readAsBytes()).buffer;
    } on FileSystemException catch (e) {
      throw FileLocalStorageException(e.message);
    }
  }

  @override
  Future<void> save(String name, ByteBuffer data) async {
    final file = File("${await dirPath}/file_local_storage/$name");

    if (!await file.exists()) await file.create(recursive: true);

    try {
      await file.writeAsBytes(data.asUint8List());
    } on FileSystemException catch (e) {
      throw FileLocalStorageException(e.message);
    }
  }
}
