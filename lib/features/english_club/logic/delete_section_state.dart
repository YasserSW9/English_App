import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_section_state.freezed.dart';

@freezed
class DeleteSectionState<T> with _$DeleteSectionState<T> {
  const factory DeleteSectionState.initial() = _Initial;

  const factory DeleteSectionState.loading() = Loading;
  const factory DeleteSectionState.success(T data) = Success<T>;
  const factory DeleteSectionState.error({required String error}) = Error;
}
