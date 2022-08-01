import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageInput extends StatefulWidget {
  final Function selectedImage;

  ImageInput(this.selectedImage);
  // const ImageInput({Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  // late final File _storedImage;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child:_storedImage != null
            ? Image.file(
          _storedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ): Text('No Image Taken'),
        alignment: Alignment.center,
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: _takePicture,
        child: Text('Pic'),
      ),
    ]);
  }

  void _takePicture() async{
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,);
    setState((){
      _storedImage = File(imageFile!.path);
    });

    final appDir = await path_provider.getApplicationDocumentsDirectory();// get the path where file is stored
    final fileName = imageFile!.name;//path.basename(imageFile!.path);// get the image name
    log('file name: ${appDir.path}/$fileName');
    final image = File('${appDir.path}/$fileName');
    await imageFile.saveTo('${appDir.path}/$fileName');
    widget.selectedImage(image); // global variable to access the properties
  }
}
