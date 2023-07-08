import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class SelectedDevice {
  final ScanResult result;
  bool flag;
  int rssi;
  double centerX;
  double centerY;
  num distance;
  double alpha;

  SelectedDevice({
    required this.result,
    this.flag = false,
    this.rssi = -60,
    this.centerX = 2.0,
    this.centerY = 2.0,
    this.distance = 1.0,
    this.alpha = -60.0
  });
}

class BluetoothController extends GetxController {
  List<ScanResult> results = [];
  List<SelectedDevice> selectedDevices = [];
  List<String> activated = [];

  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  void scanDevices() async {
    flutterBluePlus.startScan(scanMode: const ScanMode(1), allowDuplicates: true);
  }

  Stream<List<ScanResult>> get scanResults => flutterBluePlus.scanResults;

  Future updateActivate({required ScanResult result}) async {
    final selectedDevice = SelectedDevice(result: result);
    if (!selectedDevices.any((device) =>
        device.result.device.id == selectedDevice.result.device.id)) {
      selectedDevices.add(selectedDevice);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => update());
  }

  Stream<List<SelectedDevice>> get selectedDevicesStream =>
      Stream.value(selectedDevices);
}
