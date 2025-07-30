import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/delete_class_response.dart';

class DeleteClassRepo {
  final ApiService _apiService;

  DeleteClassRepo(this._apiService);

  Future<ApiResult<DeleteClassResponse>> deleteClass(
    String deleteClassId,
  ) async {
    try {
      final response = await _apiService.deleteClass(deleteClassId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
