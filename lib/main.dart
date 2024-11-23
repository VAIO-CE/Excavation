import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './services/bluetooth_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excavation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Excavation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _bluetoothManager.checkPermissions();
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
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
                    onPressed: () => {
                      // TO-DO
                    },
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
                      onPressed: () => _bluetoothManager.startScan(updateUI),
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
    );
  }
}
