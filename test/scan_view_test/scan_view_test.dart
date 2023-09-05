import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundoor/controller/bluetooth_controller.dart';
import 'package:foundoor/controller/main_wrapper_controller.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/scanner/scan_view.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'scan_view_test.mocks.dart';

@GenerateMocks([
  FlutterBluePlus,
  ScanResult,
  AdvertisementData,
  BluetoothDevice,
])

class MockBluetoothWithoutResponseController extends GetxController
    with Mock
    implements BluetoothController {
  final List<ScanResult> simulatedScanResults = [];

  @override
  Stream<List<ScanResult>> get scanResults =>
      Stream.fromIterable([simulatedScanResults]);

}
class MockBluetoothWithResponseController extends GetxController
    with Mock
    implements BluetoothController {
  final List<ScanResult> simulatedScanResults = [];

  void addSimulatedScanResult(ScanResult result) {
    simulatedScanResults.add(result);
  }

  @override
  Stream<List<ScanResult>> get scanResults =>
      Stream.fromIterable([simulatedScanResults]);
}

class MockUploadController extends GetxController with Mock implements UploadController{}

void main() {
  final ScanResult scanResult = MockScanResult();
  final BluetoothDevice bluetoothDevice = MockBluetoothDevice();
  final AdvertisementData advertisementData = MockAdvertisementData();
  final BluetoothController bluetoothControllerWithoutResponse = MockBluetoothWithoutResponseController();
  final MockBluetoothWithResponseController bluetoothControllerWithResponse = MockBluetoothWithResponseController();
  final UploadController updateController = MockUploadController();

  setUpAll(() {
    when(bluetoothDevice.name).thenReturn('Device 1');
    when(bluetoothDevice.id)
        .thenReturn(const DeviceIdentifier('00:00:00:00:00:01'));
    when(advertisementData.localName)
        .thenReturn('Device 1');
    when(advertisementData.serviceUuids).thenReturn(['0000180f-0000-1000-8000-00805f9b34fb']);
    when(advertisementData.txPowerLevel).thenReturn(-10);
    when(scanResult.device).thenReturn(bluetoothDevice);
    when(scanResult.rssi).thenReturn(-45);
    when(scanResult.advertisementData)
        .thenReturn(advertisementData);
    bluetoothControllerWithResponse.addSimulatedScanResult(scanResult);
    WidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('ScanView Widget Test - without response', (WidgetTester tester) async {
    Get.put(MainWrapperController(bluetoothControllerWithoutResponse, updateController));
    await tester.pumpWidget(const MaterialApp(
      home: ScanView(),
    ));
    expect(find.text('Explore'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Run to scan'), findsOneWidget);
    await tester.tap(find.text('Run to scan'));
    verify(bluetoothControllerWithoutResponse.scanDevices()).called(1);
    expect(find.text("No devices found"), findsOneWidget);
    });

  testWidgets('ScanView Widget Test - with response', (WidgetTester tester) async {
    Get.put(MainWrapperController(bluetoothControllerWithResponse, updateController));
    await tester.pumpWidget(const MaterialApp(
      home: ScanView(),
    ));
    expect(find.text('Explore'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Run to scan'), findsOneWidget);
    bluetoothControllerWithResponse.addSimulatedScanResult(scanResult);
    await tester.pump();
    await tester.tap(find.text('Run to scan'));
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Device 1: Device 1'), findsOneWidget);
    expect(find.widgetWithText(ExpansionTile, 'Device 1: Device 1'), findsOneWidget);
    expect(find.text('MAC: 00:00:00:00:00:01'), findsWidgets);
    expect(find.text('-45 dBm'), findsWidgets);
    await tester.tap(find.widgetWithText(ExpansionTile, 'Device 1: Device 1'));
    await tester.pump();
    expect(find.text('UUID: 0000180f-0000-1000-8000-00805f9b34fb\ntxPower level: -10'), findsOneWidget);
  });
}

