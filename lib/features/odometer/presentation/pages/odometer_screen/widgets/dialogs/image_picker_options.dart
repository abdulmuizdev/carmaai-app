import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerOptions extends StatelessWidget {
  final Function(ImageSource source) onSelected;
  const ImagePickerOptions({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text('Take a Photo'),
          onTap: () {
            Navigator.of(context).pop();
            onSelected(ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            Navigator.of(context).pop();
            onSelected(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.cancel),
          title: const Text('Cancel'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
