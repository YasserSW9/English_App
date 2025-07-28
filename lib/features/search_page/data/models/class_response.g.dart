// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassResponse _$ClassResponseFromJson(Map<String, dynamic> json) =>
    ClassResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClassResponseToJson(ClassResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  classes: (json['classes'] as List<dynamic>?)
      ?.map((e) => Classes.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'classes': instance.classes,
};

Classes _$ClassesFromJson(Map<String, dynamic> json) => Classes(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  gradeId: (json['grade_id'] as num?)?.toInt(),
  students: (json['students'] as List<dynamic>?)
      ?.map((e) => Students.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassesToJson(Classes instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'grade_id': instance.gradeId,
  'students': instance.students,
};

Students _$StudentsFromJson(Map<String, dynamic> json) => Students(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  score: (json['score'] as num?)?.toInt(),
  goldenCoins: (json['golden_coins'] as num?)?.toInt(),
  silverCoins: (json['silver_coins'] as num?)?.toInt(),
  bronzeCoins: (json['bronze_coins'] as num?)?.toInt(),
  profilePicture: json['profile_picture'] as String?,
  inactive: (json['inactive'] as num?)?.toInt(),
  borrowLimit: (json['borrow_limit'] as num?)?.toInt(),
  gClassId: (json['g_class_id'] as num?)?.toInt(),
  finishedStoriesCount: (json['finishedStoriesCount'] as num?)?.toInt(),
  finishedLevelsCount: (json['finishedLevelsCount'] as num?)?.toInt(),
  gradeName: json['gradeName'] as String?,
  className: json['className'] as String?,
);

Map<String, dynamic> _$StudentsToJson(Students instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'score': instance.score,
  'golden_coins': instance.goldenCoins,
  'silver_coins': instance.silverCoins,
  'bronze_coins': instance.bronzeCoins,
  'profile_picture': instance.profilePicture,
  'inactive': instance.inactive,
  'borrow_limit': instance.borrowLimit,
  'g_class_id': instance.gClassId,
  'finishedStoriesCount': instance.finishedStoriesCount,
  'finishedLevelsCount': instance.finishedLevelsCount,
  'gradeName': instance.gradeName,
  'className': instance.className,
};
