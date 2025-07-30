import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/edit_class_request_body.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/edit_class_response.dart';

class EditClassRepo {
  final ApiService _apiService;

  EditClassRepo(this._apiService);

  Future<ApiResult<EditClassResponse>> editClass(
    int classId,
    EditClassRequestBody editClassRequestBody,
  ) async {
    try {
      final response = await _apiService.editClass(
        classId,
        editClassRequestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
