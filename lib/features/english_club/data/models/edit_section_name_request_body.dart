import 'package:json_annotation/json_annotation.dart';

part 'edit_section_name_request_body.g.dart';

@JsonSerializable()
class EditSectionNameRequestBody {
  final String name;

  EditSectionNameRequestBody({required this.name});

  Map<String, dynamic> toJson() => _$EditSectionNameRequestBodyToJson(this);
}
