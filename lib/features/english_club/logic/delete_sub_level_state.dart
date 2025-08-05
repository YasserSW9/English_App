// delete_sub_level_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_sub_level_state.freezed.dart';

@freezed
class DeleteSubLevelState<T> with _$DeleteSubLevelState<T> {
  const factory DeleteSubLevelState.initial() = _Initial;

  const factory DeleteSubLevelState.loading() = Loading;
  const factory DeleteSubLevelState.success(T data) = Success<T>;
  const factory DeleteSubLevelState.error({required String error}) = Error;
}
