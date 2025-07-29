import 'package:json_annotation/json_annotation.dart';

part 'inactive_response.g.dart';

@JsonSerializable()
class InactiveResponse {
  String? message;

  InactiveResponse({this.message});

  factory InactiveResponse.fromJson(Map<String, dynamic> json) =>
      _$InactiveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InactiveResponseToJson(this);
}
