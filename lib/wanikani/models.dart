import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class User {
  final bool? currentVacationStartedAt;
  final int level;
  final String profileUrl;
  final DateTime startedAt;
  final String username;

  User({
    required this.currentVacationStartedAt,
    required this.level,
    required this.profileUrl,
    required this.startedAt,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
