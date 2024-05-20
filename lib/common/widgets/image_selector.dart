import 'dart:io';
import 'package:ca_mobile/features/auth/screens/select_photo_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageService {
  Future<File?> selectImage(
    BuildContext context,
    ImageSource source,
    Function(File?) onImageSelected,
  ) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      File img = File(image.path);
      img = (await _cropImage(context, imageFile: img)) ?? img;
      onImageSelected(img);
      return img;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> _cropImage(BuildContext context, {required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Foto',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(width: 520, height: 520),
          viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    return croppedImage == null ? null : File(croppedImage.path);
  }

  void showSelectPhotoOptions(
    BuildContext context,
    Function(ImageSource) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.27,
        maxChildSize: 0.3,
        minChildSize: 0.22,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SelectPhotoOptionsScreen(onTap: onSelect),
          );
        },
      ),
    );
  }
}
