import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/utils/splash_screen.dart';
import 'package:foundoor/utils/themes.dart';
import 'package:get/get.dart';

import 'controller/bluetooth_controller.dart';
import 'controller/main_wrapper_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      home: const MyApp(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<BluetoothController>(() => BluetoothController());
        Get.lazyPut<UploadController>(() => UploadController());
        Get.lazyPut<MainWrapperController>(()=>MainWrapperController(Get.find<BluetoothController>(), Get.find<UploadController>()));
      }),
    ),
  );
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MainWrapperController mainWrapperController = Get.find();

    return GetMaterialApp(
      title: 'Foundoor',
      debugShowCheckedModeBanner: true,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: mainWrapperController.theme,
      home: const SplashScreen(),
    );
  }
}
