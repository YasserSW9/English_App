import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/english_club/data/models/english_club_response.dart'; // تأكد من المسار الصحيح لملف النموذج الخاص بك

class EnglishClubRepo {
  final ApiService _apiService;

  EnglishClubRepo(this._apiService);

  Future<ApiResult<EnglishClubResponse>> getSections() async {
    try {
      final response = await _apiService.getSections();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
