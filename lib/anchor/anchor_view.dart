import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../utils/color_constants.dart';

class AnchorView extends StatefulWidget {
  const AnchorView({Key? key}) : super(key: key);

  @override
  _AnchorViewState createState() => _AnchorViewState();
}

class _AnchorViewState extends State<AnchorView> {
  XFile? _image;
  UploadTask? uploadTask;

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = XFile(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future uploadFile() async{
    final path = 'uploadedPlanimetry/${_image!.name}';
    final file =  File(_image!.path!);
    FirebaseStorage s = FirebaseStorage.instance;

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete((){});

    final urlDownload = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(20),
                  child: Text("Upload", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: ColorConstants.appColor, fontWeight: FontWeight.w600))),
              if (_image != null) Image.file(File(_image!.path)),
              const SizedBox(height: 10),
              Center(
                child: CustomButton(
                  title: 'Sfoglia',
                  icon: Icons.photo,
                  onClick: getImage,
                ),),
              const SizedBox(height: 10),
              Center(child: CustomButton(
                title: 'Carica',
                icon: Icons.upload,
                onClick: uploadFile,
              ),),

            ],
          ),
        ),
      ),
    );
  }

}


class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClick;

  const CustomButton({
    required this.title,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 80, height: 55),
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
}*/