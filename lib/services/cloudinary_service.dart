import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'de3yfpfp1';
  static const String uploadPreset = 'green_bin_profile';

  static Future<String?> uploadImage(
      XFile imageFile,
      ) async {
    try {
      // Read image as bytes
      final Uint8List bytes =
      await imageFile.readAsBytes();

      final Uri uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final http.MultipartRequest request =
      http.MultipartRequest(
        'POST',
        uploadUrl,
      );

      // Cloudinary unsigned upload preset
      request.fields['upload_preset'] =
          uploadPreset;

      // Add image
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
        ),
      );

      debugPrint(
        'Uploading image to Cloudinary...',
      );

      final http.StreamedResponse response =
      await request.send();

      final String responseBody =
      await response.stream.bytesToString();

      debugPrint(
        'Cloudinary status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(responseBody);

        final String? secureUrl =
        data['secure_url']?.toString();

        debugPrint(
          'Cloudinary upload successful',
        );

        debugPrint(
          'Image URL: $secureUrl',
        );

        return secureUrl;
      }

      debugPrint(
        'Cloudinary upload failed',
      );

      debugPrint(responseBody);

      return null;
    } catch (e, stackTrace) {
      debugPrint(
        'Cloudinary upload error: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      return null;
    }
  }
}