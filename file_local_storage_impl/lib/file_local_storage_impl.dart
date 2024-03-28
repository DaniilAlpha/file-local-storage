import "dart:async";
import "dart:typed_data";

export "/impl/file_local_storage_impl_io.dart"
    if (dart.library.html) "/impl/file_local_storage_impl_web.dart";

abstract base class FileLocalStorageInterface {
  FileLocalStorageInterface({this.storagePath, required this.storageName});

  final FutureOr<String?> storagePath;
  final String storageName;

  Future<void> save(String name, ByteBuffer data);
  Future<ByteBuffer> load(String name);
}

final class FileLocalStorageException implements Exception {
  FileLocalStorageException([this.message]);

  final String? message;

  @override
  String toString() => message == null
      ? "File storage exception"
      : "File storage exception: $message";
}
