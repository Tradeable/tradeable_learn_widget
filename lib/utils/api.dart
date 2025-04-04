import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tradeable_learn_widget/utils/constants.dart';

class Api {
  Future<String?> uploadImageToS3(File file) async {
    // Step 1: Get Pre-signed URL
    const String url = "$baseUrl/v0/lms/assets/get_presigned_url?folder=logos";

    Response presignedResponse = await Dio().get(
      url,
      queryParameters: {"folder": "logos"},
      options: Options(headers: token),
    );

    print("Presigned URL Response: ${presignedResponse.data}"); // Debugging

    if (presignedResponse.statusCode != 200) {
      throw Exception(
          "Failed to get presigned URL: ${presignedResponse.statusCode}");
    }

    String presignedUrl = presignedResponse.data;
    if (presignedUrl.isEmpty) throw Exception("Empty presigned URL received");

    // Step 2: Upload Image to S3
    Response uploadResponse = await Dio().put(
      presignedUrl,
      data: file.readAsBytesSync(),
      options: Options(headers: {"Content-Type": "image/jpeg"}),
    );

    print("Upload Response Code: ${uploadResponse.statusCode}"); // Debugging
    print("Upload Response Body: ${uploadResponse.data}"); // Debugging

    if (uploadResponse.statusCode == 200) {
      Uri uri = Uri.parse(presignedUrl);
      return uri.origin + uri.path;
    } else {
      throw Exception("Failed to upload image: ${uploadResponse.statusCode}");
    }
  }
}
