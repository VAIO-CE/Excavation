import 'dart:typed_data';

import 'package:excavator/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class MyFirmwarePage extends StatefulWidget {
  const MyFirmwarePage({super.key});

  @override
  State<MyFirmwarePage> createState() => _MyFirmwarePage();
}

class _MyFirmwarePage extends State<MyFirmwarePage> {
  final HttpService httpService = HttpService(baseUrl: "http://vaio.local");
  ValueNotifier<double> uploadProgress = ValueNotifier(0.0);

  @override
  void dispose() {
    uploadProgress.dispose();
    super.dispose();
  }

  Future<void> updateVAIO() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        RegExp regExp = RegExp(r"^firmware\.bin(\(\d+\))?$");

        if (regExp.hasMatch(fileName)) {
          await httpService.uploadFirmware("/updateFirmware", fileBytes,
              (progress) {
            uploadProgress.value = progress;
          });
        } else {
          throw Exception("Wrong file inserted.");
        }
      }
    } catch (e) {
      throw Exception("Update failed: $e");
    } finally {
      uploadProgress.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Firmware Update Progress",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: uploadProgress,
              builder: (context, progress, child) {
                return LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: updateVAIO,
              child: const Text("Update VAIO"),
            ),
          ],
        ),
      ),
    );
  }
}
