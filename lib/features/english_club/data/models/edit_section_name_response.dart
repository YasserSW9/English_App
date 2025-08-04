import 'package:json_annotation/json_annotation.dart';

part 'edit_section_name_response.g.dart';

@JsonSerializable()
class EditSectionNameResponse {
  String? message;

  EditSectionNameResponse({this.message});

  factory EditSectionNameResponse.fromJson(Map<String, dynamic> json) =>
      _$EditSectionNameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditSectionNameResponseToJson(this);
}
