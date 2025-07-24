import 'package:json_annotation/json_annotation.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  String? msg;
  List<Story>? story;

  StoryResponse({this.msg, this.story});

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}

@JsonSerializable()
class Story {
  int? id;
  @JsonKey(name: "qrCode")
  String? qrCode;
  String? title;
  dynamic? blurb; // Can be null or other type
  @JsonKey(name: "allowed_borrow_days")
  int? allowedBorrowDays;
  int? quantity;
  @JsonKey(name: "cover_url")
  String? coverUrl;
  @JsonKey(name: "sub_level_id")
  int? subLevelId;
  @JsonKey(name: "test_id")
  int? testId;
  Test? test;

  Story({
    this.id,
    this.qrCode,
    this.title,
    this.blurb,
    this.allowedBorrowDays,
    this.quantity,
    this.coverUrl,
    this.subLevelId,
    this.testId,
    this.test,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

@JsonSerializable()
class Test {
  int? id;
  @JsonKey(name: "subQuestions_count")
  int? subQuestionsCount;

  Test({this.id, this.subQuestionsCount});

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

  Map<String, dynamic> toJson() => _$TestToJson(this);
}
