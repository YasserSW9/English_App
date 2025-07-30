import 'package:json_annotation/json_annotation.dart';

part 'edit_class_request_body.g.dart';

@JsonSerializable()
class EditClassRequestBody {
  final String name;

  @JsonKey(name: 'grade_id')
  final int gradeId;

  EditClassRequestBody({required this.name, required this.gradeId});

  factory EditClassRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EditClassRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EditClassRequestBodyToJson(this);
}
