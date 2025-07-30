import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_class_state.freezed.dart';

@freezed
class EditClassState<T> with _$EditClassState<T> {
  const factory EditClassState.initial() = _Initial;

  const factory EditClassState.loading() = Loading;
  const factory EditClassState.success(T data) = Success<T>;
  const factory EditClassState.error({required String error}) = Error;
}
