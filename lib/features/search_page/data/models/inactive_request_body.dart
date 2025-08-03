import 'package:json_annotation/json_annotation.dart';

part 'inactive_request_body.g.dart';

@JsonSerializable()
class InactiveRequestBody {
  final int active;

  InactiveRequestBody({required this.active});

  Map<String, dynamic> toJson() => _$InactiveRequestBodyToJson(this);
}
