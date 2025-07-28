// lib/features/search_page/data/repos/class_repo.dart
import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/search_page/data/models/class_response.dart';

class ClassRepo {
  final ApiService _apiService;

  ClassRepo(this._apiService);

  Future<ApiResult<ClassResponse>> getClasses({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _apiService.getClasses(startDate, endDate);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
