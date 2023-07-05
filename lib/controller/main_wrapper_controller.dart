import 'package:flutter/material.dart';
import 'package:foundoor/upload/upload_view.dart';
import 'package:get/get.dart';
import '../upload/upload_view.dart';
import '../scanner/scan_view.dart';
import '../trilateration/trilateration_view.dart';
import 'bluetooth_controller.dart';

class MainWrapperController extends GetxController {
  late PageController pageController;
  BluetoothController bluetoothController = BluetoothController();
  RxInt currentPage = 0.obs;
  RxBool isDarkTheme = false.obs;

  List<Widget> pages = [
    const ScanView(),
    const UploadView(),
    const TrilaterationView(),
  ];

  ThemeMode get theme => Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
