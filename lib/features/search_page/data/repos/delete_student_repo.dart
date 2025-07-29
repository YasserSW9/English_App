import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/search_page/data/models/delete_student_response.dart';

class DeleteStudentRepo {
  final ApiService _apiService;

  DeleteStudentRepo(this._apiService);

  Future<ApiResult<DeleteStudentResponse>> deleteStudent(
    String studentId,
  ) async {
    try {
      final response = await _apiService.deleteStudent(studentId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
