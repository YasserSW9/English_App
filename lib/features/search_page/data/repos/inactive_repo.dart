import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/search_page/data/models/inactive_request_body.dart';
import 'package:english_app/features/search_page/data/models/inactive_response.dart';

class InactiveStudentRepo {
  final ApiService _apiService;

  InactiveStudentRepo(this._apiService);

  Future<ApiResult<InactiveResponse>> markStudentInactive({
    required int studentId,
    required InactiveRequestBody inactiveRequestBody,
  }) async {
    try {
      final response = await _apiService.markStudentInactive(
        studentId,
        inactiveRequestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
