# file_local_storage

A cross-platform library for saving big amounts of data.

## Usage

To use this plugin, add `file_local_storage` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

```dart
import "package:file_local_storage/file_local_storage.dart";

void main() {
  final storage = FileLocalStorage(
    dirPath: getApplicationDocumentsDirectory()
        .then((dir) => "${dir.path}/MyAppName/"),
    indexedDBName: "MyAppName",
  );

  final str = "Hello world!";

  // saves `ByteBuffer` into file in application documents directory on IO platforms and into IndexedDB on the web 
  storage.save("file.txt", Uint16List.fromList(str.codeUnits).buffer);

  // loads `ByteBuffer` from previously saved location
  final loaded = String.fromCharCodes((await storage.load("file.txt")).asUint16List());

  // both methods can throw `FileStorageException; the message will describe the failure
}
```
