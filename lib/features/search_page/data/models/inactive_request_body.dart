import 'package:json_annotation/json_annotation.dart';

part 'inactive_request_body.g.dart';

@JsonSerializable()
class InactiveRequestBody {
  final int active; // تم حذف المتحول 'inactive'

  InactiveRequestBody({required this.active}); // تم تحديث الـ constructor

  Map<String, dynamic> toJson() => _$InactiveRequestBodyToJson(this);
}
