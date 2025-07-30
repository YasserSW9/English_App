import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_class_state.freezed.dart';

@freezed
class CreateClassState<T> with _$CreateClassState<T> {
  const factory CreateClassState.initial() = _Initial;

  const factory CreateClassState.loading() = Loading;
  const factory CreateClassState.success(T data) = Success<T>;
  const factory CreateClassState.error({required String error}) = Error;
}
