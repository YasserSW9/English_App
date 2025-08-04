import 'package:json_annotation/json_annotation.dart';

part 'edit_student_request_body.g.dart';

@JsonSerializable()
class EditStudentRequestBody {
  final String name;
  @JsonKey(name: 'g_class_id')
  final int gClassId;
  @JsonKey(name: 'borrow_limit')
  final int borrowLimit;

  EditStudentRequestBody({
    required this.name,
    required this.gClassId,
    required this.borrowLimit,
  });

  Map<String, dynamic> toJson() => _$EditStudentRequestBodyToJson(this);
}
