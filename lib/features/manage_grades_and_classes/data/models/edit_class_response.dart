import 'package:json_annotation/json_annotation.dart';

part 'edit_class_response.g.dart';

@JsonSerializable()
class EditClassResponse {
  String? message;
  bool? data;

  EditClassResponse({this.message, this.data});

  factory EditClassResponse.fromJson(Map<String, dynamic> json) =>
      _$EditClassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditClassResponseToJson(this);
}
