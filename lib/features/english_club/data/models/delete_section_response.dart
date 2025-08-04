import 'package:json_annotation/json_annotation.dart';

part 'delete_section_response.g.dart';

@JsonSerializable()
class DeleteSectionResponse {
  String? message;

  DeleteSectionResponse({this.message});

  factory DeleteSectionResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteSectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteSectionResponseToJson(this);
}
