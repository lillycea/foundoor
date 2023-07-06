import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundoor/controller/upload_controller.dart';
import 'package:foundoor/upload/re_usable_select_photo_button.dart';
import 'package:foundoor/upload/selected_photo_options_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/bluetooth_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../trilateration/trilateration_view.dart';
import '../utils/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/grid/map_grid_view.dart';


class UploadView extends StatefulWidget {
  const UploadView({super.key});

  static const id = 'set_photo_screen';

  @override
  State<UploadView> createState() => UploadViewState();
}

class UploadViewState extends State<UploadView> {
  XFile? _image;
  UploadTask? uploadTask;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    loadImageFromLocalStorage().then((path) {
      if (path != null) {
        setState(() {
          _image = XFile(path);
        });
      }
    });
  }

  /*void navigateToTrilaterationView(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrilaterationView(imageUrl: imageUrl),
      ),
    );
  }*/

  Future<void> saveImageToLocalStorage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedImage', imagePath);
  }

  Future<String?> loadImageFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedImage');
  }


  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      XFile? img = XFile(image.path);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
      await saveImageToLocalStorage(_image!.path);
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  Future uploadFile() async {
    final path = 'uploadedPlanimetry/${_image!.name}';
    final file = File(_image!.path!);
    FirebaseStorage s = FirebaseStorage.instance;

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() async {
      _downloadUrl = downloadUrl;
      //navigateToTrilaterationView(await snapshot.ref.getDownloadURL()!);
    });
  }

  /*Future<File?> _cropImage({required File imageFile}) async {
    final originalImage = await ImagePicker().getImage(source: ImageSource.file(imageFile));
    if (originalImage == null) return null;

    final originalImageData = await originalImage.readAsBytes();
    final originalImageSize = originalImage.lengthSync();

    final editor = ImageEditor();
    final croppedImage = await editor.cropImage(
      image: originalImageData,
      size: Size(originalImage.width.toDouble(), originalImage.height.toDouble()),
      preferredSize: Size(500, 500), // Specify the desired size for the cropped image
    );

    final croppedImageFile = File(originalImage.path);
    await croppedImageFile.writeAsBytes(croppedImage);

    return croppedImageFile;
  }*/

  /*Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }*/

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.30,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectedPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MainWrapperController mainWrapperController = Get.find();
    return Scaffold(
        body: GetBuilder<UploadController>(
        init: mainWrapperController.uploadController,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update File",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                              color: ColorConstants.appColor,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Add your floodplain.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _showSelectPhotoOptions(context);
                            },
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: _image == null
                                      ? Image.asset(
                                    'assets/images/drop-file.png',
                                    width: 300.0,
                                    height: 300.0,
                                    fit: BoxFit.contain,
                                  )
                                      : Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.file(File(_image!.path)),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        SelectPhoto(
                                          onTap: () => {uploadFile(),},
                                          icon: Icons.upload_rounded,
                                          textLabel:
                                          'Upload selected image',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),);
        },),
    );
  }
}
