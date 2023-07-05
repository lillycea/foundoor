import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundoor/upload/re_usable_select_photo_button.dart';
import 'package:foundoor/upload/selected_photo_options_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/color_constants.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  static const id = 'set_photo_screen';

  @override
  State<UploadView> createState() => UploadViewState();
}

class UploadViewState extends State<UploadView> {
  XFile? _image;
  UploadTask? uploadTask;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      XFile? img = XFile(image.path);
      //img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
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

    final urlDownload = await snapshot.ref.getDownloadURL();
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Update File",
                        style: Theme.of(context)
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
                                              onTap: () => uploadFile(),
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
          ),
        ),
      ),
    );
  }
}

/*class UploadView extends StatefulWidget {
  const UploadView({Key? key}) : super(key: key);

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  XFile? _image;
  UploadTask? uploadTask;

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = XFile(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future uploadFile() async {
    final path = 'uploadedPlanimetry/${_image!.name}';
    final file = File(_image!.path!);
    FirebaseStorage s = FirebaseStorage.instance;

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
  }
  void showSelectedPhotoOptions(){
   showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),
       ),
       builder: (context) => DraggableScrollableSheet(
         initialChildSize: 0.28,
         maxChildSize: 0.4,
         minChildSize: 0.28,
         expand: false,
         builder: (context, scrollController){
           return SingleChildScrollView(
             controller: scrollController,
             child: const SelectedPhotoOptionsScreen(
               onTap: _image,
             ),
           );
         },
       ),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Upload",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                            color: ColorConstants.appColor,
                            fontWeight: FontWeight.w900))),
            if (_image != null) Image.file(File(_image!.path)),
            const SizedBox(height: 10),
            Center(
              child: CustomButton(
                title: 'Sfoglia',
                icon: Icons.photo,
                onClick: getImage,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CustomButton(
                title: 'Carica',
                icon: Icons.upload,
                onClick: uploadFile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClick;

  const CustomButton({super.key,
    required this.title,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 80, height: 55),
            Text(title),
          ],
        ),
      ),
    );
  }
}

/*class AnchorView extends StatelessWidget {
  const AnchorView({Key? key}) : super(key: key);
  /*Uint8List? _image;

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState((){
      _image = img;
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anchor View'),
      ),
      body: Center(
        children:[
          IconButton(onPressed: ()=>_imageSelected(context), icon: const Icon(Icons.photo), iconSize: 30,),
          const Text('Post Image', style: TextStyle(fontSize: 36.0),)
        ],
      ),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Stack(
                children: [
                  _image != null ?
                      ButtonSegment(
                        value: value
                        backgroundImage: Image.memory(_image!),

        )
              const ButtonElement(

        )
          Positioned(
          child: IconButton(
          onPressed: selectImage,
          icon: const Icon(Icons.add_a_photo),
    ),
          bottom: -10,
          left: 80,

    )
            ]
        )
            SizedBox(height: 20),
            return ElevatedButton(
              onPressed: () => await pickImage(ImageSource.gallery),
              child: Text('Scegli Immagine'),
            ),
          ],
        ),
      ),*/
    );
  }
}

pickImage(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('Nessuna immagine selezionata');
}*/*/
