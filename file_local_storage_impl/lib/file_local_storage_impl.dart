import "dart:async";
import "dart:typed_data";

export "/impl/file_local_storage_impl_io.dart"
    if (dart.library.html) "/impl/file_local_storage_impl_web.dart";

abstract base class FileLocalStorageInterface {
  FileLocalStorageInterface({
    required this.dirPath,
    required this.indexedDBName,
  });

  final FutureOr<String> dirPath;
  final String indexedDBName;

  Future<void> save(String name, ByteBuffer data);
  Future<ByteBuffer> load(String name);

  Future<void> saveString(String name, String data);
  Future<String> loadString(String name);

  Future<void> delete(String name);
}

final class FileLocalStorageException implements Exception {
  FileLocalStorageException([this.message]);
  FileLocalStorageException.fromException(
      Exception? exception, String fallbackMessage) {
    String msg;
    try {
      final dynamic dynException = exception;
      // ignore: avoid_dynamic_calls
      msg = dynException.message;
      // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      msg = fallbackMessage;
    }
    this.message = msg;
  }

  late final String? message;

  @override
  String toString() => message == null
      ? "File storage exception"
      : "File storage exception: $message";
}
