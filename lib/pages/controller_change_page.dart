import 'package:excavator/components/bottom_navbar.dart';
import 'package:excavator/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/bluetooth_manager.dart';

class MyControllerChangePage extends StatefulWidget {
  const MyControllerChangePage({super.key});

  @override
  State<MyControllerChangePage> createState() => _MyControllerChangePage();
}

class _MyControllerChangePage extends State<MyControllerChangePage> {
  final TextEditingController _controller = TextEditingController();
  final HttpService httpService = HttpService(baseUrl: "http://vaio.local");
  final _bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _bluetoothManager.checkPermissions();
  }

  void _sendMacAddress() async {
    final macAddress = _controller.text.trim();

    // Validate input
    if (macAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid MAC address"),
        ),
      );
      return;
    }

    try {
      // Send to post endpoint in ESP API server
      final response = await httpService.postRequest(
        "/mac",
        body: {'mac': macAddress},
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        final responseData = httpService.parseJson(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Success: ${responseData['message']}")),
        );
      } else {
        final errorData = httpService.parseJson(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${errorData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request: ${e}")),
      );
    }
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "XX:XX:XX:XX:XX:XX",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sendMacAddress,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.green[200])),
                    child: const Text("Send"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 600,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Center(
                    child: _bluetoothManager.isScanning
                        ? const CircularProgressIndicator()
                        : _bluetoothManager.discoveredDevices.isEmpty
                            ? const Text(
                                "No devices found!",
                                style: TextStyle(color: Colors.blueGrey),
                              )
                            : ListView.builder(
                                itemCount:
                                    _bluetoothManager.discoveredDevices.length,
                                itemBuilder: (context, index) {
                                  var device = _bluetoothManager
                                      .discoveredDevices[index];
                                  return ListTile(
                                    title: Text(device.name ?? "Unknown"),
                                    subtitle: Text(device.address),
                                    onTap: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: device.address));
                                    },
                                  );
                                },
                              ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () => _bluetoothManager.startScan(updateUI,
                          timeout: const Duration(seconds: 20)),
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.location_searching),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
