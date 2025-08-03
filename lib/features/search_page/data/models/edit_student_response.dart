import 'package:json_annotation/json_annotation.dart';

part 'edit_student_response.g.dart';

@JsonSerializable()
class EditStudentResponse {
  String? message;

  EditStudentResponse({this.message});

  factory EditStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$EditStudentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditStudentResponseToJson(this);
}
