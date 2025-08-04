import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_student_state.freezed.dart';

@freezed
class EditStudentState<T> with _$EditStudentState<T> {
  const factory EditStudentState.initial() = _Initial;

  const factory EditStudentState.loading() = Loading;
  const factory EditStudentState.success(T data) = Success<T>;
  const factory EditStudentState.error({required String error}) = Error;
}
