// delete_class_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_class_state.freezed.dart';

@freezed
class DeleteClassState<T> with _$DeleteClassState<T> {
  const factory DeleteClassState.initial() = _Initial;

  const factory DeleteClassState.loading() = Loading;
  const factory DeleteClassState.success(T data) = Success<T>;
  const factory DeleteClassState.error({required String error}) = Error;
}
