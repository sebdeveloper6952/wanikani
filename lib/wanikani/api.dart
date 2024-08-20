import 'dart:convert';

import 'package:wanikani/wanikani/models.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;

class WanikaniApi {
  final _apiUrl = "api.wanikani.com";
  final _authToken = "44a96d3d-772a-462e-a447-2dc67e3ba43f";

  Future<Result<User, String>> fetchUserInfo() async {
    final url = Uri.https(_apiUrl, "/v2/user");
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $_authToken"});
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return Result.success(User.fromJson(jsonBody["data"]));
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

    final url = Uri.https(
      _apiUrl,
      "/v2/subjects",
      {"levels": levels},
    );

    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $_authToken"});
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final subjects = (jsonBody["data"] as List)
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
