import 'package:json_annotation/json_annotation.dart';

part 'create_class_response.g.dart';

@JsonSerializable()
class CreateClassResponse {
  String? message;
  Data? data;

  CreateClassResponse({this.message, this.data});

  factory CreateClassResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateClassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateClassResponseToJson(this);
}

@JsonSerializable()
class Data {
  String? name;
  @JsonKey(name: 'grade_id')
  String? gradeId;
  int? id;

  Data({this.name, this.gradeId, this.id});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
