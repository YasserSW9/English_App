import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/create_class_request_body.dart'; // تأكد من الاستيراد الصحيح
import 'package:english_app/features/manage_grades_and_classes/data/models/create_class_response.dart'; // تأكد من الاستيراد الصحيح

class CreateClassRepo {
  final ApiService _apiService;

  CreateClassRepo(this._apiService);

  Future<ApiResult<CreateClassResponse>> createClass(
    CreateClassRequestBody createClassRequestBody,
  ) async {
    try {
      final response = await _apiService.createClass(createClassRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
