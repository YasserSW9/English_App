import 'package:english_app/core/networking/api_error_handler.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/features/story_details/data/models/story_response.dart';

class StoryRepo {
  final ApiService _apiService;

  StoryRepo(this._apiService);

  Future<ApiResult<StoryResponse>> getStory(int storyId) async {
    try {
      final response = await _apiService.getStory(storyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
