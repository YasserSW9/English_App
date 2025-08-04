// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_student_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditStudentRequestBody _$EditStudentRequestBodyFromJson(
  Map<String, dynamic> json,
) => EditStudentRequestBody(
  name: json['name'] as String,
  gClassId: (json['g_class_id'] as num).toInt(),
  borrowLimit: (json['borrow_limit'] as num).toInt(),
);

Map<String, dynamic> _$EditStudentRequestBodyToJson(
  EditStudentRequestBody instance,
) => <String, dynamic>{
  'name': instance.name,
  'g_class_id': instance.gClassId,
  'borrow_limit': instance.borrowLimit,
};
