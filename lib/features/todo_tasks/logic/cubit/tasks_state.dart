import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_app/features/todo_tasks/data/models/tasks_response.dart'; // تأكد من استيراد الموديل

part 'tasks_state.freezed.dart';

@freezed
class TasksState<T> with _$TasksState<T> {
  const factory TasksState.initial() = _Initial;

  const factory TasksState.loading() = Loading;
  const factory TasksState.loadingMore() = LoadingMore;

  const factory TasksState.success({
    required List<DoneData> doneTasks,
    required List<Waiting> waitingTasks,
  }) = Success<T>;

  const factory TasksState.error({required String error}) = Error;
}
