import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/profile_page/data/model/create_admin_request_body.dart';
import 'package:english_app/features/profile_page/data/model/create_admin_response.dart';

class CreateAdminRepo {
  final ApiService _apiService;

  CreateAdminRepo(this._apiService);

  Future<ApiResult<CreateAdminResponse>> createAdmin(
    CreateAdminRequestBody createAdminRequestBody,
  ) async {
    try {
      final response = await _apiService.createAdmin(createAdminRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
