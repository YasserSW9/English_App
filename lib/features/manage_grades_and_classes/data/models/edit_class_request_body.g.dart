// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_class_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditClassRequestBody _$EditClassRequestBodyFromJson(
  Map<String, dynamic> json,
) => EditClassRequestBody(
  name: json['name'] as String,
  gradeId: (json['grade_id'] as num).toInt(),
);

Map<String, dynamic> _$EditClassRequestBodyToJson(
  EditClassRequestBody instance,
) => <String, dynamic>{'name': instance.name, 'grade_id': instance.gradeId};
