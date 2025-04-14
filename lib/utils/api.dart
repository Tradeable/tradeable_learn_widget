import 'package:dio/dio.dart';
import 'package:tradeable_learn_widget/utils/constants.dart';

class Api {
  Future<Map<String, dynamic>> getAwsKeys() async {
    Response response = await Dio().get("$baseUrl/v0/lms/members/aws_token",
        options: Options(headers: token));

    return response.data["data"];
  }
}
