import 'package:english_app/features/todo_tasks/ui/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:english_app/features/todo_tasks/data/models/tasks_response.dart';
import 'package:english_app/features/todo_tasks/ui/widgets/shimmer_loading.dart';

class WaitingTaskList extends StatelessWidget {
  final List<Waiting> tasks;
  final Function(Waiting, int) onMarkAsDone;
  final ScrollController scrollController;
  final bool hasMoreData;
  final bool isLoadingMore;

  const WaitingTaskList({
    Key? key,
    required this.tasks,
    required this.onMarkAsDone,
    required this.scrollController,
    required this.hasMoreData,
    this.isLoadingMore = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: tasks.length + (hasMoreData && isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == tasks.length && hasMoreData && isLoadingMore) {
          // 🔄 عرض ShimmerLoading بدلاً من CircularProgressIndicator
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: ShimmerLoading(
              child:
                  TaskCardShimmer(), // استخدام TaskCardShimmer لإنشاء تأثير الشيمر
            ),
          );
        }
        final task = tasks[index];
        return TaskCard(
          task: task,
          isWaitingList: true,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              onMarkAsDone(task, index);
            }
          },
        );
      },
    );
  }
}
