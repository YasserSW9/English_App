import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/search_page/data/repos/delete_student_repo.dart';
import 'package:english_app/features/search_page/logic/delete_student_state.dart';

class DeleteStudentCubit extends Cubit<DeleteStudentState> {
  final DeleteStudentRepo _deleteStudentRepo;

  DeleteStudentCubit(this._deleteStudentRepo)
    : super(const DeleteStudentState.initial());

  void emitDeleteStudent(String studentId) async {
    emit(const DeleteStudentState.loading());
    final response = await _deleteStudentRepo.deleteStudent(studentId);
    response.when(
      success: (deleteStudentResponse) {
        emit(DeleteStudentState.success(deleteStudentResponse));
      },
      failure: (error) {
        emit(
          DeleteStudentState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
