import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';

import 'package:english_app/features/english_club/data/models/delete_section_response.dart';

class DeleteSectionRepo {
  final ApiService _apiService;

  DeleteSectionRepo(this._apiService);

  Future<ApiResult<DeleteSectionResponse>> deleteSection(
    String deleteSectionId,
  ) async {
    try {
      final response = await _apiService.deleteSection(deleteSectionId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
