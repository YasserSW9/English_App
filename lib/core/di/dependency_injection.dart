import 'package:english_app/core/networking/api_service.dart';
import 'package:english_app/core/networking/dio_factory.dart';
import 'package:english_app/features/add_students_manually/data/repos/create_student_repo.dart';
import 'package:english_app/features/add_students_manually/logic/create_student_cubit.dart';

import 'package:english_app/features/english_club/data/repos/create_section_repo.dart';
import 'package:english_app/features/english_club/data/repos/delete_section_repo.dart';
import 'package:english_app/features/english_club/data/repos/delete_sub_level_repo.dart';
import 'package:english_app/features/english_club/data/repos/edit_section_name_repo.dart';
import 'package:english_app/features/english_club/data/repos/english_club_repo.dart';
import 'package:english_app/features/english_club/logic/create_section_cubit.dart';
import 'package:english_app/features/english_club/logic/delete_section_cubit.dart';
import 'package:english_app/features/english_club/logic/delete_sub_level_cubit.dart';
import 'package:english_app/features/english_club/logic/edit_section_name_cubit.dart';
import 'package:english_app/features/english_club/logic/english_club_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/create_class_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/create_grade_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/delete_class_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/delete_grade_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/edit_class_response.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/edit_grade_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/grades_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/create_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/create_grades_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_grade_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_grade_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/grades_cubit.dart';
import 'package:english_app/features/profile_page/data/repos/admin_repo.dart';
import 'package:english_app/features/profile_page/data/repos/create_admin_repo.dart';
import 'package:english_app/features/profile_page/data/repos/delete_admin_repo.dart';
import 'package:english_app/features/admin_main_screen/data/repos/notifications_repo.dart';
import 'package:english_app/features/profile_page/logic/cubit/admin_cubit.dart';
import 'package:english_app/features/profile_page/logic/cubit/create_admin_cubit.dart';
import 'package:english_app/features/profile_page/logic/cubit/delete_admin_cubit.dart';
import 'package:english_app/features/admin_main_screen/logic/cubit/notifications_cubit.dart';
import 'package:english_app/features/login/data/repos/login_repo.dart';
import 'package:english_app/features/login/logic/cubit/login_cubit.dart';
import 'package:english_app/features/search_page/data/repos/class_repo.dart';
import 'package:english_app/features/search_page/data/repos/delete_student_repo.dart';
import 'package:english_app/features/search_page/data/repos/edit_student_repo.dart';
import 'package:english_app/features/search_page/data/repos/inactive_repo.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/search_page/logic/delete_student_cubit.dart';
import 'package:english_app/features/search_page/logic/edit_student_cubit.dart';
import 'package:english_app/features/search_page/logic/inactive_student_cubit.dart';
import 'package:english_app/features/story_details/data/repos/story_repo.dart';
import 'package:english_app/features/story_details/logic/cubit/story_cubit.dart';
import 'package:english_app/features/student_prizes/data/repos/prizes_repo.dart';
import 'package:english_app/features/student_prizes/logic/cubit/prizes_cubit.dart';
import 'package:english_app/features/todo_tasks/data/repos/collect_tasks_repo.dart';
import 'package:english_app/features/todo_tasks/data/repos/tasks_repo.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/collect_tasks_cubit.dart';
import 'package:english_app/features/todo_tasks/logic/cubit/tasks_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = await DioFactory.getDio();
  getIt.registerLazySingleton(() => ApiService(dio));
  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  // admin notifications
  getIt.registerLazySingleton<NotificationsRepo>(
    () => NotificationsRepo(getIt()),
  );
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit(getIt()));
  // admin view prizes
  getIt.registerLazySingleton<PrizesRepo>(() => PrizesRepo(getIt()));
  getIt.registerFactory<PrizesCubit>(() => PrizesCubit(getIt()));
  // view all admins
  getIt.registerLazySingleton<AdminRepo>(() => AdminRepo(getIt()));
  getIt.registerFactory<AdminCubit>(() => AdminCubit(getIt()));
  //Delete admin
  getIt.registerLazySingleton<DeleteAdminRepo>(() => DeleteAdminRepo(getIt()));
  getIt.registerFactory<DeleteAdminCubit>(() => DeleteAdminCubit(getIt()));
  // Create admin
  getIt.registerLazySingleton<CreateAdminRepo>(() => CreateAdminRepo(getIt()));
  getIt.registerFactory<CreateAdminCubit>(() => CreateAdminCubit(getIt()));
  // GET Tasks
  getIt.registerLazySingleton<TasksRepo>(() => TasksRepo(getIt()));
  getIt.registerFactory<TasksCubit>(() => TasksCubit(getIt()));
  // Patch tasks
  getIt.registerLazySingleton<CollectTasksRepo>(
    () => CollectTasksRepo(getIt()),
  );
  getIt.registerFactory<CollectTasksCubit>(() => CollectTasksCubit(getIt()));
  // grades and classess
  getIt.registerLazySingleton<GradesRepo>(() => GradesRepo(getIt()));
  getIt.registerFactory<GradesCubit>(() => GradesCubit(getIt()));
  // create grades
  getIt.registerLazySingleton<CreateGradeRepo>(() => CreateGradeRepo(getIt()));
  getIt.registerFactory<CreateGradesCubit>(() => CreateGradesCubit(getIt()));
  // edit grades
  getIt.registerLazySingleton<EditGradeRepo>(() => EditGradeRepo(getIt()));
  getIt.registerFactory<EditGradeCubit>(() => EditGradeCubit(getIt()));
  // delete grade
  getIt.registerLazySingleton<DeleteGradeRepo>(() => DeleteGradeRepo(getIt()));
  getIt.registerFactory<DeleteGradeCubit>(() => DeleteGradeCubit(getIt()));
  // create student
  getIt.registerLazySingleton<CreateStudentRepo>(
    () => CreateStudentRepo(getIt()),
  );
  getIt.registerFactory<CreateStudentCubit>(() => CreateStudentCubit(getIt()));
  // create section
  getIt.registerLazySingleton<CreateSectionRepo>(
    () => CreateSectionRepo(getIt()),
  );
  getIt.registerFactory<CreateSectionCubit>(() => CreateSectionCubit(getIt()));
  // get english club
  getIt.registerLazySingleton<EnglishClubRepo>(() => EnglishClubRepo(getIt()));
  getIt.registerFactory<EnglishClubCubit>(() => EnglishClubCubit(getIt()));
  // get story details
  getIt.registerLazySingleton<StoryRepo>(() => StoryRepo(getIt()));
  getIt.registerFactory<StoryCubit>(() => StoryCubit(getIt()));
  // get classes
  getIt.registerLazySingleton<ClassRepo>(() => ClassRepo(getIt()));
  getIt.registerFactory<ClassCubit>(() => ClassCubit(getIt()));
  // delete students
  getIt.registerLazySingleton<DeleteStudentRepo>(
    () => DeleteStudentRepo(getIt()),
  );
  getIt.registerFactory<DeleteStudentCubit>(() => DeleteStudentCubit(getIt()));
  // inactive student
  getIt.registerLazySingleton<InactiveStudentRepo>(
    () => InactiveStudentRepo(getIt()),
  );
  getIt.registerFactory<InactiveStudentCubit>(
    () => InactiveStudentCubit(getIt()),
  );
  // edit class
  getIt.registerLazySingleton<EditClassRepo>(() => EditClassRepo(getIt()));
  getIt.registerFactory<EditClassCubit>(() => EditClassCubit(getIt()));
  // create class
  getIt.registerLazySingleton<CreateClassRepo>(() => CreateClassRepo(getIt()));
  getIt.registerFactory<CreateClassCubit>(() => CreateClassCubit(getIt()));
  // delete class
  getIt.registerLazySingleton<DeleteClassRepo>(() => DeleteClassRepo(getIt()));
  getIt.registerFactory<DeleteClassCubit>(() => DeleteClassCubit(getIt()));
  // edit student
  getIt.registerLazySingleton<EditStudentRepo>(() => EditStudentRepo(getIt()));
  getIt.registerFactory<EditStudentCubit>(() => EditStudentCubit(getIt()));
  // edit section
  getIt.registerLazySingleton<EditSectionNameRepo>(
    () => EditSectionNameRepo(getIt()),
  );
  getIt.registerFactory<EditSectionNameCubit>(
    () => EditSectionNameCubit(getIt()),
  );
  // delete section
  getIt.registerLazySingleton<DeleteSectionRepo>(
    () => DeleteSectionRepo(getIt()),
  );
  getIt.registerFactory<DeleteSectionCubit>(() => DeleteSectionCubit(getIt()));
  // delete sub level
  getIt.registerLazySingleton<DeleteSubLevelRepo>(
    () => DeleteSubLevelRepo(getIt()),
  );
  getIt.registerFactory<DeleteSubLevelCubit>(
    () => DeleteSubLevelCubit(getIt()),
  );
}
