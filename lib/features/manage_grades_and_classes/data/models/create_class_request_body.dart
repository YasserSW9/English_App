import 'package:json_annotation/json_annotation.dart';

part 'create_class_request_body.g.dart';

@JsonSerializable()
class CreateClassRequestBody {
  final String name;
  @JsonKey(name: 'grade_id')
  final int gradeId;

  CreateClassRequestBody({required this.name, required this.gradeId});

  factory CreateClassRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateClassRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateClassRequestBodyToJson(this);
}
