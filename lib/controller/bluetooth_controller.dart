import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BluetoothController extends GetxController {
  List<ScanResult> results = [];
  List<bool> flagList = [];
  List<int> selectedDeviceIdxList = [];
  List<String> selectedDeviceNameList = [];
  List<int> selectedRSSI = [];
  List<double> selectedCenterXList = [];
  List<double> selectedCenterYList = [];
  List<num> selectedDistanceList = [];

  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  void scanDevices() async {
    flutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    flutterBluePlus.scanResults = results;
  }

  void scan() async {
    // Listen to scan results
    flutterBluePlus.scanResults.listen((results) {
      // do something with scan results
      this.results = results;
      // update state
    });
  }

  Stream<List<ScanResult>> get scanResults => flutterBluePlus.scanResults;

  void initBLEList() {
    flagList = [];
    selectedDeviceIdxList = [];
    selectedDeviceNameList = [];
    selectedRSSI = [];
    selectedCenterXList = [];
    selectedCenterYList = [];
    selectedDistanceList = [];
  }


  void updateFlagList({required bool flag, required int index}) {
    flagList[index] = flag;
    update();
  }

  void updateSelectedDeviceIdxList() {
    flagList.asMap().forEach((index, element) {
      if (element == true) {
        if (!selectedDeviceIdxList.contains(index)) {
          selectedDeviceIdxList.add(index);
          selectedRSSI.add(-60);
          selectedCenterXList.add(2.0);
          selectedCenterYList.add(2.0);
          selectedDistanceList.add(0.0);
        }
      } else {
        int idx = selectedDeviceIdxList.indexOf(index);
        if (idx != -1) {
          selectedDeviceIdxList.remove(index);
          selectedDeviceNameList.removeAt(idx);
          selectedRSSI.removeAt(idx);
          selectedCenterXList.removeAt(idx);
          selectedCenterYList.removeAt(idx);
          selectedDistanceList.removeAt(idx);
        }
      }
    });
    update();
  }
  }
