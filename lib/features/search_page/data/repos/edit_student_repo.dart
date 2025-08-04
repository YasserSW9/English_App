import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/search_page/data/models/edit_student_request_body.dart';
import 'package:english_app/features/search_page/data/models/edit_student_response.dart';

class EditStudentRepo {
  final ApiService _apiService;

  EditStudentRepo(this._apiService);

  Future<ApiResult<EditStudentResponse>> editStudent(
    int editStudentId,
    EditStudentRequestBody editStudentRequestBody,
  ) async {
    try {
      final response = await _apiService.editStudent(
        editStudentId,
        editStudentRequestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
