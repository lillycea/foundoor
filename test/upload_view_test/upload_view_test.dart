import 'dart:io';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundoor/controller/bluetooth_controller.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/controller/main_wrapper_controller.dart';
import 'package:foundoor/upload/re_usable_select_photo_button.dart';
import 'package:foundoor/upload/selected_photo_options_screen.dart';
import 'package:foundoor/upload/upload_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart' show rootBundle;


class MockUploadController extends GetxController
    with Mock implements UploadController {}
class MockBluetoothWithoutResponseController extends GetxController
    with Mock
    implements BluetoothController {
  final List<ScanResult> simulatedScanResults = [];

  @override
  Stream<List<ScanResult>> get scanResults =>
      Stream.fromIterable([simulatedScanResults]);
}
class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  group('UploadView Widget Test', () {
    final MockUploadController uploadController = MockUploadController();
    final MockBluetoothWithoutResponseController bluetoothController = MockBluetoothWithoutResponseController();
    final storage = MockFirebaseStorage();
    final imagePicker = MockImagePicker();
    setUpAll(() {

     /* when(imagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async {
        final byteData = await rootBundle.load('./assets/images/placeholder.jpeg');
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/placeholder.jpeg');
        await tempFile.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), flush: true);
        XFile xFile = XFile(tempFile.path);
        return xFile;
      });*/

      Get.lazyPut<ImagePicker>(() => imagePicker);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('UploadView Widget Renders Correctly', (WidgetTester tester) async {
     Get.put(MainWrapperController(bluetoothController, uploadController));
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: UploadView(),
          ),
        ),
      );
      expect(find.text('Update File'), findsOneWidget);
      expect(find.text('Add your floodplain.'), findsOneWidget);
    });

    testWidgets('Select Photo Button Click', (WidgetTester tester) async {
      Get.put(MainWrapperController(bluetoothController, uploadController));
      await tester.pumpWidget(const MaterialApp(home: UploadView(
      )));

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byWidgetPredicate(
            (Widget widget) =>
        widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/drop-file.png',
      ), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(find.byType(SelectedPhotoOptionsScreen), findsOneWidget);
      expect(find.byType(SelectPhoto), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.text('Use a Camera'), findsOneWidget);
      expect(find.text('Browse Gallery'), findsOneWidget);
      });

    /*testWidgets('Test Upload file', (WidgetTester tester) async {
      Get.put(MainWrapperController(bluetoothController, uploadController));
      await tester.pumpWidget(
        const MaterialApp(
          home: UploadView(),
        ),
      );
      expect(find.byType(GestureDetector), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(find.byType(SelectedPhotoOptionsScreen), findsOneWidget);
      expect(find.byType(SelectPhoto), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.text('Use a Camera'), findsOneWidget);
      expect(find.text('Browse Gallery'), findsOneWidget);
      await tester.tap(find.text('Browse Gallery'));

      await tester.pumpAndSettle();

      expect(find.text('Upload selected image'), findsOneWidget);
      await tester.tap(find.text('Upload selected image'));

      await tester.pumpAndSettle();
      const filename = 'placeholder.jpeg';
      final storageRef = storage.ref().child(filename);
      final localImage = await rootBundle.load("assets/images/$filename");
      await storageRef.putData(localImage.buffer.asUint8List());
      await tester.pump();

       expect(find.text("Planimetry upload done successfully!"), findsOneWidget);
    });*/
  });
}

