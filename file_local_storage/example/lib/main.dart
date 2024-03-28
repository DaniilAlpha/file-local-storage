import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:file_local_storage/file_local_storage.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TextEditingController();

  final storage = FileLocalStorage(
    dirPath: getApplicationDocumentsDirectory()
        .then((dir) => "${dir.path}/MyAppName/"),
    indexedDBName: "MyAppName",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          TextField(controller: controller),
          ButtonBar(children: [
            ElevatedButton(
              onPressed: () => storage.save("file.txt",
                  Uint16List.fromList(controller.text.codeUnits).buffer),
              child: const Text("SAVE"),
            ),
            ElevatedButton(
              onPressed: () async {
                controller.text = String.fromCharCodes(
                    (await storage.load("file.txt")).asUint16List());
                setState(() {});
              },
              child: const Text("LOAD"),
            ),
          ]),
        ]),
      ),
    );
  }
}
