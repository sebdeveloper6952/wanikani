import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wanikani/wanikani/models.dart';
import 'package:multiple_result/multiple_result.dart';

class WanikaniApi {
  final Dio _dio;

  WanikaniApi(String authToken)
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://api.wanikani.com/v2",
            connectTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 3),
            headers: {"Authorization": "Bearer $authToken"},
          ),
        );

  Future<Result<User, String>> fetchUserInfo() async {
    try {
      final response = await _dio.get("/user");
      if (response.statusCode == 200) {
        return Result.success(
          User.fromJson(
            response.data["data"],
          ),
        );
      } else {
        return Result.error("http ${response.statusCode}");
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<List<Subject>, String>> fetchSubjectsForLevel(int level) async {
    final levels = List.generate(
      level,
      (index) => index + 1,
      growable: false,
    ).join(",");

    try {
      final response = await _dio.get(
        "/subjects",
        queryParameters: {
          "levels": levels,
        },
      );
      if (response.statusCode == 200) {
        final subjects = (response.data["data"] as List)
            .map((item) => Subject.fromJson(item))
            .toList();

        return Result.success(subjects);
      } else {
        return Result.error("http ${response.statusCode}");
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
