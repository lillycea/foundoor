import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UploadController extends GetxController {
  String? file;

  Future getUrlImage({required String getImage}) async {
    file = getImage;
    WidgetsBinding.instance!.addPostFrameCallback((_) => update());
  }

}
