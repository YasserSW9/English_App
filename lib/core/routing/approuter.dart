import 'package:english_app/core/di/dependency_injection.dart';
import 'package:english_app/core/routing/routes.dart';
import 'package:english_app/features/add_students_by_excel/ui/add_students_by_excel.dart';
import 'package:english_app/features/add_students_manually/logic/create_student_cubit.dart';
import 'package:english_app/features/add_students_manually/ui/add_students_manually.dart';
import 'package:english_app/features/english_club/logic/create_section_cubit.dart';
import 'package:english_app/features/english_club/logic/english_club_cubit.dart';
import 'package:english_app/features/english_club/ui/english_club.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/story_details/logic/cubit/story_cubit.dart';
import 'package:english_app/features/story_details/ui/story_details%20.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/create_grades_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_grade_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_grade_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/grades_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/ui/manage_grades_and_classes.dart';
import 'package:english_app/features/profile_page/logic/cubit/admin_cubit.dart';
import 'package:english_app/features/profile_page/logic/cubit/create_admin_cubit.dart';
import 'package:english_app/features/profile_page/logic/cubit/delete_admin_cubit.dart';
import 'package:english_app/features/admin_main_screen/ui/admin_main_screen.dart';
import 'package:english_app/features/admin_main_screen/logic/cubit/notifications_cubit.dart';
import 'package:english_app/features/login/logic/cubit/login_cubit.dart'
    show LoginCubit;
import 'package:english_app/features/login/ui/login_Screen.dart';

import 'package:english_app/features/onbording/ui/onboarding.dart';
import 'package:english_app/features/road_map/ui/road_map.dart';
import 'package:english_app/features/student_prizes/logic/cubit/prizes_cubit.dart';
import 'package:english_app/features/student_prizes/ui/student_prizes.dart';
import 'package:english_app/features/add_students/ui/add_students.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/collect_tasks_cubit.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/tasks_cubit.dart';
import 'package:english_app/features/todo_tasks/ui/todo_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => Onboarding());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: Loginscreen(),
          ),
        );
      case Routes.adminMainScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<ClassCubit>()),
              BlocProvider(create: (context) => getIt<NotificationsCubit>()),
              BlocProvider(create: (context) => getIt<AdminCubit>()),
              BlocProvider(create: (context) => getIt<DeleteAdminCubit>()),
              BlocProvider(create: (context) => getIt<CreateAdminCubit>()),
            ],
            child: AdminMainScreen(),
          ),
        );
      case Routes.studentPrizes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<PrizesCubit>(),
            child: StudentPrizes(),
          ),
        );
      case Routes.todoTaks:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<TasksCubit>()),
              BlocProvider(create: (context) => getIt<CollectTasksCubit>()),
            ],
            child: TodoTasks(),
          ),
        );
      case Routes.addStudents:
        return MaterialPageRoute(builder: (_) => AddStudents());
      case Routes.englishclub:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<CreateSectionCubit>()),
              BlocProvider(create: (context) => getIt<EnglishClubCubit>()),
            ],
            child: Englishclub(),
          ),
        );
      case Routes.addStudentsByExcel:
        return MaterialPageRoute(builder: (_) => AddStudentsByExcel());
      case Routes.addStudentsManually:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CreateStudentCubit>(),
            child: AddStudentsManually(),
          ),
        );
      case Routes.manageGradesAndClassess:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<GradesCubit>()),
              BlocProvider(create: (context) => getIt<DeleteGradeCubit>()),
              BlocProvider(create: (context) => getIt<EditGradeCubit>()),
              BlocProvider(create: (context) => getIt<CreateGradesCubit>()),
            ],
            child: ManageGradesAndClasses(),
          ),
        );
      case Routes.roadMap:
        return MaterialPageRoute(builder: (_) => RoadMap());
      case Routes.storyDetails:
        final storyId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<StoryCubit>(),
            child: StoryDetails(storyId: storyId),
          ),
        );
      default:
        return null;
    }
  }
}
