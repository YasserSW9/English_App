// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_student_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditStudentRequestBody _$EditStudentRequestBodyFromJson(
  Map<String, dynamic> json,
) => EditStudentRequestBody(
  name: json['name'] as String,
  gClassId: (json['gClassId'] as num).toInt(),
  borrowLimit: (json['borrowLimit'] as num).toInt(),
);

Map<String, dynamic> _$EditStudentRequestBodyToJson(
  EditStudentRequestBody instance,
) => <String, dynamic>{
  'name': instance.name,
  'gClassId': instance.gClassId,
  'borrowLimit': instance.borrowLimit,
};
