import 'package:freezed_annotation/freezed_annotation.dart';

part 'inactive_student_state.freezed.dart';

@freezed
abstract class InactiveStudentState<T> with _$InactiveStudentState<T> {
  const factory InactiveStudentState.initial() = _Initial;

  const factory InactiveStudentState.loading() = Loading;
  const factory InactiveStudentState.success(T data) = Success<T>;
  const factory InactiveStudentState.error({required String error}) = Error;
}
