import 'dart:async';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothManager {
  final _bluetoothClassicPlugin = BluetoothClassic();
  final List<Device> discoveredDevices = [];
  bool isScanning = false;
  Timer? _scanTimer;

  StreamSubscription<Device>? _deviceSubscription;

  Future<void> checkPermissions() async {
    var status = await Permission.bluetooth.status;
    if (!status.isGranted) {
      await Permission.bluetooth.request();
    }
    var connectStatus = await Permission.bluetoothConnect.status;
    if (!connectStatus.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    var scanStatus = await Permission.bluetoothScan.status;
    if (!scanStatus.isGranted) {
      await Permission.bluetoothScan.request();
    }
    var locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> startScan(Function updateUI,
      {Duration timeout = const Duration(seconds: 20)}) async {
    if (isScanning) {
      // Toggle to stop scan if already scanning
      await _stopScan(updateUI);
    } else {
      // Scan if not yet scanning
      // Clear devices list
      discoveredDevices.clear();

      // Detach stream from listening
      _deviceSubscription?.cancel();
      _deviceSubscription = null;

      // Tune to new stream
      _deviceSubscription =
          _bluetoothClassicPlugin.onDeviceDiscovered().listen((device) {
        discoveredDevices.add(device);
        updateUI();
      });

      // Start scanning for bluetooth devices
      await _bluetoothClassicPlugin.startScan();
      isScanning = true;
      updateUI();

      // Set timer to stop scanning
      _scanTimer?.cancel();
      _scanTimer = Timer(timeout, () async {
        if (isScanning) {
          await _stopScan(updateUI);
        }
      });
    }
  }

  Future<void> _stopScan(Function updateUI) async {
    // Stop scan
    await _bluetoothClassicPlugin.stopScan();
    _deviceSubscription?.cancel();
    _deviceSubscription = null;
    isScanning = false;

    // Cancel timer
    _scanTimer?.cancel();
    _scanTimer = null;

    updateUI();
  }
}
