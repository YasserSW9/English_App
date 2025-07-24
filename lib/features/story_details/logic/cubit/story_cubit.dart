import 'package:bloc/bloc.dart';
import 'package:english_app/features/story_details/data/repos/story_repo.dart';
import 'package:english_app/features/story_details/logic/cubit/story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final StoryRepo storyRepo;

  StoryCubit(this.storyRepo) : super(StoryState.initial());

  void getStory(int storyId) async {
    emit(StoryState.loading());
    final response = await storyRepo.getStory(storyId);
    response.when(
      success: (storyResponse) {
        emit(StoryState.success(storyResponse));
      },
      failure: (error) {
        emit(StoryState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
