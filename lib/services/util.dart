import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

import 'package:cloudinary_public/cloudinary_public.dart';

class Util {
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    image.writeAsBytes(File(imagePath).readAsBytesSync());

    return File(imagePath).copy(image.path);
    // return image;
  }

  Future<File?> getImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image == null) return null;

      // final imageTemporary = File(image.path);

      // final imagePermanent = await saveImagePermanently(image.path);

      // print(imageTemporary);

      return File(image.path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<Map<String, String>> createImageUrl(File image) async {
    final cloudinary = CloudinaryPublic('ndth4ng', 'koy25upe', cache: false);

    try {
      Map<String, String> resImg = {'imageUrl': '', 'imageId': ''};

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );

      resImg = {'imageUrl': response.secureUrl, 'imageId': response.publicId};

      return resImg;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
      return {'imageUrl': '', 'imageId': ''};
    }
  }

  String removeSpace(String str) {
    return str.replaceAll(RegExp(' +'), ' ').trim();
  }

  List<String> splitString(String str, splitBy) {
    String trimmedStr = str.trim();
    List<String> splitedList = trimmedStr.split('$splitBy');

    return splitedList.map((String item) => removeSpace(item)).toList();
  }
}
