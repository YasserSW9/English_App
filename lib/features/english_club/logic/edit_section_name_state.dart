// edit_section_name_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_section_name_state.freezed.dart';

@freezed
class EditSectionNameState<T> with _$EditSectionNameState<T> {
  const factory EditSectionNameState.initial() = _Initial;

  const factory EditSectionNameState.loading() = Loading;
  const factory EditSectionNameState.success(T data) = Success<T>;
  const factory EditSectionNameState.error({required String error}) = Error;
}
