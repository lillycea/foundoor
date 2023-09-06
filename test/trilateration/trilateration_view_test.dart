import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundoor/controller/bluetooth_controller.dart';
import 'package:foundoor/controller/main_wrapper_controller.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/main_wrapper.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../scan_view_test/scan_view_test.mocks.dart';

@GenerateMocks([
  FlutterBluePlus,
  ScanResult,
  AdvertisementData,
  BluetoothDevice,
])

class MockBluetoothWithResponseController extends GetxController
    with Mock
    implements BluetoothController {
  final List<ScanResult> simulatedScanResults = [];
  @override
  final List<SelectedDevice> selectedDevices = [];
  void addSimulatedScanResult(ScanResult result) {
    simulatedScanResults.add(result);
  }

  @override
  Future updateActivate({required ScanResult result}) async {
    final selectedDevice = SelectedDevice(result: result);
    if (!selectedDevices.any((device) =>
    device.result.device.id == selectedDevice.result.device.id)) {
      selectedDevices.add(selectedDevice);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  @override
  Stream<List<ScanResult>> get scanResults =>
      Stream.fromIterable([simulatedScanResults]);

  @override
  Stream<List<SelectedDevice>> get selectedDevicesStream => Stream.value(selectedDevices);

}
class MockUploadController extends GetxController with Mock implements UploadController{}

void main() {
  final ScanResult scanResult = MockScanResult();
  final BluetoothDevice bluetoothDevice = MockBluetoothDevice();
  final AdvertisementData advertisementData = MockAdvertisementData();
  final MockBluetoothWithResponseController bluetoothControllerWithResponse = MockBluetoothWithResponseController();
  final UploadController updateController = MockUploadController();

  setUpAll(() {
    when(bluetoothDevice.name).thenReturn('Holy-IOT');
    when(bluetoothDevice.id)
        .thenReturn(const DeviceIdentifier('00:00:00:00:00:01'));
    when(advertisementData.localName)
        .thenReturn('Holy-IOT');
    when(advertisementData.serviceUuids).thenReturn(['0000180f-0000-1000-8000-00805f9b34fb']);
    when(advertisementData.txPowerLevel).thenReturn(-10);
    when(scanResult.device).thenReturn(bluetoothDevice);
    when(scanResult.rssi).thenReturn(-45);
    when(scanResult.advertisementData)
        .thenReturn(advertisementData);
    bluetoothControllerWithResponse.addSimulatedScanResult(scanResult);
    bluetoothControllerWithResponse.updateActivate(result: scanResult);
    WidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('MainWrapper Widget Test', (WidgetTester tester) async {
    Get.put(MainWrapperController(bluetoothControllerWithResponse, updateController));
    await tester.pumpWidget(MaterialApp(home: MainWrapper()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(BottomAppBar), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.text('Explore'), findsWidgets);
    expect(find.text('Run to scan'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.byType(ZoomTapAnimation), findsNWidgets(3));
    await tester.pump();
    await tester.tap(find.text('Run to scan'));
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Device 1: Holy-IOT'), findsOneWidget);
    expect(find.widgetWithText(ExpansionTile, 'Device 1: Holy-IOT'), findsOneWidget);
    expect(find.text('MAC: 00:00:00:00:00:01'), findsWidgets);
    expect(find.text('-45 dBm'), findsWidgets);

    final updateButton = find.widgetWithText(ZoomTapAnimation, "Upload");
    expect(updateButton, findsOneWidget);
    await tester.tap(updateButton);
    await tester.pump();
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Run to scan'), findsNothing);
    expect(find.text('Upload'), findsWidgets);
    expect(find.text('Map'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    expect(find.byWidgetPredicate(
          (Widget widget) =>
      widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/images/drop-file.png',
    ), findsOneWidget);

    final mapButton = find.widgetWithText(ZoomTapAnimation, "Map");
    expect(mapButton, findsOneWidget);
    await tester.tap(mapButton);
    expect(find.text('Map'), findsWidgets);
    expect(find.byType(ListView), findsNothing);
  });
}
