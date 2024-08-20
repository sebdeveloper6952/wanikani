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
