import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magic_recipe_client/magic_recipe_client.dart';
import 'package:magic_recipe_flutter/main.dart';

class ImageUploadButton extends StatefulWidget {
  final String? imagePath;
  final ValueChanged<String?>? onImagePathChanged;

  const ImageUploadButton({super.key, this.onImagePathChanged, this.imagePath});

  @override
  State<ImageUploadButton> createState() => _ImageUploadButtonState();
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  bool uploading = false;
  late ValueNotifier<String?> imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = ValueNotifier<String?>(widget.imagePath);
    imagePath.addListener(() {
      widget.onImagePathChanged?.call(imagePath.value);
    });
  }

  Future<String?> uploadImage(XFile imageFile) async {
    var imageStream = imageFile.openRead();
    var length = await imageFile.length();
    final (uploadDescription, path) = await client.recipes.getUploadDescription(
      imageFile.name,
    );
    if (uploadDescription != null) {
      var uploader = FileUploader(uploadDescription);
      await uploader.upload(imageStream, length);
      var success = await client.recipes.verifyUpload(path);
      return success ? path : null;
    }
    return null;
  }

  Future<void> handlePickAndUpload() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      setState(() {
        uploading = true;
      });
      imagePath.value = await uploadImage(imageFile);
      setState(() {
        uploading = false;
      });
      log('Image path: ${imagePath.value}');
    }
  }

  void handleDelete() {
    setState(() {
      imagePath.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (uploading) const Center(child: CircularProgressIndicator()),
        if (imagePath.value != null)
          Stack(
            children: [
              ServerpodImage(
                imagePath: imagePath.value,
                key: ValueKey(imagePath.value),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: handleDelete,
                ),
              ),
            ],
          ),
        if (imagePath.value == null)
          ElevatedButton(
            onPressed: handlePickAndUpload,
            child: const Text('Upload Image'),
          ),
      ],
    );
  }
}

class ServerpodImage extends StatefulWidget {
  const ServerpodImage({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  State<ServerpodImage> createState() => _ServerpodImageState();
}

class _ServerpodImageState extends State<ServerpodImage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      log('Image path: ${widget.imagePath}');
      fetchUrlAndRebuild();
    }
  }

  Future<void> fetchUrlAndRebuild() async {
    imageUrl = await client.recipes.getPublicUrlForPath(widget.imagePath!);
    log('Image URL: $imageUrl');
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ServerpodImage oldWidget) {
    if (widget.imagePath != oldWidget.imagePath) {
      imageUrl = null;
      fetchUrlAndRebuild();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Image.network(
      imageUrl!,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
