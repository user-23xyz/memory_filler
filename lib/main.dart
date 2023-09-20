import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: Scaffold(
      body: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      filleDeviceStorage();
    });
  }

//Create a file with 1MB weithg and synchoronously write to device storage forever

  Future<void> createFile() async {
    try {
      var uuid = const Uuid().v4();
      Directory? appDir = await getApplicationSupportDirectory();
      final file = File('${appDir.path}/$uuid.txt');

      log("Creating new file $uuid inr dir path ${appDir.path}");
      //var diskSpace = await DiskSpace.getFreeDiskSpace;
      //log("Free disk space: $diskSpace");
      await file.writeAsBytes(List.filled(50024 * 5024, 0));
      showSnack();
    } catch (e) {
      showErrorSnack();
    }
  }

  void showErrorSnack() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error creating file'),
      ),
    );
  }

  void showSnack() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File created'),
      ),
    );
  }

  Future<void> filleDeviceStorage() async {
    while (true) {
      await createFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disk space'),
      ),
    );
  }
}
