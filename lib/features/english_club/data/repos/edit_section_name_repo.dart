import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';

import 'package:english_app/features/english_club/data/models/edit_section_name_request_body.dart';
import 'package:english_app/features/english_club/data/models/edit_section_name_response.dart';

class EditSectionNameRepo {
  final ApiService _apiService;

  EditSectionNameRepo(this._apiService);

  Future<ApiResult<EditSectionNameResponse>> editSectionName(
    int editSectionId,
    EditSectionNameRequestBody editSectionNameRequestBody,
  ) async {
    try {
      final response = await _apiService.editSection(
        editSectionId,
        editSectionNameRequestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
