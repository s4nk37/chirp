import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File? pickedImage) imagePickFn;

  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker picker = ImagePicker();
  File? _pickedImage;
  void _pickImage() async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: 80,
              foregroundImage:
                  _pickedImage == null ? null : FileImage(_pickedImage!),
              child: const Icon(
                Icons.person_outlined,
                size: 40,
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.7),
              width: 160,
              height: 40,
              alignment: Alignment.topCenter,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    alignment: Alignment.topCenter, maximumSize: Size(150, 40)),
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.image,
                  size: 12,
                  color: Colors.black54,
                ),
                label: const Text(
                  "Upload Image",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
