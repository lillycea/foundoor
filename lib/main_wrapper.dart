import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'controller/main_wrapper_controller.dart';
import 'utils/color_constants.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final MainWrapperController _mainWrapperController =
      Get.find<MainWrapperController>();

  final ValueNotifier<bool> _isMenuOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 120,
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => Switch.adaptive(
                value: _mainWrapperController.isDarkTheme.value,
                onChanged: (newVal) {
                  _mainWrapperController.isDarkTheme.value = newVal;
                  _mainWrapperController
                      .switchTheme(newVal ? ThemeMode.dark : ThemeMode.light);
                },
                activeColor: ColorConstants.appColor),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(11),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 23),
          decoration: BoxDecoration(
              color:
                  //_mainWrapperController.isDarkTheme.value ?
                  ColorConstants.appColor.withOpacity(0.9),
              //: hexToColor('#126D76').withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomAppBarItem(
                  icon: Icons.bluetooth_outlined,
                  page: 0,
                  context,
                  label: "Explore",
                ),
                _bottomAppBarItem(
                    icon: Icons.cloud_done_outlined,
                    page: 1,
                    context,
                    label: "Upload"),
                _bottomAppBarItem(
                    icon: Icons.map_outlined, page: 2, context, label: "Map")
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _mainWrapperController.pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _mainWrapperController.animateToTab,
        children: [..._mainWrapperController.pages],
      ),
    );
  }

  Widget _bottomAppBarItem(BuildContext context,
      {required icon, required page, required label}) {
    return ZoomTapAnimation(
      onTap: () => _mainWrapperController.goToTab(page),
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 2),
              height: 2,
              width: _mainWrapperController.currentPage == page ? 25 : 0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2))),
            ),
            Icon(
              icon,
              color: Colors.white,
              /*_mainWrapperController.currentPage == page
                  ? ColorConstants.appColor
                  : Colors.grey,*/
              size: 22,
            ),
            Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  /*_mainWrapperController.currentPage == page
                      ? ColorConstants.appColor
                      : Colors.grey,*/
                  fontSize: 12,
                  fontWeight: _mainWrapperController.currentPage == page
                      ? FontWeight.w600
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
