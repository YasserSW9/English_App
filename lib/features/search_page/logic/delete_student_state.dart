import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_student_state.freezed.dart';

@freezed
class DeleteStudentState<T> with _$DeleteStudentState<T> {
  const factory DeleteStudentState.initial() = _Initial;

  const factory DeleteStudentState.loading() = Loading;
  const factory DeleteStudentState.success(T data) = Success<T>;
  const factory DeleteStudentState.error({required String error}) = Error;
}
