import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String rgbToHex(Color color) {
  return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', ''); // Remove the # if present
  if (hex.length == 6) {
    hex = 'FF$hex'; // Add opacity if missing (FF = fully opaque)
  }
  return Color(int.parse(hex, radix: 16));
}

Future<File?> pickAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      return File(result!.files.first.xFile.path!);
    } else {
      return null; // User canceled the picker
    }
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      return File(result!.files.first.xFile.path!);
    } else {
      return null; // User canceled the picker
    }
  } catch (e) {
    return null;
  }
}
