import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';

import 'package:english_app/features/english_club/data/models/delete_sub_level_response.dart';

class DeleteSubLevelRepo {
  final ApiService _apiService;

  DeleteSubLevelRepo(this._apiService);

  Future<ApiResult<DeleteSubLevelResponse>> deleteSubLevel(
    String deleteLevelId,
    String deleteSubLevelId,
  ) async {
    try {
      final response = await _apiService.deleteSubLevel(
        deleteLevelId,
        deleteSubLevelId,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
