import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundoor/utils/splash_screen.dart';
import 'package:foundoor/utils/themes.dart';
import 'package:get/get.dart';

import 'controller/main_wrapper_controller.dart';
import 'main_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Foundoor',
      debugShowCheckedModeBanner: true,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: Get.put(MainWrapperController()).theme,
      home: SplashScreen(),
     // MainWrapper(),
    );
  }
}
