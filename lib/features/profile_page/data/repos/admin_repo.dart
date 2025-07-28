import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/profile_page/data/model/admin_response.dart';

class AdminRepo {
  final ApiService _apiService;

  AdminRepo(this._apiService);

  Future<ApiResult<List<AdminResponse>>> getAdminData() async {
    try {
      final response = await _apiService.getAdminData();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
