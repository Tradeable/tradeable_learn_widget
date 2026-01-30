import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class S3Uploader {
  final String accessKey;
  final String secretKey;
  final String sessionToken;
  final String bucketName;
  final String dirName;
  final String region;

  S3Uploader({
    required this.accessKey,
    required this.secretKey,
    required this.sessionToken,
    required this.bucketName,
    required this.dirName,
    this.region = 'ap-south-1',
  });

  Future<String?> uploadImage({
    required File imageFile,
    String? customFileName,
  }) async {
    try {
      final String fileName = customFileName ?? path.basename(imageFile.path);
      final String s3Key = dirName.isEmpty ? fileName : '$dirName/$fileName';

      final String contentType = _getContentType(fileName);
      final Uint8List fileBytes = await imageFile.readAsBytes();

      final DateTime now = DateTime.now().toUtc();
      final String amzDate = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(now);
      final String dateStamp = DateFormat('yyyyMMdd').format(now);

      const String httpMethod = 'PUT';
      final String canonicalUri = '/$s3Key';
      final String host = '$bucketName.s3.$region.amazonaws.com';
      final String endpoint = 'https://$host$canonicalUri';

      final Map<String, String> headers = {
        'host': host,
        'x-amz-content-sha256': sha256.convert(fileBytes).toString(),
        'x-amz-date': amzDate,
        'x-amz-security-token': sessionToken,
        'content-type': contentType,
      };

      final String signature = _getSignature(
        httpMethod,
        canonicalUri,
        '',
        headers,
        fileBytes,
        dateStamp,
        region,
      );

      headers['Authorization'] = signature;

      final http.Response response = await http.put(
        Uri.parse(endpoint),
        headers: headers,
        body: fileBytes,
      );

      if (response.statusCode == 200) {
        return 'https://$host/$s3Key';
      } else {
        // print(
        //     'Error uploading image: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // print('Exception during S3 upload: $e');
      return null;
    }
  }

  String _getContentType(String fileName) {
    final String ext = path.extension(fileName).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }

  String _getSignature(
    String httpMethod,
    String canonicalUri,
    String queryString,
    Map<String, String> headers,
    Uint8List payload,
    String dateStamp,
    String region,
  ) {
    const String service = 's3';

    final String payloadHash = sha256.convert(payload).toString();
    final String canonicalHeaders = headers.entries
        .sorted((a, b) => a.key.compareTo(b.key))
        .map((entry) => '${entry.key.toLowerCase()}:${entry.value}\n')
        .join();

    final String signedHeaders = headers.keys
        .map((key) => key.toLowerCase())
        .toList()
        .sorted((a, b) => a.compareTo(b))
        .join(';');

    final String canonicalRequest = [
      httpMethod,
      canonicalUri,
      queryString,
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');

    const String algorithm = 'AWS4-HMAC-SHA256';
    final String scope = '$dateStamp/$region/$service/aws4_request';
    final String stringToSign = [
      algorithm,
      headers['x-amz-date'],
      scope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final Uint8List keySecret = utf8.encode('AWS4$secretKey');
    final Uint8List keyDate = _hmacSha256(keySecret, utf8.encode(dateStamp));
    final Uint8List keyRegion = _hmacSha256(keyDate, utf8.encode(region));
    final Uint8List keyService = _hmacSha256(keyRegion, utf8.encode(service));
    final Uint8List keySigning =
        _hmacSha256(keyService, utf8.encode('aws4_request'));

    final String signature =
        _hmacSha256Hex(keySigning, utf8.encode(stringToSign));

    return '$algorithm Credential=$accessKey/$scope, SignedHeaders=$signedHeaders, Signature=$signature';
  }

  Uint8List _hmacSha256(Uint8List key, List<int> message) {
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(message);
    return Uint8List.fromList(digest.bytes);
  }

  String _hmacSha256Hex(Uint8List key, List<int> message) {
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(message);
    return digest.toString();
  }
}

extension SortedListExtension<T> on Iterable<T> {
  List<T> sorted([int Function(T a, T b)? compare]) {
    final List<T> sortedList = List<T>.from(this);
    sortedList.sort(compare);
    return sortedList;
  }
}
