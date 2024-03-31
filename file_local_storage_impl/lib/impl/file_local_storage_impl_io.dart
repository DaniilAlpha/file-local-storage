import "dart:async";
import "dart:io";
import "dart:typed_data";

import "package:file_local_storage_impl/file_local_storage_impl.dart";

final class FileLocalStorageImpl extends FileLocalStorageInterface {
  FileLocalStorageImpl({required super.dirPath, super.indexedDBName = ""});

  @override
  Future<ByteBuffer> load(String name) => _action(name, (file) async {
        if (!await file.exists())
          throw FileLocalStorageException("File not exists.");
        return file.readAsBytes().then((bytes) => bytes.buffer);
      });

  @override
  Future<void> save(String name, ByteBuffer data) =>
      _action(name, (file) async {
        if (!await file.exists()) await file.create(recursive: true);
        await file.writeAsBytes(data.asUint8List());
      });

  @override
  Future<String> loadString(String name) => _action(name, (file) async {
        if (!await file.exists())
          throw FileLocalStorageException("File not exists.");
        return file.readAsString();
      });

  @override
  Future<void> saveString(String name, String data) =>
      _action(name, (file) async {
        if (!await file.exists()) await file.create(recursive: true);
        await file.writeAsString(data);
      });

  @override
  Future<void> delete(String name) => _action(name, (file) async {
        if (!await file.exists()) return;
        await file.delete();
      });

  Future<T> _action<T>(
    String fileName,
    Future<T> Function(File file) action,
  ) async {
    final file = File("${await dirPath}/file_local_storage/$fileName");

    try {
      return await action(file);
    } on FileSystemException catch (e) {
      throw FileLocalStorageException(e.message);
    }
  }
}
