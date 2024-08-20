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

@JsonSerializable()
class AuxiliaryMeaning {
  final String meaning;
  final String type;

  AuxiliaryMeaning({
    required this.meaning,
    required this.type,
  });

  factory AuxiliaryMeaning.fromJson(Map<String, dynamic> json) =>
      _$AuxiliaryMeaningFromJson(json);
  Map<String, dynamic> toJson() => _$AuxiliaryMeaningToJson(this);
}

@JsonSerializable()
class Meaning {
  final String meaning;
  final bool primary;
  final bool acceptedAnswer;

  Meaning({
    required this.meaning,
    required this.primary,
    required this.acceptedAnswer,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);
  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}

@JsonSerializable()
class CharacterImage {
  final String url;

  CharacterImage({
    required this.url,
  });

  factory CharacterImage.fromJson(Map<String, dynamic> json) =>
      _$CharacterImageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterImageToJson(this);
}

@JsonSerializable()
class SubjectData {
  final String? characters;
  final String documentUrl;
  final int lessonPosition;
  final int level;
  final String meaningMnemonic;
  final String slug;
  final int spacedRepetitionSystemId;
  final DateTime createdAt;
  final DateTime? hiddenAt;
  final List<AuxiliaryMeaning> auxiliaryMeanings;
  final List<Meaning> meanings;
  final List<CharacterImage>? characterImages;

  SubjectData({
    required this.characters,
    required this.documentUrl,
    required this.lessonPosition,
    required this.level,
    required this.meaningMnemonic,
    required this.slug,
    required this.spacedRepetitionSystemId,
    required this.createdAt,
    required this.hiddenAt,
    required this.auxiliaryMeanings,
    required this.meanings,
    required this.characterImages,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) =>
      _$SubjectDataFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectDataToJson(this);
}

@JsonSerializable()
class Subject {
  final int id;
  final String object;
  final String url;
  final DateTime dataUpdatedAt;
  final SubjectData data;

  Subject({
    required this.id,
    required this.object,
    required this.url,
    required this.dataUpdatedAt,
    required this.data,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}