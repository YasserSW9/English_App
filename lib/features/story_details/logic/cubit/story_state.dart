import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_state.freezed.dart';

@freezed
class StoryState<T> with _$StoryState<T> {
  const factory StoryState.initial() = _Initial;

  const factory StoryState.loading() = Loading;
  const factory StoryState.success(T data) = Success<T>;
  const factory StoryState.error({required String error}) = Error;
}
