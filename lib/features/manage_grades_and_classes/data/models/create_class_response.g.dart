// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_class_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateClassResponse _$CreateClassResponseFromJson(Map<String, dynamic> json) =>
    CreateClassResponse(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClassResponseToJson(
  CreateClassResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  name: json['name'] as String?,
  gradeId: json['grade_id'] as String?,
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'name': instance.name,
  'grade_id': instance.gradeId,
  'id': instance.id,
};
