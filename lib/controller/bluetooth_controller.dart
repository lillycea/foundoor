import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedDevice {
  final ScanResult result;
  bool flag;
  int rssi;
  double centerX;
  double centerY;
  num distance;

  SelectedDevice({
    required this.result,
    this.flag = false,
    this.rssi = -60,
    this.centerX = 2.0,
    this.centerY = 2.0,
    this.distance = 0.0,
  });
}
class BluetoothController extends GetxController {
  List<ScanResult> results = [];
  List<SelectedDevice> selectedDevices = [];
  List<String> activated = [];

  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  void scanDevices() async {
    flutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  }

  Stream<List<ScanResult>> get scanResults => flutterBluePlus.scanResults;

  void initBLEList() {
    selectedDevices = [];
  }

  void updateDeviceList({required ScanResult scanResult}) {
    final selectedDevice = new SelectedDevice(result: scanResult);

    print("device selezionati - 2" + selectedDevice.toString());
      if (!selectedDevices.contains(selectedDevice)) {
        selectedDevices.add(selectedDevice);
        print("device selezionati -3 " + selectedDevice.toString());
      }
    update();
  }

  Future updateActivate({required ScanResult result}) async {
    final selectedDevice = new SelectedDevice(result: result);

    print("updateActivate - device selezionati - 2" + selectedDevice.toString());
    if (!selectedDevices.any((device) => device.result == selectedDevice.result)) {
      selectedDevices.add(selectedDevice);
      print("updateActivate - device selezionati holy-iot -3 " + selectedDevice.toString());
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => update());
  }

  Stream<List<SelectedDevice>> get selectedDevicesStream => Stream.value(selectedDevices);
}
