import 'package:json_annotation/json_annotation.dart';

part 'class_response.g.dart';

@JsonSerializable()
class ClassResponse {
  String? message;
  List<Data>? data;

  ClassResponse({this.message, this.data});

  factory ClassResponse.fromJson(Map<String, dynamic> json) =>
      _$ClassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClassResponseToJson(this);
}

@JsonSerializable()
class Data {
  int? id;
  String? name;
  List<Classes>? classes;

  Data({this.id, this.name, this.classes});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Classes {
  int? id;
  String? name;
  @JsonKey(name: 'grade_id')
  int? gradeId;
  List<Students>? students;

  Classes({this.id, this.name, this.gradeId, this.students});

  factory Classes.fromJson(Map<String, dynamic> json) =>
      _$ClassesFromJson(json);

  Map<String, dynamic> toJson() => _$ClassesToJson(this);
}

@JsonSerializable()
class Students {
  int? id;
  String? name;
  int? score;
  @JsonKey(name: 'golden_coins')
  int? goldenCoins;
  @JsonKey(name: 'silver_coins')
  int? silverCoins;
  @JsonKey(name: 'bronze_coins')
  int? bronzeCoins;
  @JsonKey(name: 'profile_picture')
  String? profilePicture;
  int? inactive;
  @JsonKey(name: 'borrow_limit')
  int? borrowLimit;
  @JsonKey(name: 'g_class_id')
  int? gClassId;
  @JsonKey(name: 'finishedStoriesCount')
  int? finishedStoriesCount;
  @JsonKey(name: 'finishedLevelsCount')
  int? finishedLevelsCount;
  @JsonKey(name: 'gradeName')
  String? gradeName;
  @JsonKey(name: 'className')
  String? className;

  Students({
    this.id,
    this.name,
    this.score,
    this.goldenCoins,
    this.silverCoins,
    this.bronzeCoins,
    this.profilePicture,
    this.inactive,
    this.borrowLimit,
    this.gClassId,
    this.finishedStoriesCount,
    this.finishedLevelsCount,
    this.gradeName,
    this.className,
  });

  factory Students.fromJson(Map<String, dynamic> json) =>
      _$StudentsFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsToJson(this);
}
