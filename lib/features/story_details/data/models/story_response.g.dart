// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryResponse _$StoryResponseFromJson(Map<String, dynamic> json) =>
    StoryResponse(
      msg: json['msg'] as String?,
      story: (json['story'] as List<dynamic>?)
          ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryResponseToJson(StoryResponse instance) =>
    <String, dynamic>{'msg': instance.msg, 'story': instance.story};

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
  id: (json['id'] as num?)?.toInt(),
  qrCode: json['qrCode'] as String?,
  title: json['title'] as String?,
  blurb: json['blurb'],
  allowedBorrowDays: (json['allowed_borrow_days'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  coverUrl: json['cover_url'] as String?,
  subLevelId: (json['sub_level_id'] as num?)?.toInt(),
  testId: (json['test_id'] as num?)?.toInt(),
  test: json['test'] == null
      ? null
      : Test.fromJson(json['test'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
  'id': instance.id,
  'qrCode': instance.qrCode,
  'title': instance.title,
  'blurb': instance.blurb,
  'allowed_borrow_days': instance.allowedBorrowDays,
  'quantity': instance.quantity,
  'cover_url': instance.coverUrl,
  'sub_level_id': instance.subLevelId,
  'test_id': instance.testId,
  'test': instance.test,
};

Test _$TestFromJson(Map<String, dynamic> json) => Test(
  id: (json['id'] as num?)?.toInt(),
  subQuestionsCount: (json['subQuestions_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
  'id': instance.id,
  'subQuestions_count': instance.subQuestionsCount,
};
