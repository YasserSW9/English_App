import 'package:dio/dio.dart';
import 'package:english_app/core/networking/api_contants.dart';
import 'package:english_app/features/add_students_manually/data/models/create_student_request_body.dart';
import 'package:english_app/features/add_students_manually/data/models/create_student_response.dart';

import 'package:english_app/features/english_club/data/models/create_section_request_body.dart';
import 'package:english_app/features/english_club/data/models/create_section_response.dart';
import 'package:english_app/features/english_club/data/models/english_club_response.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/create_grade_request_body.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/create_grade_response.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/delete_grade_response.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/edit_grade_request_body.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/edit_grade_response.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/grades_response.dart';
import 'package:english_app/features/profile_page/data/model/admin_response.dart';
import 'package:english_app/features/profile_page/data/model/create_admin_request_body.dart';
import 'package:english_app/features/profile_page/data/model/create_admin_response.dart';
import 'package:english_app/features/profile_page/data/model/delete_response.dart';
import 'package:english_app/features/admin_main_screen/data/models/notifications_response.dart';
import 'package:english_app/features/login/data/models/login_request_body.dart';
import 'package:english_app/features/login/data/models/login_response.dart';
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/story_details/data/models/story_response.dart';
import 'package:english_app/features/student_prizes/data/models/prizes_response.dart';
import 'package:english_app/features/todo_tasks/data/models/collect_tasks.dart';
import 'package:english_app/features/todo_tasks/data/models/tasks_response.dart';

import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // AUTH
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  // admin notifications
  @GET(ApiConstants.adminNotifications)
  Future<NotificationsResponse> getNotifications(@Query('page') int page);
  // admin view prizes
  @GET(ApiConstants.adminViewPrizes)
  Future<PrizesResponse> getPrizes(
    @Query('page') int page,
    @Query('collected') int? collectedStatus,
  );
  //admin collect prizes
  @POST("/admin/students/{student_id}/collectedPrize/{prize_item_id}")
  Future<HttpResponse<dynamic>> collectPrize(
    @Path("student_id") int studentId,
    @Path("prize_item_id") int prizeItemId,
  );
  // admin info
  @GET(ApiConstants.getAdminData)
  Future<List<AdminResponse>> getAdminData();
  // delete admin
  @DELETE("admin/admins/{delete_admin_id}")
  Future<DeleteResponse> deleteAdmin(
    @Path("delete_admin_id") String deleteAdminId,
  );
  // create admin
  @POST(ApiConstants.createAdmin)
  Future<CreateAdminResponse> createAdmin(
    @Body() CreateAdminRequestBody createAdminRequestBody,
  );
  // admin taks
  @GET(ApiConstants.getTasks)
  Future<TasksResponse> getTasks(
    @Query("page") int page,
    @Query("per_page") int perPage,
  );
  //collect admin tasks
  @PATCH("admin/todoNotifications/{task_id}/makeDone")
  Future<CollectTasks> getCollectTasks(@Path("task_id") int taskId);
  // grades and classess info
  @GET(ApiConstants.getGrades)
  Future<GradesResponse> getGrades();
  // create grades

  @POST(ApiConstants.createGrades)
  Future<CreateGradeResponse> createGrades(
    @Body() CreateGradeRequestBody createGradesRequestBody,
  );
  // edit grades
  @PUT('admin/grades/{edit_grade_id}')
  Future<EditGradeResponse> editGrade(
    @Path("edit_grade_id") int editGradeIt,
    @Body() EditGradeRequestBody editGradeRequestBody,
  );
  // delete grades
  @DELETE("admin/grades/{delete_grade_id}")
  Future<DeleteGradeResponse> deleteGrade(
    @Path("delete_grade_id") String deleteGradeId,
  );
  // create student
  @POST("admin/students")
  Future<CreateStudentResponse> createStudent(
    @Body() CreateStudentRequestBody createStudentRequestBody,
  );
  // create section
  @POST(ApiConstants.createSection)
  Future<CreateSectionResponse> createSection(
    @Body() CreateSectionRequestBody createSectionRequestBody,
  );
  // get section
  @GET(ApiConstants.getSection)
  Future<EnglishClubResponse> getSections();
  // get Story
  @GET('admin/story/{story_id}')
  Future<StoryResponse> getStory(@Path("story_id") int storyId);
  // get classes data
  @GET("admin/students")
  Future<ClassResponse> getClasses(
    @Query("start_date") String startDate,
    @Query("end_date") String endDate,
  );
}
