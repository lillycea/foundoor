import 'package:flutter/material.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/upload/upload_view.dart';
import 'package:get/get.dart';
import '../scanner/scan_view.dart';
import '../trilateration/trilateration_view.dart';
import 'bluetooth_controller.dart';

class MainWrapperController extends GetxController {
  late PageController pageController;
  BluetoothController bluetoothController = BluetoothController();
  UploadController uploadController = UploadController();
  RxInt currentPage = 0.obs;
  RxBool isDarkTheme = false.obs;


  List<Widget> pages = [];

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
    super.onInit();
    pageController = PageController(initialPage: 0);

    pages = [
      const ScanView(),
      const UploadView(),
      const TrilaterationView(),
    ];
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
