// lib/features/your_feature_folder/logic/class_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_state.freezed.dart';

@freezed
abstract class ClassState<T> with _$ClassState<T> {
  const factory ClassState.initial() = _Initial;
  const factory ClassState.loading() = Loading;
  const factory ClassState.success(T data) = Success<T>;
  const factory ClassState.error({required String error}) = Error;
}
