import 'package:json_annotation/json_annotation.dart';

part 'delete_class_response.g.dart';

@JsonSerializable()
class DeleteClassResponse {
  String? message;

  DeleteClassResponse({this.message});

  factory DeleteClassResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteClassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteClassResponseToJson(this);
}
