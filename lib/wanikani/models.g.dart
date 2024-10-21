// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          currentVacationStartedAt:
              $checkedConvert('current_vacation_started_at', (v) => v as bool?),
          level: $checkedConvert('level', (v) => (v as num).toInt()),
          profileUrl: $checkedConvert('profile_url', (v) => v as String),
          startedAt:
              $checkedConvert('started_at', (v) => DateTime.parse(v as String)),
          username: $checkedConvert('username', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'currentVacationStartedAt': 'current_vacation_started_at',
        'profileUrl': 'profile_url',
        'startedAt': 'started_at'
      },
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'current_vacation_started_at': instance.currentVacationStartedAt,
      'level': instance.level,
      'profile_url': instance.profileUrl,
      'started_at': instance.startedAt.toIso8601String(),
      'username': instance.username,
    };

AuxiliaryMeaning _$AuxiliaryMeaningFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AuxiliaryMeaning',
      json,
      ($checkedConvert) {
        final val = AuxiliaryMeaning(
          meaning: $checkedConvert('meaning', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AuxiliaryMeaningToJson(AuxiliaryMeaning instance) =>
    <String, dynamic>{
      'meaning': instance.meaning,
      'type': instance.type,
    };

Meaning _$MeaningFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Meaning',
      json,
      ($checkedConvert) {
        final val = Meaning(
          meaning: $checkedConvert('meaning', (v) => v as String),
          primary: $checkedConvert('primary', (v) => v as bool),
          acceptedAnswer: $checkedConvert('accepted_answer', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {'acceptedAnswer': 'accepted_answer'},
    );

Map<String, dynamic> _$MeaningToJson(Meaning instance) => <String, dynamic>{
      'meaning': instance.meaning,
      'primary': instance.primary,
      'accepted_answer': instance.acceptedAnswer,
    };

Reading _$ReadingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Reading',
      json,
      ($checkedConvert) {
        final val = Reading(
          reading: $checkedConvert('reading', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String?),
          acceptedAnswer: $checkedConvert('accepted_answer', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'acceptedAnswer': 'accepted_answer'},
    );

Map<String, dynamic> _$ReadingToJson(Reading instance) => <String, dynamic>{
      'reading': instance.reading,
      'type': instance.type,
      'accepted_answer': instance.acceptedAnswer,
    };

CharacterImage _$CharacterImageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CharacterImage',
      json,
      ($checkedConvert) {
        final val = CharacterImage(
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CharacterImageToJson(CharacterImage instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

SubjectData _$SubjectDataFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SubjectData',
      json,
      ($checkedConvert) {
        final val = SubjectData(
          characters: $checkedConvert('characters', (v) => v as String?),
          documentUrl: $checkedConvert('document_url', (v) => v as String),
          lessonPosition:
              $checkedConvert('lesson_position', (v) => (v as num).toInt()),
          level: $checkedConvert('level', (v) => (v as num).toInt()),
          meaningMnemonic:
              $checkedConvert('meaning_mnemonic', (v) => v as String),
          slug: $checkedConvert('slug', (v) => v as String),
          spacedRepetitionSystemId: $checkedConvert(
              'spaced_repetition_system_id', (v) => (v as num).toInt()),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          hiddenAt: $checkedConvert('hidden_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          auxiliaryMeanings: $checkedConvert(
              'auxiliary_meanings',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      AuxiliaryMeaning.fromJson(e as Map<String, dynamic>))
                  .toList()),
          meanings: $checkedConvert(
              'meanings',
              (v) => (v as List<dynamic>)
                  .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
                  .toList()),
          characterImages: $checkedConvert(
              'character_images',
              (v) => (v as List<dynamic>?)
                  ?.map(
                      (e) => CharacterImage.fromJson(e as Map<String, dynamic>))
                  .toList()),
          readings: $checkedConvert(
              'readings',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Reading.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'documentUrl': 'document_url',
        'lessonPosition': 'lesson_position',
        'meaningMnemonic': 'meaning_mnemonic',
        'spacedRepetitionSystemId': 'spaced_repetition_system_id',
        'createdAt': 'created_at',
        'hiddenAt': 'hidden_at',
        'auxiliaryMeanings': 'auxiliary_meanings',
        'characterImages': 'character_images'
      },
    );

Map<String, dynamic> _$SubjectDataToJson(SubjectData instance) =>
    <String, dynamic>{
      'characters': instance.characters,
      'document_url': instance.documentUrl,
      'lesson_position': instance.lessonPosition,
      'level': instance.level,
      'meaning_mnemonic': instance.meaningMnemonic,
      'slug': instance.slug,
      'spaced_repetition_system_id': instance.spacedRepetitionSystemId,
      'created_at': instance.createdAt.toIso8601String(),
      'hidden_at': instance.hiddenAt?.toIso8601String(),
      'auxiliary_meanings':
          instance.auxiliaryMeanings.map((e) => e.toJson()).toList(),
      'meanings': instance.meanings.map((e) => e.toJson()).toList(),
      'character_images':
          instance.characterImages?.map((e) => e.toJson()).toList(),
      'readings': instance.readings?.map((e) => e.toJson()).toList(),
    };

Subject _$SubjectFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Subject',
      json,
      ($checkedConvert) {
        final val = Subject(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          object: $checkedConvert('object', (v) => v as String),
          url: $checkedConvert('url', (v) => v as String),
          dataUpdatedAt: $checkedConvert(
              'data_updated_at', (v) => DateTime.parse(v as String)),
          data: $checkedConvert(
              'data', (v) => SubjectData.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'dataUpdatedAt': 'data_updated_at'},
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'url': instance.url,
      'data_updated_at': instance.dataUpdatedAt.toIso8601String(),
      'data': instance.data.toJson(),
    };
