import 'package:json_annotation/json_annotation.dart';

part 'delete_sub_level_response.g.dart';

@JsonSerializable()
class DeleteSubLevelResponse {
  String? message;

  DeleteSubLevelResponse({this.message});

  factory DeleteSubLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteSubLevelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteSubLevelResponseToJson(this);
}
