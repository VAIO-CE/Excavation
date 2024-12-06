import 'package:excavator/services/http_service.dart';
import 'package:flutter/material.dart';

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
      final firmwareUrl = await httpService.getLatestFirmware();
      print('Firmware URL: $firmwareUrl');

      print("Downloading...");
      final firmwareBytes = await httpService.downloadFirmware(firmwareUrl);
      print('Firmware downloaded, size: ${firmwareBytes.length} bytes');

      print("Uploading to ESP32");
      await httpService.uploadFirmware(
          "${httpService.baseUrl}/updateFirmware", firmwareBytes);
      print("Firmware update successful!");
    } catch (e) {
      print("Error: $e");
    } finally {
      uploadProgress.value = 0.0;
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
            Text("Firmware Update Progress", style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: uploadProgress,
              builder: (context, progress, child) {
                return LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ),
            SizedBox(height: 32),
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
