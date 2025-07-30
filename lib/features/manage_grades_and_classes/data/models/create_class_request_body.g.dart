// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_class_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateClassRequestBody _$CreateClassRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateClassRequestBody(
  name: json['name'] as String,
  gradeId: (json['grade_id'] as num).toInt(),
);

Map<String, dynamic> _$CreateClassRequestBodyToJson(
  CreateClassRequestBody instance,
) => <String, dynamic>{'name': instance.name, 'grade_id': instance.gradeId};
