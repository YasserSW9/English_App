import 'package:english_app/core/helpers/extensions.dart';
import 'package:english_app/features/todo_tasks/data/models/collect_tasks.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/collect_tasks_cubit.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/collect_tasks_state.dart';
import 'package:english_app/features/todo_tasks/ui/widgets/done_task_list.dart';
import 'package:english_app/features/todo_tasks/ui/widgets/shimmer_loading.dart';
import 'package:english_app/features/todo_tasks/ui/widgets/waiting_task_list.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/tasks_cubit.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/tasks_state.dart';
import 'package:english_app/features/todo_tasks/data/models/tasks_response.dart';

class TodoTasks extends StatefulWidget {
  const TodoTasks({super.key});

  @override
  _TodoTasksState createState() => _TodoTasksState();
}

class _TodoTasksState extends State<TodoTasks>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _waitingScrollController = ScrollController();
  final ScrollController _doneScrollController = ScrollController();
  bool _isLoadingConfirmation = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<TasksCubit>().emitGetTasks();

    _waitingScrollController.addListener(() {
      if (_waitingScrollController.position.pixels ==
          _waitingScrollController.position.maxScrollExtent) {
        context.read<TasksCubit>().emitLoadMoreTasks();
      }
    });

    _doneScrollController.addListener(() {
      if (_doneScrollController.position.pixels ==
          _doneScrollController.position.maxScrollExtent) {
        context.read<TasksCubit>().emitLoadMoreTasks();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _waitingScrollController.dispose();
    _doneScrollController.dispose();
    super.dispose();
  }

  void _markTaskAsDone(Waiting task, int index) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Confirm Task Completion\n',
      desc: 'Are you sure you want to mark this task as done?\n',
      btnCancelText: 'Cancel',
      btnOkText: 'Confirm',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (!mounted) {
          debugPrint(
            'Dialog button pressed, but TodoTasks is not mounted. Aborting.',
          );
          return;
        }

        if (task.id != null) {
          setState(() {
            _isLoadingConfirmation = true;
          });
          context.read<CollectTasksCubit>().emitMarkTaskAsDoneState(task.id!);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Task ID is missing. Cannot mark as done.',
            btnOkOnPress: () {},
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'System Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF673AB7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Waiting'),
            Tab(text: 'Done'),
          ],
        ),
      ),
      body: Stack(
        children: [
          MultiBlocListener(
            listeners: [
              BlocListener<CollectTasksCubit, CollectTasksState<CollectTasks>>(
                listener: (context, state) {
                  state.whenOrNull(
                    loading: () {},
                    success: (response) {
                      if (!mounted) {
                        debugPrint(
                          'CollectTasksCubit success, but TodoTasks is not mounted. Aborting dialog.',
                        );
                        return;
                      }
                      setState(() {
                        _isLoadingConfirmation = false;
                      });
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Success',
                        desc:
                            response.message ??
                            'Task marked as done successfully!',
                        btnOkOnPress: () {
                          if (!mounted) {
                            debugPrint(
                              'AwesomeDialog OK pressed, but TodoTasks is not mounted. Aborting operations.',
                            );
                            return;
                          }
                          context.read<TasksCubit>().emitGetTasks();
                          _tabController.animateTo(1);
                        },
                      ).show();
                    },
                    error: (error) {
                      if (!mounted) {
                        debugPrint(
                          'CollectTasksCubit error, but TodoTasks is not mounted. Aborting dialog.',
                        );
                        return;
                      }
                      setState(() {
                        _isLoadingConfirmation = false;
                      });
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: error,
                        btnOkOnPress: () {
                          if (!mounted) {
                            debugPrint(
                              'AwesomeDialog ERROR OK pressed, but TodoTasks is not mounted. Aborting operations.',
                            );
                            return;
                          }
                        },
                      ).show();
                    },
                  );
                },
              ),
            ],
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                final tasksCubit = context.read<TasksCubit>();

                final bool isLoadingMore = state is LoadingMore;
                final bool hasMoreData = tasksCubit.hasMoreData;

                return state.when(
                  initial: () =>
                      const Center(child: Text('Initializing Tasks...')),
                  loading: () {
                    return ShimmerLoading(
                      child: TabBarView(
                        controller: _tabController,
                        children: List.generate(
                          2,
                          (tabIndex) => ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: 5,
                            itemBuilder: (context, index) =>
                                const TaskCardShimmer(),
                          ),
                        ),
                      ),
                    );
                  },
                  success: (doneTasks, waitingTasks) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        WaitingTaskList(
                          tasks: waitingTasks,
                          onMarkAsDone: _markTaskAsDone,
                          scrollController: _waitingScrollController,
                          hasMoreData: hasMoreData,
                          isLoadingMore: isLoadingMore,
                        ),
                        DoneTaskList(
                          tasks: doneTasks,
                          scrollController: _doneScrollController,
                          hasMoreData: hasMoreData,
                          isLoadingMore: isLoadingMore,
                        ),
                      ],
                    );
                  },
                  loadingMore: () {
                    List<DoneData> doneTasks = [];
                    List<Waiting> waitingTasks = [];

                    tasksCubit.state.maybeWhen(
                      success: (_doneTasks, _waitingTasks) {
                        doneTasks = _doneTasks;
                        waitingTasks = _waitingTasks;
                      },
                      orElse: () {},
                    );

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        WaitingTaskList(
                          tasks: waitingTasks,
                          onMarkAsDone: _markTaskAsDone,
                          scrollController: _waitingScrollController,
                          hasMoreData: hasMoreData,
                          isLoadingMore: isLoadingMore,
                        ),
                        DoneTaskList(
                          tasks: doneTasks,
                          scrollController: _doneScrollController,
                          hasMoreData: hasMoreData,
                          isLoadingMore: isLoadingMore,
                        ),
                      ],
                    );
                  },
                  error: (error) =>
                      Center(child: Text('An error occurred: $error')),
                );
              },
            ),
          ),
          if (_isLoadingConfirmation)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
