import 'package:json_annotation/json_annotation.dart';

part 'delete_student_response.g.dart';

@JsonSerializable()
class DeleteStudentResponse {
  String? message;

  DeleteStudentResponse({this.message});

  factory DeleteStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteStudentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteStudentResponseToJson(this);
}
