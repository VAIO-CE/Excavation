import 'dart:async';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothManager {
  final _bluetoothClassicPlugin = BluetoothClassic();
  final List<Device> discoveredDevices = [];
  bool isScanning = false;

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

  Future<void> startScan(Function updateUI) async {
    if (isScanning) {
      await _bluetoothClassicPlugin.stopScan();
      _deviceSubscription?.cancel();
      isScanning = false;
      updateUI();
    } else {
      discoveredDevices.clear();
      _deviceSubscription?.cancel();
      _deviceSubscription =
          _bluetoothClassicPlugin.onDeviceDiscovered().listen((device) {
        discoveredDevices.add(device);
        updateUI();
      });
      await _bluetoothClassicPlugin.startScan();
      isScanning = true;
      updateUI();
    }
  }
}
