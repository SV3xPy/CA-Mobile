import 'dart:io';

//https://stackoverflow.com/questions/77505933/unable-to-build-android-bundle-or-ios-etc
//Se sigue el link anterior para reparar la dependencia de la libreria.
//En el segundo se modifica lo siguente en donde da el error
//enabled: data?.enabled ?? enabled ?? false
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showSnackBar({BuildContext? context, required String content}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  return image;
}

Future<File?> pickVideoGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  return video;
}

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat('y/M/d').format(dateTime);

    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return time;
  }

  static String formatDateToISO(DateTime date) {
    final DateFormat formatter = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    return formatter.format(date.toUtc());
  }
}
